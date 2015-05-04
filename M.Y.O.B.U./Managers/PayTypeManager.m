//
//  PayTypeManager.m
//  M.Y.O.B.U.
//
//  Created by Raymond on 2/16/15.
//  Copyright (c) 2015 MYOB University. All rights reserved.
//

#import "PayTypeManager.h"
#import "Envelope.h"
#import "MSDataManager.h"


@interface PayTypeManager()
@property (nonatomic, strong) NSMutableArray * payTypes;
@end

@implementation PayTypeManager



+ (id)sharedManager
{
    static PayTypeManager *_sharedManager = nil;
    static dispatch_once_t onceQueue;
    
    dispatch_once(&onceQueue, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}




- (void) initialize {
    
    self.payTypes = [[NSMutableArray alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:kPayTypesKey] != nil) {
        NSMutableArray * payTypeNames = [defaults valueForKey:kPayTypesKey];
        
        for (NSString * payTypeName in payTypeNames) {
            [self addPayType:payTypeName];
        }
    }
    
    [self sort];
}

- (void)sort {
    self.payTypes = [[self.payTypes sortedArrayUsingComparator:^NSComparisonResult(PayType * payType, PayType * payType2) {
        return [payType.name compare:payType2.name];
    }] mutableCopy];
}

- (void)addPayType:(NSString *)name {
    
    if ([self getIndexOfPayType:name] == -1) {
        
        PayType * payType = [[PayType alloc] init];
        payType.name = name;
        [self.payTypes addObject:payType];
        [self sort];
        [self savePayTypes];
    }
}

- (void)renamePayType:(PayType *)payType withName:(NSString *)name {
    
    if([self hasPayTypeNamed:name]) {
        // has pay type with name
        
    }
    else {
     
        for (Envelope * e in [[MSDataManager sharedManager] envelopes]) {
            
            if ([e.paytype isEqualToString:payType.name]) {
                
                e.paytype = name;
            }
        }
        
        payType.name = name;
        
        [[MSDataManager sharedManager] updateEnvelopesObjects];
        [self sort];
        [self savePayTypes];
    }
}

- (BOOL)hasPayTypeNamed:(NSString *)name {
    
    bool hasPayType = false;
    for (PayType * payType in self.payTypes) {
        
        
        
        if([[payType.name lowercaseString] isEqualToString:[name lowercaseString]]) {
            hasPayType = true;
            break;
        }
    }
    
    return hasPayType;
}

- (BOOL)payTypeInUse:(PayType *)payType {
    
    bool inUse = false;
    for (Envelope * e in [[MSDataManager sharedManager] envelopes]) {
        
        if ([e.paytype isEqualToString:payType.name]) {
            
            inUse = true;
            break;
        }
    }
    
    return inUse;
}

- (void)deletePayType:(PayType *)payType {
    
    if (![self payTypeInUse:payType]) {
        
        NSMutableArray *newPayTypes = [[NSMutableArray alloc] init];
        for (PayType * pType in self.payTypes) {
            
            if (![[pType.name lowercaseString] isEqualToString:[payType.name lowercaseString]]) {
                
                [newPayTypes addObject:pType];
            }
        }
        self.payTypes = newPayTypes;
        [self sort];
        [self savePayTypes];
    }
}

- (NSInteger)getIndexOfPayType:(NSString *)name {
    
    for (int i=0; i<self.payTypes.count; i++) {
        PayType * payType = self.payTypes[i];
        if ([[payType.name lowercaseString ] isEqualToString:[name lowercaseString]]) {
            return i;
        }
    }
    
    return -1;
}


-(void) savePayTypes {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray * payTypeNames = [[NSMutableArray alloc] init];
    
    for (PayType * pt in self.payTypes) {
        
        [payTypeNames addObject:pt.name];
    }
    
    [defaults setObject:payTypeNames forKey:kPayTypesKey];
}

- (PayType *)getPayTypeByName:(NSString *)name {
    
    for (PayType * payType in self.payTypes) {
        if ([[payType.name lowercaseString] isEqualToString:[name lowercaseString]]) {
            return payType;
        }
    }
    
    return nil;
}

@end
