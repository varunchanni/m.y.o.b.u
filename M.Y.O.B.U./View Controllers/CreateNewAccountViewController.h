//
//  CreateNewAccountViewController.h
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 12/12/13.
//  Copyright (c) 2013 MYOB University. All rights reserved.
//

#import "MYOBViewController.h"

@interface CreateNewAccountViewController : MYOBViewController
@property (weak, nonatomic) IBOutlet UITextField *username1;
@property (weak, nonatomic) IBOutlet UITextField *username2;
@property (weak, nonatomic) IBOutlet UITextField *email1;
@property (weak, nonatomic) IBOutlet UITextField *email2;
@property (weak, nonatomic) IBOutlet UITextField *password1;
@property (weak, nonatomic) IBOutlet UITextField *password2;

- (IBAction)ContinuePressed:(id)sender;
- (IBAction)backPressed:(id)sender;
@end
