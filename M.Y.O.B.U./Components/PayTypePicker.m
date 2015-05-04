//
//  PayTypePicker.m
//  M.Y.O.B.U.
//
//  Created by Raymond on 2/25/15.
//  Copyright (c) 2015 MYOB University. All rights reserved.
//

#import "PayTypePicker.h"
#import "PayTypeManager.h"
#import "MSUIManager.h"

@interface PayTypePicker() <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) PayTypeManager * payTypeManager;
@property (strong, nonatomic) MSUIManager *uiManager;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@end

@implementation PayTypePicker

- (PayTypeManager *)payTypeManager {
    return [PayTypeManager sharedManager];
}

- (MSUIManager *)uiManager {
    return [MSUIManager sharedManager];
}

- (void)viewDidLoad{
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.payTypeManager.payTypes.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"PayTypeCell";
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    
    PayType * payType = [self.payTypeManager.payTypes objectAtIndex:[indexPath row]];
    cell.textLabel.text = payType.name;
    
    if ([payType.name isEqualToString:self.selectedPayType.name]) {
        [tableView selectRowAtIndexPath:indexPath
                               animated:NO
                         scrollPosition:UITableViewScrollPositionMiddle];
    }
    else {
        cell.selected = false;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PayType * payType = [self.payTypeManager.payTypes objectAtIndex:[indexPath row]];
    
    if (![self.payTypeManager payTypeInUse:payType]) {
        [self.payTypeManager deletePayType:payType];
        [self.tableView reloadData];
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Can't delete Pay Types in use" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!tableView.editing) {
        if (self.customDelegate != nil) {
            
            PayType * payType = [self.payTypeManager.payTypes objectAtIndex:[indexPath row]];
            [self.customDelegate payTypeValueSelected:payType];
        }
        
        
        [self.uiManager popFadeViewController:self.navigationController];
    }
    else {
        
        PayType * payType = [self.payTypeManager.payTypes objectAtIndex:[indexPath row]];
        NSString * message = [NSString stringWithFormat:@"Rename '%@' Pay Type", payType.name];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Edit Pay Type" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        // Add the text field for text entry.
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            // If you need to customize the text field, you can do so here.
            textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            textField.text = payType.name;
        }];
        
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"The \"Text Entry\" alert's cancel action occured.");
        }];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
           
            
            [self tryEditPayType:payType WithName:[[[alertController textFields] objectAtIndex:0] text]];
        }];
        
        // Add the actions.
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


- (void)tryAddPayTypeWithName:(NSString *)name {
    
    NSString * trim = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(trim.length == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't Create a Pay Type with no name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {

        [self.payTypeManager addPayType:name];
        self.tableView.editing = false;
        [self.tableView reloadData];
    }
}


- (void)tryEditPayType:(PayType *)payType WithName:(NSString *)name {
    
    NSString * trim = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(trim.length == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't Create a Pay Type with no name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        
        [self.payTypeManager renamePayType:payType withName:name];
        self.tableView.editing = false;
        [self.tableView reloadData];
    }
}
- (IBAction)backPressed:(id)sender {
    
    if (self.tableView.editing) {
        
        self.tableView.editing = NO;
        [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [self.actionButton setTitle:@"Cancel" forState:UIControlStateNormal];
    }
    else {
        [self.uiManager popFadeViewController:self.navigationController];
    }
}

- (IBAction)addPayTypePressed:(id)sender {

    NSString *title = NSLocalizedString(@"Add Pay Type", nil);
    NSString *message = NSLocalizedString(@"Enter name of new Pay Type", nil);
    NSString *okButtonTitle = NSLocalizedString(@"OK", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Add the text field for text entry.
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        // If you need to customize the text field, you can do so here.
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }];
    
    // Create the actions.
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Text Entry\" alert's cancel action occured.");
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UITextField *tf = [alertController.textFields objectAtIndex:0];
        [self tryAddPayTypeWithName:tf.text];
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)editPressed:(id)sender {
    
    self.tableView.editing = !self.tableView.editing;
    
    if (self.tableView.editing) {
        
        [self.actionButton setTitle:@"Done" forState:UIControlStateNormal];
    }
    else {
        [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [self.actionButton setTitle:@"Cancel" forState:UIControlStateNormal];
    }
}


@end
