//
//  TransactionEditViewController.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 7/20/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "TransactionEditViewController.h"
#import "UICurrencyTextField.h"
#import "UIDateSelect.h"
#import "UIPickerTextField.h"
#import "MYOBUTextView.h"
#import "PayTypeManager.h"

@interface TransactionEditViewController ()<UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate>

@property (nonatomic, weak) IBOutlet PayTypeManager * payTypeManager;
@property (nonatomic, weak) IBOutlet UITextView *transactionNotesInput;
@property (nonatomic, weak) IBOutlet UIPickerTextField * paytypePicker;
@property (nonatomic, strong) NSDictionary * transactionTypeInfo;

@property (nonatomic, weak) IBOutlet UIPickerTextField * transactionTypePicker;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (nonatomic, weak) IBOutlet UIDateSelect * transactionDate;
@property (nonatomic, weak) IBOutlet UICurrencyTextField * transactionAmount;
@property (weak, nonatomic) IBOutlet UIPickerTextField *userPicker;
@property (weak, nonatomic) IBOutlet UIPickerTextField *moveLocationPicker;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *envelopeName;
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;
@property (strong, nonatomic) MYOBUTextView *notesView;
@property (weak, nonatomic) IBOutlet UILabel *moveFromLabel;
@property (weak, nonatomic) IBOutlet UIView *moveToView;
@property (assign, nonatomic) enum TransactionType originalTransitionType;
@property (assign, nonatomic) enum TransactionType editedTransitionType;
@property (strong, nonatomic) Envelope * moveToEnvelope;
@property (strong, nonatomic) Envelope * envelope;

@end

@implementation TransactionEditViewController

- (Envelope *)envelope {
    return [self.dataManager GetEnvelopeByIdentifier:self.envelopeID];
}

- (NSDictionary *)transactionTypeInfo
{
    if(_transactionTypeInfo == nil)
    {
        _transactionTypeInfo = @{[NSString stringWithFormat:@"%@", @(transactionTypeCreated)]:@"Created",
                                 [NSString stringWithFormat:@"%@", @(transactionTypeAdd)]:@"Filled",
                                 [NSString stringWithFormat:@"%@", @(transactionTypeMinus)]:@"Spent",
                                 [NSString stringWithFormat:@"%@", @(transactionTypeMoveAdd)]:@"Moved To",
                                 [NSString stringWithFormat:@"%@", @(transactionTypeMoveMinus)]:@"Moved Out"};
        
    }
    
    return _transactionTypeInfo;
}

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
    
    self.originalTransitionType = self.transaction.transactionType;
    self.editedTransitionType = self.transaction.transactionType;
    self.transactionDate.delegate = self;
    
    [self.transactionAmount setup];
    self.transactionAmount.hideBlur = YES;
    
    self.notesView  = [[MYOBUTextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:self.notesView];
    self.notesView.displayLabel = self.notesLabel;
    self.notesView.text = [self.transaction fullNotes];
    self.notesLabel.text = [self.transaction fullNotes];
    [self.notesView initialize];
    
    
    self.moveLocationPicker.delegate = self;
    self.moveLocationPicker.pickerView.delegate = self;
    self.moveLocationPicker.options = [self sortEnvelopes:self.dataManager.envelopes];
    self.moveLocationPicker.numberOfComponentsInPickerView = 1;
    self.moveLocationPicker.pickerView.tag = 2;
    [self.moveLocationPicker.pickerView reloadAllComponents];
    self.moveLocationPicker.placeholder = @"Move To";
    
    self.userPicker.pickerView.delegate = self;
    self.userPicker.delegate = self;
    self.userPicker.options = @[self.dataManager.currentUserAccount.username];
    self.userPicker.text = self.dataManager.currentUserAccount.username;
    self.userPicker.numberOfComponentsInPickerView = 1;
    self.userPicker.pickerView.tag = 1;
    [self.userPicker.pickerView reloadAllComponents];
    
    self.transactionTypePicker.pickerView.tag = 3;
    self.transactionTypePicker.options = @[@"Spend", @"Refund", @"Move"];
    self.transactionTypePicker.numberOfComponentsInPickerView = 1;
    self.transactionTypePicker.delegate =self;
    self.transactionTypePicker.pickerView.delegate = self;
    [self.transactionTypePicker.pickerView reloadAllComponents];
    self.transactionTypePicker.text = [self.transactionTypeInfo valueForKey:[NSString stringWithFormat:@"%d", self.editedTransitionType]];

    self.envelopeName.text = self.envelope.name;
    
    self.transactionDate.date = self.transaction.date;
    [self.transactionDate initialize];
    
    self.transactionAmount.text = self.transaction.displayAmount;
    self.transactionNotesInput.text = [self.transaction fullNotes];
    self.paytypePicker.text = self.transaction.paytype;
    
    if (self.editedTransitionType == transactionTypeAdd) {
        [self.moveFromLabel setHidden:true];
        [self.transactionAmount setTextColor:self.uiManager.myobuGreenBold];
        [self.updateButton setBackgroundColor:self.uiManager.myobuGreenBold];
        [self.transactionTypePicker setTextColor:self.uiManager.myobuGreenBold];
    }
    else if (self.editedTransitionType == transactionTypeMinus) {
        [self.moveFromLabel setHidden:true];
        [self.transactionAmount setTextColor:self.uiManager.myobuRed];
        [self.updateButton setBackgroundColor:self.uiManager.myobuRed];
        [self.transactionTypePicker setTextColor:self.uiManager.myobuRed];
    }
    else if (self.editedTransitionType== transactionTypeMoveAdd) {
        [self.moveFromLabel setHidden:false];
        [self.transactionAmount setTextColor:self.uiManager.myobuBlue];
        [self.updateButton setBackgroundColor:self.uiManager.myobuBlue];
        [self.transactionTypePicker setTextColor:self.uiManager.myobuBlue];
        
        NSString * tempID = self.envelope.identifier;
        self.envelope = [self.dataManager GetEnvelopeByIdentifier:self.transaction.linkedEnvelopeIdentifier];
        self.moveToEnvelope =  [self.dataManager GetEnvelopeByIdentifier:tempID];
        
        
        self.envelopeName.text = self.envelope.name;
        
        UIColor * color = [MSUIManager colorFrom:self.envelope.category.backgroundColor];
        const CGFloat* components = CGColorGetComponents([color CGColor]);
        CGFloat red = components[0];
        CGFloat green = components[1];
        CGFloat blue = components[2];
        
        
        [self.titleView setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:.6]];
        
        color = [MSUIManager colorFrom:self.moveToEnvelope.category.backgroundColor];
        components = CGColorGetComponents([color CGColor]);
        red = components[0];
        green = components[1];
        blue = components[2];
        
        self.moveLocationPicker.text = self.moveToEnvelope.name;
        [self.moveToView setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:.6]];
        
    }
    else if (self.editedTransitionType == transactionTypeMoveMinus) {
        [self.moveFromLabel setHidden:false];
        [self.transactionAmount setTextColor:self.uiManager.myobuBlue];
        [self.updateButton setBackgroundColor:self.uiManager.myobuBlue];
        [self.transactionTypePicker setTextColor:self.uiManager.myobuBlue];
        
        self.moveToEnvelope = [self.dataManager GetEnvelopeByIdentifier:self.transaction.linkedEnvelopeIdentifier];
        UIColor * color = [MSUIManager colorFrom:self.moveToEnvelope.category.backgroundColor];
        const CGFloat* components = CGColorGetComponents([color CGColor]);
        CGFloat red = components[0];
        CGFloat green = components[1];
        CGFloat blue = components[2];
        
        self.moveLocationPicker.text = self.moveToEnvelope.name;
        [self.moveToView setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:.6]];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setLabels];
    [self refreshScreen];
}

- (NSArray *)sortEnvelopes:(NSArray *)envelopes
{
    return [envelopes sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
}

- (void)refreshScreen {
    
    
    UIColor * color = [MSUIManager colorFrom:self.envelope.category.backgroundColor];
    const CGFloat* components = CGColorGetComponents([color CGColor]);
    CGFloat red = components[0];
    CGFloat green = components[1];
    CGFloat blue = components[2];
    
    [self.titleView setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:.6]];
    
    self.titleLabel.text = [NSString stringWithFormat:@"Balance: %@", [MSUIManager addCurrencyStyleCommaToDouble:[self.envelope.balance doubleValue]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)notesPressed:(id)sender {
    [self.notesView becomeFirstResponder];
}

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
- (IBAction)savePressed:(id)sender
{
    [self saveActions];
}

- (IBAction)spendPressed:(id)sender {
    
    [self updateTransactionToEnvelope:self.envelope FromInputWithType:transactionTypeMinus];
    [self refreshScreen];
    
}
- (IBAction)fillPressed:(id)sender {
    
    [self updateTransactionToEnvelope:self.envelope FromInputWithType:transactionTypeAdd];
    [self refreshScreen];
}

-(IBAction)moveFunds:(id)sender
{
    [self updateTransactionToEnvelope:self.envelope FromInputWithType:transactionTypeMoveMinus];
    [self refreshScreen];
}
*/

- (IBAction)updateTransactionPressed:(id)sender {
    
    
    NSString * toNotes = [NSString stringWithFormat:@"Moved To: %@\n", self.moveToEnvelope.name];
    NSString * fromNotes = [NSString stringWithFormat:@"Moved From: %@\n", self.envelope.name];
    NSString * notes = [self.notesLabel.text stringByReplacingOccurrencesOfString:toNotes withString:@""];
    notes = [self.notesLabel.text stringByReplacingOccurrencesOfString:fromNotes withString:@""];
    NSString * amountWithNoDollarSign = [MSUIManager stripDollarSignFromString:self.transactionAmount.text];
    NSString * amountWithNoComma = [MSUIManager stripCommasFromString:amountWithNoDollarSign];
    NSNumber * amount = @([amountWithNoComma doubleValue]);
    notes = [self.notesLabel.text stringByReplacingOccurrencesOfString:self.transaction.systemNotes withString:@""];
    

    self.transaction.amount = amount;
    self.transaction.date = self.transactionDate.date;
    self.transaction.user = self.dataManager.currentUserAccount;
    self.transaction.notes = notes;
    self.transaction.systemNotes = @"";
    self.transaction.transactionType = self.editedTransitionType;
    
    BOOL shouldAddToMoveEnvelope = false;
    if (self.editedTransitionType== transactionTypeMoveMinus || self.editedTransitionType == transactionTypeMoveAdd) {
    
        Transaction * newTransAction = [self getLinkedTransaction];
        
        if (newTransAction == nil) {

            newTransAction = [[Transaction alloc] init];
            newTransAction.linkID = self.transaction.linkID;
            shouldAddToMoveEnvelope = true;
        }
        else {
            notes = [notes stringByReplacingOccurrencesOfString:newTransAction.systemNotes withString:@""];
        }
        
        newTransAction.systemNotes = toNotes;
        newTransAction.amount = amount;
        newTransAction.date = self.transactionDate.date;
        newTransAction.user = self.dataManager.currentUserAccount;
        newTransAction.paytype = self.transaction.paytype;
    
        if (self.editedTransitionType == transactionTypeMoveMinus) {
            newTransAction.transactionType = transactionTypeMoveAdd;
        }
        else {
            newTransAction.transactionType = transactionTypeMoveMinus;
        }
        
        newTransAction.notes = notes;
        self.transaction.notes = notes;
        
        if (self.editedTransitionType == transactionTypeMoveMinus) {
            
            newTransAction.systemNotes = fromNotes;
            self.transaction.systemNotes = toNotes;
        }
        else {
            newTransAction.systemNotes = toNotes;
            self.transaction.systemNotes = fromNotes;
        }
        
        if (shouldAddToMoveEnvelope) {
            
            if(self.transaction.linkID == nil || self.transaction.linkID.length == 0) {
                
                self.transaction.linkID = self.dataManager.GetUUID;
                newTransAction.linkID = self.transaction.linkID;
                self.transaction.linkedEnvelopeIdentifier = self.moveToEnvelope.identifier;
                newTransAction.linkedEnvelopeIdentifier = self.envelope.identifier;
            }
            
            [newTransAction update];
            [self.moveToEnvelope.transactions addObject:newTransAction];
            [self.moveToEnvelope update];
        }
    }
    else if (self.originalTransitionType == transactionTypeMoveMinus || self.originalTransitionType == transactionTypeMoveAdd) {
        
        [self removeLinkedTransaction];
    }
    
    [self.transaction update];
    [self.envelope update];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateMove {
    
    
}

- (Transaction *)getLinkedTransaction {
    
    if (![self.transaction.linkID isEqualToString:@""]) {
        for(Transaction * transaction in self.moveToEnvelope.transactions) {
            if(self.transaction.linkID == transaction.linkID) {
            
                NSLog(@"Found Transaction!");
                return transaction;
            }
        }
    }
    
    return nil;
}

- (void)removeLinkedTransaction {
    
    Envelope * e;
    if (self.originalTransitionType == transactionTypeMoveMinus) {
        e = self.moveToEnvelope;
    }else {
        e = self.envelope;
    }
    
    NSArray * transactions = e.transactions;
    for(Transaction * transaction in transactions) {
        if(self.transaction.linkID == transaction.linkID) {
            
            [e.transactions removeObject:transaction];
        }
    }
}

/*
- (void)updateTransactionToEnvelope:(Envelope *)envelope FromInputWithType:(enum TransactionType)transactionType
{
    NSString * amountWithNoDollarSign = [MSUIManager stripDollarSignFromString:self.transactionAmount.text];
    NSString * amountWithNoComma = [MSUIManager stripCommasFromString:amountWithNoDollarSign];
    NSNumber * amount = @([amountWithNoComma doubleValue]);
    
    self.transaction.date = self.transactionDate.date;
    self.transaction.amount = amount;
    self.transaction.notes = self.notesLabel.text;
    self.transaction.transactionType = transactionType;
    self.transaction.user = self.dataManager.currentUserAccount;
    
    [self.dataManager updateEnvelopesObjects];
}*/


- (void)setLabels
{

    if(self.editedTransitionType == transactionTypeMinus)
    {
        self.transactionTypePicker.text = @"Spend";
        self.moveLocationPicker.text = @"";
        self.moveLocationPicker.placeholder = @"Move To";
        [self.transactionTypePicker.pickerView selectRow:0 inComponent:0 animated:false];
        [self.transactionTypePicker setTextColor:self.uiManager.myobuRed];
        [self.transactionAmount setTextColor:self.uiManager.myobuRed];
        [self.updateButton setBackgroundColor:self.uiManager.myobuRed];
        [self.moveToView setHidden:true];
        [self.moveFromLabel setHidden:true];
    }
    else if(self.editedTransitionType == transactionTypeAdd || self.editedTransitionType ==  transactionTypeCreated)
    {
        self.transactionTypePicker.text = @"Refund";
        self.moveLocationPicker.text = @"";
        self.moveLocationPicker.placeholder = @"Move To";
        [self.transactionTypePicker.pickerView selectRow:1 inComponent:0 animated:false];
        [self.transactionTypePicker setTextColor:self.uiManager.myobuGreenBold];
        [self.transactionAmount setTextColor:self.uiManager.myobuGreenBold];
        [self.updateButton setBackgroundColor:self.uiManager.myobuGreenBold];
        [self.moveToView setHidden:true];
        [self.moveFromLabel setHidden:true];
    }
    else if(self.editedTransitionType == transactionTypeMoveMinus || self.editedTransitionType == transactionTypeMoveAdd)
    {
        self.transactionTypePicker.text = @"Move";
        self.moveToView.userInteractionEnabled = true;
        [self.transactionTypePicker.pickerView selectRow:2 inComponent:0 animated:false];
        [self.transactionTypePicker setTextColor:self.uiManager.myobuBlue];
        [self.transactionAmount setTextColor:self.uiManager.myobuBlue];
        [self.updateButton setBackgroundColor:self.uiManager.myobuBlue];
        [self.moveToView setHidden:false];
        [self.moveFromLabel setHidden:false];
    }
    
}


- (void)transactionTypeChanged:(NSString *)type {
    
    if([type isEqualToString:@"Spend"])
    {

    }
    else if([type isEqualToString:@"Fill"] )
    {

    }
    else if([type isEqualToString:@"Move"] )
    {

    }
}


- (void)updateKeyControls
{
    self.paytypePicker.pickerView.delegate = self;
    self.transactionTypePicker.pickerView.delegate = self;
    self.paytypePicker.delegate = self;
    self.transactionTypePicker.delegate = self;
    self.transactionDate.delegate = self;
    self.transactionAmount.delegate = self;
    self.transactionNotesInput.delegate = self;
    
    
    self.paytypePicker.options = self.payTypeManager.payTypes;
    self.paytypePicker.numberOfComponentsInPickerView = 1;
    self.paytypePicker.text = self.transaction.paytype;
    
    if([self.transaction.paytype isEqualToString:@""])
    {
        NSUInteger paytypePickerIndex = [self.payTypeManager.payTypes indexOfObject:self.transaction.paytype];
        [self.paytypePicker.pickerView selectRow:paytypePickerIndex inComponent:0 animated:NO];
        [self.paytypePicker.pickerView reloadAllComponents];
    }
    
    self.transactionTypePicker.options = [self.transactionTypeInfo allValues];
    self.transactionTypePicker.numberOfComponentsInPickerView = 1;
    
    self.transactionTypePicker.text = [self.transactionTypeInfo valueForKey:[NSString stringWithFormat:@"%@",@(self.transaction.transactionType)]];
    
    NSInteger i = self.transaction.transactionType;
    
    [self.transactionTypePicker.pickerView selectRow:i inComponent:0 animated:NO];
    [self.transactionTypePicker.pickerView reloadAllComponents];
    
    NSArray * fields = @[self.transactionDate, self.transactionAmount, self.transactionNotesInput, self.paytypePicker, self.transactionTypePicker];
    
    [self setKeyboardControls:[[MSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
    [self.keyboardControls setToolbarVisibility:YES];
    
    self.Form_Y_Origin = -90;
}
/*
-(void)saveActions
{
    // remove transactions
    [self.envelope.transactions removeObject:self.transaction];
    
    if (self.originalTransitionType == transactionTypeMoveMinus || self.originalTransitionType == transactionTypeMoveAdd) {
        
        Transaction * linkedTransaction =self.transaction.linkedToTransaction;
        NSLog(@"Transaction Count: %lu", (unsigned long)self.envelope.transactions.count);
        [self.envelope.transactions removeObject:linkedTransaction];
        NSLog(@"Transaction Count After Remove Attempt: %lu", (unsigned long)self.envelope.transactions.count);
    }
    
    // add transactions
    
    NSDictionary * transactionInfo = @{@"date":self.transactionDate.date,
                                       @"amount":@([MSUIManager convertStringToDoubleValue:self.transactionAmount.text]),
                                       @"notes":self.transactionNotesInput.text,
                                       @"paytype":self.paytypePicker.text,
                                       @"transactionType":@(self.transaction.transactionType),
                                       @"user":self.dataManager.currentUserAccount};
    
    
    Transaction * newTransaction = [[Transaction alloc] initWithDictionary:transactionInfo];
    [self.envelope.transactions addObject:newTransaction];
    
    
    if (self.transaction.transactionType == transactionTypeMoveMinus) {
        
        
        [transactionInfo setValue:self.moveToEnvelope.paytype forKey:@"paytype"];
        [transactionInfo setValue:@(transactionTypeMoveAdd) forKey:@"transactionType"];
        Transaction * moveTransaction = [[Transaction alloc] initWithDictionary:transactionInfo];
        [self.moveToEnvelope.transactions addObject:moveTransaction];
    }
    
    [self.dataManager updateEnvelopesObjects];
    [self.transactionAmount reset];
}
*/
#pragma mark UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self base_textFieldDidBeginEditing:textField];
    
    if([textField isKindOfClass:[UIDateSelect class]]) {
        
        
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self base_textFieldDidEndEditing:textField];
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self base_textViewDidBeginEditing:textView];
    self.notesView.previousValue = self.notesView.text;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self base_textViewDidEndEditing:textView];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self base_textViewDidChange:textView];
}

#pragma Picker delegate
// Display each row's data.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if(pickerView.tag == 1)
    {
        return [self.userPicker.options objectAtIndex:row];
        
    }else if(pickerView.tag == 2)
    {
        Envelope * e = [self.moveLocationPicker.options objectAtIndex:row];
        return e.identifier;
    }
    else if(pickerView.tag == 3)
    {
        return [self.transactionTypePicker.options  objectAtIndex:row];
    }
    
    return nil;
}

// Do something with the selected row.
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (pickerView.tag == 2)
    {
        self.moveToEnvelope = [self.moveLocationPicker.options objectAtIndex:row];
        
        UIColor * color = [MSUIManager colorFrom:self.moveToEnvelope.category.backgroundColor];
        const CGFloat* components = CGColorGetComponents([color CGColor]);
        CGFloat red = components[0];
        CGFloat green = components[1];
        CGFloat blue = components[2];
        
        
        [self.moveToView setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:.6]];
        
        self.moveLocationPicker.text = self.moveToEnvelope.name;
    }
    else if(pickerView.tag == 3)
    {
        self.transactionTypePicker.text = [self.transactionTypePicker.options objectAtIndex:row];
        
        if (row == 0) {
            self.editedTransitionType = transactionTypeMinus;
            self.transaction.systemNotes = @"";
        }else if (row == 1) {
            self.editedTransitionType = transactionTypeAdd;
            self.transaction.systemNotes = @"";
        }
        else {
            self.editedTransitionType = transactionTypeMoveMinus;
        }
        [self setLabels];
    }
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
