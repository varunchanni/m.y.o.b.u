//
//  EnvelopeCategory.h
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 3/28/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "MSModelObject.h"

@interface EnvelopeCategory : MSModelObject
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * backgroundColor;
@property (nonatomic, strong) NSString * accentColor;

+ (EnvelopeCategory *)getEnvelopeCategoryBy:(NSString *)Name;
@end
