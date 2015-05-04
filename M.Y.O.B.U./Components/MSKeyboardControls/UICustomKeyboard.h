//
//  UICustomKeyboard.h
//  The Envelope Filler
//
//  Created by Raymond Kelly on 11/12/13.
//  Copyright (c) 2013 MFX Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UICustomKeyboardDelegate;

@interface UICustomKeyboard : UIView
@property (nonatomic, weak) id<UICustomKeyboardDelegate> delegate;
- (void)updateAccessoryLabel:(NSString *)text;
@end


@protocol UICustomKeyboardDelegate <NSObject>
@optional
- (void)customKeyboardDonePressed;
@end