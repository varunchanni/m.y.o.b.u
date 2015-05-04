//
//  EnvelopeFillerViewController.m
//  M.Y.O.B.U.
//
//  Created by Raymond on 9/12/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "EnvelopeFillerViewController.h"
#import "EnvelopeManager.h"
#import "EnvelopeFillerCell.h"
#import "SpendEnvelopesViewController.h"
#import "AddModifyEnvelopesViewController.h"
#import "SWRevealViewController.h"
#import "SideMenuSettings.h"
#import "FillerControl.h"
#import "MSAlertView.h"
#import "NSString+Extension.h"
#import "FillEnvelopeCell.h"
#import "PayTypeManager.h"

enum EnvelopeFillerDisplayMode {
    EnvelopeFillerDisplayTypeNormal,
    EnvelopeFillerDisplayFillMode,
    EnvelopeFillerDisplayReorderMode
};

enum EnvelopeFillerSortMode{
    EnvelopeFillerSortedModeNormal,
    EnvelopeFillerSortedModeName,
    EnvelopeFillerSortedModeAmount,
    EnvelopeFillerSortedModeDate,
    EnvelopeFillerSortedModePayType
};

@interface EnvelopeFillerViewController()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SideMenuSettingsDelegate, UITextFieldDelegate, FillerControlDelegate, UICurrencyTextFieldDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *titleItem;
@property (weak, nonatomic) IBOutlet UISearchBar *search;
@property (weak, nonatomic) IBOutlet UITableView * tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightNavButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *nameSortButton;
@property (weak, nonatomic) IBOutlet UIButton *balanceSortButton;
@property (weak, nonatomic) IBOutlet UIButton *dateSortButton;
@property (weak, nonatomic) IBOutlet UIButton *paytypeSortButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;
@property (weak, nonatomic) IBOutlet UIView *fillContainerView;

@property (strong, nonatomic) EnvelopeManager * envelopeManager;
@property (strong, nonatomic) PayTypeManager * payTypeManager;
@property (assign, nonatomic) enum EnvelopeFillerDisplayMode displayMode;
@property (assign, nonatomic) enum EnvelopeFillerSortMode sortMode;
@property (strong, nonatomic) FillerControl * fillControl;
@property (strong, nonatomic) NSDictionary * sectionTotals;
@property (strong, nonatomic) NSArray * envelopes;
@property (strong, nonatomic) NSArray * envelopeCategories;
@property (strong, nonatomic) NSArray * envelopePayTypes;
@property (strong, nonatomic) NSString * filterString;
@property (strong, nonatomic) NSDictionary * menuContent;
@property (assign, nonatomic) BOOL sortAscending;
@property (strong, nonatomic) UIViewController * mainMenuViewController;
@property (strong, nonatomic) NSDictionary * menuItems;
@property (strong, nonatomic) NSDictionary * fillAmounts;
@property (assign, nonatomic) double fillBalance;
@property (strong, nonatomic) NSString * fillRemainingBalance;
@end

@implementation EnvelopeFillerViewController

#pragma properties
- (EnvelopeManager *)envelopeManager
{
	return [EnvelopeManager sharedManager];
}

- (PayTypeManager *) payTypeManager {
    
    return [PayTypeManager sharedManager];
}

- (NSString *) filterString
{
    return self.search.text;//[self.search.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSSortDescriptor *)sortByNameDescriptor:(BOOL)ascending
{
   return [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:ascending];
}

- (NSSortDescriptor *)sortByBalanceDescriptor:(BOOL)ascending
{
    return [NSSortDescriptor sortDescriptorWithKey:@"balance" ascending:ascending];
}

- (NSSortDescriptor *)sortByLastModiefiedDateDescriptor:(BOOL)ascending
{
    return [NSSortDescriptor sortDescriptorWithKey:@"lastModiefiedDate" ascending:ascending];
}

- (NSSortDescriptor *)sortByPayTypeDescriptor:(BOOL)ascending
{
    return [NSSortDescriptor sortDescriptorWithKey:@"paytype" ascending:ascending];
}

- (NSArray *)envelopes
{
    NSArray * e;
    if([self.filterString length] <= 0)
    {
        //get envelopes
        e = self.dataManager.envelopes;
    }
    else
    {
        //filter envelopes
        e = [self filterEnvelopesBySearchString];
    }
    
    //sort envelopes
    if(self.sortMode != EnvelopeFillerSortedModeNormal) // || self.standByDisplayType == EnvelopeFillerDisplaySortedMode)
    {
        e = [self sortEnvelopes:e];
    }
    
    if(self.displayMode == EnvelopeFillerDisplayFillMode)
    {
        e = [self sortEnvelopes:e];
        //self.titleItem.title = [@"Amount Remaining: " stringByAppendingString:self.fillRemainingBalance];
    }
    else {
        
        self.titleItem.title = [@"Envelopes: " stringByAppendingString:[self.envelopeManager GetTotalForEnvelopes:e]];
    }
	return e;
}

- (NSArray *)envelopeCategories
{
    if([self.filterString length] <= 0)
    {
        //get all envelope categories
        return self.dataManager.envelopeCategories;
    }
    else
    {
        //get filter envelope categories
        
        return [self EnvelopesCategoriesInEnvelopes:self.envelopes];
    }
}

- (NSArray *)envelopePayTypes
{
    NSArray * pts = self.payTypeManager.payTypes;
    
    NSSortDescriptor * descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:self.sortAscending];

    pts = [pts sortedArrayUsingDescriptors:@[descriptor]];
    
    return pts;
}



#pragma init
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
    [self.envelopeManager initialize];
    self.displayMode = EnvelopeFillerDisplayTypeNormal;
 
    
    self.fillContainerView.hidden = YES;
    
    [self.childViewControllers enumerateObjectsUsingBlock:^(UIViewController * controller, NSUInteger idx, BOOL *stop) {
        
        if(controller.class == [FillerControl class])
        {
            self.fillControl = (FillerControl *)controller;
            self.fillControl.delegate = self;
        }
        *stop = YES;
    }];
    
    //self.resetButton.enabled = NO;
    
    self.search.delegate = self;
    self.tableView.tag = 1;
    
    [self updateKeyControls];
    
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    self.menuButton.target = self.revealViewController;
    self.menuButton.action = @selector(revealToggle:);
    self.settingsButton.target = self.revealViewController;
    self.settingsButton.action = @selector(rightRevealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    SideMenuSettings * sideMenu = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SideMenuSettings"];
    
    NSArray * settingsArray = @[@"Add Envelope", @"Fill Envelopes", @"Reorder Envelopes", @"Income", @"Expenses", @"Show Only Favorites", @"Share"];
    self.menuItems = @{@"Settings":settingsArray};
    
    sideMenu.titleLabel.text = @"Envelope Settings";
    sideMenu.menuItems = self.menuItems;
    sideMenu.delegate = self;
    
    self.revealViewController.rightViewController = sideMenu;

}

- (void)viewWillAppear:(BOOL)animated {
    
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma IBActions
- (IBAction)resetPressed:(id)sender {

    [self clearSort];
    [self.search resignFirstResponder];
    self.sortMode = EnvelopeFillerSortedModeNormal;
    
    [self refresh];
    
    //self.resetButton.enabled = NO;
}

- (IBAction)sortByNamePressed:(id)sender {

    [self clearSort];
    
    self.sortMode = EnvelopeFillerSortedModeName;
    self.sortAscending = !self.sortAscending;
    //self.resetButton.enabled = YES;
    //self.displayType = EnvelopeFillerDisplaySortedMode;
    
    [self refresh];
}

- (IBAction)sortByBalancePressed:(id)sender {

    [self clearSort];
    
    self.sortMode = EnvelopeFillerSortedModeAmount;
    self.sortAscending = !self.sortAscending;
    //self.resetButton.enabled = YES;
    //self.displayType = EnvelopeFillerDisplaySortedMode;
    
    [self refresh];
}

- (IBAction)sortByDatePressed:(id)sender {

    [self clearSort];
    
    self.sortMode = EnvelopeFillerSortedModeDate;
    self.sortAscending = !self.sortAscending;
    //self.resetButton.enabled = YES;
    //self.displayType = EnvelopeFillerDisplaySortedMode;
    
    [self refresh];
}

- (IBAction)sortByPayTypePressed:(id)sender {

    [self clearSort];
    
    self.sortMode = EnvelopeFillerSortedModePayType;
    self.sortAscending = !self.sortAscending;
    //self.resetButton.enabled = YES;
    //self.displayType = EnvelopeFillerDisplaySortedMode;
    
    [self refresh];
}

#pragma private actions

/*
- (NSString *)getTotalFromEnvelopes
{
    __block NSNumber * total;
    
    [self.envelopes enumerateObjectsUsingBlock:^(Envelope * envelope, NSUInteger idx, BOOL *stop) {
        
        
    }];
    
    return total;
}
*/
- (NSArray *)filterEnvelopesBySearchString
{
    NSPredicate *sPredicate = [NSPredicate predicateWithFormat:
                               [NSString stringWithFormat:@"self.name contains[c] '%@'",self.filterString]];
                                //|| SELF.name contains[c] '%@' || self.notes contains[c] '%@' || self.paytype contains[c] '%@'",
                                //self.filterString, self.filterString, self.filterString, self.filterString]];
    
    return [self.dataManager.envelopes filteredArrayUsingPredicate:sPredicate];
}

- (NSArray *)sortEnvelopes:(NSArray *)envelopes
{
    NSSortDescriptor *descriptor;
    if(self.sortMode == EnvelopeFillerSortedModeName)
    {
        return [envelopes sortedArrayUsingDescriptors:@[[self sortByNameDescriptor:self.sortAscending]]];
    }
    else if(self.sortMode == EnvelopeFillerSortedModeAmount)
    {
        return [envelopes sortedArrayUsingDescriptors:@[
                                              [self sortByBalanceDescriptor:self.sortAscending],
                                              [self sortByNameDescriptor:YES]
                                              ]];
    }
    else if(self.sortMode == EnvelopeFillerSortedModeDate)
    {
        return [envelopes sortedArrayUsingDescriptors:@[
                                              [self sortByLastModiefiedDateDescriptor:self.sortAscending],
                                              [self sortByNameDescriptor:YES],
                                              [self sortByBalanceDescriptor:YES]
                                              ]];
    }
    else if(self.sortMode == EnvelopeFillerSortedModePayType)
    {
        return [envelopes sortedArrayUsingDescriptors:@[
                                              [self sortByPayTypeDescriptor:self.sortAscending],
                                              [self sortByNameDescriptor:YES],
                                              [self sortByBalanceDescriptor:YES]
                                              ]];
    }
    else
    {
        descriptor  = [NSSortDescriptor sortDescriptorWithKey:@"defaultOrder" ascending:self.sortAscending];
        return [envelopes sortedArrayUsingDescriptors:@[descriptor]];
    }
}

- (NSArray *)EnvelopesCategoriesInEnvelopes:(NSArray *)envelopes
{
    __block NSMutableArray * eCat = [[NSMutableArray alloc] init];
    [self.envelopes enumerateObjectsUsingBlock:^(Envelope * envelope, NSUInteger idx, BOOL *stop) {
        
        if(![eCat containsObject:envelope.category])
        {
            [eCat addObject:envelope.category];
        }
        
    }];
    
    return eCat;
}

- (void)refresh
{
    self.fillContainerView.hidden = YES;
    
    CGRect frame = self.tableView.frame;
    NSInteger tableX = 107;
    NSInteger tableHeight = self.view.frame.size.height - tableX;
    
    frame = CGRectMake(frame.origin.x, tableX, frame.size.width, tableHeight);
    self.tableView.frame = frame;
    
    if(self.displayMode == EnvelopeFillerDisplayFillMode)
    {
        [self.fillControl reset];
        self.fillControl.datePicker.delegate = self;
        
        //self.rightNavButton.title = @"Cancel";
        self.fillContainerView.hidden = NO;
        [self toggleButtons:NO];
        
        CGRect frame = self.tableView.frame;
        NSInteger tableX = 167;
        NSInteger tableHeight = self.view.frame.size.height - tableX;
        
        frame = CGRectMake(frame.origin.x, tableX, frame.size.width, tableHeight);
        self.tableView.frame = frame;
    
    }
    else if(self.displayMode == EnvelopeFillerDisplayReorderMode)
    {
        //self.rightNavButton.title = @"Cancel";
        [self toggleButtons:NO];
    }
    else
    {
        //self.rightNavButton.title = @"Edit";
        [self toggleButtons:YES];
    }
    
    
    [self.envelopeManager resetFillSection];
    [self.tableView reloadData];
    [self.view reloadInputViews];
}


- (void)toggleButtons:(BOOL)enabled
{
    self.search.userInteractionEnabled = enabled;
    self.nameSortButton.userInteractionEnabled = enabled;
    self.balanceSortButton.userInteractionEnabled = enabled;
    self.dateSortButton.userInteractionEnabled = enabled;
    self.paytypeSortButton.userInteractionEnabled = enabled;
    //self.resetButton.userInteractionEnabled = enabled;
}

- (void)clearSort
{
    //self.sortByName = NO;
    //self.sortByAmount = NO;
    //self.sortByDate = NO;
    //self.sortByPayType = NO;
    self.displayMode = EnvelopeFillerDisplayTypeNormal;
    //self.standByDisplayType = EnvelopeFillerDisplayTypeNormal;
}

- (void)updateKeyControls
{
    [self setKeyboardControls:[[MSKeyboardControls alloc] initWithFields:@[self.search]]];
    [self.keyboardControls setDelegate:self];
    [self.keyboardControls setToolbarVisibility:NO];
    self.Form_Y_Origin = -1;
}

- (NSString *)sectionTotalForEnvelopeCategory:(EnvelopeCategory *)envelopeCat AtSection:(NSInteger)section
{
    __block NSString * catName = envelopeCat.name;
    __block NSNumber * total;
    
    [self.envelopes enumerateObjectsUsingBlock:^(Envelope * envelope, NSUInteger idx, BOOL *stop) {
        
        if([envelope.category.name isEqualToString:catName])
        {
            total = @([total doubleValue] + [envelope.balance doubleValue]);
        }
    }];
    
    return [MSUIManager addCurrencyStyleCommaToDouble:[total doubleValue]];
}

- (NSString *)sectionTotalForPayType:(NSString *)payType AtSection:(NSInteger)section
{
    __block NSNumber * total;
    
    [self.envelopes enumerateObjectsUsingBlock:^(Envelope * envelope, NSUInteger idx, BOOL *stop) {
        
        if([envelope.paytype isEqualToString:payType])
        {
            total = @([total doubleValue] + [envelope.balance doubleValue]);
        }
    }];
    
    return [MSUIManager addCurrencyStyleCommaToDouble:[total doubleValue]];
}

- (Envelope *)getEnvelopeForCell:(NSIndexPath *)indexPath
{
    Envelope * envelope;
    
    if (self.sortMode != EnvelopeFillerSortedModeNormal)
    {
        if(self.sortMode != EnvelopeFillerSortedModePayType)
        {
            envelope = [self.envelopes objectAtIndex:indexPath.row];
        }
        else
        {
            
            PayType * payType = [self.envelopePayTypes objectAtIndex:indexPath.section];
            NSArray * envelopesInSection = [Envelope Filter:self.envelopes WithPayType:payType.name];
            envelope = [envelopesInSection objectAtIndex:indexPath.row];
        }
    }
    else
    {
        NSString * catName = [[self.envelopeCategories objectAtIndex:indexPath.section] name];
        NSArray * envelopesInSection = [Envelope Filter:self.envelopes WithCategoryName:catName];
        envelope = [envelopesInSection objectAtIndex:indexPath.row];
    }
    
    return envelope;
}
 - (NSString *)GetCellIDForCellDisplayMode
{
    NSString * cellID;
    if(self.displayMode == EnvelopeFillerDisplayTypeNormal)
    {
        cellID = @"EnvelopeFillerCell";
    }
    else if(self.displayMode == EnvelopeFillerDisplayFillMode)
    {
        cellID = @"EnvelopeFillerCellFillMode";
    }
    else if(self.displayMode == EnvelopeFillerDisplayReorderMode)
    {
        cellID = @"EnvelopeFillerCellReorderMode";
    }
    
    return cellID;
}
- (EnvelopeFillerCell *)createEnvelopeFillerCell:(NSIndexPath *)indexPath
{
    NSString * cellID = [self GetCellIDForCellDisplayMode];
    Envelope * envelope = [self getEnvelopeForCell:indexPath];
    
    EnvelopeFillerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.line.image = [UIImage imageNamed:@"Line"];
    
    if(envelope != nil)
    {
        cell.envelopeID = envelope.identifier;
        cell.envelopeFillAmount.hideBlur = NO;
        cell.fillInput.hideBlur = NO;
        cell.envelopeLabel.text = envelope.name;
        cell.envelopePayLabel.text = envelope.paytype;
        cell.envelopeDateLabel.text = [MSUIManager longDateFormat:envelope.lastModiefiedDate];
        cell.envelopeTotalLabel.text = [MSUIManager addCurrencyStyleCommaToDouble:[envelope.balance doubleValue]];
        cell.fillInput.detail = [self sectionTotalForEnvelopeCategory:envelope.category AtSection:indexPath.section];
        cell.fillInput.envelope = envelope;
        [cell.fillInput setup];
    }
    
    if(self.sortMode != EnvelopeFillerSortedModeNormal)
    {
        UIColor * color = [MSUIManager colorFrom:envelope.category.backgroundColor];
        const CGFloat* components = CGColorGetComponents([color CGColor]);
        CGFloat red = components[0];
        CGFloat green = components[1];
        CGFloat blue = components[2];
        
        cell.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:.6];
    }
    else if(self.displayMode == EnvelopeFillerDisplayFillMode)
    {
        if (indexPath.row % 2) {
            cell.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
        }
        else
        {
            cell.backgroundColor = [UIColor whiteColor];
        }
        
    }
    else
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    
    
    return cell;
    
}

#pragma mark UITableView DataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
    [view setBackgroundColor:[UIColor whiteColor]];
    //[view setTintColor:[UIColor lightGrayColor]];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 20)];
    [label setTextColor:[UIColor blackColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont fontWithName: @"Century Gothic" size: 12.0f]];
    
    
    UILabel * totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 2, 100, 20)];
    [totalLabel setTextColor:[UIColor blackColor]];
    [totalLabel setBackgroundColor:[UIColor clearColor]];
    [totalLabel setTextAlignment:NSTextAlignmentRight];
    [totalLabel setFont:[UIFont fontWithName: @"Century Gothic" size:10.0f]];
    
    
        if(self.sortMode == EnvelopeFillerSortedModeName) label.text = @"Sorted by Name";
        else if(self.sortMode == EnvelopeFillerSortedModeAmount) label.text = @"Sorted by Balance";
        else if(self.sortMode == EnvelopeFillerSortedModeDate) label.text = @"Sorted by Last Modified Date";
        else if(self.sortMode == EnvelopeFillerSortedModePayType)
        {
            PayType * payType = [self.envelopePayTypes objectAtIndex:section];
            label.text = payType.name;
            totalLabel.text = [self sectionTotalForPayType:payType.name AtSection:section];
        }
        else
        {
            EnvelopeCategory * envelopCat = [self.envelopeCategories objectAtIndex:section];
            UIColor * color = [MSUIManager colorFrom:envelopCat.backgroundColor];
            const CGFloat* components = CGColorGetComponents([color CGColor]);
            CGFloat red = components[0];
            CGFloat green = components[1];
            CGFloat blue = components[2];
            
            UIView * backview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
            [backview setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:.6]];
            [view addSubview:backview];
            
            
            label.text = envelopCat.name;
            
            
            if (self.displayMode == EnvelopeFillerDisplayTypeNormal) {
                
                totalLabel.text = [self sectionTotalForEnvelopeCategory:envelopCat AtSection:section];
            }
            else if (self.displayMode == EnvelopeFillerDisplayFillMode)
            {
                totalLabel.text = [self.envelopeManager GetFillTotalForSection:section];
            }
            
        }
  
  
    [view addSubview:totalLabel];
    [view addSubview:label];
    
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 1) {
        
        if(self.sortMode == EnvelopeFillerSortedModeNormal)
        {
            return self.envelopeCategories.count;
        }
        else if(self.sortMode == EnvelopeFillerSortedModePayType)
        {
            return [self.payTypeManager.payTypes count];
        }
        else
        {
            return 1;
        }
    }
    else
    {
        return [self.menuContent count];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 1)
    {
        if(self.sortMode == EnvelopeFillerSortedModeNormal)
        {
            NSString * catName = [[self.envelopeCategories objectAtIndex:section] name];
            NSUInteger rows = [[Envelope Filter:self.envelopes WithCategoryName:catName] count];
        
            return rows;
        }
        else if(self.sortMode == EnvelopeFillerSortedModePayType)
        {
            NSString * payType = [[self.payTypeManager.payTypes objectAtIndex:section] name];
            
            NSUInteger rows = [[Envelope Filter:self.envelopes WithPayType:payType] count];
            
            return rows;
        }
        else
        {
            return [self.envelopes count];
        }
    }
    else
    {
        NSString * key = [[self.menuContent allKeys] objectAtIndex:section];
        return [[self.menuContent objectForKey:key] count];
    }
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID;
    if(self.displayMode == EnvelopeFillerDisplayTypeNormal)
    {
        cellID = @"EnvelopeFillerCell";
    }
    else if(self.displayMode == EnvelopeFillerDisplayFillMode)
    {
        cellID = @"EnvelopeFillerCellFillMode";
    }
    else if(self.displayMode == EnvelopeFillerDisplayReorderMode)
    {
        cellID = @"EnvelopeFillerCellReorderMode";
    }
    
    
    EnvelopeFillerCell * cell;
    
    if(self.displayMode == EnvelopeFillerDisplayTypeNormal)
    {
        cell = [self createEnvelopeFillerCell:indexPath];
    }
    else if(self.displayMode == EnvelopeFillerDisplayFillMode)
    {
        cell = [self createEnvelopeFillerCell:indexPath];
        [cell.fillInput reset];
        cell.fillInput.currencyDelegate = self;
        cell.fillInput.section = indexPath.section;
        cell.fillInput.row = indexPath.row;
        cell.fillInput.accessoryBackgroundType = CustomAccessoryViewTypeBlurAndDim;
        cell.fillInput.text = [self.envelopeManager getFillValueForRow:indexPath.row inSection:indexPath.section];
    }
    else if(self.displayMode == EnvelopeFillerDisplayReorderMode)
    {
        cell = [[EnvelopeFillerCell alloc] init];
    }
    
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EnvelopeFillerCell * cell = (EnvelopeFillerCell *)[tableView cellForRowAtIndexPath:indexPath];
    
        if(self.displayMode == EnvelopeFillerDisplayTypeNormal || self.sortMode != EnvelopeFillerSortedModeNormal)
        {
            SpendEnvelopesViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                                             instantiateViewControllerWithIdentifier:@"SpendEnvelopesViewController"];
            viewController.envelopeID = cell.envelopeID;
            [self.navigationController pushViewController:viewController animated:YES];
        }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
        //delete your data here
        //EnvelopeFillerCell * cell = (EnvelopeFillerCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        
        //[self.dataManager.envelopes removeObject:cell.envelope];
        //[self.dataManager updateEnvelopesObjects];
        //[self createSectionTotals:self.dataManager.envelopes];
        //[self loadData];
        //[self.tableView reloadData];
        //[self.tableView reloadInputViews];
    }
}

#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    [self refresh];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text.length == 0) {
        
        
        return YES;
    }
    
    NSMutableCharacterSet *myCharSet = [NSMutableCharacterSet illegalCharacterSet];
    [myCharSet addCharactersInString:@"\\'\""];
    
    for (int i = 0; i < [text length]; i++) {
        unichar c = [text characterAtIndex:i];
        if ([myCharSet characterIsMember:c]) {
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Invalid Input" message:@"Oops! You can't use that character." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [av show];
            return NO;
        }
    }
    
    
    return YES;

}

#pragma SideMenu Delegate
- (void)tableCellPressed:(NSIndexPath *)indexPath
{
    NSString * key = [[self.menuItems allKeys] objectAtIndex:indexPath.section];
    NSString * itemTitle = [[self.menuItems objectForKey:key] objectAtIndex:indexPath.row];;
    NSLog(@"%@", itemTitle);
    
    if([itemTitle isEqualToString:@"Add Envelope"])
    {
        AddModifyEnvelopesViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                                             instantiateViewControllerWithIdentifier:@"AddModifyEnvelopesViewController"];
        NSLog(@"%@", viewController);
        viewController.startingCategoryName = @"Giving";
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if([itemTitle isEqualToString:@"Fill Envelopes"])
    {
        self.displayMode = EnvelopeFillerDisplayFillMode;
        self.sortMode = EnvelopeFillerSortedModeNormal;
        
        self.titleItem.title  = @"Amount Remaining: $0.00";
        
        
        NSString * title = @"Income";
        NSString * message = @"Enter your Income";
        MSAlertView * alert = [[MSAlertView alloc] initWithTitle:title
                                                         message:message
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"OK", nil];
        
        
        
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        UICurrencyTextField * temp = [[UICurrencyTextField alloc]  initWithFrame:CGRectMake(12, 3, 200, 30)];
        temp.detail = @"Income Amount";
        [temp setup];
        //[alert textFieldAtIndex:0] = temp;
        //alert.frame = CGRectMake(12, 3, 200, 300);
        //[alert addSubview:temp];
        
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        
        
        
        alertTextField.keyboardType = temp.keyboardType;
        alertTextField.placeholder = temp.placeholder;
        alertTextField.tag = 999;
        alertTextField.delegate = self;
        
        [alert show];
        
        
        
        
        
        
        [self refresh];
    }
    else if([itemTitle isEqualToString:@"Reorder Envelopes"])
    {
        self.displayMode = EnvelopeFillerDisplayReorderMode;
        [self refresh];
    }
    else if([itemTitle isEqualToString:@"Income"])
    {
        
    }
    else if([itemTitle isEqualToString:@"Expenses"])
    {
        
    }
    else if([itemTitle isEqualToString:@"Show Favorites Only"])
    {
        
    }
    else if([itemTitle isEqualToString:@"Show All"])
    {
        
    }
    else if([itemTitle isEqualToString:@"Share"])
    {
        
    }
    
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
}

#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView.title isEqualToString:@"Income"])
    {
        self.fillBalance = -1;
        NSString * fillBalanceString = [[alertView textFieldAtIndex:0] text];
        fillBalanceString = [fillBalanceString stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        
        
        if(![fillBalanceString isEqualToString:@""])
        {
            self.titleItem.title  = [NSString stringWithFormat:@"Amount Remaining: %@", fillBalanceString];
        }
        
        
        fillBalanceString = [MSUIManager stripDollarSignFromString:fillBalanceString];
        fillBalanceString = [MSUIManager stripCommasFromString:fillBalanceString];
        self.fillBalance = [fillBalanceString doubleValue];
    }
}

#pragma UITextfield Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if ([textField isKindOfClass:[UICurrencyTextField class]]){
        
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * stringValue = [MSUIManager stripDecimalsFromString:textField.text];
    stringValue = [MSUIManager stripDollarSignFromString:stringValue];
    stringValue = [MSUIManager stripCommasFromString:stringValue];
    
    if (string.length == 0) {

        
        
        stringValue = [stringValue substringToIndex:stringValue.length-1];      // set commas and decimals
        textField.text = [NSString stringWithCurrency:stringValue];
    }

    
    NSCharacterSet * myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    // Return if bad character
    for (NSInteger i = 0; i < [string length]; i++) {
        unichar c = [string characterAtIndex:i];
        if (![myCharSet characterIsMember:c]) {
            return NO;
        }
    }
    
    stringValue = [stringValue stringByAppendingString:string];
    // set commas and decimals
    textField.text = [NSString stringWithCurrency:stringValue];
    
    return NO;
}

#pragma fillControllDelegate
- (void)fillerControlCancelPressed
{
    self.displayMode = EnvelopeFillerDisplayTypeNormal;
    [self refresh];
}

- (void)fillerControlFillPressed:(FillerControl *)control
{
    self.displayMode = EnvelopeFillerDisplayTypeNormal;
    
    
    NSString * notes = control.notesLabel.text;
    NSDate * date = control.datePicker.date;

    [self.envelopeManager fillEnvelopes:self.envelopes withNotes:notes onDate:date];    
    [self refresh];
}

#pragma UICurrencyTextField Delegate

- (void)currencyValueChanged:(UICurrencyTextField *)currencyTextField
{
    NSString * stringValue = [MSUIManager stripCommasFromString:currencyTextField.text];
    stringValue = [MSUIManager stripDollarSignFromString:stringValue];
    CGFloat value = [stringValue doubleValue];
    
    [self.envelopeManager UpdateFillDataAtSection:currencyTextField.section AtRow:currencyTextField.row withValue:value];
    
    NSIndexSet * set = [[NSIndexSet alloc] initWithIndex:currencyTextField.section];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
    
    double fillTotal = [self.envelopeManager GetFillTotalDouble];
    double fillRemainingBal = self.fillBalance - fillTotal;
    
    NSString * fillBalanceString = [MSUIManager addCurrencyStyleCommaToDouble:fillRemainingBal];
    self.titleItem.title  = [NSString stringWithFormat:@"Amount Remaining: %@", fillBalanceString];
    //NSLog(@"GetFillTotal: %@", s);
}



/*
#pragma FillEnvelopeCellDelegate
- (void)fillAmountUpdatedAt:(NSIndexPath *)indexPath forAmount:(NSString *)fillAmount
{
    //if([textField isKindOfClass:[UICurrencyTextField class]])
    {
        //UICurrencyTextField * currencyField = (UICurrencyTextField *)textField;
        
        
        NSString * stringValue = [MSUIManager stripCommasFromString:fillAmount];
        stringValue = [MSUIManager stripDollarSignFromString:stringValue];
        CGFloat value = [stringValue doubleValue];
        
        
        [self.envelopeManager UpdateFillDataAtSection:indexPath.section AtRow:indexPath.row withValue:value];
        
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


- (NSDictionary *)resetFillLabel{
    
    __block NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];

    [self.envelopes enumerateObjectsUsingBlock:^(Envelope *envelope, NSUInteger idx, BOOL *stop) {
        
        [dict setObject:@"" forKey:envelope.name];
    }];
    
    return dict;
}


- (NSString *)getFillTotalForEnvelopeCategory:(NSString *)EnvelopeCatName
{
    [self.fillAmounts enumerateKeysAndObjectsUsingBlock:^(id key, NSNumber * value, BOOL *stop) {
        
        NSLog(@"key: %@, id: %@", key, value);
        
    }];
    
    return @"";//[MSUIManager addCurrencyStyleCommaToDouble:[total doubleValue]];
}

- (NSString *)sectionFillTotalForEnvelopeCategory:(EnvelopeCategory *)envelopeCat
{
    __block NSString * catName = envelopeCat.name;
    __block NSNumber * total;
    
    
    [self.envelopes enumerateObjectsUsingBlock:^(Envelope * envelope, NSUInteger idx, BOOL *stop) {
        
        if([envelope.category.name isEqualToString:catName])
        {
            total = @([total doubleValue] + [envelope.balance doubleValue]);
        }
    }];
    
    return [MSUIManager addCurrencyStyleCommaToDouble:[total doubleValue]];
}
 */
@end
