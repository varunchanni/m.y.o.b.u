//
//  ChangePasswordViewController.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 12/27/13.
//  Copyright (c) 2013 MYOB University. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "UserAccount.h"

@interface ChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *currentPassword;
@property (weak, nonatomic) IBOutlet UITextField *Password1;
@property (weak, nonatomic) IBOutlet UITextField *Password2;
@end

@implementation ChangePasswordViewController

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
    [self configureKeyboardControls];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Text Field Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self base_textFieldDidBeginEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self base_textFieldDidEndEditing:textField];
}

- (void)configureKeyboardControls
{
    self.currentPassword.delegate = self;
    self.Password1.delegate = self;
    self.Password2.delegate = self;
    
    NSArray *fields = @[ self.currentPassword, self.Password1, self.Password2];
    NSArray *options = @[ kMSKeyboardValidationOptionsRequired, kMSKeyboardValidationOptionsRequired, kMSKeyboardValidationOptionsRequired];
    
    [self setKeyboardControls:[[MSKeyboardControls alloc] initWithFields:fields validateOptions:options]];
    [self.keyboardControls setDelegate:self];
    [self.keyboardControls setToolbarVisibility:YES];
}

#pragma IB Actions
- (IBAction)changePasswordPressed:(id)sender {
    
    [self.keyboardControls.activeField resignFirstResponder];
    NSString * password = self.currentPassword.text;
    
    //make sure old password is a valid input
    if([UserAccount isPasswordValid:password password2:password])
    {
        [self.serviceManager authenicateUser:self.dataManager.currentUserAccount.email password:password
                                   completed:^(id userAuthenicatedId) {
                                       
            if(userAuthenicatedId != nil)
            {
                [self createNewPassword];
            }
            else
            {
                [MSUIManager alertWithTitle:@"Authenication Error" andMessage:@"Current Password is not correct!"];
            }
            
        }];
    }
    else
    {
        [MSUIManager alertWithTitle:@"Authenication Error" andMessage:@"Current Password is not correct!"];
    }
    
}

- (IBAction)backPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createNewPassword
{
    //make sure new password is valid
    if([UserAccount isPasswordValid:self.Password1.text password2:self.Password2.text])
    {
        [self.serviceManager changePasswordForAccountWithId:self.dataManager.currentUserAccount.accountId
            password:self.Password1.text  completed:^(BOOL passwordChanged) {
        
                if(passwordChanged)
                {
                    [MSUIManager alertWithTitle:@"Success" andMessage:@"Password successfully changed"];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                else
                {
                    [MSUIManager alertWithTitle:@"Error" andMessage:@"Password change failed"];
                }
        }];
    }
    
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
