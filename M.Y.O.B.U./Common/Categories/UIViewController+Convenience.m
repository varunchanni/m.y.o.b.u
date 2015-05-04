//
//  UIViewController+Convience.m
//  PrivateCam
//
//  Created by Prince Ugwuh on 8/25/12.
//  Copyright (c) 2012 MFX Studios. All rights reserved.
//

#import "UIViewController+Convenience.h"

static NSString *const kDefaultStoryboard = @"MainStoryboard";
static NSString *const kStoryboard568h = @"MainStoryboard-568";

@implementation UIViewController (Convenience)

+ (BOOL)is568h
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
	{
		if ([UIScreen mainScreen].scale == 2.0f)
		{
			CGSize result = [[UIScreen mainScreen] bounds].size;
			CGFloat scale = [UIScreen mainScreen].scale;
			result = CGSizeMake(result.width * scale, result.height * scale);
			
			if (result.height == 1136)
			{
				return YES;
			}
		}
	}

	return NO;
}

+ (id)storyboard568h
{
    NSString *identifier = [NSString stringWithFormat:@"%@",NSStringFromClass([self class])];
    return [self storyboardWithName:kStoryboard568h viewControllerIdentifier:identifier];
}

+ (id)storyboard
{
	return [self storyboardWithName:kDefaultStoryboard viewControllerIdentifier:NSStringFromClass([self class])];
}

+ (id)storyboard568hWithIdentifier:(NSString *)identifier
{
    return [self storyboardWithName:kStoryboard568h viewControllerIdentifier:identifier];
}

+ (id)storyboardWithIdentifier:(NSString *)identifier
{
	return [self storyboardWithName:kDefaultStoryboard viewControllerIdentifier:identifier];
}

+ (id)storyboardWithName:(NSString *)storyboardName viewControllerIdentifier:(NSString *)identifier
{
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
	return [storyboard instantiateViewControllerWithIdentifier:identifier];
}

+ (id)controller
{
	return [[self alloc] init];
}

+ (id)controllerWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	return [[self alloc] initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}
@end
