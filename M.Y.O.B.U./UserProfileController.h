//
//  UserProfileController.h
//  ADVFlatUI
//
//  Created by Tope on 31/05/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYOBViewController.h"

@interface UserProfileController : MYOBViewController;

@property (nonatomic, weak) IBOutlet UIImageView* profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView4;


@property (nonatomic, weak) IBOutlet UIView* overlayView;

@property (nonatomic, weak) IBOutlet UILabel* nameLabel;

@property (nonatomic, weak) IBOutlet UILabel* usernameLabel;

@property (nonatomic, weak) IBOutlet UIScrollView* scrollView;

@property (weak, nonatomic) IBOutlet UIButton *signout;

@end
