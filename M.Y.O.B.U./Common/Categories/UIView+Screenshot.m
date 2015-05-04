//
//  UIView+Screenshot.m
//  PrivateCam
//
//  Created by Prince Ugwuh on 10/10/12.
//  Copyright (c) 2012 MFX Studios. All rights reserved.
//

#import "UIView+Screenshot.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Screenshot)

- (UIImage *)screenshot
{
	UIImage *image;
	
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
	{
		UIGraphicsBeginImageContextWithOptions(self.window.bounds.size, NO, [UIScreen mainScreen].scale);
	}
	else
	{
		UIGraphicsBeginImageContext(self.window.bounds.size);
	}
	
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
	image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	return image;
}

- (UIViewController *)parentViewController {
    
    UIResponder * parentResponder = self;
    while (parentResponder != nil) {
        parentResponder = parentResponder.nextResponder;
        NSLog(@"%@", parentResponder);
        if ([[parentResponder class] isSubclassOfClass:[UIViewController class]]) {
            return (UIViewController *)parentResponder;
        }
    }
    
    return  nil;
}

@end
