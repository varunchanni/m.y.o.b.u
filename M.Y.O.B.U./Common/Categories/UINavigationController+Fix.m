//
//  UINavigationController+Fix.m
//  PrivateCam
//
//  Created by Prince Ugwuh on 9/23/12.
//  Copyright (c) 2012 MFX Studios. All rights reserved.
//

#import "UINavigationController+Fix.h"

@implementation UINavigationController (Fix)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return [[self.viewControllers lastObject] shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (BOOL)shouldAutorotate
{
    return [[self.viewControllers lastObject] shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}



@end
