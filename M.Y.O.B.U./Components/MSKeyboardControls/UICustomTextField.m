//
//  UICustomTextField.m
//  The Envelope Filler
//
//  Created by Raymond Kelly on 11/14/13.
//  Copyright (c) 2013 MFX Studios. All rights reserved.
//

#import "UICustomTextField.h"
#import "UICustomKeyboard.h"

@interface UICustomTextField() <UICustomKeyboardDelegate>
@property (nonatomic, strong) UICustomKeyboard * keyboardView;
@property (nonatomic, strong) NSString * stringValue;
@end



@implementation UICustomTextField

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
    self.stringValue = [[NSString alloc] init];
    
    self.keyboardType = UIKeyboardTypeAlphabet;
    self.keyboardAppearance = UIKeyboardAppearanceLight;
    
    self.keyboardView = [[UICustomKeyboard alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    self.keyboardView.delegate = self;
    self.inputAccessoryView = self.keyboardView;
    [self.keyboardView updateAccessoryLabel:self.placeholder];
}


#pragma mark - TextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([self.customDelegate respondsToSelector:@selector(customTextFieldDidEndEditing:)])
    {
        [self.customDelegate customTextFieldDidEndEditing:(UICustomTextField *)textField];
    }
    [self.keyboardView updateAccessoryLabel:self.text];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.keyboardControls setActiveField:textField];
    
    if([self.customDelegate respondsToSelector:@selector(customTextFieldDidBeginEditing:)])
    {
        [self.customDelegate customTextFieldDidBeginEditing:(UICustomTextField *)textField];
    }
    [self.keyboardView updateAccessoryLabel:self.text];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([self.customDelegate respondsToSelector:@selector(customTextFieldShouldBeginEditing:)])
    {
        return [self.customDelegate customTextFieldShouldBeginEditing:(UICustomTextField *)textField];
    }
    [self.keyboardView updateAccessoryLabel:self.text];
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if([self.customDelegate respondsToSelector:@selector(customTextFieldShouldEndEditing:)])
    {
        return [self.customDelegate customTextFieldShouldEndEditing:(UICustomTextField *)textField];
    }
    [self.keyboardView updateAccessoryLabel:self.text];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //If delete was pressed delete and return
    if(string.length == 0  && self.stringValue.length !=0)
    {
        self.stringValue = [self.stringValue substringToIndex:(self.stringValue.length-1)];
        self.text = self.stringValue;
        [self.keyboardView updateAccessoryLabel:self.text];
    }
    
    self.stringValue = [self.stringValue stringByAppendingString:string];
    self.text = self.stringValue;
    [self.keyboardView updateAccessoryLabel:self.text];
    return NO;
}
@end
