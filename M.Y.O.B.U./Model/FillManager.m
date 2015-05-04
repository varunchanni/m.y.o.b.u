//
//  FillManager.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 4/30/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "FillManager.h"
#import "MSDataManager.h"
#import "MSUIManager.h"
#import "EnvelopeCategory.h"
#import "Envelope.h"

static NSString * const kRemainingFundsString = @"Remaining Funds: $";

@interface FillManager()
@property (nonatomic, strong) MSDataManager * dataManager;
@property (nonatomic, strong) NSMutableArray * sections;
@property (nonatomic, strong) NSMutableArray * sectionTotals;
@property (nonatomic, strong) NSDictionary * envelopeCategoryInfo;
@end

@implementation FillManager

+ (id)sharedManager
{
	static FillManager *_sharedManager = nil;
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

- (id)init
{
    if(self)
    {
        [self updateEnvelopeCategoryInfo];
        [self createStructure];
    }
    
    return self;
}


#pragma mark Public Functions

- (void)UpdateDataAtSection:(int)Section AtRow:(int)Row withValue:(double)Value
{
    NSString * stringValue = [NSString stringWithFormat:@"%.2f", Value];
    [[self.sections objectAtIndex:Section] replaceObjectAtIndex:Row withObject:stringValue];
    
    [self recalculateTotals];
    
}

- (NSString *)GetTotalForSection:(int)Section
{
    CGFloat value = [[self.sectionTotals objectAtIndex:Section] doubleValue];
    return [@"$" stringByAppendingString:[MSUIManager addCurrencyStyleCommaToDouble:value]];
}


- (NSString *)getValueForRow:(int)Row inSection:(int)Section
{
    CGFloat value = [[[self.sections objectAtIndex:Section] objectAtIndex:Row] doubleValue];
    return [@"$" stringByAppendingString:[MSUIManager addCurrencyStyleCommaToDouble:value]];
}


- (NSString *)GetBalanceOfRemainingFunds
{
    __block CGFloat sectionTotalsValue = 0.00;
    [self.sectionTotals enumerateObjectsUsingBlock:^(NSString * sectionTotal, NSUInteger idx, BOOL *stop) {
        
        sectionTotal = [MSUIManager stripDollarSignFromString:sectionTotal];
        sectionTotal = [MSUIManager stripCommasFromString:sectionTotal];
        
        sectionTotalsValue += [sectionTotal doubleValue];
    }];
    
    NSString * remainingBalanceValue = self.fundsBudget;
    remainingBalanceValue = [remainingBalanceValue stringByReplacingOccurrencesOfString:kRemainingFundsString withString:@""];
    remainingBalanceValue = [MSUIManager stripDollarSignFromString:remainingBalanceValue];
    remainingBalanceValue = [MSUIManager stripCommasFromString:remainingBalanceValue];
    
    CGFloat remainingBalance = [remainingBalanceValue doubleValue];
    remainingBalance = remainingBalance - sectionTotalsValue;
    
    return [kRemainingFundsString stringByAppendingString:[MSUIManager addCurrencyStyleCommaToDouble:remainingBalance]];
    
}

- (void)reset
{
    NSInteger sectionTotalsCount = self.sectionTotals.count;
    
    for(NSInteger i = 0; i < sectionTotalsCount; i++ )
    {
        NSInteger rowCount = [[self.sections objectAtIndex:i] count];
        
        for(NSInteger k = 0; k < rowCount; k++)
        {
            [[self.sections objectAtIndex:i] replaceObjectAtIndex:k withObject:@"0.00"];
        }
        
        
        [self.sectionTotals replaceObjectAtIndex:i withObject:@"0.00"];
    }
}

- (void)fillEnvelopes
{
    NSInteger sectionsCount = self.sections.count;
    
    for(NSInteger i = 0; i < sectionsCount; i++ )
    {
        NSString * categoryName = [[self.dataManager.envelopeCategories objectAtIndex:i] name];
        NSArray * envelopes = [Envelope Filter:self.dataManager.envelopes WithCategoryName:categoryName];
        
        NSInteger rowCount = [[self.sections objectAtIndex:i] count];
        for(NSInteger k = 0; k < rowCount; k++)
        {
            Envelope * envelope =  [envelopes objectAtIndex:k];
            CGFloat fundsToAdd = [[[self.sections objectAtIndex:i] objectAtIndex:k] doubleValue];
            
            if(fundsToAdd != 0)
            {
                Transaction * transaction = [[Transaction alloc] init];
                transaction.amount = @(fundsToAdd);
                transaction.user = self.dataManager.currentUserAccount;
                transaction.transactionType = transactionTypeAdd;
                transaction.date = [[NSDate alloc] init];
                [envelope.transactions addObject:transaction];
            }
        }
    }
    
    [self.dataManager updateEnvelopesObjects];
}

#pragma mark Private Functions

- (void)createStructure
{
    NSInteger envelopeCategoriesCount = self.dataManager.envelopeCategories.count;
    self.sections = [[NSMutableArray alloc] initWithCapacity:envelopeCategoriesCount];
    self.sectionTotals = [[NSMutableArray alloc] initWithCapacity:envelopeCategoriesCount];
    
    for(NSInteger i = 0; i < envelopeCategoriesCount; i++)
    {
        NSMutableArray * rowArray = [[NSMutableArray alloc] init];
        [self.sections addObject:rowArray];
        [self.sectionTotals addObject:@"0.00"];
    }
    
    [self.dataManager.envelopes enumerateObjectsUsingBlock:^(Envelope * envelope, NSUInteger idx, BOOL *stop) {
        
        NSNumber * sectionIndex = [self.envelopeCategoryInfo objectForKey:envelope.category.name];
      
        [[self.sections objectAtIndex:[sectionIndex intValue]] addObject:@"0.00"];
    }];
    
}

- (void)updateEnvelopeCategoryInfo
{
    __block NSMutableDictionary * envelopeCategoryInfo = [[NSMutableDictionary alloc] init];
    [self.dataManager.envelopeCategories enumerateObjectsUsingBlock:^(EnvelopeCategory * envelopeCategory, NSUInteger idx, BOOL *stop) {
        
        NSNumber * i = [[NSNumber alloc] initWithInteger:idx];
        [envelopeCategoryInfo setValue:i forKey:envelopeCategory.name];
        
    }];
    
    self.envelopeCategoryInfo = [[NSDictionary alloc] initWithDictionary:envelopeCategoryInfo];
}


- (void)recalculateTotals
{
    NSInteger sectionTotalsCount = self.sectionTotals.count;
    
    for(NSInteger i = 0; i < sectionTotalsCount; i++ )
    {
        NSInteger rowCount = [[self.sections objectAtIndex:i] count];
        
        CGFloat sectionValue = 0.0;
        
        for(NSInteger k = 0; k < rowCount; k++)
        {
            CGFloat rowValue = [[[self.sections objectAtIndex:i] objectAtIndex:k] doubleValue];
            sectionValue += rowValue;
        }
        
        [self.sectionTotals replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%.2f", sectionValue]];
    }
}



@end
