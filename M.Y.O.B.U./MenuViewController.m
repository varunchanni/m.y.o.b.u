//
//  MenuViewController.m
//  M.Y.O.B.U.
//
//  Created by Raymond on 9/12/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "MenuViewController.h"

//old
#import "WithdrawerViewController.h"
#import "EnvelopeFillerViewController.h"

@interface MenuViewController ()
@property (nonatomic, strong) NSArray * features;
@property (nonatomic, assign) NSInteger featureIndex;
@property (weak, nonatomic) IBOutlet UIButton *iPadButton;
@end


@implementation MenuViewController

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
    
    self.features = @[@"The Withdrawer", @"The Envelope Filler"];
    
    [self.iPadButton setTitle:[self.features objectAtIndex:self.featureIndex] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma IBActions
- (IBAction)startPressed:(id)sender {
    
    if([self.iPadButton.titleLabel.text isEqualToString:@"The Withdrawer"])
    {
        WithdrawerViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                                     instantiateViewControllerWithIdentifier:@"WithdrawerViewController"];
        [self.uiManager pushFadeViewController:self.navigationController toViewController:viewController];

    }
    else if([self.iPadButton.titleLabel.text isEqualToString:@"The Envelope Filler"])
    {
        EnvelopeFillerViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                                         instantiateViewControllerWithIdentifier:@"EnvelopeFillerViewController"];
        [self.uiManager pushFadeViewController:self.navigationController toViewController:viewController];

    }
}

- (IBAction)iPadPressed:(id)sender {
 
    self.featureIndex = [self.features indexOfObject:self.iPadButton.titleLabel.text];
    
    self.featureIndex++;
    
    if(self.featureIndex >= [self.features count])
    {
        self.featureIndex = 0;
    }
    
    [self.iPadButton setTitle:[self.features objectAtIndex:self.featureIndex] forState:UIControlStateNormal];
}

- (IBAction)backPressed:(id)sender {
    
    [self.uiManager popFadeViewController:self.navigationController];
}

@end
