//
//  DataUtilities.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 12/8/13.
//  Copyright (c) 2013 MYOB University. All rights reserved.
//

#import "MSDataUtilities.h"

#define kPlistType @"plist"
#define kFEATURE_NAME                    @"Feature Name"
#define kFEATURE_CONTENT                 @"Content"

@implementation MSDataUtilities



+ (NSMutableDictionary *)getDataFromPlistInMainBundle:(NSString *)plistName
{
    NSMutableDictionary * rootData = nil;
    
    NSString *mainBundlePlistFilePath = [[NSBundle mainBundle] pathForResource:plistName ofType:kPlistType];
    rootData = [NSMutableDictionary dictionaryWithContentsOfFile:mainBundlePlistFilePath];
    
    return rootData;
}

+ (NSMutableDictionary *)getDataFromPlistByName:(NSString *)plistName
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSString * plistFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",plistName, kPlistType]];
    
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:plistFilePath])
    {
        //no data exist copy from main bundle plist
        NSString *mainBundlePlistFilePath = [[NSBundle mainBundle] pathForResource:plistName ofType:kPlistType];
        NSMutableDictionary * rootData = [NSMutableDictionary dictionaryWithContentsOfFile:mainBundlePlistFilePath];
        [rootData writeToFile:plistFilePath atomically:YES];
    }
    
    
    // read property list into memory as an NSData object
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistFilePath];
	NSString *errorDesc = nil;
	NSPropertyListFormat format;
    
	// convert static property list into dictionary object
	NSMutableDictionary *temp = (NSMutableDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
	
    
    if (!temp)
	{
		NSLog(@"Error reading plist: %@", errorDesc);
	}
    
    return temp;
}

+ (void)saveDataToPlistByName:(NSString*)plistName key:(NSString *)key data:(NSData *)data feature:(NSString *)feature
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSString * plistFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",plistName]];
    
    
    if([[NSFileManager defaultManager] fileExistsAtPath:plistFilePath])
    {
        //if file exist copy from main bundle plist
        NSMutableDictionary * rootData = [NSMutableDictionary dictionaryWithContentsOfFile:plistFilePath];
        NSMutableDictionary * content = [rootData objectForKey:kFEATURE_CONTENT];
        
        [content setObject:data forKey:key];
        [rootData setObject:content forKey:kFEATURE_CONTENT];
        
        
        if([rootData writeToFile:plistFilePath atomically:YES])
        {
            NSLog(@"Data Saved!");
        }
        else
        {
            NSLog(@"Data NOT Saved!");
        }
    }
    
}

+ (void)saveDataToPlistByName:(NSString*)plistName key:(NSString *)key array:(NSArray *)array feature:(NSString *)feature
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSString * plistFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",plistName]];
    
    
    if([[NSFileManager defaultManager] fileExistsAtPath:plistFilePath])
    {
        //if file exist copy from main bundle plist
        NSMutableDictionary * rootData = [NSMutableDictionary dictionaryWithContentsOfFile:plistFilePath];
        NSMutableDictionary * content = [rootData objectForKey:kFEATURE_CONTENT];
        
        [content setObject:array forKey:key];
        [rootData setObject:content forKey:kFEATURE_CONTENT];
        
        
        if([rootData writeToFile:plistFilePath atomically:YES])
        {
            NSLog(@"Data Saved!");
            //TODO: if show indicator
        }
        else
        {
            NSLog(@"Data NOT Saved!");
        }
    }
    
}
@end
