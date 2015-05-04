//
//  WithdrawerViewController.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 12/29/13.
//  Copyright (c) 2013 MYOB University. All rights reserved.
//

#import "WithdrawerViewController.h"
#import "WithdrawerTableViewCell.h"
#import "WithdrawerTotalCell.h"
#import "Currency.h"
#import "UINumberTextField.h"
#import "HomeViewController.h"
#import "TransitionAnimator.h"

//#define kTableHeaderHeight 36
#define iPhone5CellHeight = 40;

@interface WithdrawerViewController () <UIViewControllerTransitioningDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *webAddressLabel;
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic)IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UIImageView *ribbon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel3;
@property (weak, nonatomic) IBOutlet UIView *tapView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *withdrawerIcon;
@property (weak, nonatomic) IBOutlet UIImageView *myobLogo;
@property (strong, nonatomic) NSMutableArray *currencyObjects;
@property (strong, nonatomic) NSMutableArray *fields;
@property (strong, nonatomic) NSDate * date;
@property (assign, nonatomic) BOOL isEditMode;
@end

@implementation WithdrawerViewController


- (NSMutableArray *)currencyObjects
{
    return self.dataManager.currencyObjects;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib
{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isEditMode = false;
    self.bannerView.hidden = YES;
    //[self toggleAnimatingView:YES];
	// Do any additional setup after loading the view.
    self.Form_Y_Origin = -110;
    self.fields = [[NSMutableArray alloc] init];
    
    self.date = [[NSDate alloc] init];
    self.dateLabel.text = [MSUIManager getLongDateString:self.date];
    self.timeLabel.text = [MSUIManager getTimeString:self.date];

    self.totalTitleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:16];
    self.totalLabel.font = [UIFont fontWithName:@"Lato-Bold" size:16];
    
    self.dateLabel.font = [UIFont fontWithName:@"Lato-Bold" size:10];
    self.timeLabel.font = [UIFont fontWithName:@"Lato-Bold" size:10];
    
    self.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:20];
    self.editButton.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:12];
    self.clearButton.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:12];
    self.undoButton.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:12];
    
    self.titleLabel1.font = [UIFont fontWithName:@"Lato-Bold" size:14];
    self.titleLabel2.font = [UIFont fontWithName:@"Lato-Bold" size:14];
    self.titleLabel3.font = [UIFont fontWithName:@"Lato-Bold" size:14];

    self.webAddressLabel.font = [UIFont fontWithName:@"Lato-Bold" size:12];
    
    
    if([MSUIManager isIPhone5])
    {
        self.Form_Y_Origin = -80;
        CGRect frame = self.undoButton.frame;
        frame.origin.y -= 20;
        self.undoButton.frame = frame;
        
        frame = self.shareButton.frame;
        frame.origin.y -= 20;
        self.shareButton.frame = frame;
        
        frame = self.infoButton.frame;
        frame.origin.y -= 20;
        self.infoButton.frame = frame;
        
        frame = self.editButton.frame;
        frame.origin.y -= 20;
        self.editButton.frame = frame;
        
        [self.tableView setRowHeight:48];
        
        frame = self.mainView.frame;
        frame.size.height += 75;
        self.mainView.frame = frame;
    }
    
    UIColor *green = [UIColor colorWithRed:(152/255.0) green:(255/255.0) blue:(181/255.0) alpha:1.0];
    CAGradientLayer *bgLayer = [self.uiManager whiteToColorGradient:green];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    UIImage *myGradient = [UIImage imageNamed:@"textGradient.png"];
    self.titleLabel.textColor  = [UIColor colorWithPatternImage:myGradient];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma UITableView DataSource
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WithdrawerTableViewCell * withdrawerTableViewCell = (WithdrawerTableViewCell *)cell;
    [self.fields addObject:withdrawerTableViewCell.quanityTextfield];
    
    if([indexPath row] == self.currencyObjects.count -1){
        //end of loading
        
        [self updateTotals];
        [self setKeyboardControls:[[MSKeyboardControls alloc] initWithFields:self.fields]];
        [self.keyboardControls setDelegate:self];
        [self.keyboardControls setToolbarVisibility:YES];
        [self enableAllFields];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currencyObjects.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
        static NSString *cellID = @"WithdrawerTableViewCell";
        
        WithdrawerTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        Currency * currency = [self.currencyObjects objectAtIndex:indexPath.row];
    
    currency.indexPath = indexPath;
        cell.backgroundColor = [UIColor clearColor];
        cell.currencyLabel.text = currency.name;
        [self updateCellCurrencyFields:cell withCurrency:currency];
    
        cell.quanityTextfield.tag = indexPath.row;
        cell.quanityTextfield.maxDigits = 5;
        cell.quanityTextfield.delegate = self;
        cell.highlightView.frame = CGRectMake(0, 0, 320, self.tableView.rowHeight) ;
    
        [cell playClickedAnimation:currency.highlightColor];

        return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WithdrawerTableViewCell *cell = (WithdrawerTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    
    if(self.currencyObjects.count  > indexPath.row)
    {
        Currency * currency = [self.currencyObjects objectAtIndex:indexPath.row];
        
        if(!self.isEditMode)
        {
            //increment value
            [currency incrementCounter];
        }
        else
        {
            //reverse value
            [currency reverseCounter];
        }
        
        //update cell
        [self updateCellCurrencyFields:cell withCurrency:currency];
    }
}

- (void)updateCellCurrencyFields:(WithdrawerTableViewCell *)cell withCurrency:(Currency *)currency
{
    cell.quanityTextfield.text =  [MSUIManager addCurrencyStyleCommaToDouble:[currency.counter doubleValue]];

    
    cell.currencyTotalLabel.text = [MSUIManager addDecimalsToString:
                                      [NSString stringWithFormat:@"%.2f",[currency.total doubleValue]]
                                      isCurrency:YES
                                    ];
    
    [self updateTotals];
    
    //play animation
    [cell playClickedAnimation:currency.highlightColor];
}

- (void)updateTotals
{
    __block CGFloat totalValue = 0;
    
    [self.currencyObjects enumerateObjectsUsingBlock:^(Currency *currency, NSUInteger idx, BOOL *stop) {
        
        NSNumber * total = currency.total;
        totalValue += [total doubleValue];
    }];
    self.totalLabel.text = [MSUIManager addDecimalsToString:[NSString stringWithFormat:@"%.2f",totalValue] isCurrency:YES];
}

#pragma mark - Shake Functions
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake )
    {
        if([self.dataManager hasUndoActions:kFEATURE_WITHDRAWER_KEY])
        {
            // shaking has ended
            UIAlertView * undoAlert = [[UIAlertView alloc] initWithTitle:@"Undo"
                                                                 message:@"Are you sure you want to undo the last action?"
                                                                delegate:self
                                                       cancelButtonTitle:@"Canel"
                                                       otherButtonTitles:@"OK", nil];
            
            [undoAlert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView.title isEqualToString:@"Undo"] == YES)
    {
        if(buttonIndex == 1)
        {
            //undo action
            [self undoPressed:self];
        }
    }
}



#pragma IBActions
- (IBAction)backPressed:(id)sender {
    
    [self.uiManager popFadeViewController:self.navigationController];
}

- (IBAction)editPressed:(id)sender {
    
    self.isEditMode = !self.isEditMode;
    
    [[[self.view.layer sublayers] objectAtIndex:0] removeFromSuperlayer];
    
    
    if(self.isEditMode)
    {
        CAGradientLayer *bgLayer = [self.uiManager whiteToColorGradient:[UIColor redColor]];
        bgLayer.frame = self.view.bounds;
        [self.view.layer insertSublayer:bgLayer atIndex:0];
    }
    else
    {
        UIColor *green = [UIColor colorWithRed:(152/255.0) green:(255/255.0) blue:(181/255.0) alpha:1.0];
        CAGradientLayer *bgLayer = [self.uiManager whiteToColorGradient:green];
        bgLayer.frame = self.view.bounds;
        [self.view.layer insertSublayer:bgLayer atIndex:0];
    }
}

- (IBAction)clearPressed:(id)sender {
    
    //create and save current values as an undo action
    NSMutableArray * currencyObjectsClone = [[NSMutableArray alloc] init];
    [self.currencyObjects enumerateObjectsUsingBlock:^(Currency * currency, NSUInteger idx, BOOL *stop) {
        
        [currencyObjectsClone addObject:[[Currency alloc] cloneWithCurrency:currency]];
    }];
    
    [self.dataManager addCurrencyUndoAction:currencyObjectsClone];
    
    [self.currencyObjects enumerateObjectsUsingBlock:^(Currency * currency, NSUInteger idx, BOOL *stop) {
        
        currency.counter = [NSNumber numberWithInt:0];
    }];
    
    //save value
    [self.dataManager updateCurrencyObjects];
    [self.tableView reloadData];
}
- (IBAction)undoPressed:(id)sender {
    
    if([self.dataManager hasUndoActions:kFEATURE_WITHDRAWER_KEY])
    {
        //undo actions
        id undoAction = [self.dataManager removeAndGetLastestCurrencyUndoAction];
        
        
        if([undoAction isKindOfClass:[Currency class]])
        {
            
            Currency * currency = undoAction;
            WithdrawerTableViewCell *cell = (WithdrawerTableViewCell *)[self.tableView cellForRowAtIndexPath:currency.indexPath];
            
            //replace data object
            [self.currencyObjects replaceObjectAtIndex:currency.indexPath.row withObject:currency];
            
            //refresh view
            [self updateCellCurrencyFields:cell withCurrency:currency];
        }
        else if ([undoAction isKindOfClass:[NSArray class]])
        {
            
            [undoAction enumerateObjectsUsingBlock:^(Currency * currency, NSUInteger idx, BOOL *stop) {
                
                WithdrawerTableViewCell *cell = (WithdrawerTableViewCell *)[self.tableView cellForRowAtIndexPath:currency.indexPath];
                
                //replace data object
                [self.currencyObjects replaceObjectAtIndex:currency.indexPath.row withObject:currency];
                
                //refresh view
                [self updateCellCurrencyFields:cell withCurrency:currency];
                
            }];
            
        }
        
        [self.dataManager updateCurrencyObjects];
    }
}


- (IBAction)sharePressed:(id)sender {
    
    [self toggleShareReadyView:YES];
    UIActivityViewController * shareView = [self.uiManager SharePressed:self.view];
    [self toggleShareReadyView:NO];
    

    self.view.userInteractionEnabled = NO;
    [self.navigationController presentViewController:shareView animated:YES completion:^{
        self.view.userInteractionEnabled = YES;
    }];

}
- (IBAction)infoPressed:(id)sender {
}

#pragma TextfieldDelegates
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL shouldChangeCharactersInRange = NO;
    if([textField isKindOfClass:[UINumberTextField class]])
    {
        shouldChangeCharactersInRange = [(UINumberTextField *)textField base_textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }

    return shouldChangeCharactersInRange;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self base_textFieldDidBeginEditing:textField];
    
    if([textField isKindOfClass:[UINumberTextField class]])
    {
        textField.text = @"";
        [(UINumberTextField *)textField reset];
        [self disableAllFieldsExcept:textField];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [self base_textFieldDidEndEditing:textField];
    
    if([textField isKindOfClass:[UINumberTextField class]] && ![textField.text isEqualToString:@""])
    {
        NSInteger index = textField.tag;
        Currency * currency = [self.currencyObjects objectAtIndex:index];
        NSString * text = [MSUIManager stripCommasFromString:textField.text];
        NSNumber * counter = [NSNumber numberWithInt:[text intValue]];
        [currency updateCounter:counter];
    }
    
    //refresh view
    [self.tableView reloadData];
}

#pragma modifications
- (void)disableAllFieldsExcept:(UITextField *)field
{
    [self.fields enumerateObjectsUsingBlock:^(UITextField * fieldInFields, NSUInteger idx, BOOL *stop) {
        
        if(field != fieldInFields) fieldInFields.userInteractionEnabled = NO;
    }];
}

- (void)enableAllFields
{
    [self.fields enumerateObjectsUsingBlock:^(UITextField * fieldInFields, NSUInteger idx, BOOL *stop) {
        
        fieldInFields.userInteractionEnabled = YES;
    }];
}

- (void)toggleShareReadyView:(BOOL)isHidden
{
    self.undoButton.hidden = isHidden;
    self.clearButton.hidden = isHidden;
    self.backButton.hidden = isHidden;
    self.shareButton.hidden = isHidden;
    self.infoButton.hidden = isHidden;
    self.bannerView.hidden = !isHidden;
    self.withdrawerIcon.hidden = isHidden;
    self.myobLogo.hidden = !isHidden;
    self.editButton.hidden = isHidden;
    
    if([MSUIManager isIPhone5])
    {
        CGRect frame = self.mainView.frame;
        NSInteger offset = 10;
        if(isHidden)
        {
            frame.origin.y += offset;
        }
        else
        {
            frame.origin.y -= offset;
        }
        
        self.mainView.frame = frame;
    }
}

- (void)toggleAnimatingView:(BOOL)isHidden
{
    self.undoButton.hidden = isHidden;
    self.clearButton.hidden = isHidden;
    self.backButton.hidden = isHidden;
    self.shareButton.hidden = isHidden;
    self.infoButton.hidden = isHidden;
    self.tableView.hidden = isHidden;
    self.dateLabel.hidden = isHidden;
    self.timeLabel.hidden = isHidden;
    self.titleLabel.hidden = isHidden;
    self.titleLabel1.hidden = isHidden;
    self.titleLabel2.hidden = isHidden;
    self.titleLabel3.hidden = isHidden;
    
}

#pragma View Controller Transition Delegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    
    //use this if statement for handing different types of animations on same controller
    //if([[presented class] isSubclassOfClass:[MSMenuViewController class]])
    
    TransitionAnimator *animator = [TransitionAnimator new];
    animator.presenting = YES;
    animator.delegate = self.uiManager;
    return animator;
    
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    //use this if statement for handing different types of animations on same controller
    //if([[presented class] isSubclassOfClass:[MSMenuViewController class]])
    
    
    TransitionAnimator *animator = [TransitionAnimator new];
    animator.presenting = NO;
    animator.delegate = self.uiManager;
    return animator;
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
