//
//  NSError+Extension.m
//  PrivateCam
//
//  Created by Prince Ugwuh on 6/13/13.
//  Copyright (c) 2013 MFX Studios. All rights reserved.
//

#import "NSError+Extension.h"

@implementation NSError (Extension)

+ (NSError *)defaultErroWithLocalizedDescription:(NSString *)description
{
    return [NSError errorWithDomain:@"com.mfxstudios.com"
                               code:MSErrorCodeDefault
                           userInfo:@{ NSLocalizedDescriptionKey: description }];
}

+ (NSError *)thirdPartyErroWithLocalizedDescription:(NSString *)description
{
    return [NSError errorWithDomain:@"com.mfxstudios.com"
                               code:MSErrorCodeThirdParty
                           userInfo:@{ NSLocalizedDescriptionKey: description }];
}

+ (NSError *)clientAPIErroWithLocalizedDescription:(NSString *)description
{
    return [NSError errorWithDomain:@"com.mfxstudios.com"
                               code:MSErrorCodeClientAPI
                           userInfo:@{ NSLocalizedDescriptionKey: description }];
}


@end
