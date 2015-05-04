//
//  MSModleObject.h
//  PrivateCam
//
//  Created by Prince Ugwuh on 11/26/12.
//  Copyright (c) 2012 MFX Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSModelObject : NSObject<NSCoding>
@property (nonatomic, assign) BOOL onlineObject;
@property (nonatomic, assign) BOOL snyced;
@property (nonatomic, strong) NSDictionary * customProperties;

+ (NSDateFormatter *)serverDateFormatter;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end