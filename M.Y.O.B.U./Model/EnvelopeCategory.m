//
//  EnvelopeCategory.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 3/28/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "EnvelopeCategory.h"
#import "MSDataManager.h"

@implementation EnvelopeCategory

- (void)initCustomProperties
{
    self.name = ([self.name length] == 0) ? @"": self.name;
    self.backgroundColor = ([self.backgroundColor length] == 0) ? @"": self.backgroundColor;
    self.accentColor = ([self.accentColor length] == 0) ? @"": self.accentColor;
    
    self.customProperties = @{@"name":self.name,
                              @"backgroundColor":self.backgroundColor,
                              @"accentColor":self.accentColor};
}

+ (EnvelopeCategory *)getEnvelopeCategoryBy:(NSString *)Name
{
    __block EnvelopeCategory * envelopeCategory;
    MSDataManager * dataManager = [MSDataManager sharedManager];
    NSArray * envelopeCategories = [dataManager envelopeCategories];
    
    [envelopeCategories enumerateObjectsUsingBlock:^(EnvelopeCategory * eCategory, NSUInteger idx, BOOL *stop) {
        
        if([eCategory.name isEqualToString:Name])
        {
            envelopeCategory = eCategory;
        }
    }];
    
    return envelopeCategory;
}

@end
