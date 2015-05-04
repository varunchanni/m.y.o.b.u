//
//  UICustomTextField.h
//  The Envelope Filler
//
//  Created by Raymond Kelly on 11/14/13.
//  Copyright (c) 2013 MFX Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSKeyboardControls.h"

@protocol UICustomTextFieldDelegate;


enum CustomAccessoryBackgroundType {
    CustomAccessoryViewTypeNone,
    CustomAccessoryViewTypeBlurAndDim
};

@interface UICustomTextField : UITextField <UITextFieldDelegate>
@property (nonatomic, strong) MSKeyboardControls * keyboardControls;
@property (nonatomic, weak) id <UICustomTextFieldDelegate> customDelegate;
@property (nonatomic, assign) enum CustomAccessoryBackgroundType accessoryBackgroundType;
@end


@protocol UICustomTextFieldDelegate <NSObject>
@optional
- (BOOL)customTextFieldShouldBeginEditing:(UICustomTextField *)textField;
- (BOOL)customTextFieldShouldEndEditing:(UICustomTextField *)textField;
- (void)customTextFieldDidEndEditing:(UICustomTextField *)textField;
- (void)customTextFieldDidBeginEditing:(UICustomTextField *)textField;
@end

