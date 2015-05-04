//
//  FillerControl.m
//  M.Y.O.B.U.
//
//  Created by Raymond on 10/15/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "FillerControl.h"
#import "MSDataManager.h"
#import "UserAccount.h"
#import "EnvelopeManager.h"
#import "MYOBUTextView.h"

@interface FillerControl ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *fillButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIPickerTextField *incomePicker;


@property (strong, nonatomic) NSArray * users;
@property (strong, nonatomic) NSString * userSelected;
@property (strong, nonatomic) NSString * oldUserSelected;
@property (strong, nonatomic) UITextView* uitextView;
@property (strong, nonatomic) MYOBUTextView *notesView;


@end

@implementation FillerControl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.fillButton.enabled = NO;
    self.amountRemaining.userInteractionEnabled = NO;
    
    UserAccount * user = [[MSDataManager sharedManager] currentUserAccount];
    self.users = @[user];
    
    #warning check if account is linked
    
    self.incomePicker.text = user.username;
    self.incomePicker.options = self.users;
    
    //self.incomePicker = [[UIPickerView alloc] init];
    self.incomePicker.pickerView.delegate = self;
    self.incomePicker.pickerView.dataSource = self;
    
    self.uitextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    
    self.notesView  = [[MYOBUTextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:self.notesView];
    [self.notesView initialize];
    self.notesView.displayLabel = self.notesLabel;
    
    self.datePicker.date = [NSDate date];
    [self.datePicker initialize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)reset {
    
    self.notesLabel.text = @"";
    self.notesView.text = @"";
    self.datePicker.date = [NSDate date];
}


- (UIView *)GetEnvelopeInputAccessoryView
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 24)];
    [view setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
    
    UIButton * cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 1, 150, 21)];
    [cancelButton setImage:[UIImage imageNamed:@"CancelKeyboardButton"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelPressed) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelButton];
    
    UIButton * doneButton = [[UIButton alloc] initWithFrame:CGRectMake(165, 1, 150, 21)];
    [doneButton setImage:[UIImage imageNamed:@"DoneKeyboardButton"] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(donePressed) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:doneButton];
    
    return view;
}

- (void)cancelPressed
{
    self.userSelected = self.oldUserSelected;
    [self.uitextView resignFirstResponder];
}

- (void)donePressed
{
    [self.uitextView resignFirstResponder];
}

#pragma IBActions
- (IBAction)fillPressed:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(fillerControlFillPressed:)])
    {
        [self.delegate fillerControlFillPressed:self];
    }
}
- (IBAction)cancelPressed:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(fillerControlCancelPressed)])
    {
        [self.delegate fillerControlCancelPressed];
    }
}
- (IBAction)changeInomePressed:(id)sender {
    
    self.oldUserSelected = self.userSelected;
    
    self.uitextView.inputView = self.incomePicker;
    self.uitextView.inputAccessoryView = [self GetEnvelopeInputAccessoryView];
    [self.view addSubview:self.uitextView];
    
    
    [self.uitextView becomeFirstResponder];
}

- (IBAction)notesPressed:(id)sender {
    
    [self.notesView becomeFirstResponder];
}


#pragma Picker delegate
// Display each row's data.

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [[self.users objectAtIndex:row] username];
}

// Do something with the selected row.
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    self.incomePicker.text = [[self.users objectAtIndex:row] username];
    
}

#pragma picker datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.users count];
}
@end
