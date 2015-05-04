//
//  MSDropdownMenu.m
//  M.Y.O.B.U.
//
//  Created by Raymond on 9/13/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "MSDropdownMenu.h"

@interface MSDropdownMenu() //<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) CGRect hiddenFrame;
@property (nonatomic, assign) CGRect showingFrame;
@end

@implementation MSDropdownMenu


- (void)hideMenu
{
    self.showingFrame = self.frame;
    self.frame = CGRectMake(self.frame.origin.x, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
    self.hiddenFrame = self.frame;
}

- (void)animateInMenu
{
    self.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.frame = self.showingFrame;
        
    } completion:^(BOOL finished) {
        
        self.userInteractionEnabled = YES;
        self.isDisplayed = YES;
    }];
}

- (void)animateOutMenu
{
    self.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.frame = self.hiddenFrame;
        
    } completion:^(BOOL finished) {
        
        self.userInteractionEnabled = YES;
        self.isDisplayed = NO;
    }];
}

@end
