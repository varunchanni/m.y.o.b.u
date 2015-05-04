//
//  EnvelopeManager.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 5/3/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "EnvelopeManager.h"
#import "MSDataManager.h"
#import "MSUIManager.h"
#import "EnvelopeSectionData.h"
#import "Transaction.h"
#import "UICurrencyTextField.h"
#import "PayTypeManager.h"


@class MYOBViewController;

struct EnvelopeData
{
    CGFloat value;
    CGFloat fillValue;
};

static NSString * const kRemainingFundsString = @"Remaining Funds: $";
static NSString * const kZeroFundsPlaceholder = @"0.00";

@interface EnvelopeManager() <UIAlertViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) MSDataManager * dataManager;
@property (nonatomic, strong) PayTypeManager * payTypeManager;
@property (nonatomic, strong) NSMutableArray * sections;



@property (nonatomic, strong) NSMutableArray * fillSections;
@property (nonatomic, strong) NSMutableArray * fillSectionTotals;
@property (nonatomic, strong) NSDictionary * envelopeCategoryIndex;

@property (nonatomic, strong) UIPickerTextField * parentPickerView;



@end

@implementation EnvelopeManager

+ (id)sharedManager
{
	static EnvelopeManager *_sharedManager = nil;
    static dispatch_once_t onceQueue;
	
    dispatch_once(&onceQueue, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}
- (MSDataManager *)dataManager
{
	return [MSDataManager sharedManager];
}

- (PayTypeManager *)payTypeManager
{
    return [PayTypeManager sharedManager];
}


#pragma mark Init
- (void)initialize
{
    [self updateEnvelopeCategoryIndex];
    //[self createFullStructure];
    
    
    [self createFillStructure];
}


- (BOOL)doesEnvelopeExistWithName:(NSString *)envelopeName andPayTypeName:(NSString *)payTypeName {
    
    for (Envelope * e in self.dataManager.envelopes) {
        
        if ([[e.name lowercaseString] isEqualToString:[envelopeName lowercaseString]]) {
         
            if([[e.paytype lowercaseString] isEqualToString:[payTypeName lowercaseString]]) {
                
                return true;
            }
        }
    }
    
    return false;
}


- (NSString *)GetTotalForEnvelopes:(NSArray *)envelopes
{
    __block NSNumber * total;
    
    [envelopes enumerateObjectsUsingBlock:^(Envelope * envelope, NSUInteger idx, BOOL *stop) {
        
        total = @([total doubleValue] + [[envelope balance] doubleValue]);
    }];
    
    return [MSUIManager addCurrencyStyleCommaToDouble:[total doubleValue]];
}


- (void)deleteEnvelope:(Envelope *)envelope {
    
    NSMutableArray * newEnvelopes = [[NSMutableArray alloc] init];
    for (Envelope * e in self.dataManager.envelopes) {
        
        if (e.name != envelope.name) {
            [newEnvelopes addObject:e];
        }
    }
    self.dataManager.envelopes = newEnvelopes;
    [self.dataManager updateEnvelopesObjects];
}


#pragma mark Public Fill Mode Functions
-(NSNumber *)totalAmountFromFilterTransactions:(NSArray *)transactions type:(enum TransactionType)transactionType
{
    __block NSNumber * total;
    
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"transactionType = %d", transactionType];
    NSArray * filteredArray = [transactions filteredArrayUsingPredicate:filterPredicate];
    
    [filteredArray enumerateObjectsUsingBlock:^(Transaction * transaction, NSUInteger idx, BOOL *stop) {
        
        total = [NSNumber numberWithFloat:([total floatValue] + [transaction.amount floatValue])];
        
    }];
    
    return total;
}

-(NSNumber *)totalYTDAmountFromFilterTransactions:(NSArray *)transactions type:(enum TransactionType)transactionType
{
    __block NSNumber * total;
    NSDate *currentDate = [NSDate date];
    
    __block NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate]; // Get necessary date components
    __block NSInteger currentYear = [components year];
    
    NSPredicate * transactionTypeFilterPredicate = [NSPredicate predicateWithFormat:@"transactionType = %d", transactionType];

    NSArray * filteredArray = [transactions filteredArrayUsingPredicate:transactionTypeFilterPredicate];
    
    
    
    [filteredArray enumerateObjectsUsingBlock:^(Transaction * transaction, NSUInteger idx, BOOL *stop) {
        
        NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:transaction.date]; // Get necessary date components
        NSInteger transactionYear = [components year];
        
        if(transactionYear == currentYear)
        {
            total = [NSNumber numberWithFloat:([total floatValue] + [transaction.amount floatValue])];
        }
    }];
    
    return total;
}

- (void)changeDisplayOrder:(NSNumber *)defaultOrder ofEnvelope:(Envelope *)envelope inEnvelopes:(NSMutableArray *)envelopes
{
    __block NSNumber * addIndex = [NSNumber numberWithInteger:([defaultOrder integerValue] - 1)];
    __block NSString * envelopeName = envelope.name;
    __block NSNumber * indexToRemove;
    

    if([addIndex integerValue] > envelopes.count)
    {
        addIndex = [NSNumber numberWithInteger:(envelopes.count - 1)];
    }
    
    [envelopes enumerateObjectsUsingBlock:^(Envelope * envelopeInArray, NSUInteger idx, BOOL *stop) {
        
        if([envelopeInArray.name isEqualToString:envelopeName])
        {
            indexToRemove = [NSNumber numberWithInteger:([envelopeInArray.defaultOrder integerValue] - 1)];
        }
    }];
    
    [envelopes removeObjectAtIndex:[indexToRemove integerValue]];
    [envelopes insertObject:envelope atIndex:[addIndex integerValue]];
    
    [envelopes enumerateObjectsUsingBlock:^(Envelope * envelopeInArray, NSUInteger idx, BOOL *stop) {
        
        envelopeInArray.defaultOrder = [NSNumber numberWithInteger:(idx + 1)];
    }];
    
    [self.dataManager updateEnvelopesObjects];

}

- (void)UpdateFillDataAtSection:(NSInteger)Section AtRow:(NSInteger)Row withValue:(CGFloat)Value
{
    NSString * stringValue = [NSString stringWithFormat:@"%.2f", Value];
    [[self.fillSections objectAtIndex:Section] replaceObjectAtIndex:Row withObject:stringValue];
    
    [self recalculateTotals];
}


- (double)GetFillTotalDouble
{
    __block CGFloat total = 0.00;
    [self.fillSectionTotals enumerateObjectsUsingBlock:^(NSString * value, NSUInteger idx, BOOL *stop) {
        
        total += [value doubleValue];
    }];
    
    return total;
}
- (NSString *)GetFillTotal
{
    CGFloat total = [self GetFillTotalDouble];
    return [MSUIManager addCurrencyStyleCommaToDouble:total];
}

- (NSString *)GetFillTotalForSection:(NSInteger)Section
{
    CGFloat value = [[self.fillSectionTotals objectAtIndex:Section] doubleValue];
    return [MSUIManager addCurrencyStyleCommaToDouble:value];
}


- (NSString *)getFillValueForRow:(NSInteger)Row inSection:(NSInteger)Section
{
    CGFloat value = [[[self.fillSections objectAtIndex:Section] objectAtIndex:Row] doubleValue];
    
    if (value == 0)
    {
        return @"";
    }
    else {
        return [MSUIManager addCurrencyStyleCommaToDouble:value];
    }
}


- (NSString *)GetFillBalanceOfRemainingFunds
{
    __block CGFloat sectionTotalsValue = 0.00;
    [self.fillSectionTotals enumerateObjectsUsingBlock:^(NSString * sectionTotal, NSUInteger idx, BOOL *stop) {
        
        sectionTotal = [MSUIManager stripDollarSignFromString:sectionTotal];
        sectionTotal = [MSUIManager stripCommasFromString:sectionTotal];
        
        sectionTotalsValue += [sectionTotal doubleValue];
    }];
    
    NSString * remainingBalanceValue = self.fillFundsBudget;
    remainingBalanceValue = [remainingBalanceValue stringByReplacingOccurrencesOfString:kRemainingFundsString withString:@""];
    remainingBalanceValue = [MSUIManager stripDollarSignFromString:remainingBalanceValue];
    remainingBalanceValue = [MSUIManager stripCommasFromString:remainingBalanceValue];
    
    CGFloat remainingBalance = [remainingBalanceValue doubleValue];
    remainingBalance = remainingBalance - sectionTotalsValue;
    
    return [kRemainingFundsString stringByAppendingString:[MSUIManager addCurrencyStyleCommaToDouble:remainingBalance]];
    
}

- (void)resetFillSection
{
    NSUInteger sectionTotalsCount =  self.fillSectionTotals.count;
    
    for(NSInteger i = 0; i < sectionTotalsCount; i++ )
    {
        NSUInteger rowCount = [[self.fillSections objectAtIndex:i] count];
        
        for(NSInteger k = 0; k < rowCount; k++)
        {
            [[self.fillSections objectAtIndex:i] replaceObjectAtIndex:k withObject:kZeroFundsPlaceholder];
        }
        
        
        [self.fillSectionTotals replaceObjectAtIndex:i withObject:kZeroFundsPlaceholder];
    }
}

- (void)executeFillEnvelopes
{
    NSUInteger sectionsCount = self.fillSections.count;
    NSMutableArray * newEnvelopes = [[NSMutableArray alloc] init];
    
    for(NSInteger i = 0; i < sectionsCount; i++ )
    {
        NSString * categoryName = [[self.dataManager.envelopeCategories objectAtIndex:i] name];
        NSArray * envelopes = [Envelope Filter:self.dataManager.envelopes WithCategoryName:categoryName];
        
        
        NSUInteger rowCount = [[self.fillSections objectAtIndex:i] count];
        for(NSInteger k = 0; k < rowCount; k++)
        {
            Envelope * envelope =  [envelopes objectAtIndex:k];
            CGFloat fundsToAdd = [[[self.fillSections objectAtIndex:i] objectAtIndex:k] doubleValue];
            //envelope.remainingBalance += fundsToAdd;
            
            if(fundsToAdd != 0)
            {
                Transaction * transaction = [[Transaction alloc] init];
                transaction.date = [NSDate date];
                transaction.transactionType = transactionTypeAdd;
                transaction.amount = @(fundsToAdd);
                transaction.notes = @"Added from Envelope Filler";
                transaction.user = self.dataManager.currentUserAccount;
                transaction.paytype = envelope.paytype;
                [envelope.transactions addObject:transaction];
                
            }
            
            [newEnvelopes addObject:envelope];
        }
    }
    
    self.dataManager.envelopes = [[NSMutableArray alloc] initWithArray:newEnvelopes];
    [self.dataManager updateEnvelopesObjects];
}

- (void)showPayTypeAlert:(UIPickerTextField *)pickerView;
{
    self.parentPickerView = pickerView;
    
    NSString * title = @"Pay Type";
    NSString * message = @"Enter new Pay Type Name";
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title
                                                     message:message
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"OK", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardAppearanceDark;
    [alertTextField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    alertTextField.delegate = self;
    [alert show];
    
    
}

#pragma mark Private Functions
- (void)createFullStructure
{
    NSUInteger envelopeCategoriesCount = self.dataManager.envelopeCategories.count;
    self.sections = [[NSMutableArray alloc] initWithCapacity:envelopeCategoriesCount];
    

    for(NSInteger i = 0; i < envelopeCategoriesCount; i++)
    {
        EnvelopeSectionData * sectionData = [[EnvelopeSectionData alloc] init];
        sectionData.value = 0.00;
        sectionData.fillValue = 0.00;
        sectionData.envelopes = [[NSMutableArray alloc] init];
        [self.sections addObject:sectionData];
    }
    
    
    self.sections = [[NSMutableArray alloc] init];
    
    [self.dataManager.envelopes enumerateObjectsUsingBlock:^(Envelope * envelope, NSUInteger idx, BOOL *stop) {
        
        NSInteger sectionIndex = (NSInteger)[self.envelopeCategoryIndex objectForKey:envelope.category.name];
        
        EnvelopeData *envelopeData = [[EnvelopeData alloc] init];
        envelopeData.value = 0.0;
        envelopeData.fillValue = 0.0;
        [[self.sections objectAtIndex:sectionIndex] addObject:envelopeData];
        
    }];
    
}




- (void)createFillStructure
{
    NSUInteger envelopeCategoriesCount = self.dataManager.envelopeCategories.count;
    self.fillSections = [[NSMutableArray alloc] initWithCapacity:envelopeCategoriesCount];
    self.fillSectionTotals = [[NSMutableArray alloc] initWithCapacity:envelopeCategoriesCount];
    
    for(NSInteger i = 0; i < envelopeCategoriesCount; i++)
    {
        NSMutableArray * rowArray = [[NSMutableArray alloc] init];
        [self.fillSections addObject:rowArray];
        [self.fillSectionTotals addObject:kZeroFundsPlaceholder];
    }
    
    [self.dataManager.envelopes enumerateObjectsUsingBlock:^(Envelope * envelope, NSUInteger idx, BOOL *stop) {
        
        NSNumber * sectionIndex = [self.envelopeCategoryIndex objectForKey:envelope.category.name];
        
        [[self.fillSections objectAtIndex:[sectionIndex intValue]] addObject:kZeroFundsPlaceholder];
    }];
    
}

- (void)fillEnvelopes:(NSArray *)envelopes withNotes:(NSString *)notes onDate:(NSDate *)date
{
    NSInteger sectionsCount = self.fillSections.count;

    for(NSInteger i = 0; i < sectionsCount; i++ )
    {
        NSString * categoryName = [[self.dataManager.envelopeCategories objectAtIndex:i] name];
        NSArray * filteredEnvelopes = [Envelope Filter:envelopes WithCategoryName:categoryName];
        
        NSInteger rowCount = filteredEnvelopes.count; // [[self.fillSections objectAtIndex:i] count];
        for(NSInteger k = 0; k < rowCount; k++)
        {
            Envelope * envelope =  [filteredEnvelopes objectAtIndex:k];
            CGFloat fundsToAdd = [[[self.fillSections objectAtIndex:i] objectAtIndex:k] doubleValue];
            
            if(fundsToAdd != 0)
            {
                Transaction * transaction = [[Transaction alloc] init];
                transaction.amount = @(fundsToAdd);
                transaction.user = self.dataManager.currentUserAccount;
                transaction.transactionType = transactionTypeAdd;
                transaction.date = date;
                transaction.notes = notes;
                [envelope.transactions addObject:transaction];
            }
        }
    }
    
    [self resetFillSection];
    [self.dataManager updateEnvelopesObjects];
}

- (void)updateEnvelopeCategoryIndex
{
    __block NSMutableDictionary * envelopeCategoryInfo = [[NSMutableDictionary alloc] init];
    [self.dataManager.envelopeCategories enumerateObjectsUsingBlock:^(EnvelopeCategory * envelopeCategory, NSUInteger idx, BOOL *stop) {
        
        NSNumber * i = [[NSNumber alloc] initWithInteger:idx];
        NSString *value = [NSString stringWithFormat:@"%@", i];
        [envelopeCategoryInfo setValue:i forKey:envelopeCategory.name];
        [envelopeCategoryInfo setValue:envelopeCategory.name forKey:value];
    }];
    
    self.envelopeCategoryIndex = [[NSDictionary alloc] initWithDictionary:envelopeCategoryInfo];
}


- (void)recalculateTotals
{
    NSUInteger sectionTotalsCount = self.fillSectionTotals.count;
    
    for(NSInteger i = 0; i < sectionTotalsCount; i++ )
    {
        NSUInteger rowCount = [[self.fillSections objectAtIndex:i] count];
        
        CGFloat sectionValue = 0.0;
        
        for(NSInteger k = 0; k < rowCount; k++)
        {
            CGFloat rowValue = [[[self.fillSections objectAtIndex:i] objectAtIndex:k] doubleValue];
            sectionValue += rowValue;
        }
        
        [self.fillSectionTotals replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%.2f", sectionValue]];
    }
}

- (Envelope *)addTransactionType:(enum TransactionType)type andAmount:(double)amount toEnvelope:(Envelope *)envelope
{
    Transaction * transaction = [[Transaction alloc] init];
    transaction.transactionType = type;
    transaction.date = [NSDate date];
    
    NSMutableArray * transactions = [[NSMutableArray alloc] initWithArray:[envelope.transactions arrayByAddingObject:transaction]];
    envelope.transactions = transactions;
    
    return envelope;
}


- (BOOL)doesPayTypeExist:(NSString *)payTypeToAdd
{
    __block BOOL doesPayTypeExist = NO;
    
    
    [self.payTypeManager.payTypes enumerateObjectsUsingBlock:^(NSString *payType, NSUInteger idx, BOOL *stop) {
        
        if([payTypeToAdd isEqualToString:payType])
        {
            doesPayTypeExist = YES;
        }
    }];
    
    return doesPayTypeExist;
}

#pragma mark AlertView Delegate
/*
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView.title isEqualToString:@"Pay Type"])
    {
        if(buttonIndex == 0) //cancel
        {
            
        }
        else if(buttonIndex == 1) //ok
        {
            NSString * value = [[alertView textFieldAtIndex:0] text];
            value = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
            if(value.length != 0)
            {
                if(![self doesPayTypeExist:value])
                {
                    [self.payTypeManager.payTpyes addObject:value];
                    
                    NSArray * sortedArray = [self.payTypeManager.payTypes sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                    self.payTypeManager.payTpyes = [[NSMutableArray alloc] initWithArray:sortedArray];
                    
                    self.parentPickerView.text = value;
                    self.parentPickerView.options = self.payTypeManager.payTypes;
                    [self.parentPickerView.pickerView reloadAllComponents];
                    [self.dataManager updateEnvelopePayTypesObjects];
                    
                }
            }
            
        }
    }
}
*/
#pragma mark Text Field Delegate
/*- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self base_textFieldDidBeginEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self base_textFieldDidEndEditing:textField];
}
*/
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if([textField isKindOfClass:[UICurrencyTextField class]])
    {
        UICurrencyTextField * currencyTF = (UICurrencyTextField *)textField;
        return [currencyTF currency_textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    return YES;
}

- (BOOL)doesEnvelopeExistWithName:(NSString *)name AndPayType:(NSString *)payType
{
    __block BOOL doesEnvelopeExist = NO;
    
    name = [[name stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
    payType = [[payType stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
    
    [self.dataManager.envelopes enumerateObjectsUsingBlock:^(Envelope * envelope, NSUInteger idx, BOOL *stop) {
        
        NSString * envelopeName = [[envelope.name stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
        NSString * envelopePayType = [[envelope.paytype stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
        
        if([envelopeName isEqualToString:name] && [envelopePayType isEqualToString:payType])
        {
            doesEnvelopeExist = YES;
            *stop = YES;
        }
    }];
    
    return doesEnvelopeExist;
    
}

@end
