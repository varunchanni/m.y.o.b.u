//
//  AddModifyEnvelopesViewController.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 4/21/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "AddModifyEnvelopesViewController.h"
#import "UICurrencyTextField.h"
#import "Envelope.h"
#import "UICurrencyTextField.h"
#import "UIPickerTextField.h"
#import "EnvelopeCategory.h"
#import "EnvelopeManager.h"
#import "MSKeyboardControls.h"
#import "MYOBUTextView.h"
#import "PayTypeManager.h"
#import "PayTypePickerTextField.h"
#import "UIDateSelect.h"

@interface AddModifyEnvelopesViewController () <UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *envelopeNameInput;
@property (weak, nonatomic) IBOutlet UIView *envelopeHeadingView;
@property (weak, nonatomic) IBOutlet UICurrencyTextField *envelopeBalanceInput;
@property (weak, nonatomic) IBOutlet UIPickerTextField *envelopeCategoryInput;
@property (weak, nonatomic) IBOutlet PayTypePickerTextField *envelopePayTypeInput;
@property (weak, nonatomic) IBOutlet UIPickerTextField *userPicker;
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;
@property (weak, nonatomic) IBOutlet UIDateSelect *addDate;
@property (strong, nonatomic) MYOBUTextView * notesView;
@property (strong, nonatomic) PayTypeManager * payTypeManager;


@end

@implementation AddModifyEnvelopesViewController

- (PayTypeManager *) payTypeManager {
    
    return [PayTypeManager sharedManager];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self configureKeyboardControls];
    [self.envelopeBalanceInput setup];
    
    self.notesView  = [[MYOBUTextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:self.notesView];
    [self.notesView initialize];
    self.notesView.displayLabel = self.notesLabel;
    
    self.addDate.date = [NSDate date];
    self.addDate.delegate = self;
    self.addDate.date = [[NSDate alloc] init];
    [self.addDate initialize];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.envelopeBalanceInput.hideBlur = YES;
}



#pragma Private Methods
- (void)configureKeyboardControls
{
    self.userPicker.pickerView.delegate = self;
    self.envelopeCategoryInput.pickerView.delegate = self;
    self.userPicker.delegate = self;
    self.envelopeNameInput.delegate = self;
    self.envelopeBalanceInput.delegate = self;
    self.envelopeCategoryInput.delegate = self;
    
    self.envelopePayTypeInput.navController = self.navigationController;
    
    NSMutableArray * categoryNames = [[NSMutableArray alloc] init];
    
    [self.dataManager.envelopeCategories enumerateObjectsUsingBlock:^(EnvelopeCategory * category, NSUInteger idx, BOOL *stop) {
        
        [categoryNames addObject:category.name];
    }];
    
    self.envelopeCategoryInput.options = categoryNames;
    //self.envelopePayTypeInput.options = self.payTypeManager.payTypes;
    self.envelopeCategoryInput.numberOfComponentsInPickerView = 1;
    //self.envelopePayTypeInput.numberOfComponentsInPickerView = 1;
    
    self.userPicker.options = @[self.dataManager.currentUserAccount.username];
    self.userPicker.text = self.dataManager.currentUserAccount.username;
    self.userPicker.numberOfComponentsInPickerView = 1;
    [self.userPicker.pickerView reloadAllComponents];
    
    [self.envelopeCategoryInput.pickerView reloadAllComponents];
    //[self.envelopePayTypeInput.pickerView reloadAllComponents];

    self.envelopeCategoryInput.pickerView.tag = 1;
    //self.envelopePayTypeInput.pickerView.tag = 2;
    self.userPicker.pickerView.tag = 3;

    self.envelopeCategoryInput.text = [categoryNames objectAtIndex:0];
    
    PayType * payType = [self.payTypeManager.payTypes objectAtIndex:0];
    self.envelopePayTypeInput.payType = payType;

    
}

#pragma Private Methods
- (void)updateMainEnvelopeColor:(NSString *) catName
{
    EnvelopeCategory * envelopeCategory = [EnvelopeCategory getEnvelopeCategoryBy:catName];
    
    UIColor * color = [MSUIManager colorFrom:envelopeCategory.backgroundColor];
    const CGFloat* components = CGColorGetComponents([color CGColor]);
    CGFloat red = components[0];
    CGFloat green = components[1];
    CGFloat blue = components[2];
    
    [self.envelopeHeadingView setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:.6]];
}

- (void)clearScreen
{
    
    self.addDate.date = [NSDate date];
    
    self.titleLabel.text = @"Balance: $0.00";
    self.envelopeNameInput.text = @"";
    self.envelopeNameInput.placeholder = @"Envelope Name";
    self.envelopeBalanceInput.text = @"";
    self.envelopeBalanceInput.placeholder = @"Starting Balance";
    [self.envelopeBalanceInput reset];
    
    self.envelopeCategoryInput.text = @"";
    self.envelopeCategoryInput.placeholder = @"Category";
    self.envelopePayTypeInput.text = @"";
    self.envelopePayTypeInput.placeholder = @"Pay Type";
    self.userPicker.text = @"";
    self.userPicker.placeholder = @"User";
    self.userPicker.text = @"";
    
    self.notesLabel.text = @"";
    [self.notesView reset];
    
    EnvelopeCategory * cat = self.dataManager.envelopeCategories[0];
    UIColor * color = [MSUIManager colorFrom:cat.backgroundColor];
    const CGFloat* components = CGColorGetComponents([color CGColor]);
    CGFloat red = components[0];
    CGFloat green = components[1];
    CGFloat blue = components[2];
    
    [self.envelopeHeadingView setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:.6]];
}

#pragma IBActions
- (IBAction)addEnvelopePressed:(id)sender {
    
    NSString *envelopeName = self.envelopeNameInput.text;
    NSString *envelopePayType = self.envelopePayTypeInput.text;
    NSString *envelopeCategory = self.envelopeCategoryInput.text;
    
    if ([[envelopeName stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0) {
        
        //Alert there is no name
        [MSUIManager alertWithTitle:@"Warning!" andMessage:@"Envelope Name can NOT be blank!"];
    }
    else if ([[envelopeCategory stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0) {
        
        //Alert there is no name
        [MSUIManager alertWithTitle:@"Warning!" andMessage:@"Envelope Category can NOT be blank!"];
        
    }
    else if ([[envelopePayType stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0) {
        
        //Alert there is no name
        [MSUIManager alertWithTitle:@"Warning!" andMessage:@"Envelope Pay Type can NOT be blank!"];
    
    }
    else
    {
        if(![[EnvelopeManager sharedManager] doesEnvelopeExistWithName:envelopeName AndPayType:envelopePayType])
        {
        
            NSUInteger defaultOrder = [[Envelope Filter:self.dataManager.envelopes WithCategoryName:self.envelopeCategoryInput.text] count]+1;
            NSDictionary * envelopeInfo = @{@"Name" : self.envelopeNameInput.text,
                                        @"StartingBalance" : @([MSUIManager convertStringToDoubleValue:self.envelopeBalanceInput.text]),
                                        @"category" : self.envelopeCategoryInput.text,
                                        @"Paytype" : self.envelopePayTypeInput.text,
                                        @"Notes" : self.notesLabel.text,
                                        @"defaultOrder" : @(defaultOrder) };
        
            Envelope * envelope = [[Envelope alloc] initWithDictionary:envelopeInfo andUser:self.dataManager.currentUserAccount OnDate:self.addDate.date];
            [self.dataManager.envelopes addObject:envelope];
            [self.dataManager updateEnvelopesObjects];
        
            [self clearScreen];
        }
        else
        {
            //Envelope exist
            [MSUIManager alertWithTitle:@"Warning!" andMessage:[NSString stringWithFormat:@"Envelope with Name: '%@' and Pay Type: '%@' already exist!", envelopeName, envelopePayType]];
        }
    }
}
- (IBAction)backPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addPayType:(id)sender {
    
   // EnvelopeManager * em = [EnvelopeManager sharedManager];
    
    //[em showPayTypeAlert:self.envelopePayTypeInput.text];
}

- (IBAction)notesPressed:(id)sender {
    
    [self.notesView becomeFirstResponder];
}



#pragma Picker delegate
// Display each row's data.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if(pickerView.tag == 1)
    {
        return [self.envelopeCategoryInput.options objectAtIndex: row];
    
    }
    //else if (pickerView.tag == 2) {
        
        //PayType * payType = [self.envelopePayTypeInput.options objectAtIndex: row];
        //return payType.name;
       
    //}
    else
    {
        return [self.userPicker.options objectAtIndex: row];
    }
}

// Do something with the selected row.
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if(pickerView.tag == 1)
    {
        NSString * catName = [self.envelopeCategoryInput.options objectAtIndex: row];
        [self updateMainEnvelopeColor:catName];
    
        self.envelopeCategoryInput.text = catName;
    }
    //else if (pickerView.tag == 2) {
    //    NSString * payTypeName = [[self.envelopePayTypeInput.options objectAtIndex: row] name];
    //    self.envelopePayTypeInput.text = payTypeName;
    //}
    else
    {
        
    }
}

#pragma mark Text Field Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self base_textFieldDidBeginEditing:textField];
    
    if([textField isKindOfClass:[UIPickerTextField class]])
    {
        UIPickerTextField * picker = (UIPickerTextField *)textField;
        picker.text = picker.options[0];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self base_textFieldDidEndEditing:textField];
    
    if ([textField isEqual:self.envelopeBalanceInput]) {
        self.titleLabel.text = [NSString stringWithFormat:@"Balance: %@", self.envelopeBalanceInput.text];
    }
    
    
    if ([textField isEqual:self.envelopeNameInput]) {
        
        if ([[self.envelopeNameInput.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0) {
        
            self.envelopeNameInput.text = @"";
            self.envelopeNameInput.placeholder = @"Envelope Name";
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField isKindOfClass:[UICurrencyTextField class]])
    {
        UICurrencyTextField * currencyTF = (UICurrencyTextField *)textField;
        return [currencyTF currency_textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return NO;
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self base_textViewDidBeginEditing:textView];
    
    self.notesView.previousValue = self.notesView.text;
    //self.addEnvelopeBtn.enabled = NO;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self base_textViewDidEndEditing:textView];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self base_textViewDidChange:textView];
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
