//
//  MYOBViewController.h
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 12/8/13.
//  Copyright (c) 2013 MYOB University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSDataManager.h"
#import "MSUIManager.h"
#import "MSServiceManager.h"
#import "MSKeyboardControls.h"

@protocol MYOBViewControllerDelegate <NSObject>

@optional
- (void)movePanelLeft;
- (void)movePanelRight;

@required
- (void)movePanelToOriginalPosition;

@end

@interface MYOBViewController : UIViewController <MSKeyboardControlsDelegate, UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, assign) id<MYOBViewControllerDelegate> delegate;
@property (nonatomic, strong) MSDataManager *dataManager;
@property (nonatomic, strong) MSUIManager *uiManager;
@property (nonatomic, strong) MSServiceManager *serviceManager;
@property (strong, nonatomic) MSKeyboardControls * keyboardControls;
@property (nonatomic, assign) NSInteger Form_Y_Origin;
@property (nonatomic, strong) UITapGestureRecognizer *keyboardControlsSingleTap;
@property (nonatomic, assign) BOOL shouldAnimateScreen;
@property (nonatomic, strong) LFGlassView * dimOverlay;

- (void)base_textFieldDidBeginEditing:(UITextField *)textField;
- (void)base_textFieldDidEndEditing:(UITextField *)textField;
- (BOOL)base_textFieldShouldReturn:(UITextField *)textField;
- (void)base_textViewDidBeginEditing:(UITextView *)textView;
- (void)base_textViewDidEndEditing:(UITextView *)textView;
- (void)base_textViewDidChange:(UITextView *)textView;
#pragma mark Keyboard Controls Base Delegate
- (void)base_keyboardControlsDonePressed:(MSKeyboardControls *)keyboardControls;
- (void)base_keyboardControlsCancelPressed:(MSKeyboardControls *)keyboardControls;
- (void)base_keyboardControlsSavePressed:(MSKeyboardControls *)keyboardControls;
- (void)fadeInObject:(UIView *)view WithInterval:(NSTimeInterval)interval toAlpha:(NSNumber *)alpha
           completed:(void (^)(BOOL finshed))done;
- (void)hideKeyboard;
@end
