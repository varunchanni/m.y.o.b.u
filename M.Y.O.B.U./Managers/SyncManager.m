//
//  SyncManager.m
//  M.Y.O.B.U.
//
//  Created by AppleMac on 8/30/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "SyncManager.h"
#import "MSDataManager.h"

@interface SyncManager()
@property (nonatomic, strong) NSMutableArray * syncQueue;

@end

@implementation SyncManager

+ (id)sharedManager
{
	static SyncManager *_sharedManager = nil;
    static dispatch_once_t onceQueue;
	
    dispatch_once(&onceQueue, ^{
        _sharedManager = [[self alloc] init];
    });
    
	return _sharedManager;
}




@end
