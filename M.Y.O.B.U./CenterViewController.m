//
//  CenterViewController.m
//  Navigation
//
//  Created by Tammy Coron on 1/19/13.
//  Copyright (c) 2013 Tammy L Coron. All rights reserved.
//

#import "CenterViewController.h"

@interface CenterViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *mainImageView;
@property (nonatomic, weak) IBOutlet UILabel *imageTitle;
@property (nonatomic, weak) IBOutlet UILabel *imageCreator;

@property (nonatomic, strong) NSMutableArray *imagesArray;

@end

@implementation CenterViewController

#pragma mark -
#pragma mark View Did Load/Unload

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark -
#pragma mark View Will/Did Appear

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

#pragma mark -
#pragma mark View Will/Did Disappear

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark Button Actions

-(IBAction)btnMovePanelRight:(id)sender {
	UIButton *button = sender;
	switch (button.tag) {
		case 0: {
			[_delegate movePanelToOriginalPosition];
			break;
		}
			
		case 1: {
			[_delegate movePanelRight];
			break;
		}
			
		default:
			break;
	}
}

-(IBAction)btnMovePanelLeft:(id)sender {
	UIButton *button = sender;
	switch (button.tag) {
		case 0: {
			[_delegate movePanelToOriginalPosition];
			break;
		}
			
		case 1: {
			[_delegate movePanelLeft];
			break;
		}
            
		default:
			break;
	}
}

#pragma mark -
#pragma mark Delagate Method for capturing selected image

#pragma mark -
#pragma mark Default System Code

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
