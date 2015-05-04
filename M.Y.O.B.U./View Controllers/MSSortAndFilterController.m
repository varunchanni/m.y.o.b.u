//
//  MSSortAndFilterController.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 3/31/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "MSSortAndFilterController.h"
#import "EnvelopeFillerViewController.h"

@interface MSSortAndFilterController ()
@property (weak, nonatomic) IBOutlet UIView *sortView;
@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (strong, nonatomic) EnvelopeFillerViewController * customParentController;

@end

@implementation MSSortAndFilterController

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
    
}

- (void)viewDidAppear:(BOOL)animated
{
    self.customParentController = (EnvelopeFillerViewController*)self.parentViewController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma IBActions
- (IBAction)filterPressed:(id)sender {
    
    self.filterView.hidden = NO;
    self.sortView.hidden = YES;
}
- (IBAction)sortPressed:(id)sender {
    
    self.sortView.hidden = NO;
    self.filterView.hidden = YES;
    

    [self.customParentController filterEnvelopesBy:@"TEST"];
    
}

- (IBAction)sortValueChanged:(id)sender {
    
}

@end
