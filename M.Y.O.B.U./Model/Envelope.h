//
//  Envelope.h
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 3/28/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "MSModelObject.h"
#import "EnvelopeCategory.h"
#import "UserAccount.h"
#import "Transaction.h"


@interface Envelope : MSModelObject
@property (nonatomic, strong) EnvelopeCategory * category;
@property (nonatomic, strong) NSNumber * defaultOrder;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * notes;
@property (nonatomic, strong) NSString * paytype;
@property (nonatomic, strong) NSNumber * startingBalance;
@property (nonatomic, strong) NSMutableArray * transactions;
@property (nonatomic, strong, readonly) NSDate * lastModiefiedDate;

@property (nonatomic, strong) NSNumber * totalSpent;
@property (nonatomic, strong) NSNumber * totalFilled;
@property (nonatomic, strong) NSNumber * totalSpentYTD;
@property (nonatomic, strong) NSNumber * totalFilledYTD;
@property (nonatomic, strong) NSNumber * balance;
@property (nonatomic, strong) NSString * displayBalance;
@property (nonatomic, strong) NSString * displayTotalSpent;
@property (nonatomic, strong) NSString * displayTotalFilled;
@property (nonatomic, strong) NSString * displayTotalSpentYTD;
@property (nonatomic, strong) NSString * displayTotalFilledYTD;
@property (nonatomic, strong, readonly) NSString * identifier;





+ (NSArray *)Filter:(NSArray *)envelopes WithCategoryName:(NSString *)categoryName;
+ (NSArray *)Filter:(NSArray *)envelopes WithPayType:(NSString *)payType;

- (id)initWithDictionary:(NSDictionary *)dictionary andUser:(UserAccount *)user OnDate:(NSDate *)date;
- (void)update;
// - (void)makeEnvelopeTransaction:(Transaction *)transaction;

@end
