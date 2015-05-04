//
//  NSString+Extension.h
//  PrivateCam
//
//  Created by Prince Ugwuh on 8/26/12.
//  Copyright (c) 2012 MFX Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
- (BOOL)isEmailString;
- (NSString *)stringLowercaseFirstLetter;
- (NSString *)stringCapitalizeFirstLetter;
+ (NSString *)stringWithUUID;
+ (NSString *)tinyURLWithURLString:(NSString *)urlString;

+ (NSString *)stringWithCurrency:(NSString*)string;
+ (NSString *)stringWithCurrencyCommas:(NSString *)string;
+ (NSString *)stringByRemovingCurrencyCharacters:(NSString *)string;
+ (NSString *)stringWithCurrencyDecimals:(NSString *)string;
@end
