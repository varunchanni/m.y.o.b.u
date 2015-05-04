//
//  MYOBUTextView.h
//  M.Y.O.B.U.
//
//  Created by Raymond on 11/30/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYOBUTextView : UITextView <UITextViewDelegate>
@property (nonatomic, assign) enum CustomAccessoryBackgroundType accessoryBackgroundType;
@property (nonatomic, strong) UILabel * displayLabel;
@property (nonatomic, assign) BOOL showBlur;
@property (nonatomic, strong) NSString * previousValue;

- (void)initialize;
- (void)reset;
@end
