//
//  UIBarButtonItem+Extension.m
//  PrivateCam
//
//  Created by Prince Ugwuh on 10/18/12.
//  Copyright (c) 2012 MFX Studios. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

- (CGRect)frameForView:(UIView *)view
{
	CGRect frame = CGRectZero;
	UIView *customView = self.customView;
	
	if (!customView && [self respondsToSelector:@selector(view)])
	{
		customView = [self performSelector:@selector(view)];
	}
	
	UIView *parentView = customView.superview;
	NSArray *subviews = parentView.subviews;
	
	BOOL containsView = [subviews containsObject:customView];
	NSUInteger subviewCount = subviews.count;
	
	if (subviewCount > 0 && containsView)
	{
		NSInteger indexOfView = [subviews indexOfObject:customView];
		UIView *button = parentView.subviews[indexOfView];
		frame = [button convertRect:button.bounds toView:view];
	}
	
	return frame;
}

@end
