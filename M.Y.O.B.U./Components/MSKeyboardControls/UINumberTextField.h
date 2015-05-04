//
//  UINumberTextField.h
//  Example
//
//  Created by Raymond Kelly on 11/3/13.
//
//

#import <UIKit/UIKit.h>
#import "MSKeyboardControls.h"
#import "UICustomKeyboard.h"
#import "UICustomTextField.h"

//@protocol UINumberTextFieldDelegate;

@interface UINumberTextField : UICustomTextField <UITextFieldDelegate>
@property (nonatomic, assign) NSInteger maxDigits;
@property (nonatomic, strong) MSKeyboardControls * keyboardControls;
//@property (nonatomic, weak) id <UINumberTextFieldDelegate> customDelegate;

- (void)reset;
- (BOOL)base_textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
@end


/*
@protocol UINumberTextFieldDelegate <NSObject>
@optional
- (BOOL)numberTextFieldShouldBeginEditing:(UINumberTextField *)textField;
- (BOOL)numberTextFieldShouldEndEditing:(UINumberTextField *)textField;
- (void)numberTextFieldDidEndEditing:(UINumberTextField *)textField;
- (void)numberTextFieldDidBeginEditing:(UINumberTextField *)textField;
@end*/