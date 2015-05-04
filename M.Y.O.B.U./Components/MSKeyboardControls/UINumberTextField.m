//
//  UINumberTextField.m
//  Example
//
//  Created by Raymond Kelly on 11/3/13.
//
//

#import "UINumberTextField.h"
#import "NSString+Extension.h"

static NSString * kNumberPlaceholder = @"0";
static NSInteger const kNumberMaxDigits = 10;

@interface UINumberTextField() <UICustomKeyboardDelegate>
@property (nonatomic, strong) NSNumber * numberValue;
@property (nonatomic, strong) NSString * stringValue;
@property (nonatomic, strong) UICustomKeyboard * keyboardView;
@end

@implementation UINumberTextField

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
    self.delegate = self;

    self.placeholder = kNumberPlaceholder;
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.keyboardAppearance = UIKeyboardAppearanceLight;
    
    self.keyboardView = [[UICustomKeyboard alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    self.keyboardView.delegate = self;
    self.inputAccessoryView = self.keyboardView;
    [self.keyboardView updateAccessoryLabel:self.placeholder];
    
    self.numberValue = [[NSNumber alloc] init];
    self.stringValue = [[NSString alloc] init];
}

- (void)customKeyboardDonePressed
{
    [self resignFirstResponder];
}

- (void)reset
{
    self.stringValue = self.text;
    self.numberValue = [NSNumber numberWithInteger:[self.stringValue integerValue]];
}


#pragma mark - TextField Delegate
/*
- (void)textFieldDidEndEditing:(UITextField *)textField
{

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{

    
    return YES;
}
*/

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [self base_textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (BOOL)base_textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //If delete was pressed delete and return
    if(string.length == 0  && self.stringValue.length !=0)
    {
        self.stringValue = [self.stringValue substringToIndex:(self.stringValue.length-1)];
        self.numberValue = [NSNumber numberWithInteger:[self.stringValue integerValue]];
        
        // set commas and decimals
        self.text = [NSString stringWithCurrencyCommas:self.stringValue];
        [self.keyboardView updateAccessoryLabel:self.text];
    }
    
    //is place character limit
    if(self.maxDigits == 0)
    {
        self.maxDigits = kNumberMaxDigits;
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
    self.text = [NSString stringWithCurrencyCommas:self.stringValue];
    [self.keyboardView updateAccessoryLabel:self.text];
    return NO;
}
@end
