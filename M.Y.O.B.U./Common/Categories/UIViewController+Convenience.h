//
//  UIViewController+Convience.h
//  PrivateCam
//
//  Created by Prince Ugwuh on 8/25/12.
//  Copyright (c) 2012 MFX Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Convenience)
+ (BOOL)is568h;
+ (id)storyboard;
+ (id)storyboard568h;
+ (id)storyboardWithIdentifier:(NSString *)identifier;
+ (id)storyboard568hWithIdentifier:(NSString *)identifier;
+ (id)controller;
+ (id)controllerWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
@end
