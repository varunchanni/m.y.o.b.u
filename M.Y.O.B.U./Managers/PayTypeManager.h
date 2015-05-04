//
//  PayTypeManager.h
//  M.Y.O.B.U.
//
//  Created by Raymond on 2/16/15.
//  Copyright (c) 2015 MYOB University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayType.h"

static NSString * const kPayTypesKey = @"PayTypes";

@interface PayTypeManager : NSObject
@property (nonatomic, strong, readonly) NSMutableArray * payTypes;


- (void) initialize;
+ (id)sharedManager;
- (void)addPayType:(NSString *)name;
- (NSInteger)getIndexOfPayType:(NSString *)name;
- (void)savePayTypes;
- (BOOL)payTypeInUse:(PayType *)payType;
- (void)deletePayType:(PayType *)payType;
- (void)renamePayType:(PayType *)payType withName:(NSString *)name;
- (PayType *)getPayTypeByName:(NSString *)name;
@end
