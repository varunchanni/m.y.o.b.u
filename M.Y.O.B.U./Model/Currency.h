//
//  Currency.h
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 12/8/13.
//  Copyright (c) 2013 MYOB University. All rights reserved.
//

#import "MSModelObject.h"

@interface Currency : MSModelObject <NSObject>
@property (nonatomic, strong, readonly) NSString * name;
@property (nonatomic, strong, readonly) NSNumber * value;
@property (nonatomic, strong) NSNumber * counter;
@property (nonatomic, strong) NSIndexPath * indexPath;
@property (nonatomic, strong, readonly) NSNumber * total;
@property (nonatomic, strong, readonly) NSString * highlightColorRefString;
@property (nonatomic, strong, readonly) UIColor * highlightColor;

- (instancetype)cloneWithCurrency:(Currency *)currency;
- (void)incrementCounter;
- (void)reverseCounter;
- (void)updateCounter:(NSNumber *)counter;

+ (NSString *)getCurrencyObjectsKey;
+ (NSString *)getCurrencyObjectsDefaultKey;
@end
