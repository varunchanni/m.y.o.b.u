//
//  AccountViewController.m
//  M.Y.O.B.U.
//
//  Created by Raymond on 9/6/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "AccountViewController.h"
#import "EnvelopeFillerViewController.h"

@interface AccountViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UITextField *email1;
@property (weak, nonatomic) IBOutlet UITextField *email2;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password1;
@property (weak, nonatomic) IBOutlet UITextField *password2;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIView *labelView;
@property (weak, nonatomic) IBOutlet UIView *busyView;

@end

@implementation AccountViewController

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
    
    if(self.type == AccountViewControllerTypePasswordReset)
    {
        self.email2.hidden = YES;
        self.username.hidden = YES;
        self.password1.hidden = YES;
        self.password2.hidden = YES;
        [self.actionButton setTitle:@"Reset Password" forState:UIControlStateNormal];
    }
    
    [self configureKeyboardControls];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self slideBackgroundX:@(-141) withDuration:0.5 completion:^(BOOL finished) {
        
        [self fadeInObject:self.labelView WithInterval:1.0 toAlpha:@(1.0) completed:^(BOOL finshed) {
            
            
        }];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma IBActions
- (IBAction)backPressed:(id)sender {
    
    [self fadeInObject:self.labelView WithInterval:0.4 toAlpha:@(0.0) completed:^(BOOL finshed) {
        [self slideBackgroundX:@(0) withDuration:0.5 completion:^(BOOL finished) {
            
            [self.uiManager popAppearController:self.navigationController];
        }];
    }];
    
}

- (IBAction)actionButtonPressed:(id)sender {

    if(self.type == AccountViewControllerTypeCreate)
    {
        [self createAccount];
    }
    else if(self.type == AccountViewControllerTypePasswordReset)
    {
        [self resetPassword];
    }
}

#pragma private methods
- (void)configureKeyboardControls
{
    self.email1.delegate = self;
    self.email2.delegate = self;
    self.username.delegate = self;
    self.password1.delegate = self;
    self.password2.delegate = self;
    
    UIColor *color = [UIColor lightTextColor];
    self.email1.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    self.email2.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Re Enter Email" attributes:@{NSForegroundColorAttributeName: color}];
    self.username.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];
    self.password1.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    self.password2.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Re Enter Password" attributes:@{NSForegroundColorAttributeName: color}];

    NSArray *fields = @[ self.email1, self.email2, self.username, self.password1, self.password2];
    NSArray *options;
    
    if(self.type == AccountViewControllerTypeCreate)
    {
        options = @[ kMSKeyboardValidationOptionsRequired, kMSKeyboardValidationOptionsRequired, kMSKeyboardValidationOptionsRequired,
                     kMSKeyboardValidationOptionsRequired, kMSKeyboardValidationOptionsRequired];
    }
    else if(self.type == AccountViewControllerTypePasswordReset)
    {
        options = @[ kMSKeyboardValidationOptionsRequired, kMSKeyboardValidationOptionsOptional, kMSKeyboardValidationOptionsOptional,
                     kMSKeyboardValidationOptionsOptional, kMSKeyboardValidationOptionsOptional];
    }
  
    
    [self setKeyboardControls:[[MSKeyboardControls alloc] initWithFields:fields validateOptions:options]];
    [self.keyboardControls setDelegate:self];
    [self.keyboardControls setToolbarVisibility:NO];
}

- (void)slideBackgroundX:(NSNumber *)x withDuration:(NSTimeInterval)interval completion:(void (^)(BOOL finished))done
{
    CGRect frame = self.background.frame;
    
    [UIView animateWithDuration:interval animations:^{
        
        self.background.frame = CGRectMake([x floatValue], frame.origin.y, frame.size.width, frame.size.height);
        
    } completion:^(BOOL finished) {
        
        done(finished);
        
    }];
    
}

- (void)createAccount
{
    if([self isCreateAccountFormValid])
    {
    
        //create User Account
        NSArray *fields = @[ self.username.text, self.email1.text, self.password1.text];
        NSArray *keys = @[ @"username", @"email", @"password"];
    
        NSDictionary * accountInfo = [[NSDictionary alloc] initWithObjects:fields forKeys:keys];
        UserAccount * userAccount = [[UserAccount alloc] initWithDictionary:accountInfo];
    
        self.busyView.hidden = NO;
        
        [self.serviceManager createAccount:userAccount completed:^(BOOL successful, id response) {
            
            self.busyView.hidden = YES;
            if(successful)
            {
                if([[response objectForKey:@"Message"] isEqualToString:@"Account Created!"])
                {
                    self.dataManager.currentUserAccount = userAccount;
                    self.dataManager.lastLoggedOutEmail = userAccount.email;
                    
                    EnvelopeFillerViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EnvelopeFillerViewController"];
                    [self.uiManager pushFadeViewController:self.navigationController toViewController:viewController];
                    
                }
                else
                {
                  [MSUIManager alertWithTitle:@"Error" andMessage:[response objectForKey:@"Message"]];
                }
            }
            else
            {
                [MSUIManager alertWithTitle:@"Error" andMessage:[response objectForKey:@"Message"]];
            }
            
        }];
    
    }
}

- (void)resetPassword
{
    if([self isResetPasswordFormValid])
    {
        
        self.busyView.hidden = NO;
        
        [self.serviceManager recoverAccountPassword:self.email1.text completed:^(BOOL successful, id response) {
            
        self.busyView.hidden = YES;
            
            if(successful)
            {
                if([[response objectForKey:@"Message"] isEqualToString:@"Email Sent!"])
                {
                    [MSUIManager alertWithTitle:@"Success" andMessage:
                     [NSString stringWithFormat:@"Your password was successfully sent to: %@", self.email1.text]];
                
                    [self fadeInObject:self.labelView WithInterval:0.4 toAlpha:@(0.0) completed:^(BOOL finshed) {
                        [self slideBackgroundX:@(0) withDuration:0.5 completion:^(BOOL finished) {
                            
                            [self.uiManager popAppearController:self.navigationController];
                        }];
                    }];
                }
                else
                {
                    [MSUIManager alertWithTitle:@"Error" andMessage:@"Error sending email."];
                }
            
            }
            else
            {
                [MSUIManager alertWithTitle:@"Error" andMessage:@"Email address submitted is not a registered to a MYOBU Account."];
            }
            
        }];
    }
}

- (BOOL)isCreateAccountFormValid
{
    if([UserAccount isUsernameValid:self.username.text username2:self.username.text] &&
       [UserAccount isEmailValid:self.email1.text email2:self.email2.text] &&
       [UserAccount isPasswordValid:self.password1.text password2:self.password2.text])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isResetPasswordFormValid
{
    if([UserAccount isEmailValid:self.email1.text email2:self.email1.text])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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



@end
