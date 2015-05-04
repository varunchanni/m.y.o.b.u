//
//  RecoverPasswordViewController.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 12/27/13.
//  Copyright (c) 2013 MYOB University. All rights reserved.
//

#import "RecoverPasswordViewController.h"
#import "UserAccount.h"

@interface RecoverPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountEmail;

@end

@implementation RecoverPasswordViewController

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
    self.accountEmail.delegate = self;
    
    NSArray *fields = @[ self.accountEmail];
    NSArray *options = @[ kMSKeyboardValidationOptionsRequired];
    
    [self setKeyboardControls:[[MSKeyboardControls alloc] initWithFields:fields validateOptions:options]];
    [self.keyboardControls setDelegate:self];
    [self.keyboardControls setToolbarVisibility:YES];
}

#pragma IB Actions
- (IBAction)recoverPasswordPressed:(id)sender {
    
    NSString *email = self.accountEmail.text ;
    NSString *accountId = self.accountEmail.text ;
    
    if([UserAccount isEmailValid:email email2:email]  && accountId != nil)
    {
        [self.serviceManager recoverAccountPassword:email completed:^(BOOL successful, id response) {
            
            if(successful)
            {
                [MSUIManager alertWithTitle:@"Success" andMessage:
                 [NSString stringWithFormat:@"Your password was successfully sent to: %@", email]];
            }
            else
            {
                [MSUIManager alertWithTitle:@"Error" andMessage:@"Email address submitted is not a registered to a MYOBU Account."];
            }
            
        }];
        
        /*
        [self.serviceManager recoverPasswordByEmail:email completed:^(BOOL emailSent) {
            
            if(emailSent)
            {
                [MSUIManager alertWithTitle:@"Success" andMessage:
                 [NSString stringWithFormat:@"Your password was successfully sent to: %@", email]];
            }
            else
            {
                [MSUIManager alertWithTitle:@"Error" andMessage:@"Email address submitted is not a registered to a MYOBU Account."];
            }
        }];
        */
    }
    
}
- (IBAction)backPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
