//
//  UIFont+Theme.m
//  PrivateCam
//
//  Created by Prince Ugwuh on 12/28/12.
//  Copyright (c) 2012 MFX Studios. All rights reserved.
//

#import "UIFont+AppFont.h"

static NSString * const kOpenSansRegular = @"OpenSans";
static NSString * const kOpenSansBold = @"OpenSans-Bold";
static NSString * const kOpenSansBoldItalic = @"OpenSans-BoldItalic";

@implementation UIFont (AppFont)

+ (UIFont *)openSansRegularWithSize:(CGFloat)size
{
	return [UIFont fontWithName:kOpenSansRegular size:size];
}

+ (UIFont *)openSansBoldWithSize:(CGFloat)size
{
	return [UIFont fontWithName:kOpenSansBold size:size];
}

+ (UIFont *)openSansBoldItalicWithSize:(CGFloat)size
{
	return [UIFont fontWithName:kOpenSansBoldItalic size:size];
}

@end
