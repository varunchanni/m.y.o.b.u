//
//  MainMenuViewController.m
//  M.Y.O.B.U.
//
//  Created by Raymond on 10/1/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "MainMenuViewController.h"
#import "SWRevealViewController.h"

@interface MainMenuViewController ()<UITableViewDataSource>
@property (nonatomic, strong) NSArray * menuSections;
@property (nonatomic, strong) NSArray * menuItems;
@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.menuSections = @[@"Profile", @"Apps", @"Settings", @"M.Y.O.B. University"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma IBActions
- (IBAction)logoutPressed:(id)sender {
    
}

#pragma UITableView Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.menuSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 2;
    }
    else if (section == 1)
    {
        return 2;
    }
    else if (section == 2)
    {
        return 1;
    }
    else if (section == 3)
    {
        return 4;
    }
    return 0;
}


#pragma UITableView Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 16)];
    [view setBackgroundColor:[UIColor lightGrayColor]];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 16)];
    [label setTextColor:[UIColor darkGrayColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont fontWithName: @"AvenirNext-Bold" size: 11.0f]];
    
    label.text = [self.menuSections objectAtIndex:section];
    
    [view addSubview:label];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    UIViewController * viewController = nil;
    UIViewController * viewSettingsController = nil;
    
    if(section == 0)//Account
    {
        
    }
    else if(section == 1)//Apps
    {
        if(row == 0)
        {
            viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                              instantiateViewControllerWithIdentifier:@"EnvelopeFillerViewController"];
        }
        else if(row == 1)
        {
            viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                               instantiateViewControllerWithIdentifier:@"WithdrawerViewController"];
        }
    }
    else if(section == 2)//Settings
    {
        
    }
    else if(section == 3)//MYOBU
    {
        
    }
    
    
    if(viewController != nil)
    {
        self.revealViewController.frontViewController = viewController;
    }
    
    if(viewSettingsController != nil)
    {
        self.revealViewController.rightViewController = viewSettingsController;
    }
    
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
}

@end
