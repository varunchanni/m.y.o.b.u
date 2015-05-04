//
//  TransactionViewController.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 5/14/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "TransactionViewController.h"
#import "TransactionCell.h"
#import "TransactionEditViewController.h"
#import "UIPickerTextField.h"

@interface TransactionViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *envelopeName;
@property (weak, nonatomic) IBOutlet UILabel * ytdSpentLabel;
@property (strong, nonatomic) Envelope * envelope;
@end

@implementation TransactionViewController

- (Envelope *)envelope {
    return [self.dataManager GetEnvelopeByIdentifier:self.envelopeID];
}

- (void)setEnvelopeID:(NSString *)envelopeID
{
    if (![_envelopeID isEqualToString:envelopeID])
    {
        _envelopeID = envelopeID;
        [self setLabels];
    }
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
    self.envelopeName.userInteractionEnabled = NO;
    self.envelopeName.text = self.envelope.name;
    self.titleLabel.text = [NSString stringWithFormat:@"Balance: %@", [MSUIManager addCurrencyStyleCommaToDouble:[self.envelope.balance doubleValue]]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setLabels];
    [self refreshScreen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLabels
{
    self.titleView.backgroundColor = [MSUIManager colorFrom:self.envelope.category.backgroundColor];
    self.ytdSpentLabel.text = self.envelope.displayTotalSpentYTD;
}

- (void)refreshScreen {
    
    
    UIColor * color = [MSUIManager colorFrom:self.envelope.category.backgroundColor];
    const CGFloat* components = CGColorGetComponents([color CGColor]);
    CGFloat red = components[0];
    CGFloat green = components[1];
    CGFloat blue = components[2];
    
    [self.tableView reloadData];
    
    [self.titleView setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:.6]];
    
    self.titleLabel.text = [NSString stringWithFormat:@"Balance: %@", [MSUIManager addCurrencyStyleCommaToDouble:[self.envelope.balance doubleValue]]];
}

#pragma mark IBActions
- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark UITableView DataSource
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
    NSDictionary * labels = @{@"DATE":@5, @"NOTES":@60, @"USER":@150, @"PAY TYPE":@205, @"AMOUNT":@270};
    
    
    for(NSString * labelKey in [labels allKeys])
    {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake([[labels valueForKey:labelKey] integerValue], 0, 50, 22)];
        [label setTextColor:[UIColor blackColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont fontWithName: @"Trebuchet MS" size: 10.0f]];
        label.text = labelKey;
        [view addSubview:label];
    }
    return view;
}
*/
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.envelope.transactions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"TransactionCell";
    TransactionCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];// forIndexPath:indexPath];
    
    NSInteger transactionIndex = self.envelope.transactions.count - (indexPath.row + 1);
    Transaction * transaction = [self.envelope.transactions objectAtIndex:transactionIndex];
    cell.transaction = transaction;
    [cell setLabels];
    
    CGRect frame = cell.notesLabel.frame;
    CGFloat labelHeight = [self getLabelHeight:cell.notesLabel withString:transaction.notes];
    frame.size.height = labelHeight;
    cell.notesLabel.frame = frame;
    
    if (indexPath.row % 2) {
        cell.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
    }
    else
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellHeightWithOutLabel = 66;
    
    static NSString *cellID = @"TransactionCell";
    TransactionCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    NSInteger transactionIndex = self.envelope.transactions.count - (indexPath.row + 1);
    Transaction * transaction = [self.envelope.transactions objectAtIndex:transactionIndex];
    
    CGFloat labelHeight = [self getLabelHeight:cell.notesLabel withString:transaction.notes];
    
    return cellHeightWithOutLabel + labelHeight;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //delete your data here
        
        TransactionCell * cell = (TransactionCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        
        [self.envelope.transactions removeObject:cell.transaction];
        [self.dataManager updateEnvelopesObjects];
        [self setLabels];
        [self.tableView reloadData];
        [self.tableView reloadInputViews];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TransactionCell * cell = (TransactionCell *)[tableView cellForRowAtIndexPath:indexPath];
    enum TransactionType type = cell.transaction.transactionType;
    
    if(type != transactionTypeCreated)
    {
        TransactionEditViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                                     instantiateViewControllerWithIdentifier:@"TransactionEditViewController"];
        viewController.transaction = cell.transaction;
        viewController.envelopeID = self.envelope.identifier;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (CGFloat) getLabelHeight:(UILabel *)label withString:(NSString *)text  {
    
    CGSize labelSize = label.frame.size;
    NSString * removeReturns = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    CGSize sizeNeeded = [self getSizeOfLabel:label withString:removeReturns];
    
    CGFloat labelHeight = labelSize.height;
    
    if (labelSize.width < sizeNeeded.width/2)
    {
        CGFloat lines = ceil(sizeNeeded.width / (labelSize.width));
        labelHeight = lines * ceil(sizeNeeded.height);
        
        //if has returns get the number of them
        NSUInteger returnCount = [[text componentsSeparatedByString:@"\n"] count];
        NSUInteger extraLinesNeeded = returnCount - lines;
        
        if (extraLinesNeeded > 0) {
            labelHeight += labelSize.height * extraLinesNeeded;
        }
        
    }

    return labelHeight;
}
- (CGSize)getSizeOfLabel:(UILabel *)label withString:(NSString *)text  {
    
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    [data setValue:label.font forKey:NSFontAttributeName];
    
    return [text sizeWithAttributes:data];
}
#pragma mark UITableView Delegate
@end
