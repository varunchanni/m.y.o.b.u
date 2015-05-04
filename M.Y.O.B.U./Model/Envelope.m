//
//  Envelope.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 3/28/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "Envelope.h"
#import "EnvelopeCategory.h"
#import "MSUIManager.h"
#import "NSString+Extension.h"
#import "EnvelopeManager.h"
#import "PayTypeManager.h"
#import "MSDataManager.h"


@implementation Envelope


- (NSDate *)lastModiefiedDate {
    
    if(self.transactions.count == 0 || [self.transactions.firstObject class] != [Transaction class]) {
        return [NSDate dateWithTimeIntervalSince1970:0];
    }
    else {
        Transaction * transaction = self.transactions.lastObject;
        return transaction.date;
    }
    /*
    else if ([self.transactions.firstObject class] != [Transaction class]) {
        return [NSDate date];
    }
    else {
        Transaction * lastTranscation = self.transactions.lastObject;
        
        return lastTranscation.date;
    }*/
}

- (NSNumber *)totalMovedOut
{
    return [[EnvelopeManager sharedManager] totalAmountFromFilterTransactions:self.transactions type:transactionTypeMoveMinus];
}

- (NSNumber *)totalMovedIn
{
    return [[EnvelopeManager sharedManager] totalAmountFromFilterTransactions:self.transactions type:transactionTypeMoveAdd];
}

- (NSNumber *)totalSpent
{
    return [[EnvelopeManager sharedManager] totalAmountFromFilterTransactions:self.transactions type:transactionTypeMinus];
}

- (NSNumber *)totalFilled
{
    return [[EnvelopeManager sharedManager] totalAmountFromFilterTransactions:self.transactions type:transactionTypeAdd];
}

- (NSNumber *)totalSpentYTD
{
    return [[EnvelopeManager sharedManager] totalYTDAmountFromFilterTransactions:self.transactions type:transactionTypeMinus];
}

- (NSNumber *)totalFilledYTD
{
    return [[EnvelopeManager sharedManager] totalYTDAmountFromFilterTransactions:self.transactions type:transactionTypeAdd];
}
- (NSNumber *)balance
{
    double startingbal = [self.startingBalance doubleValue];
    double additions = [self.totalFilled doubleValue] + [[self totalMovedIn] doubleValue];
    double subtractions = [self.totalSpent doubleValue] + [[self totalMovedOut] doubleValue];
    
    return [NSNumber numberWithFloat:(startingbal + (additions- subtractions))];
}

- (NSString *)displayTotalSpent
{
    return [MSUIManager addCurrencyStyleCommaToDouble:[self.totalSpent doubleValue]];
}

- (NSString *)displayTotalFilled
{
    return [MSUIManager addCurrencyStyleCommaToDouble:[self.totalFilled doubleValue]];
}

- (NSString *)displayTotalSpentYTD
{
    return [MSUIManager addCurrencyStyleCommaToDouble:[self.totalSpentYTD doubleValue]];
}

- (NSString *)displayTotalFilledYTD
{
    return [MSUIManager addCurrencyStyleCommaToDouble:[self.totalFilledYTD doubleValue]];
}

- (NSString *)displayBalance
{
    return [MSUIManager addCurrencyStyleCommaToDouble:[self.balance doubleValue]];
}

- (NSString *)identifier
{
    return [[self.name lowercaseString] stringByAppendingString:[NSString stringWithFormat:@" -  %@",self.paytype]];
}



- (NSMutableArray *)transactions
{
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    _transactions = [[_transactions sortedArrayUsingDescriptors:@[sort]] mutableCopy];
    
    return _transactions;
}

- (void)initCustomProperties
{
    self.name = ([self.name length] == 0) ? @"": self.name;
    self.notes = ([self.notes length] == 0) ? @"": self.notes;
    self.paytype = ([self.paytype length] == 0) ? @"": self.paytype;
    //self.lastModiefiedDate = (self.lastModiefiedDate == nil) ? [NSDate date] : self.lastModiefiedDate;
    self.transactions = ([self.transactions count] == 0) ? @[@""].mutableCopy: self.transactions;
    self.category = (self.category == nil) ? [[EnvelopeCategory alloc] init] : self.category;
    self.defaultOrder = (self.defaultOrder == nil) ? @(0): self.defaultOrder;
    self.startingBalance = (self.startingBalance == nil) ? @(0): self.startingBalance;
    
    
    self.customProperties = @{@"name":self.name,
                              @"notes":self.notes,
                              @"paytype":self.paytype,
                              @"startingBalance":self.startingBalance,
                              @"transactions":self.transactions,
                              @"category":self.category,
                              @"defaultOrder":self.defaultOrder};
}

- (id)initWithDictionary:(NSDictionary *)dictionary andUser:(UserAccount *)user OnDate:(NSDate *)date
{
    self = [super initWithDictionary:dictionary];
    
    if(self)
    {
        if(self.startingBalance == 0)
        {
            self.startingBalance = @(0.00);
        }
        
        if(self.transactions == nil)
        {
            self.transactions = [[NSMutableArray alloc] init];
            [self transactionCreated:user onDate:date];
        }
        
        
        [[PayTypeManager sharedManager] addPayType:self.paytype];
    }
    
    return self;
}

- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
	NSArray *keys = [keyedValues allKeys];
	NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    
	[keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		
		NSString *currentKey = (NSString *)obj;
		id value = [keyedValues valueForKey:currentKey];
		if (value != nil)
		{
            //only if string conversions are needed
            if([[value class] isSubclassOfClass:[NSString class]])
            {
                /*
                if([[currentKey stringLowercaseFirstLetter] isEqualToString:@"remainingBalance"])
                {
                    //stripes commas and dollar signs
                    value = [NSString stringWithFormat:@"%.2f", [MSUIManager convertStringToDoubleValue:value]];
                }
                else
                   */
                if([[currentKey stringLowercaseFirstLetter] isEqualToString:@"category"])
                {
                    
                    value = [EnvelopeCategory getEnvelopeCategoryBy:value];
                    
                }
            }
            
            [mutableDictionary setValue:value forKey:[currentKey stringLowercaseFirstLetter]];
		}
        

	}];
	
	[super setValuesForKeysWithDictionary:mutableDictionary];
}

+ (NSArray *)Filter:(NSArray *)envelopes WithCategoryName:(NSString *)categoryName
{
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"category.name ==[c] %@", categoryName];
    //NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"defaultOrder" ascending:YES];
    NSArray * envelopesArray = [envelopes filteredArrayUsingPredicate:filterPredicate];
    //envelopesArray = [envelopesArray sortedArrayUsingDescriptors:@[descriptor]];

    return envelopesArray;
}

+ (NSArray *)Filter:(NSArray *)envelopes WithPayType:(NSString *)payType
{
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"SELF.paytype ==[c] %@", payType];
    //NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"defaultOrder" ascending:YES];
    NSArray * envelopesArray = [envelopes filteredArrayUsingPredicate:filterPredicate];
    //envelopesArray = [envelopesArray sortedArrayUsingDescriptors:@[descriptor]];
    
    return envelopesArray;
}


- (void)transactionCreated:(UserAccount *)user onDate:(NSDate *)date
{
    Transaction * transaction = [[Transaction alloc]init];
    transaction.date = date;
    transaction.amount = self.startingBalance;
    transaction.transactionType = transactionTypeCreated;
    transaction.notes = @"Envelope Created";
    
    if (self.notes != nil) {
    NSString * notesValue = [self.notes stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![notesValue isEqualToString:@""]) {
        
        transaction.notes = [transaction.notes stringByAppendingFormat:@" - %@", self.notes];
    }
    }
    
    transaction.user = user;
    [self.transactions addObject:transaction];
}

- (void)update {

    //make sure this object is in self.dataManager.envelopes
    [[[MSDataManager sharedManager] envelopes] enumerateObjectsUsingBlock:^(Envelope * e, NSUInteger idx, BOOL *stop) {
        
        if(e.identifier == self.identifier){
            e = self;
            *stop = YES;
        }
        
    }];
 
    [[MSDataManager sharedManager] updateEnvelopesObjects];
}


@end
