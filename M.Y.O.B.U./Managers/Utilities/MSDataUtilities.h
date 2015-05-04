//
//  MSDataUtilities.h
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 12/8/13.
//  Copyright (c) 2013 MYOB University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSDataUtilities : NSObject

+ (NSMutableDictionary *)getDataFromPlistInMainBundle:(NSString *)plistName;
+ (NSMutableDictionary *)getDataFromPlistByName:(NSString *)plistName;
+ (void)saveDataToPlistByName:(NSString*)plistName key:(NSString *)key array:(NSArray *)array feature:(NSString *)feature;
+ (void)saveDataToPlistByName:(NSString*)plistName key:(NSString *)key data:(NSData *)data feature:(NSString *)feature;
@end
