//
//  EnvelopeFillerViewController.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 3/31/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "EnvelopeFillerViewControllerOld.h"
#import "Envelope.h"
#import "EnvelopeCategory.h"
#import "EnvelopeFillerCell.h"
#import "AddModifyEnvelopesViewController.h"
#import "EnvelopeManager.h"
#import "SpendEnvelopesViewController.h"
#import "PayTypeManager.h"


enum EnvelopeFillerDisplayType {
    EnvelopeFillerDisplayTypeNormal,
    EnvelopeFillerDisplayTypeSorting,
    EnvelopeFillerDisplayTypeFiltering,
    EnvelopeFillerDisplayTypePay,
    EnvelopeFillerDisplayFillMode
};

enum EnvelopeFillerFilterType {
    EnvelopeFillerFilterTypeName,
    EnvelopeFillerFilterTypeDate,
    EnvelopeFillerFilterTypeAmount,
    EnvelopeFillerFilterTypePay
};


@interface EnvelopeFillerViewControllerOld () <MSKeyboardControlsDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) EnvelopeManager * envelopeManager;
@property (strong, nonatomic) PayTypeManager * payTypeManager;
@property (weak, nonatomic) IBOutlet UILabel *envelopeTotalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UISearchBar *search;
@property (weak, nonatomic) IBOutlet UIButton *sortFilterToggleBtn;
@property (weak, nonatomic) IBOutlet UITableView * tableView;
@property (weak, nonatomic) IBOutlet UIButton *fillButton;
@property (weak, nonatomic) IBOutlet UIView *fillView;
@property (weak, nonatomic) IBOutlet UILabel *remainingFundsLabel;
@property (weak, nonatomic) IBOutlet UIButton *AddFundsBtn;
@property (strong, nonatomic) NSArray * sortedFilteredEnvelopes;
@property (strong, nonatomic) NSDictionary * sectionTotals;
@property (assign, nonatomic) enum EnvelopeFillerDisplayType displayType;
@property (assign, nonatomic) enum EnvelopeFillerFilterType filterType;
@property (assign, nonatomic) BOOL nameSortedAscending;
@property (assign, nonatomic) BOOL dateSortedAscending;
@property (assign, nonatomic) BOOL balanceSortedAscending;
@property (assign, nonatomic) BOOL typeSortedFirstTime;
@property (assign, nonatomic) BOOL fillBalanceCheck;
@property (assign, nonatomic) NSNumber *fillBalance;
@property (assign, nonatomic) NSMutableArray * fields;
@property (strong, nonatomic) NSArray * fillSectionTotals;
@property (strong, nonatomic) NSMutableDictionary * fillLabels;
@property (strong, nonatomic) NSMutableDictionary * sectionTotalLabels;
@property (strong, nonatomic) NSMutableDictionary * displayedFillInputs;

//@property (strong, nonatomic) UILabel * fillLabel;
//@property (weak, nonatomic) IBOutlet UIView *sortAndFilterView;
//@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@end

@implementation EnvelopeFillerViewControllerOld


- (EnvelopeManager *)envelopeManager
{
	return [EnvelopeManager sharedManager];
}

- (PayTypeManager *)payTypeManager
{
    return [PayTypeManager sharedManager];
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
    [self loadData];
}

- (void)loadData{
    
    [self.envelopeManager initialize];
    
    
    UIFont *font = [UIFont systemFontOfSize:10.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self.segmentControl setTitleTextAttributes:attributes
                                       forState:UIControlStateNormal];
    
    self.segmentControl.hidden = YES;
    
    self.displayType = EnvelopeFillerDisplayTypeNormal;
    self.sortedFilteredEnvelopes = self.dataManager.envelopes;
    //self.sectionTotals = [self createSectionTotals:self.dataManager.envelopes];
    
    [self updateKeyControlsForNormalMode];
    
    self.search.delegate = self;
    //[self enableAllFields];
    
    self.nameSortedAscending = YES;
    self.dateSortedAscending = YES;
    self.balanceSortedAscending = YES;
    self.typeSortedFirstTime = YES;
    
    self.fillLabels = [[NSMutableDictionary alloc] init];
    self.displayedFillInputs = [[NSMutableDictionary alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewWillAppear:(BOOL)animated
{
    [self createSectionTotals:self.dataManager.envelopes];
    [self.tableView reloadData];
}


- (void)filterEnvelopesBy:(NSString *)Text
{
    NSPredicate *sPredicate = [NSPredicate predicateWithFormat:
                               [NSString stringWithFormat:@"SELF.name contains[c] '%@'", Text]];
    self.sortedFilteredEnvelopes = [self.dataManager.envelopes filteredArrayUsingPredicate:sPredicate];
}



#pragma mark IB Actions
- (IBAction)sortFilterTogglePressed:(id)sender {
    
    if([self.sortFilterToggleBtn.titleLabel.text isEqualToString:@"Sort"])
    {
        self.search.hidden = YES;
        self.segmentControl.hidden = NO;
        [self.sortFilterToggleBtn setTitle:@"Filter" forState:UIControlStateNormal];
        
    }else if([self.sortFilterToggleBtn.titleLabel.text isEqualToString:@"Filter"])
    {
        self.segmentControl.hidden = YES;
        self.search.hidden = NO;
        [self.sortFilterToggleBtn setTitle:@"Sort" forState:UIControlStateNormal];
    }
    
}
- (IBAction)clearPressed:(id)sender {
    
    [self clearTable];
}

- (IBAction)fillPressed:(id)sender {

    
    
    if(self.displayType != EnvelopeFillerDisplayFillMode)
    {
        [self clearTable];
        
        self.displayType = EnvelopeFillerDisplayFillMode;
        [self.envelopeManager resetFillSection];
        
        
        self.remainingFundsLabel.text = @"";
        [self.fillButton setTitle:@"Cancel" forState:UIControlStateNormal];
        
        NSInteger height = 360;
        
        if([MSUIManager isIPhone5])
        {
            height += 100;
        }
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 60, 0)];
                             [self.tableView setFrame:CGRectMake(0, 125, 320, height)];
                         
                         }
                         completion:^(BOOL finished){
                             self.view.userInteractionEnabled = YES;
                         }];
        
        
        NSString * title = @"Pay Amount";
        NSString * message = @"Enter your Pay Amount";
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title
                                                         message:message
                                                        delegate:self
                                               cancelButtonTitle:@"Skip"
                                               otherButtonTitles:@"OK", nil];
        
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        UICurrencyTextField * temp = [[UICurrencyTextField alloc] init];
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        
        
        alertTextField.keyboardType = temp.keyboardType;
        alertTextField.placeholder = temp.placeholder;
        alertTextField.tag = 999;
        alertTextField.delegate = self;
        [alert show];
        
        [self.tableView reloadData];
        [self updateKeyControlsForFillModeWithFieldData];
        [self createSectionTotals:self.dataManager.envelopes];
    }
    else
    {
        [self cancelFillMode];
    }
    
    
}


- (IBAction)segmentValueChanged:(id)sender {
    
    self.displayType = EnvelopeFillerDisplayTypeSorting;
    
    
    if(self.segmentControl.selectedSegmentIndex == 0)//Name
    {
        [self sortEnvelopesByName];
    }
    else if (self.segmentControl.selectedSegmentIndex == 1)//Date
    {
        [self sortEnvelopesByDate];
    }
    else if (self.segmentControl.selectedSegmentIndex == 2)//Amount
    {
        [self sortEnvelopesByBalance];
    }
    else if (self.segmentControl.selectedSegmentIndex == 3)//PayType
    {
        [self sortEnvelopesByPayType];
    }
    
    [self.tableView reloadData];
    
    NSLog(@"DisplayType: %i", self.displayType);
    NSLog(@"FilterType: %i", self.filterType);
    
}
- (IBAction)backPressed:(id)sender {
    [self.uiManager popFadeViewController:self.navigationController];
}

- (void)addEnvelopePressed:(id)sender {
    
    AddModifyEnvelopesViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                                         instantiateViewControllerWithIdentifier:@"AddModifyEnvelopesViewController"];
    if([sender isKindOfClass: [UIButton class]] )
    {
        UIButton * button = sender;
        NSString * catName = [[self.dataManager.envelopeCategories objectAtIndex:button.tag] name];
        viewController.startingCategoryName = catName;
        
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)AddFundsToEnvelopes:(id)sender {
    
    [self.envelopeManager executeFillEnvelopes];
    [self cancelFillMode];
}

#pragma mark Private Methods

- (void)clearTable
{
    self.displayType = EnvelopeFillerDisplayTypeNormal;
    self.search.text = @"";
    NSLog(@"DisplayType: %i", self.displayType);
    
    [self.tableView reloadData];
}
- (void)cancelFillMode
{
    self.remainingFundsLabel.text = @"";
    [self.envelopeManager resetFillSection];
    self.displayType = EnvelopeFillerDisplayTypeNormal;
    [self.fillButton setTitle:@"Fill Envelopes" forState:UIControlStateNormal];
    
    NSInteger height = 295;
    
    if([MSUIManager isIPhone5])
    {
        height += 100;
        
    }
    
    //self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                         [self.tableView setFrame:CGRectMake(0, 185, 320, height)];
                         
                     }
                     completion:^(BOOL finished){
                         self.view.userInteractionEnabled = YES;
                     }];
    
    self.fillView.hidden = YES;
    
    [self.envelopeManager resetFillSection];
    [self createSectionTotals:self.dataManager.envelopes];
    [self.tableView reloadData];
    [self updateKeyControlsForNormalMode];
    self.fillLabels = [[NSMutableDictionary alloc] init];
}

- (void)sortEnvelopesByName
{
    self.filterType = EnvelopeFillerFilterTypeName;
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:self.nameSortedAscending];
    self.sortedFilteredEnvelopes = [self.sortedFilteredEnvelopes sortedArrayUsingDescriptors:@[sort]];
    
    self.nameSortedAscending = !self.nameSortedAscending;
}


- (void)sortEnvelopesByDate
{
    self.filterType = EnvelopeFillerFilterTypeDate;
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"lastModiefiedDate" ascending:self.dateSortedAscending];
    self.sortedFilteredEnvelopes = [self.sortedFilteredEnvelopes sortedArrayUsingDescriptors:@[sort]];
    
    self.dateSortedAscending = !self.dateSortedAscending;    
}

- (void)sortEnvelopesByBalance
{
    self.filterType = EnvelopeFillerFilterTypeAmount;
    
    NSSortDescriptor *sortByBalance = [NSSortDescriptor sortDescriptorWithKey:@"balance" ascending:self.balanceSortedAscending comparator:^NSComparisonResult(id obj1, id obj2) {
    
        NSNumber * value1 = @([obj1 doubleValue]);
        NSNumber * value2 = @([obj2 doubleValue]);
        
        return [[NSString stringWithFormat:@"%@", value1] compare:[NSString stringWithFormat:@"%@", value2] options:NSNumericSearch];
    }];
    NSSortDescriptor *sortByAlpha = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    self.sortedFilteredEnvelopes = [self.sortedFilteredEnvelopes sortedArrayUsingDescriptors:@[sortByBalance, sortByAlpha]];
    
    self.balanceSortedAscending = !self.balanceSortedAscending;
}

- (void)sortEnvelopesByPayType
{
    
    self.filterType = EnvelopeFillerFilterTypePay;
    self.displayType = EnvelopeFillerDisplayTypePay;
    
    /*
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"paytype" ascending:YES];
    NSSortDescriptor *sortByCatName = [NSSortDescriptor sortDescriptorWithKey:@"category.name" ascending:YES];
    NSSortDescriptor *sortByAlpha = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    
    
    [self.sortedFilteredEnvelopes sortedArrayUsingComparator:^NSComparisonResult(Envelope * envelope1, Envelope * envelope2) {
        
        if (![envelope1.paytype isEqualToString:envelope2.paytype]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        else
        {
            if (![envelope1.category.name isEqualToString:envelope2.category.name]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            else
            {
                if (![envelope1.name isEqualToString:envelope2.name]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                else
                {
                    return (NSComparisonResult)NSOrderedSame;
                }
            }
        }
        
    }];
    
    self.sortedFilteredEnvelopes = [self.dataManager.envelopes sortedArrayUsingDescriptors:@[sortByCatName]];
    
     */
    
    if(!self.typeSortedFirstTime)
    {
        /*
        self.payTypeManager.payTypes = [[NSMutableArray alloc] initWithArray:
            [[self.payTypeManager.payTypes reverseObjectEnumerator] allObjects]];
        
        NSLog(@"payTypes: %@", self.payTypeManager.payTypes);
        NSLog(@"payTypes: %lu", (unsigned long)self.payTypeManager.payTypes.count);
    
         */
    }
    self.typeSortedFirstTime = NO;
}



- (NSArray *)getEnvelopesWithPayType:(NSString *)payType
{
    NSMutableArray * envelopesArray = [[NSMutableArray alloc] init];
    
    [self.dataManager.envelopes enumerateObjectsUsingBlock:^(Envelope * envelope, NSUInteger idx, BOOL *stop) {
        
        if([envelope.paytype isEqualToString:payType])
        {
            [envelopesArray addObject:envelope];
        }
    }];
    
    
    return envelopesArray;
}

- (NSString *)getTotalOfEnvelopesWith:(NSArray *)envelopes
{
    __block NSNumber * total;
    
    [envelopes enumerateObjectsUsingBlock:^(Envelope * envelope, NSUInteger idx, BOOL *stop) {
        
        total = [NSNumber numberWithFloat:([envelope.balance floatValue] + [total floatValue])];
        
    }];
    
    return [@"$" stringByAppendingString:[MSUIManager addCurrencyStyleCommaToDouble:[total doubleValue]]];
}

- (void)createSectionTotals:(NSArray *)envelopes
{
    __block CGFloat total = 0;
    __block NSMutableDictionary * sectionTotals = [[NSMutableDictionary alloc] init];
    [self.dataManager.envelopeCategories enumerateObjectsUsingBlock:^(EnvelopeCategory * envelopeCat, NSUInteger idx, BOOL *stop) {
        
        NSString * catName = envelopeCat.name;
        NSArray * envelopesInSection = [Envelope Filter:self.dataManager.envelopes WithCategoryName:catName];
        NSString * sectionTotal = [self getTotalOfEnvelopesWith:envelopesInSection];
        [sectionTotals setValue:sectionTotal forKey:catName];
        
        NSString * sectionTotalValue = [MSUIManager stripDollarSignFromString:sectionTotal];
        sectionTotalValue = [MSUIManager stripCommasFromString:sectionTotalValue];
        //NSNumber * x = [NSNumber numberWithDouble:[sectionTotalValue doubleValue]];
        total += [sectionTotalValue doubleValue];
    }];
    
    NSString * totalValue = [@"$" stringByAppendingString:[MSUIManager addCurrencyStyleCommaToDouble:total]];
    NSString * fillTotal = [self.envelopeManager GetFillTotal];
    self.envelopeTotalLabel.text = [self addStringValues:@[totalValue, fillTotal]];
    self.sectionTotals = sectionTotals;
}

- (void)updateKeyControlsForFillModeWithFieldData
{
    NSArray * fields = [self.displayedFillInputs allValues];
    
    [self setKeyboardControls:[[MSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
    [self.keyboardControls setToolbarVisibility:YES];
    
    if([MSUIManager isIPhone5])
    {
        self.Form_Y_Origin = -120;
    }
    else
    {
        self.Form_Y_Origin = -150;
    }
}


- (void)updateKeyControlsForNormalMode
{
    [self setKeyboardControls:[[MSKeyboardControls alloc] initWithFields:@[self.search]]];
    [self.keyboardControls setDelegate:self];
    [self.keyboardControls setToolbarVisibility:YES];
    
    self.Form_Y_Origin = -90;
}


- (void)recalculateRemainingFunds
{
    self.remainingFundsLabel.text = [self.envelopeManager GetFillBalanceOfRemainingFunds];
    
    
    if ([self.remainingFundsLabel.text rangeOfString:@"-"].location != NSNotFound) {
       
        if(self.fillBalanceCheck)
        {
            self.AddFundsBtn.hidden = YES;
            self.remainingFundsLabel.hidden = NO;
            self.remainingFundsLabel.textColor = [UIColor redColor];
        }
    }
    else if([self.remainingFundsLabel.text isEqualToString:@"Remaining Funds: $0.00"])
    {
        if(self.fillBalanceCheck)
        {
            self.AddFundsBtn.hidden = NO;
            self.remainingFundsLabel.hidden = YES;
        }
    }
    else
    {
        if(self.fillBalanceCheck)
        {
            self.AddFundsBtn.hidden = YES;
            self.remainingFundsLabel.hidden = NO;
            self.remainingFundsLabel.textColor = [UIColor greenColor];
        }
    }
    
}

- (NSString *)addStringValues:(NSArray *)strings
{
    __block CGFloat total = 0.0;
    [strings enumerateObjectsUsingBlock:^(NSString * string, NSUInteger idx, BOOL *stop) {
        
        string = [MSUIManager stripCommasFromString:string];
        string = [MSUIManager stripDollarSignFromString:string];
        total += [string doubleValue];
    }];
    
    NSString * value = [@"$" stringByAppendingString:[MSUIManager addCurrencyStyleCommaToDouble:total]];
    return value;
}

#pragma mark UITableView DataSource

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * key = [NSString stringWithFormat:@"%li-%li",(long)indexPath.section, (long)indexPath.row];
    
    if(![[self.displayedFillInputs allKeys] containsObject:key])
    {
        EnvelopeFillerCell * envelopeFilterCell = (EnvelopeFillerCell *)cell;
        [self.displayedFillInputs setValue:envelopeFilterCell.envelopeFillAmount forKey:key];
        
        //[self updateKeyControlsForFillModeWithFieldData];
        
    }
}

-(void) tableView:(UITableView *)tableView didEndDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * key = [NSString stringWithFormat:@"%li-%li",(long)indexPath.section, (long)indexPath.row];
    
    if([[self.displayedFillInputs allKeys] containsObject:key])
    {
        
        [self.displayedFillInputs removeObjectForKey:key];
        
    }
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    

    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [view setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.95]];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 20)];
    [label setTextColor:[UIColor blackColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont fontWithName: @"Trebuchet MS" size: 12.0f]];
    
    if(self.displayType == EnvelopeFillerDisplayTypeNormal || self.displayType == EnvelopeFillerDisplayFillMode)
    {
        EnvelopeCategory * envelopCat = [self.dataManager.envelopeCategories objectAtIndex:section];
        label.text = envelopCat.name;
        
        
        UILabel * totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 2, 300, 20)];
        [totalLabel setTextColor:[UIColor blackColor]];
        [totalLabel setBackgroundColor:[UIColor clearColor]];
        [totalLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size:10.0f]];
        
        
        NSString * catName = [[self.dataManager.envelopeCategories objectAtIndex:section] name];
        
        totalLabel.text =  [self.sectionTotals objectForKey:catName];
        
        NSString * key = [NSString stringWithFormat:@"%li",(long)section];
    
        
        
        if(self.displayType == EnvelopeFillerDisplayTypeNormal)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
            [button setFrame:CGRectMake(295.0, 5.0, 14.0, 14.0)];
            button.tag = section;
            button.hidden = NO;
            [button setBackgroundColor:[UIColor clearColor]];
            [button addTarget:self action:@selector(addEnvelopePressed:) forControlEvents:UIControlEventTouchDown];
            
            UILabel *buttonLabel=[[UILabel alloc] initWithFrame:CGRectMake(-205, -15, 200, 44)];
            buttonLabel.text = @"Add Envelope";
            buttonLabel.textAlignment = NSTextAlignmentRight;
            [buttonLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 10.0f]];
            [buttonLabel setTextColor:[UIColor lightGrayColor]];
            [button addSubview:buttonLabel];
            [view addSubview:button];
        }
        
        
        if(self.displayType == EnvelopeFillerDisplayFillMode)
        {
            if(![[self.fillLabels allKeys] containsObject:key])
            {
                UILabel *fillLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 0, 100, 20)];;
                fillLabel.text = [self.envelopeManager GetFillTotalForSection:section];
                fillLabel.textAlignment = NSTextAlignmentRight;
                [fillLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 10.0f]];
                [fillLabel setTextColor:[UIColor lightGrayColor]];
                [view addSubview:fillLabel];
                
                [self.fillLabels setValue:fillLabel forKey:key];
                totalLabel.text = [self addStringValues:@[totalLabel.text, fillLabel.text]];
            }
            else
            {
                UILabel *fillLabel = (UILabel *)[self.fillLabels valueForKey:key];
                [view addSubview:fillLabel];
                totalLabel.text = [self addStringValues:@[totalLabel.text, fillLabel.text]];
            }
            
            
        }
        
        [view addSubview:totalLabel];
        [view setTintColor:[UIColor lightGrayColor]];
    }
    else if(self.displayType == EnvelopeFillerDisplayTypePay)
    {
        NSString * payType = [self.payTypeManager.payTypes objectAtIndex:section];
        label.text = payType;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(210, 0, 100, 20)];
        NSArray * envelopesInSection = [self getEnvelopesWithPayType:payType];
        
        
        
        label.text = [self getTotalOfEnvelopesWith:envelopesInSection];
        label.textAlignment = NSTextAlignmentRight;
        [label setFont:[UIFont fontWithName: @"Trebuchet MS" size: 10.0f]];
        [label setTextColor:[UIColor lightGrayColor]];
        [view addSubview:label];
        
    }
    else
    {
        NSString * display = (self.displayType == EnvelopeFillerDisplayTypeSorting) ? (@"sorted") : (@"filtered");
        NSString * action;
        
        if(self.displayType == EnvelopeFillerDisplayTypeSorting)
        {
            if(self.filterType == EnvelopeFillerFilterTypeAmount)
            {
                action = @"'amount'";
            }
            else if (self.filterType == EnvelopeFillerFilterTypeName)
            {
                action = @"'name'";
            }
            else if (self.filterType == EnvelopeFillerFilterTypeDate)
            {
                action = @"'date'";
            }
            else
            {
                action = @"'pay type'";
            }
        }
        else
        {
            action = [NSString stringWithFormat:@"'%@'", self.search.text];
            
            [self filterEnvelopesBy:self.search.text];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(210, 0, 100, 20)];
            NSArray * envelopesInSection = self.sortedFilteredEnvelopes.copy;
            
            
            
            label.text = [self getTotalOfEnvelopesWith:envelopesInSection];
            label.textAlignment = NSTextAlignmentRight;
            [label setFont:[UIFont fontWithName: @"Trebuchet MS" size: 10.0f]];
            [label setTextColor:[UIColor lightGrayColor]];
            [view addSubview:label];
        }
        
        
        label.text = [[display stringByAppendingString:@" by "] stringByAppendingString:action];
    }
    
    
    [view addSubview:label];
    
    
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.displayType == EnvelopeFillerDisplayTypeNormal || self.displayType == EnvelopeFillerDisplayFillMode)
    {
        NSInteger count = self.dataManager.envelopeCategories.count;
        return count;
    }
    else if(self.displayType == EnvelopeFillerDisplayTypePay)
    {
        NSInteger count = self.payTypeManager.payTypes.count;
        return count;
    }
    else{
        return 1;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.displayType == EnvelopeFillerDisplayTypeNormal || self.displayType == EnvelopeFillerDisplayFillMode)
    {
        NSString * catName = [[self.dataManager.envelopeCategories objectAtIndex:section] name];
        NSUInteger rows = [[Envelope Filter:self.dataManager.envelopes WithCategoryName:catName] count];
        
        if(self.dataManager.envelopeCategories.count-1 == section && self.displayType == EnvelopeFillerDisplayFillMode)
        {
            //rows++;
        }
        
        return rows;
    }
    else if(self.displayType == EnvelopeFillerDisplayTypePay)
    {
        NSString * payType = [self.payTypeManager.payTypes objectAtIndex:section];
        return [[self getEnvelopesWithPayType:payType] count];
    }
    else if(self.displayType == EnvelopeFillerDisplayTypeFiltering)
    {
        
        [self filterEnvelopesBy:self.search.text];
        return self.sortedFilteredEnvelopes.count;
    }
    
    return self.dataManager.envelopes.count;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    Envelope * envelope;
    static NSString *cellID = @"EnvelopeFillerCell";
    
    if(self.displayType == EnvelopeFillerDisplayTypeNormal || self.displayType == EnvelopeFillerDisplayFillMode)
    {
        NSString * catName = [[self.dataManager.envelopeCategories objectAtIndex:indexPath.section] name];
        NSArray * envelopesInSection = [Envelope Filter:self.dataManager.envelopes WithCategoryName:catName];
        if(self.dataManager.envelopeCategories.count-1 == indexPath.section &&
           self.displayType == EnvelopeFillerDisplayFillMode &&
           envelopesInSection.count == indexPath.row)
        {
            
        }
        else
        {
            NSInteger index = indexPath.row;
            envelope = [envelopesInSection objectAtIndex:index];
        }
    }
    else if(self.displayType == EnvelopeFillerDisplayTypePay)
    {
        NSString * payType = [self.payTypeManager.payTypes objectAtIndex:indexPath.section];
        
        NSSortDescriptor *sortByCatName = [NSSortDescriptor sortDescriptorWithKey:@"category.name" ascending:YES];
        NSSortDescriptor *sortByAlpha = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        
        NSArray * envelopesInSection = [[self getEnvelopesWithPayType:payType] sortedArrayUsingDescriptors:@[sortByCatName, sortByAlpha]];
        envelope = [envelopesInSection objectAtIndex:indexPath.row];
    }
    else
    {
        envelope = [self.sortedFilteredEnvelopes objectAtIndex:indexPath.row];
    }
    
    EnvelopeFillerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    
    if(envelope != nil)
    {
        cell.envelope = envelope;
        cell.envelopeLabel.text = envelope.name;
        cell.envelopePayLabel.text = envelope.paytype;
        cell.envelopeDateLabel.text = [MSUIManager shortDateFormat:envelope.lastModiefiedDate];
        
        if(self.displayType == EnvelopeFillerDisplayFillMode)
        {
            cell.envelopePayLabel.frame = CGRectMake(93, 21, 160, 21);
            cell.envelopePayLabel.textAlignment = NSTextAlignmentLeft;
            cell.envelopeFillAmount.hidden = NO;
            cell.envelopeFillAmount.delegate = self;
            cell.envelopeFillAmount.keyboardAppearance = UIKeyboardAppearanceDark;
            [cell.envelopeFillAmount reset];
            cell.envelopeFillAmount.tag = 50;
            cell.envelopeFillAmount.section = indexPath.section;
            cell.envelopeFillAmount.row = indexPath.row;
            cell.envelopeFillAmount.text = [self.envelopeManager getFillValueForRow:indexPath.row inSection:indexPath.section];
            
            CGFloat fillAmount = [MSUIManager convertStringToDoubleValue:cell.envelopeFillAmount.text];
            CGFloat total = [envelope.balance floatValue] + fillAmount;
            
            cell.envelopeTotalLabel.text =  [@"$" stringByAppendingString:[MSUIManager addCurrencyStyleCommaToDouble:total]];
        }
        else
        {
            cell.envelopePayLabel.frame = CGRectMake(261, 11, 59, 21);
            cell.envelopePayLabel.textAlignment = NSTextAlignmentCenter;
            cell.envelopeFillAmount.hidden = YES;
            cell.envelopeTotalLabel.text = envelope.displayBalance;
        }
        
        
        cell.backgroundColor = [MSUIManager colorFrom:envelope.category.backgroundColor];
    }
    else
    {
        cell.envelopePayLabel.hidden = YES;
        cell.envelopeFillAmount.hidden = YES;
        cell.envelopeTotalLabel.hidden = YES;
        cell.envelopeLabel.hidden = YES;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EnvelopeFillerCell * cell = (EnvelopeFillerCell *)[tableView cellForRowAtIndexPath:indexPath];
    SpendEnvelopesViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                                 instantiateViewControllerWithIdentifier:@"SpendEnvelopesViewController"];
    viewController.envelopeID  = cell.envelope.identifier;
    //[self.navigationController pushViewController:viewController animated:YES];
    //[self.uiManager pushFadeViewController:self.navigationController toViewController:viewController];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //delete your data here
        EnvelopeFillerCell * cell = (EnvelopeFillerCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        
        [self.dataManager.envelopes removeObject:cell.envelope];
        [self.dataManager updateEnvelopesObjects];
        [self createSectionTotals:self.dataManager.envelopes];
        [self loadData];
        [self.tableView reloadData];
        [self.tableView reloadInputViews];
        
    }
}

#pragma mark UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UITextField *)textField
{
    [self base_textFieldDidBeginEditing:textField];
}
- (void)searchBarTextDidEndEditing:(UITextField *)textField
{
    [self base_textFieldDidEndEditing:textField];
    
    if(textField.text.length == 0)
    {
        self.displayType = EnvelopeFillerDisplayTypeNormal;
        [self.tableView reloadData];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length != 0)
    {
        self.displayType = EnvelopeFillerDisplayTypeFiltering;
    }
    else
    {
        self.displayType = EnvelopeFillerDisplayTypeNormal;
    }
    
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    /*
    if(searchBar.text.length != 0)
    {
        self.displayType = EnvelopeFillerDisplayTypeFiltering;
        [self.tableView reloadData];
    }
    */
    [searchBar resignFirstResponder];
}

#pragma mark Text Field Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
   
    [self base_textFieldDidBeginEditing:textField];
    if(textField.tag == 50)
    {
        self.tableView.scrollEnabled = NO;
    }
    /*
    if(textField.tag == 50)
    {
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(keyboardDidShowOrHide:)
                                                     name: UIKeyboardDidShowNotification object:nil];
        
    }
    else
    {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    }
    */
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self base_textFieldDidEndEditing:textField];
    
    
    self.tableView.scrollEnabled = YES;
    
    if([textField isKindOfClass:[UICurrencyTextField class]])
    {
        UICurrencyTextField * currencyField = (UICurrencyTextField *)textField;
        
        
        NSString * stringValue = [MSUIManager stripCommasFromString:currencyField.text];
        stringValue = [MSUIManager stripDollarSignFromString:stringValue];
        CGFloat value = [stringValue doubleValue];
    

        [self.envelopeManager UpdateFillDataAtSection:currencyField.section AtRow:currencyField.row withValue:value];
        [self recalculateRemainingFunds];
        
        
        
        NSString * key = [NSString stringWithFormat:@"%li",(long)currencyField.section];
        UILabel * label  = (UILabel *)[self.fillLabels objectForKey:key];
        label.text = [self.envelopeManager GetFillTotalForSection:currencyField.section];
        [self createSectionTotals:self.dataManager.envelopes];
        
        //[self.tableView reloadRowsAtIndexPaths:(NSArray *) withRowAnimation:]
        //UILabel *sectionLabel = [self.sectionTotalLabels objectForKey:@"0"];
        //sectionLabel.text = @"0";
        UITableViewHeaderFooterView * header = [self.tableView headerViewForSection:currencyField.section];
        
        for(UIView * view in header.subviews)
        {
            NSLog(@"view: %@", view);
        }
    }
}

/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if([textField isKindOfClass:[UICurrencyTextField class]])
    {
        UICurrencyTextField * currencyTF = (UICurrencyTextField *)textField;
        return [currencyTF currency_textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    else if(textField.tag == 999)
    {
        UICurrencyTextField * currencyTF = [[UICurrencyTextField alloc] init];
        currencyTF.text = textField.text;
        //currencyTF.text = textField.text;
    return [currencyTF noncurrency_textField:textField shouldChangeCharactersInRange:range replacementString:string];
        
    }
    
    return YES;
}*/


#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView.title isEqualToString:@"Pay Amount"])
    {
        if(buttonIndex == 0) //skip
        {
            self.fillBalanceCheck = NO;
            self.remainingFundsLabel.hidden = YES;
            self.AddFundsBtn.hidden = NO;
        }
        else if(buttonIndex == 1) //ok
        {
            
            self.fillBalanceCheck = YES;
            NSString * fillBalanceString = [[alertView textFieldAtIndex:0] text];
            fillBalanceString = [fillBalanceString stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            if([fillBalanceString isEqualToString:@""])
            {
                self.fillBalanceCheck = NO;
            }
            
            if(self.fillBalanceCheck)
            {
                [self.envelopeManager setFillFundsBudget:fillBalanceString];
                
                [self recalculateRemainingFunds];
                
                fillBalanceString = [MSUIManager stripDollarSignFromString:fillBalanceString];
                fillBalanceString = [MSUIManager stripCommasFromString:fillBalanceString];
                self.fillBalance = [NSNumber numberWithDouble:[fillBalanceString doubleValue]];
                
                self.remainingFundsLabel.hidden = NO;
                self.AddFundsBtn.hidden = YES;
            }
            else
            {
                //remove labels
                self.remainingFundsLabel.hidden = YES;
                self.AddFundsBtn.hidden = NO;
            }
            
        }
        
        self.fillView.hidden =NO;
        
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
