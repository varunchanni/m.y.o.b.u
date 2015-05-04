//
//  PinViewController.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 12/14/13.
//  Copyright (c) 2013 MYOB University. All rights reserved.
//

#import "PinViewController.h"
#import "HomeViewController.h"

@interface PinViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *passwordInput1;
@property (weak, nonatomic) IBOutlet UIImageView *passwordInput2;
@property (weak, nonatomic) IBOutlet UIImageView *passwordInput3;
@property (weak, nonatomic) IBOutlet UIImageView *passwordInput4;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic, strong) NSString * pinToSubmit;
@property (nonatomic, strong) NSString * pinCreate1;
@property (nonatomic, strong) NSString * pinCreate2;

@end

@implementation PinViewController

#pragma variables
- (NSString *)pinToSubmit
{
    if(_pinToSubmit == nil)
    {
        _pinToSubmit = @"";
    }
    
    return _pinToSubmit;
}

- (NSString *)pinCreate1
{
    if(_pinCreate1 == nil)
    {
        _pinCreate1 = @"";
    }
    
    return _pinCreate1;
}
- (NSString *)pinCreate2
{
    if(_pinCreate2 == nil)
    {
        _pinCreate2 = @"";
    }
    
    return _pinCreate2;
}

#pragma overrides
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    [self.instructionLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 12.0f]];
    [self.instructionLabel setTintColor:[UIColor colorWithWhite:.3 alpha:.95]];
    
    if (self.pinViewControllerType == PinViewControllerTypeAuthenicate) {
        self.instructionLabel.text = @"Please enter your 4 digit security";
    }
    else
    {
        self.instructionLabel.text = @"Please create your 4 digit security";
        self.backButton.hidden = YES;
    }
    
    self.passwordInput1.hidden = YES;
    self.passwordInput2.hidden = YES;
    self.passwordInput3.hidden = YES;
    self.passwordInput4.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma IB Actions
- (IBAction)key0Pressed:(id)sender {
    [self addCharToPin:@"0"];
}
- (IBAction)key1Pressed:(id)sender {
    [self addCharToPin:@"1"];
}
- (IBAction)key2Pressed:(id)sender {
    [self addCharToPin:@"2"];
}
- (IBAction)key3Pressed:(id)sender {
    [self addCharToPin:@"3"];
}
- (IBAction)key4Pressed:(id)sender {
    [self addCharToPin:@"4"];
}
- (IBAction)key5Pressed:(id)sender {
    [self addCharToPin:@"5"];
}
- (IBAction)key6Pressed:(id)sender {
    [self addCharToPin:@"6"];
}
- (IBAction)key7Pressed:(id)sender {
    [self addCharToPin:@"7"];
}
- (IBAction)key8Pressed:(id)sender {
    [self addCharToPin:@"8"];
}
- (IBAction)key9Pressed:(id)sender {
    [self addCharToPin:@"9"];
}
- (IBAction)backPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma private methods 
- (void)addCharToPin:(NSString *)Char
{
    [self updateUI];
    if(self.pinViewControllerType == PinViewControllerTypeAuthenicate)
    {
        self.pinToSubmit = [self.pinToSubmit stringByAppendingString:Char];
        if(self.pinToSubmit.length == 4)
        {
            [self submitPin];
        }
    }
    else if(self.pinCreate1.length != 4)
    {
        self.pinCreate1 = [self.pinCreate1 stringByAppendingString:Char];
        if(self.pinCreate1.length == 4)
        {
            [self recreatePin];
        }
    }
    else
    {
        self.pinCreate2 = [self.pinCreate2 stringByAppendingString:Char];
        if(self.pinCreate2.length == 4)
        {
            [self createPin];
        }
    }
}

- (void)updateUI
{
    
    NSInteger pinLength;
    if(self.pinViewControllerType == PinViewControllerTypeAuthenicate)
    {
        pinLength = (int)self.pinToSubmit.length;
    }
    else if(self.pinCreate1.length != 4)
    {
        pinLength = (int)self.pinCreate1.length;
    }
    else
    {
        pinLength = (int)self.pinCreate2.length;
    }
    
    
    switch (pinLength) {
        case 0:
            self.passwordInput1.hidden = NO;
            break;
        case 1:
            self.passwordInput2.hidden = NO;
            break;
        case 2:
            self.passwordInput3.hidden = NO;
            break;
        case 3:
            self.passwordInput4.hidden = NO;
            break;
        default:
            break;
    }
}

- (void)submitPin
{
    NSString * pin = self.pinToSubmit;
    self.pinToSubmit = @"";
    
    if([self.dataManager.currentUserAccount isCorrectPin:pin])
    {
        [self.dataManager.currentUserAccount login];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)recreatePin
{
    _instructionLabel.text = @"Please re-enter your 4 digit security pin";
    self.passwordInput1.hidden = YES;
    self.passwordInput2.hidden = YES;
    self.passwordInput3.hidden = YES;
    self.passwordInput4.hidden = YES;
}

- (void)createPin
{
    if([self.pinCreate1 isEqualToString:self.pinCreate2])
    {
        [self.dataManager.currentUserAccount setNewPin:self.pinCreate1];
        [self.dataManager.currentUserAccount login];
        
        HomeViewController * homeView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeViewController"];
        [self.navigationController pushViewController:homeView animated:YES];
    }
    else
    {
        self.pinCreate1 = @"";
        self.pinCreate2 = @"";
        self.passwordInput1.hidden = YES;
        self.passwordInput2.hidden = YES;
        self.passwordInput3.hidden = YES;
        self.passwordInput4.hidden = YES;

        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Invalid Pin"
                                                         message:@"Security pin's entered do not match. Please try again."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
        [alert show];
    }
}
@end
