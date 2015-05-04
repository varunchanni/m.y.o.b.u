//
//  NSError+Extension.h
//  PrivateCam
//
//  Created by Prince Ugwuh on 6/13/13.
//  Copyright (c) 2013 MFX Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    MSErrorCodeDefault = 100,
    MSErrorCodeThirdParty,
    MSErrorCodeClientAPI
} MSErrorCode;

@interface NSError (Extension)
+ (NSError *)defaultErroWithLocalizedDescription:(NSString *)description;
+ (NSError *)thirdPartyErroWithLocalizedDescription:(NSString *)description;
+ (NSError *)clientAPIErroWithLocalizedDescription:(NSString *)description;
@end
