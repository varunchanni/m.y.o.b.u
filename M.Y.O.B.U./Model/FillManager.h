//
//  FillManager.h
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 4/30/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FillManager : NSObject
@property (nonatomic, strong) NSString * fundsBudget;

+ (id)sharedManager;
- (void)UpdateDataAtSection:(int)Section AtRow:(int)Row withValue:(double)Value;
- (NSString *)GetTotalForSection:(int)Section;
- (NSString *)getValueForRow:(int)Row inSection:(int)Section;
- (NSString *)GetBalanceOfRemainingFunds;
- (void)fillEnvelopes;
- (void)reset;
@end
