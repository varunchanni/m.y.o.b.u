//
//  UICurrencyTextField.m
//  Example
//
//  Created by Raymond Kelly on 11/3/13.
//
//

#import "UICurrencyTextField.h"
#import "NSString+Extension.h"
#import "MSUIManager.h"
#import "UIView+Screenshot.h"
#import "MSDataManager.h"
#import "MYOBViewController.h"

static NSString * kCurrencyPlaceholder = @"$0.00";
static NSInteger const kCurrenyMaxDigits = 14;

@interface UICurrencyTextField()<UITextFieldDelegate>
@property (nonatomic, strong) NSNumber * oldNumberValue;
@property (nonatomic, strong) NSString * oldStringValue;
@property (nonatomic, strong) NSNumber * numberValue;
@property (nonatomic, strong) NSString * stringValue;
@property (strong, nonatomic) UILabel * detailLabel;
@property (strong, nonatomic) UILabel * currencyLabel;
@property (strong, nonatomic) MSDataManager * dataManager;
@end

@implementation UICurrencyTextField

- (MSDataManager *)dataManager {
    return [MSDataManager sharedManager];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.numberValue = [[NSNumber alloc] init];
    self.stringValue = [[NSString alloc] init];
    self.detail = [[NSString alloc] init];
    self.delegate = self;
}


-(void)setup
{
    self.placeholder = kCurrencyPlaceholder;
    self.keyboardAppearance = UIKeyboardAppearanceLight;
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.inputAccessoryView = [self GetEnvelopeInputAccessoryView];
}


- (void)reset
{
    self.numberValue = 0;
    self.stringValue = @"";
    self.text = @"";
    self.detail = @"";
    self.detailLabel.text = @"";
    self.currencyLabel.text = @"";
}

- (UIView *)GetEnvelopeInputAccessoryView
{
    if(self.envelope != nil)
    {
        UIView * mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 110)];
        [mainView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
    
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        [headerView setBackgroundColor:[MSUIManager colorFrom:self.envelope.category.backgroundColor]];
        
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 300, 20)];
        [label setTextColor:[UIColor blackColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont fontWithName: @"Century Gothic" size: 12.0f]];
        label.text = self.envelope.category.name;
        
        
        UILabel * totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 6, 100, 20)];
        [totalLabel setTextColor:[UIColor blackColor]];
        [totalLabel setBackgroundColor:[UIColor clearColor]];
        [totalLabel setTextAlignment:NSTextAlignmentRight];
        [totalLabel setFont:[UIFont fontWithName: @"Century Gothic" size:10.0f]];
   
        totalLabel.text = self.detail;
        
        [headerView addSubview:label];
        [headerView addSubview:totalLabel];
        
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 34, 320, 19)];
        self.detailLabel.textAlignment = NSTextAlignmentLeft;
        [self.detailLabel  setFont:[UIFont fontWithName: @"Century Gothic" size:13.0f]];
        [self.detailLabel setTintColor:[MSUIManager colorFrom:@"363636"]];
        self.detailLabel.text = self.envelope.name;
        [mainView addSubview:self.detailLabel];
        
        self.currencyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 305, 24)];
        self.currencyLabel.textAlignment = NSTextAlignmentLeft;
        [self.currencyLabel setFont:[UIFont fontWithName: @"Century Gothic" size:14.0f]];
        self.currencyLabel.textAlignment = NSTextAlignmentRight;
        [self.currencyLabel setTintColor:[MSUIManager colorFrom:@"363636"]];
        self.currencyLabel.text = @"$0.00";
        [mainView addSubview:self.currencyLabel];
        
        UILabel * catTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 56, 320, 19)];
        catTotalLabel.textAlignment = NSTextAlignmentLeft;
        [catTotalLabel  setFont:[UIFont fontWithName: @"Century Gothic" size:14.0f]];
        [catTotalLabel setTextColor:[MSUIManager colorFrom:@"005493"]];
        catTotalLabel.text = [MSUIManager addCurrencyStyleCommaToDouble:[self.envelope.balance doubleValue]];;
        [mainView addSubview:catTotalLabel];
        
        
        UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 320, 30)];
        [bottomView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.4]];
        
        UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelButton.frame = CGRectMake(0, 5, 150, 21);
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton setTintColor:[MSUIManager colorFrom:@"FF0000"]];
        [cancelButton.titleLabel setFont:[UIFont fontWithName: @"Avenir Next" size:13.0f]];
        [cancelButton addTarget:self action:@selector(cancelPressed) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:cancelButton];
        
        UIButton * doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        doneButton.frame = CGRectMake(160, 5, 150, 21);
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton setTintColor:[MSUIManager colorFrom:@"005493"]];
        [doneButton.titleLabel setFont:[UIFont fontWithName: @"Avenir Next" size:13.0f]];
        [doneButton addTarget:self action:@selector(donePressed) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:doneButton];
        
        [mainView addSubview:bottomView];
        [mainView addSubview:headerView];
        
        return mainView;
    }
    else {
        
        
        UIView * mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        [mainView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
        
        UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        [bottomView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.4]];
        
        UIButton * doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        doneButton.frame = CGRectMake(240, 5, 70, 21);
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton setTintColor:[MSUIManager colorFrom:@"005493"]];
        [doneButton.titleLabel setFont:[UIFont fontWithName: @"Avenir Next" size:13.0f]];
        [doneButton addTarget:self action:@selector(donePressed) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:doneButton];
        
        [mainView addSubview:bottomView];
        
        return mainView;
    }
    
    return nil;
}

- (UIFont *)boldFontWithFont:(UIFont *)font
{
    UIFontDescriptor * fontD = [font.fontDescriptor
                                fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    return [UIFont fontWithDescriptor:fontD size:0];
}

- (BOOL)currency_textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //If delete was pressed delete and return
    if(string.length == 0  && self.stringValue.length !=0)
    {
        self.stringValue = [self.stringValue substringToIndex:(self.stringValue.length-1)];
        self.numberValue = [NSNumber numberWithInteger:[self.stringValue integerValue]];
        
        // set commas and decimals
        self.text = [NSString stringWithCurrency:self.stringValue];
    }
    
    //is place character limit
    if(self.maxDigits == 0)
    {
        self.maxDigits = kCurrenyMaxDigits;
    }
    
    if(self.text.length > self.maxDigits )
    {
        return NO;
    }
    
    
    
    NSCharacterSet * myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    // Return if bad character
    for (NSInteger i = 0; i < [string length]; i++) {
        unichar c = [string characterAtIndex:i];
        if (![myCharSet characterIsMember:c]) {
            return NO;
        }
    }
    
    self.stringValue = [self.stringValue stringByAppendingString:string];
    self.numberValue = [NSNumber numberWithInteger:[self.stringValue integerValue]];
    
    // set commas and decimals
    self.text = [NSString stringWithCurrency:self.stringValue];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!self.hideBlur) {
        
        MYOBViewController * myobVC = (MYOBViewController *)self.parentViewController;
        NSLog(@"%@", myobVC);
        NSLog(@"%@", myobVC.dimOverlay);
        myobVC.dimOverlay.alpha = 1;
    }
    self.oldStringValue = self.stringValue;
    self.oldNumberValue = self.numberValue;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    MYOBViewController * myobVC = (MYOBViewController *)self.parentViewController;
    myobVC.dimOverlay.alpha = 0;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * stringValue = [MSUIManager stripDecimalsFromString:textField.text];
    stringValue = [MSUIManager stripDollarSignFromString:stringValue];
    stringValue = [MSUIManager stripCommasFromString:stringValue];
    
    self.stringValue =  stringValue;
    //If delete was pressed delete and return
    if(string.length == 0  && self.stringValue.length !=0)
    {
        self.stringValue = [self.stringValue substringToIndex:(self.stringValue.length-1)];
        self.numberValue = [NSNumber numberWithInteger:[self.stringValue integerValue]];
        
        // set commas and decimals
        self.text = [NSString stringWithCurrency:self.stringValue];
    }
    
    //is place character limit
    if(self.maxDigits == 0)
    {
        self.maxDigits = kCurrenyMaxDigits;
    }
    
    if(self.text.length > self.maxDigits )
    {
        return NO;
    }
    
    
    
    NSCharacterSet * myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    // Return if bad character
    for (NSInteger i = 0; i < [string length]; i++) {
        unichar c = [string characterAtIndex:i];
        if (![myCharSet characterIsMember:c]) {
            return NO;
        }
    }
    
    self.stringValue = [self.stringValue stringByAppendingString:string];
    self.numberValue = [NSNumber numberWithInteger:[self.stringValue integerValue]];
    
    // set commas and decimals
    self.currencyLabel.text = textField.text = [NSString stringWithCurrency:self.stringValue];
    
    return NO;
}



#pragma selectors

- (void)cancelPressed
{
    self.stringValue = self.oldStringValue;
    self.numberValue = self.oldNumberValue;
    
    if(self.stringValue.length !=0)
    {
        self.text = [NSString stringWithCurrency:self.stringValue];
    }
    else
    {
        self.text = self.placeholder;
    }
    
    self.currencyLabel.text = self.text;
    [self resignFirstResponder];
}

- (void)donePressed
{
    if([self.currencyDelegate respondsToSelector:@selector(currencyValueChanged:)])
    {
        [self.currencyDelegate currencyValueChanged:self];
    }
    
    [self resignFirstResponder];
}



@end
