//
//  CreateNewAccountViewController.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 12/12/13.
//  Copyright (c) 2013 MYOB University. All rights reserved.
//

#import "CreateNewAccountViewController.h"
#import "PinViewController.h"
#import "UserAccount.h"

@interface CreateNewAccountViewController ()

@end

@implementation CreateNewAccountViewController



#pragma overrides
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


#pragma IBActions
- (IBAction)ContinuePressed:(id)sender {
    [self validForm];
}

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Text Field Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self base_textFieldDidBeginEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self base_textFieldDidEndEditing:textField];
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

#pragma private methods
- (void)configureKeyboardControls
{
    self.username1.delegate = self;
    self.username2.delegate = self;
    self.email1.delegate = self;
    self.email2.delegate = self;
    self.password1.delegate = self;
    self.password2.delegate = self;
    
    NSArray *fields = @[ self.username1, self.username2, self.email1, self.email2, self.password1, self.password2];
    NSArray *options = @[ kMSKeyboardValidationOptionsRequired, kMSKeyboardValidationOptionsRequired,
                          kMSKeyboardValidationOptionsRequired, kMSKeyboardValidationOptionsRequired,
                          kMSKeyboardValidationOptionsRequired, kMSKeyboardValidationOptionsRequired];
    
    [self setKeyboardControls:[[MSKeyboardControls alloc] initWithFields:fields validateOptions:options]];
    [self.keyboardControls setDelegate:self];
    [self.keyboardControls setToolbarVisibility:YES];
}

-(void)validForm
{
    if([UserAccount isUsernameValid:self.username1.text username2:self.username2.text] &&
       [UserAccount isEmailValid:self.email1.text email2:self.email2.text] &&
       [UserAccount isPasswordValid:self.password1.text password2:self.password2.text])
    {
        //create User Account
        NSArray *fields = @[ self.username1.text, self.email1.text, self.password1.text];
        NSArray *keys = @[ @"username", @"email", @"password"];
        
        NSDictionary * accountInfo = [[NSDictionary alloc] initWithObjects:fields forKeys:keys];
        UserAccount * userAccount = [[UserAccount alloc] initWithDictionary:accountInfo];
        
        
        [self.serviceManager createAccount:userAccount completed:^(BOOL successful, id response) {
            
            if(successful)
            {
                self.dataManager.currentUserAccount = userAccount;
                self.dataManager.lastLoggedOutEmail = userAccount.email;
                
                //continue to pin creation
                PinViewController * pinView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PinViewController"];
                pinView.pinViewControllerType = PinViewControllerTypeCreate;
                [self.navigationController pushViewController:pinView animated:YES];
            }
            
        }];
    }
}


@end


