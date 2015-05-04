//
//  MainViewController.m
//  M.Y.O.B.U.
//
//  Created by Raymond on 9/6/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "MainViewController.h"
#import "AccountViewController.h"
#import "TransitionAnimator.h"
#import "UserAccount.h"
#import "SWRevealViewController.h"

#import "EnvelopeFillerViewController.h"

//#import "HomeViewController.h"

@interface MainViewController ()<UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundBlurImage;
@property (weak, nonatomic) IBOutlet UIView *labelView;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIView *busyView;
@end

@implementation MainViewController

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
    // Do any additional setup after loading the view.
    self.shouldAnimateScreen = YES;
    
    [self configureKeyboardControls];
    
    UIColor *color = [UIColor whiteColor];
    self.username.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];
    self.password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    
    [self fadeInObject:self.labelView WithInterval:1.0 toAlpha:@(1.0) completed:^(BOOL finshed) {
        
        
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self fadeInObject:self.labelView WithInterval:1.0 toAlpha:@(1.0) completed:^(BOOL finshed) {
        
        
    }];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self fadeInObject:self.labelView WithInterval:1.0 toAlpha:@(0.0) completed:^(BOOL finshed) {
        
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma private methods
- (void)configureKeyboardControls
{
    self.username.delegate = self;
    self.password.delegate = self;
    
    NSArray *fields = @[ self.username, self.password];
    NSArray *options = @[ kMSKeyboardValidationOptionsRequired, kMSKeyboardValidationOptionsRequired];
    
    [self setKeyboardControls:[[MSKeyboardControls alloc] initWithFields:fields validateOptions:options]];
    [self.keyboardControls setDelegate:self];
    [self.keyboardControls setToolbarVisibility:NO];
}

- (BOOL)checkKeyboardControlsInputValidation
{
    BOOL isValid = NO;
    
    
    if([UserAccount isUsernameValid:self.username.text username2:self.username.text] &&
       [UserAccount isPasswordValid:self.password.text password2:self.password.text])
    {
        isValid = YES;
    }
    
    return isValid;
}

    
#pragma IBActions
- (IBAction)loginPressed:(id)sender {
    
    if([self checkKeyboardControlsInputValidation])
    {
        
        [self hideKeyboard];
        
        
        self.busyView.hidden = NO;
        
        [self.serviceManager loginUser:self.username.text password:self.password.text completed:^(BOOL successful, id response) {
            
            self.busyView.hidden = YES;
            
            self.password.text = @"";
            BOOL showErr = YES;
            
            if(successful)
            {
                if([[response objectForKey:@"Status"] isEqualToString:@"Success"])
                {
                    if([[response allKeys] containsObject:@"userId"])
                    {
                        showErr = NO;
                        
                        
                        
                        self.dataManager.currentUserAccount = [[UserAccount alloc] initWithDictionary:response];
                        [self.dataManager.currentUserAccount login];
                        
                        EnvelopeFillerViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EnvelopeFillerViewController"];
                        [self.uiManager pushFadeViewController:self.navigationController toViewController:viewController];
                    }
                }
            }
            
            if(showErr)
            {
                [MSUIManager alertWithTitle:@"Authenication Error" andMessage:@"Inncorrect Email or Password. Please try again."];
            }
            
        }];
    }
}

- (IBAction)createPasswordPressed:(id)sender {
    AccountViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                              instantiateViewControllerWithIdentifier:@"AccountViewController"];
    viewController.type = AccountViewControllerTypePasswordReset;
    [self.uiManager pushAppearController:self.navigationController toViewController:viewController];
}

- (IBAction)createAccountPressed:(id)sender {
    
    AccountViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                           instantiateViewControllerWithIdentifier:@"AccountViewController"];
    viewController.type = AccountViewControllerTypeCreate;
    [self.uiManager pushAppearController:self.navigationController toViewController:viewController];

}

- (IBAction)continueAsGuestPressed:(id)sender {
    
    UserAccount * user = [[UserAccount alloc] initAsGuest];
    self.dataManager.currentUserAccount = user;
    
    SWRevealViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    
    
    [self.uiManager pushFadeViewController:self.navigationController toViewController:viewController];
}


#pragma View Controller Transition Delegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    
    //use this if statement for handing different types of animations on same controller
    //if([[presented class] isSubclassOfClass:[MSMenuViewController class]])
    
    TransitionAnimator *animator = [TransitionAnimator new];
    animator.presenting = YES;
    animator.delegate = self.uiManager;
    return animator;
    
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    //use this if statement for handing different types of animations on same controller
    //if([[presented class] isSubclassOfClass:[MSMenuViewController class]])
    
    
    TransitionAnimator *animator = [TransitionAnimator new];
    animator.presenting = NO;
    animator.delegate = self.uiManager;
    return animator;
}
#pragma mark Text Field Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self base_textFieldDidBeginEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self base_textFieldDidEndEditing:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [self base_textFieldShouldReturn:textField];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //If delete was pressed delete and return
    if(string.length == 0)
    {
        textField.text = [textField.text substringToIndex:(textField.text.length-1)];
        return NO;
    }
    
    if([textField.text length] == 30)
    {
        return NO;
    }
    return YES;
}

@end
