//
//  Currency.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 12/8/13.
//  Copyright (c) 2013 MYOB University. All rights reserved.
//

#import "Currency.h"
#import "MSDataManager.h"
#import "MSUIManager.h"
#import "NSString+Extension.h"

#define kMAX_COUNTER_VALUE 99999
NSString * const kCurrencyObjectsDefaultKey = @"US Currencies Default";
NSString * const kCurrencyObjectsKey = @"US Currencies";

@interface Currency()
@property (nonatomic, strong) MSDataManager * dataManager;
@property (nonatomic, strong, readwrite) NSString * name;
@property (nonatomic, strong, readwrite) NSNumber * value;
@property (nonatomic, strong, readwrite) NSString * highlightColorRefString;
@end
@implementation Currency

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"%@", self.counter];
}

+ (NSString *)getCurrencyObjectsKey
{
    return kCurrencyObjectsKey;
}
+ (NSString *)getCurrencyObjectsDefaultKey
{
    return kCurrencyObjectsDefaultKey;
}

- (MSDataManager *)dataManager
{
	return [MSDataManager sharedManager];
}

- (UIColor *)highlightColor
{
    return [MSUIManager colorFrom:self.highlightColorRefString];
}

- (NSNumber *) total
{
    NSNumber *intValue = [NSNumber numberWithDouble:[self.counter doubleValue] * [self.value doubleValue]];
    
    return  intValue;
}

- (void)initCustomProperties
{
    self.name = ([self.name length] == 0) ? @"": self.name;
    self.highlightColorRefString = ([self.highlightColorRefString length] == 0) ? @"": self.highlightColorRefString;
    self.value = (self.value == nil) ? @(0): self.value;
    self.counter = (self.counter == nil) ? @(0): self.counter;

    self.customProperties = @{@"name":self.name,
                              @"highlightColorRefString":self.highlightColorRefString,
                              @"value":self.value,
                              @"counter":self.counter};
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.counter = 0;
        
    }
    return self;
}

- (instancetype)cloneWithCurrency:(Currency *)currency
{
    Currency * clone = [self init];
    
    if (clone) {
        
        clone.counter = currency.counter;
        clone.name = currency.name;
        clone.value = currency.value;
        clone.highlightColorRefString = currency.highlightColorRefString;
        clone.indexPath = currency.indexPath;
    }
    return clone;
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
            [mutableDictionary setValue:value forKey:[currentKey stringLowercaseFirstLetter]];
		}
	}];
	
	[super setValuesForKeysWithDictionary:mutableDictionary];
}

- (void)incrementCounter
{
    if([self.counter integerValue] < kMAX_COUNTER_VALUE)
    {
        //create and save current values as an undo action
        
        [self.dataManager addCurrencyUndoAction:[[Currency alloc] cloneWithCurrency:self]];
        
        self.counter = @([self.counter integerValue] +1);
        
        //save value
        [self.dataManager updateCurrencyObjects];
    }
}

- (void)reverseCounter
{
    if([self.counter integerValue] > 0)
    {
        //create and save current values as an undo action
        
        [self.dataManager addCurrencyUndoAction:[[Currency alloc] cloneWithCurrency:self]];
        
        self.counter  =@([self.counter integerValue] -1);
        
        //save value
        [self.dataManager updateCurrencyObjects];
    }
}

- (void)updateCounter:(NSNumber *)counter
{
    //create and save current values as an undo action
    [self.dataManager addCurrencyUndoAction:[[Currency alloc] cloneWithCurrency:self]];
    
    self.counter = counter;
    
    //save value
    [self.dataManager updateCurrencyObjects];
}


@end
