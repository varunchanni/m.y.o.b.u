//
//  SignInViewController.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 12/8/13.
//  Copyright (c) 2013 MYOB University. All rights reserved.
//

#import "SignInViewController.h"
#import "CreateNewAccountViewController.h"
#import "HomeViewController.h"
#import "PinViewController.h"
#import "UserAccount.h"

@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation SignInViewController

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
    self.Form_Y_Origin = -205;
    
    
    [self configureKeyboardControls];

    /*
    bool userSignedIn = self.dataManager.currentUserAccount.isSignedIn;

    //if(userSignedIn)
    {
        PinViewController * pinView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PinViewController"];
        //[self.navigationController pushViewController:pinView animated:YES];
        [self.uiManager pushFadePinViewController:self.navigationController toViewController:pinView];
    }
    */
    /*
    [self.serviceManager getAllUsers:nil completed:^(BOOL successful, id response) {
        
      
        NSLog(@"response: %@", response);
    }];
     */
}

- (void)viewWillAppear:(BOOL)animated
{
    //self.email.text = self.dataManager.lastLoggedOutEmail;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Private Methods
- (void)configureKeyboardControls
{
    
    self.email.delegate = self;
    self.password.delegate = self;
    
    NSArray *fields = @[ self.email, self.password];
    NSArray *options = @[ kMSKeyboardValidationOptionsRequired, kMSKeyboardValidationOptionsRequired];
    
    [self setKeyboardControls:[[MSKeyboardControls alloc] initWithFields:fields validateOptions:options]];
    [self.keyboardControls setDelegate:self];
    [self.keyboardControls setToolbarVisibility:YES];
}

- (BOOL)checkKeyboardControlsInputValidation
{
    BOOL isValid = NO;
    
    
    if([UserAccount isEmailValid:self.email.text email2:self.email.text] &&
       [UserAccount isPasswordValid:self.password.text password2:self.password.text])
    {
        isValid = YES;
    }
    
    
    return isValid;
}

- (void)getUserInfoAndSignIn:(NSString *)accountId
{
    [self.serviceManager getAccountInfoByAccountId:accountId completed:^(id userInfo) {
       
        if(userInfo != nil)
        {
            self.dataManager.currentUserAccount = [[UserAccount alloc] initWithDictionary:userInfo];
            HomeViewController * homeView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeViewController"];
            [self.navigationController pushViewController:homeView animated:YES];
        }
        else
        {
            [MSUIManager alertWithTitle:@"Authenication Error" andMessage:@"Failed to authenicate user. Please try again."];
        }
    }];
}

#pragma mark Text Field Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self base_textFieldDidBeginEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self base_textFieldDidEndEditing:textField];
}


#pragma IBActions
- (IBAction)userLoginPressed:(id)sender {
    
    if([self checkKeyboardControlsInputValidation])
    {
        [self hideKeyboard];
        
        [self.serviceManager loginUser:self.email.text password:self.password.text completed:^(BOOL successful, id response) {
            
            self.password.text = @"";
            
            if(successful)
            {
                if([[response allKeys] containsObject:@"userId"])
                {
                    self.dataManager.currentUserAccount = [[UserAccount alloc] initWithDictionary:response];
                    [self.dataManager.currentUserAccount login];
                    
                    HomeViewController * homeView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeViewController"];
                    [self.navigationController pushViewController:homeView animated:YES];
                }
            }
            else
            {
                [MSUIManager alertWithTitle:@"Authenication Error" andMessage:@"Inncorrect Email or Password. Please try again."];
            }
            
        }];
    }
}

- (IBAction)guestLoginPressed:(id)sender {
    
    UserAccount * user = [[UserAccount alloc] initAsGuest];
    self.dataManager.currentUserAccount = user;
    HomeViewController * homeView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [self.navigationController pushViewController:homeView animated:YES];
    
}

- (IBAction)userCreatePressed:(id)sender {
  
    CreateNewAccountViewController * createView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CreateNewAccountViewController"];
    [self.navigationController pushViewController:createView animated:YES];
}

#pragma mark Keyboard Controls Delegate
- (void)keyboardControlsDonePressed:(MSKeyboardControls *)keyboardControls
{
    [self base_keyboardControlsDonePressed:keyboardControls];
}

- (void)keyboardControlsCancelPressed:(MSKeyboardControls *)keyboardControls
{
    [self base_keyboardControlsCancelPressed:keyboardControls];
}

- (void)keyboardControlsSavePressed:(MSKeyboardControls *)keyboardControls
{
    [self base_keyboardControlsSavePressed:keyboardControls];
}

@end
