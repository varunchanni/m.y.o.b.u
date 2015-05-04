//
//  UICurrencyTextField.h
//  Example
//
//  Created by Raymond Kelly on 11/3/13.
//
//

#import <UIKit/UIKit.h>
#import "MSKeyboardControls.h"
#import "UICustomTextField.h"
#import "Envelope.h"

@class UICurrencyTextField;
@protocol UICurrencyTextFieldDelegate;

@interface UICurrencyTextField : UICustomTextField 
@property (nonatomic, assign) NSInteger maxDigits;
@property (nonatomic, strong) MSKeyboardControls * keyboardControls;
@property (assign, nonatomic) NSInteger section;
@property (assign, nonatomic) NSInteger row;
@property (strong, nonatomic) NSString * detail;
@property (strong, nonatomic) Envelope * envelope;
@property (nonatomic, weak) id <UICurrencyTextFieldDelegate, UITextFieldDelegate> currencyDelegate;
@property (assign, nonatomic) BOOL hideBlur;

-(void)setup;
- (void)reset;
- (BOOL)currency_textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
//- (BOOL)noncurrency_textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
@end


@protocol UICurrencyTextFieldDelegate
@optional
- (void)currencyValueChanged:(UICurrencyTextField *)currencyTextField;
- (void)textFieldDidEndEditing:(UICurrencyTextField *)textField;
- (void)textFieldDidBeginEditing:(UICurrencyTextField *)textField;
/*
 - (BOOL)textFieldShouldBeginEditing:(UICurrencyTextField *)textField;
 - (BOOL)textFieldShouldEndEditing:(UICurrencyTextField *)textField;
*/
@end

