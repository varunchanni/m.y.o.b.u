//
//  MSModleObject.m
//  PrivateCam
//
//  Created by Prince Ugwuh on 11/26/12.
//  Copyright (c) 2012 MFX Studios. All rights reserved.
//

#import "MSModelObject.h"
#import "NSString+Extension.h"

@implementation MSModelObject

+ (NSDateFormatter *)serverDateFormatter
{
    static NSDateFormatter *dateFormat = nil;
    static dispatch_once_t onceQueue;
	
    dispatch_once(&onceQueue, ^{
        dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    });
		
    return dateFormat;
}


- (id)initWithDictionary:(NSDictionary *)dictionary
{
	self = [self init];
	if (self)
	{
        if (dictionary != nil)
        {
            [self setValuesForKeysWithDictionary:dictionary];
        }
	}
	return self;
}

- (void)initCustomProperties
{
    //must override this function to save data
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    
    if(self.customProperties == nil)
    {
        [self initCustomProperties];
    }
    
    [self.customProperties enumerateKeysAndObjectsUsingBlock:^(NSString * key, id obj, BOOL *stop) {
        
        [encoder encodeObject:obj forKey:key];
    }];
    
}


- (id)initWithCoder:(NSCoder *)encoder {
    
    if(self.customProperties == nil)
    {
        [self initCustomProperties];
    }
    
    NSDictionary * initData = @{}.mutableCopy;
    [self.customProperties enumerateKeysAndObjectsUsingBlock:^(NSString * key, id obj, BOOL *stop) {
        [initData setValue:[encoder decodeObjectForKey:key] forKey:key];
        
    }];
    

    
    
    self = [[[self class] alloc] initWithDictionary:initData];
    
    return self;
}

#pragma mark -
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

@end
