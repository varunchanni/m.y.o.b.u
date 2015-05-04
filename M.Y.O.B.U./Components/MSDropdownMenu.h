//
//  MSDropdownMenu.h
//  M.Y.O.B.U.
//
//  Created by Raymond on 9/13/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSDropdownMenu : UIView
@property (nonatomic, strong) IBOutlet UITableView * tableView;
@property (nonatomic, strong) NSDictionary * content;
@property (nonatomic, assign) BOOL isDisplayed;

- (void)hideMenu;
- (void)animateInMenu;
- (void)animateOutMenu;

@end
