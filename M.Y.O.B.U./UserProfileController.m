//
//  UserProfileController.m
//  ADVFlatUI
//
//  Created by Tope on 31/05/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "UserProfileController.h"
#import <QuartzCore/QuartzCore.h>
#import "UserAccount.h"
#import "EditUserProfileController.h"

@interface UserProfileController ()
@property (nonatomic, strong) UserAccount * userAccount;
@property (nonatomic, strong) UIColor* mainColor;
@property (nonatomic, strong) UIColor* imageBorderColor;
@property (nonatomic, strong) NSString* fontName;
@property (nonatomic, strong) NSString* boldItalicFontName;
@property (nonatomic, strong) NSString* boldFontName;
@property (nonatomic, weak) IBOutlet UIButton* editButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation UserProfileController

- (UserAccount * )userAccount
{
    return self.dataManager.currentUserAccount;
}
   
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.mainColor = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:1.0f];
    self.imageBorderColor = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:0.4f];
    self.fontName = @"Avenir-Book";
    self.boldItalicFontName = @"Avenir-BlackOblique";
    self.boldFontName = @"Avenir-Black";
    
    
    [self setLabels];
    
    
    [self setProfileImageData];
    
    
    [self addDividerToView:self.scrollView atLocation:230];

    
    self.scrollView.contentSize = CGSizeMake(320, 590);
    self.scrollView.backgroundColor = [UIColor whiteColor];
}


- (void)setLabels
{
    self.nameLabel.textColor =  self.mainColor;
    self.nameLabel.font =  [UIFont fontWithName:self.boldItalicFontName size:18.0f];
    self.nameLabel.text = [[self.userAccount.firstname stringByAppendingString:@" "] stringByAppendingString:self.userAccount.lastname];
    
    self.usernameLabel.textColor =  self.mainColor;
    self.usernameLabel.font =  [UIFont fontWithName:self.fontName size:14.0f];
    self.usernameLabel.text = self.userAccount.username;
    
    self.signout.titleLabel.font =  [UIFont fontWithName:self.fontName size:14.0f];
    
    if([self.nameLabel.text isEqualToString:@"Guest "])
    {
        self.editButton.hidden = YES;
    }
}

-(void)setProfileImageData
{
    
    NSString * avtarId = self.dataManager.currentUserAccount.avtarId;
    NSLog(@"AvtarId: %@", avtarId);
    
    self.profileImageView.image = [UIImage imageNamed:@"guest_icon.png"];
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderWidth = 2.0f;
    self.profileImageView.layer.cornerRadius = 55.0f;
    self.profileImageView.layer.borderColor = self.imageBorderColor.CGColor;
    
    self.profileImageView2.image = [UIImage imageNamed:@"leah2.png"];
    self.profileImageView2.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImageView2.clipsToBounds = YES;
    self.profileImageView2.layer.borderWidth = 1.5f;
    self.profileImageView2.layer.cornerRadius = 25.0f;
    self.profileImageView2.layer.borderColor = self.imageBorderColor.CGColor;
   
    self.profileImageView4.image = [UIImage imageNamed:@"leah4.png"];
    self.profileImageView4.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImageView4.clipsToBounds = YES;
    self.profileImageView4.layer.borderWidth = 1.5f;
    self.profileImageView4.layer.cornerRadius = 25.0f;
    self.profileImageView4.layer.borderColor = self.imageBorderColor.CGColor;
    
    self.profileImageView3.image = [UIImage imageNamed:@"leah3.png"];
    self.profileImageView3.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImageView3.clipsToBounds = YES;
    self.profileImageView3.layer.borderWidth = 1.5f;
    self.profileImageView3.layer.cornerRadius = 25.0f;
    self.profileImageView3.layer.borderColor = self.imageBorderColor.CGColor;
}

-(void)styleFriendProfileImage:(UIImageView*)imageView withImageNamed:(NSString*)imageName andColor:(UIColor*)color{
    
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.layer.borderWidth = 4.0f;
    imageView.layer.borderColor = color.CGColor;
    imageView.layer.cornerRadius = 35.0f;
}

-(void)addDividerToView:(UIView*)view atLocation:(CGFloat)location{
    
    UIView* divider = [[UIView alloc] initWithFrame:CGRectMake(20, location, 280, 1)];
    divider.backgroundColor = [UIColor colorWithWhite:0.9f alpha:0.7f];
    [view addSubview:divider];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma IBActions
- (IBAction)signOutPressed:(id)sender {
    
    self.dataManager.currentUserAccount = [[UserAccount alloc] initAsGuest];
     [self.navigationController popToRootViewControllerAnimated:NO];
}
- (IBAction)backPressed:(id)sender {
    
    [self.uiManager popFadeViewController:self.navigationController];

}
- (IBAction)editProfilePressed:(id)sender {
    
    EditUserProfileController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                              instantiateViewControllerWithIdentifier:@"EditUserProfileController"];
    
    //self.parentNavController.view.hidden = YES;
    [self.uiManager pushFadeViewController:self.navigationController toViewController:viewController];
    
}


@end
