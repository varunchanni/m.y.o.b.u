//
//  AccountViewController.h
//  M.Y.O.B.U.
//
//  Created by Raymond on 9/6/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "MYOBViewController.h"

enum AccountViewControllerType {
    AccountViewControllerTypeCreate,
    AccountViewControllerTypePasswordReset
};

@interface AccountViewController : MYOBViewController
@property (nonatomic, assign) enum AccountViewControllerType type;
@end
