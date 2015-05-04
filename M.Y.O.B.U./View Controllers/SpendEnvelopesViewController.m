//
//  SpendEnvelopesViewController.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 4/21/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "SpendEnvelopesViewController.h"
#import "UICurrencyTextField.h"
#import "UIDateSelect.h"
#import "Transaction.h"
#import "TransactionCell.h"
#import "UIPickerTextField.h"
#import "EnvelopeManager.h"
#import "TransactionViewController.h"
#import "MSUIManager.h"
#import "MYOBUTextView.h"
#import "PayTypeManager.h"
#import "PayTypePickerTextField.h"
#import "EnvelopeManager.h"

@interface SpendEnvelopesViewController ()<UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *hightlightViews;


@property (weak, nonatomic) IBOutlet UITextField *envelopeNameTF;
@property (weak, nonatomic) IBOutlet UICurrencyTextField *fundsInput;
@property (weak, nonatomic) IBOutlet UIPickerTextField *userPicker;
@property (weak, nonatomic) IBOutlet UIPickerTextField *moveLocationPicker;
@property (weak, nonatomic) IBOutlet UIPickerTextField *envelopeCategoryPicker;
@property (weak, nonatomic) IBOutlet PayTypePickerTextField *payTypePicker;
@property (weak, nonatomic) IBOutlet UIDateSelect *fundsDate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel * ytdSpentLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSString * envelopePicked;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;
@property (strong, nonatomic) MYOBUTextView *notesView;
@property (strong, nonatomic) PayTypeManager *payTypeManager;
@property (strong, nonatomic) EnvelopeManager *envelopeManager;
@property (strong, nonatomic) Envelope * envelope;
@end

@implementation SpendEnvelopesViewController

- (Envelope *)envelope {
    return [self.dataManager GetEnvelopeByIdentifier:self.envelopeID];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (EnvelopeManager *)envelopeManager {
    
    return [EnvelopeManager sharedManager];
}

- (PayTypeManager *) payTypeManager {
    
    return [PayTypeManager sharedManager];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    
    [self updateKeyControls];
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableTapped:)];
    tapped.numberOfTapsRequired = 1;
    [self.tableView addGestureRecognizer:tapped];
    
    self.notesView  = [[MYOBUTextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:self.notesView];
    [self.notesView initialize];
    self.notesView.displayLabel = self.notesLabel;
    
    self.payTypePicker.navController = self.navigationController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.envelopeNameTF.text = self.envelope.name;
    
    for (UIView * view in self.hightlightViews) {
        
        UIColor * color = [MSUIManager colorFrom:self.envelope.category.backgroundColor];
        const CGFloat* components = CGColorGetComponents([color CGColor]);
        CGFloat red = components[0];
        CGFloat green = components[1];
        CGFloat blue = components[2];
        
        [view setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:.6]];
    }
    
    [self refreshScreen];
}

- (void)refreshScreen {

    
    if(self.payTypePicker.payType.name.length == 0) {
        self.payTypePicker.payType  = [self.payTypeManager getPayTypeByName:self.envelope.paytype];
    }
    else if(![self.payTypePicker.payType.name isEqualToString:self.envelope.paytype]) {
        
        if ([self.envelopeManager doesEnvelopeExistWithName:self.envelope.name AndPayType:self.payTypePicker.payType.name]) {
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't create duplicate Envelopes with Pay Type names" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else {
            self.envelope.paytype = self.payTypePicker.payType.name;
            [self.dataManager updateEnvelopesObjects];
        }
    }
    
    
    self.titleLabel.text = [NSString stringWithFormat:@"Balance: %@", [MSUIManager addCurrencyStyleCommaToDouble:[self.envelope.balance doubleValue]]];
    self.ytdSpentLabel.text = self.envelope.displayTotalSpentYTD;
    
    self.notesLabel.text = @"";
    [self.notesView reset];
    [self.fundsInput reset];
    
    [self.tableView reloadData];
}

#pragma mark Private Functions
- (void)updateKeyControls
{
    self.envelopeNameTF.delegate = self;
    //self.payTypePicker.pickerView.delegate = self;
    self.userPicker.pickerView.delegate = self;
    self.userPicker.delegate = self;
    //self.fundsInput.delegate = self;
    //self.fundsInput.placeholder = @"$0.00";
    self.fundsInput.envelope = self.envelope; 
    [self.fundsInput setup];
    self.fundsInput.tag = 100;
    
    
    self.fundsDate.delegate = self;
    self.fundsDate.date = [[NSDate alloc] init];
    [self.fundsDate initialize];
    
    self.moveLocationPicker.delegate = self;
    self.moveLocationPicker.pickerView.delegate = self;
    self.envelopeCategoryPicker.delegate = self;
    self.envelopeCategoryPicker.pickerView.delegate = self;
    
    self.moveLocationPicker.options = [self sortEnvelopes:self.dataManager.envelopes];
    self.moveLocationPicker.numberOfComponentsInPickerView = 1;
    self.moveLocationPicker.pickerView.tag = 2;
    [self.moveLocationPicker.pickerView reloadAllComponents];
    self.moveLocationPicker.placeholder = @"Move To";
    
    self.envelopeCategoryPicker.options = self.dataManager.envelopeCategories;
    self.envelopeCategoryPicker.text = self.envelope.category.name;
    self.envelopeCategoryPicker.numberOfComponentsInPickerView = 1;
    self.envelopeCategoryPicker.pickerView.tag = 3;
    [self.envelopeCategoryPicker.pickerView reloadAllComponents];
    
    self.userPicker.options = @[self.dataManager.currentUserAccount.username];
    self.userPicker.text = self.dataManager.currentUserAccount.username;
    self.userPicker.numberOfComponentsInPickerView = 1;
    self.userPicker.pickerView.tag = 4;
    [self.userPicker.pickerView reloadAllComponents];
    
    //NSArray * fields = @[self.envelopeNameTF, self.payTypePicker, self.envelopeCategoryPicker, self.envelopeNotesInput, self.fundsInput, self.fundsDate, self.moveLocationPicker];
    
    //[self setKeyboardControls:[[MSKeyboardControls alloc] initWithFields:fields]];
    //[self.keyboardControls setDelegate:self];
    //[self.keyboardControls setToolbarVisibility:YES];
    
     //self.Form_Y_Origin = -90;
}

- (NSArray *)sortEnvelopes:(NSArray *)envelopes
{
   return [envelopes sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
}

- (void)tableTapped:(id)sender
{
    TransactionViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                                  instantiateViewControllerWithIdentifier:@"TransactionViewController"];
    viewController.envelopeID = self.envelope.identifier;
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark IBActions
- (IBAction)notesPressed:(id)sender {
    [self.notesView becomeFirstResponder];
}

- (IBAction)closePressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)spendPressed:(id)sender {
    
    [self addTransactionToEnvelope:self.envelope.name FromInputWithType:transactionTypeMinus];
    [self refreshScreen];

}
- (IBAction)fillPressed:(id)sender {
    
    [self addTransactionToEnvelope:self.envelope.name FromInputWithType:transactionTypeAdd];
    [self refreshScreen];
}

- (IBAction)deleteEnvelopePressed:(id)sender {

    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Delete Envelope" message:@"Are you sure you want to delete this envelope?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}

-(IBAction)moveFunds:(id)sender
{
    if(![self.moveLocationPicker.text isEqualToString:@""])
    {
        if(![self.envelopePicked isEqualToString:@""])
        {
            [self addMoveTransaction];
        }
    }
    
    [self refreshScreen];
}

- (void)addMoveTransaction {
    
    NSNumber * amount;
    if(self.fundsInput.text.length != 0)
    {
        NSString * amountWithNoDollarSign = [MSUIManager stripDollarSignFromString:self.fundsInput.text];
        NSString * amountWithNoComma = [MSUIManager stripCommasFromString:amountWithNoDollarSign];
        amount = @([amountWithNoComma doubleValue]);
    }
    else {
        return;
    }
    
    Envelope * envelopePicked = [self.dataManager GetEnvelopeByIdentifier:self.envelopePicked];
    NSString * toNotes = [NSString stringWithFormat:@"Moved To: %@\n", envelopePicked.name];
    NSString * fromNotes = [NSString stringWithFormat:@"Moved From: %@\n", self.envelope.name];
    
    Transaction * moveToTransaction = [[Transaction alloc] init];
    Transaction * moveFromTransaction = [[Transaction alloc] init];
    
    //create move to transaction
    moveToTransaction.systemNotes = fromNotes;
    moveToTransaction.notes = self.notesLabel.text;
    moveToTransaction.amount = amount;
    moveToTransaction.user = self.dataManager.currentUserAccount;
    moveToTransaction.paytype = envelopePicked.paytype;
    moveToTransaction.transactionType = transactionTypeMoveAdd;
    moveToTransaction.date = self.fundsDate.date;
    
    //create move from transaction
    moveFromTransaction.systemNotes = toNotes;
    moveFromTransaction.notes = self.notesLabel.text;
    moveFromTransaction.amount = amount;
    moveFromTransaction.user = self.dataManager.currentUserAccount;
    moveFromTransaction.paytype = self.envelope.paytype;
    moveFromTransaction.transactionType = transactionTypeMoveMinus;
    moveFromTransaction.date = self.fundsDate.date;
    
    NSString * linkID = [self.dataManager GetUUID];
    //link transactions
    moveFromTransaction.linkID = linkID;
    moveFromTransaction.linkedEnvelopeIdentifier = envelopePicked.identifier;
    moveToTransaction.linkID = linkID;
    moveToTransaction.linkedEnvelopeIdentifier = self.envelope.identifier;
    
    //add to envelopes
    [self.envelope.transactions addObject:moveFromTransaction];
    [envelopePicked.transactions addObject:moveToTransaction];
    
    //update last modified date
    //self.envelope.lastModiefiedDate = self.fundsDate.date;
    //envelopePicked.lastModiefiedDate = self.fundsDate.date;
    
    //save and refresh
    [self.dataManager updateEnvelopesObjects];
    [self refreshScreen];
}


- (void)addTransactionToEnvelope:(NSString *)envelopeName FromInputWithType:(enum TransactionType)transactionType
{
    [self addTransactionToEnvelope:envelopeName FromInputWithType:transactionType shouldReset:true appendedNotes:@""];
}

- (void)addTransactionToEnvelope:(NSString *)envelopeName FromInputWithType:(enum TransactionType)transactionType shouldReset:(BOOL)shouldReset appendedNotes:(NSString *)appendedNotes
{
    if(self.fundsInput.text.length != 0)
    {
        NSString * amountWithNoDollarSign = [MSUIManager stripDollarSignFromString:self.fundsInput.text];
        NSString * amountWithNoComma = [MSUIManager stripCommasFromString:amountWithNoDollarSign];
        NSNumber * amount = @([amountWithNoComma doubleValue]);
        [self addTransactionToEnvelope:envelopeName ForAmount:amount withType:transactionType shouldReset:shouldReset appendedNotes:appendedNotes];
    }
}

- (void)addTransactionToEnvelope:(NSString *)envelopeName ForAmount:(NSNumber *)amount withType:(enum TransactionType)transactionType
{
    [self addTransactionToEnvelope:envelopeName ForAmount:amount withType:transactionType shouldReset:true appendedNotes:@""];
}

- (void)addTransactionToEnvelope:(NSString *)envelopeName ForAmount:(NSNumber *)amount withType:(enum TransactionType)transactionType shouldReset:(BOOL)shouldReset appendedNotes:(NSString *)appendedNotes
{
    
    Transaction * transaction = [[Transaction alloc] init];
    transaction.notes = [appendedNotes stringByAppendingString:self.notesLabel.text];
    transaction.amount = amount;
    transaction.user = self.dataManager.currentUserAccount;
    transaction.paytype = self.envelope.paytype;
    transaction.transactionType = transactionType;
    transaction.date = self.fundsDate.date;
    
    Envelope * envelope = [self.dataManager GetEnvelopeByIdentifier:[[envelopeName lowercaseString] stringByAppendingString:[NSString stringWithFormat:@" -  %@",self.envelope.paytype]]];
    [envelope.transactions addObject:transaction];
    //envelope.lastModiefiedDate = transaction.date;
    [self.dataManager updateEnvelopesObjects];
    
    //[self saveAndReloadEnvelope];

    if (![self.envelope.paytype isEqualToString:self.payTypePicker.text]) {
        
        envelope.paytype = self.payTypePicker.text;
        [self changedPayType];
        [self.dataManager updateEnvelopePayTypesObjects];
    }
    
    if (shouldReset) {
        [self refreshScreen];
    }
}


- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changedPayType
{
    Transaction * transaction = [[Transaction alloc] init];
    transaction.notes = [@"Change Pay Type to " stringByAppendingString:self.payTypePicker.text];
    transaction.amount = @(0.00);
    transaction.date = self.fundsDate.date;
    transaction.user = self.dataManager.currentUserAccount;
    transaction.transactionType = transactionTypePayTypeEdit;
    
    [self.envelope.transactions addObject:transaction];
    [self saveAndReloadEnvelope];
}

- (void)shouldChangePayType
{
    if(![self.payTypePicker.text isEqualToString:self.envelope.paytype])
    {
        self.envelope.paytype = self.payTypePicker.text;
        [self changedPayType];
    }
}

#pragma mark UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self base_textFieldDidBeginEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self base_textFieldDidEndEditing:textField];
    
    if([textField isEqual:self.envelopeNameTF])
    {
        self.envelope.name = self.envelopeNameTF.text;

        //NSLog(@"self.envelope.name: %@", self.envelope.name);
        
        [self saveAndReloadEnvelope];
        //NSLog(@"self.envelopeS.name: %@", [[self.dataManager.envelopes objectAtIndex:0] name]);
    }
    /*
    else if([textField isEqual:self.defaultOrder])
    {
        NSMutableArray * envelopesInSection = [[Envelope Filter:self.dataManager.envelopes WithCategoryName:self.envelope.category.name] mutableCopy];
        [[EnvelopeManager sharedManager] changeDisplayOrder:@([self.defaultOrder.text integerValue]) ofEnvelope:self.envelope inEnvelopes:envelopesInSection];
    }*/
    
    [self shouldChangePayType];
    
    if(textField.tag == 100) {
    textField.placeholder = @"$0.00";
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
        //return [self.payTypePicker.options objectAtIndex: row];
    }
    else if (pickerView.tag == 2)
    {
        Envelope * e = [self.moveLocationPicker.options objectAtIndex:row];
        return e.identifier;
    }
    else if (pickerView.tag == 3)
    {
        EnvelopeCategory * cat = [self.envelopeCategoryPicker.options objectAtIndex:row];
        return cat.name;
    }
    else if (pickerView.tag == 4)
    {
        return [self.userPicker.options objectAtIndex:row];
    }
    
    return @"";
}

// Do something with the selected row.
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if(pickerView.tag == 1)
    {
        /*
        NSString * payTypeName = [self.payTypePicker.options objectAtIndex: row];
        
        if([payTypeName isEqualToString:@"Add New Pay Type"]) {
            
            EnvelopeManager * em = [EnvelopeManager sharedManager];
            [em showPayTypeAlert:self.payTypePicker];
        }
        else {
            self.payTypePicker.text = payTypeName;
        }*/
    }
    else if (pickerView.tag == 2)
    {
        Envelope * e = [self.moveLocationPicker.options objectAtIndex:row];
        
        self.envelopePicked = e.identifier;
        self.moveLocationPicker.text = e.name;
    }
    else if (pickerView.tag == 3)
    {
        EnvelopeCategory * cat = [self.envelopeCategoryPicker.options objectAtIndex:row];
        
        self.envelope.category = cat;
        self.envelopeCategoryPicker.text = cat.name;
        [self saveAndReloadEnvelope];
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

- (void)saveAndReloadEnvelope
{
    NSUInteger index = [self.dataManager.envelopes indexOfObject:self.envelope];
    
    [self.dataManager updateEnvelopesObjects];
    
    self.envelope = [self.dataManager.envelopes objectAtIndex:index];
    
    [self.view layoutIfNeeded];
    [self.tableView reloadData];
}


#pragma mark UITableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.envelope.transactions.count > 3) {
        
        return 3;
    }
    
    return self.envelope.transactions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"TransactionCell";
    TransactionCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    NSInteger transactionIndex = self.envelope.transactions.count - (indexPath.row + 1);
    Transaction * transaction = [self.envelope.transactions objectAtIndex:transactionIndex];
    cell.transaction = transaction;
    [cell setLabels];
    
    if (indexPath.row % 2) {
        cell.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        cell.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
    }
    
    return cell;
    
}

#pragma UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1){
        
        [[EnvelopeManager sharedManager] deleteEnvelope:self.envelope];
        [self.navigationController popViewControllerAnimated:YES];
    }
}



@end
