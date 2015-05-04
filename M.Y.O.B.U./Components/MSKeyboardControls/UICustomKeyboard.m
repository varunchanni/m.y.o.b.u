//
//  UICustomKeyboard.m
//  The Envelope Filler
//
//  Created by Raymond Kelly on 11/12/13.
//  Copyright (c) 2013 MFX Studios. All rights reserved.
//

#import "UICustomKeyboard.h"

@interface UICustomKeyboard()
@property (nonatomic, strong) UILabel * preview;
@end

@implementation UICustomKeyboard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createInputAccessoryView];
    }
    return self;
}

- (void)createInputAccessoryView
{
    self.backgroundColor = [UIColor colorWithWhite:.97 alpha:.9];
    
    UIView * labelFrame = [[UIView alloc]initWithFrame:CGRectMake(5, self.frame.size.height - 45, 250, 40)];
    labelFrame.backgroundColor = [UIColor whiteColor];
    labelFrame.layer.cornerRadius = 5;
    labelFrame.layer.masksToBounds = YES;
    
    self.preview = [[UILabel alloc] initWithFrame:CGRectMake(15, self.frame.size.height - 45, 250, 40)];
    
    labelFrame.contentMode = UITextBorderStyleRoundedRect;
    self.preview.font = [UIFont systemFontOfSize:15];
    
    self.preview.text = @"label is here";
    
    UIButton * doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    
    doneButton.frame = CGRectMake(260, self.frame.size.height - 45, 50, 40);
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:labelFrame];
    [self addSubview:self.preview];
    [self addSubview:doneButton];
}

- (void)updateAccessoryLabel:(NSString *)text
{
    self.preview.text = text;
}

- (void)doneAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(customKeyboardDonePressed)])
    {
        [self.delegate customKeyboardDonePressed];
    }
}

@end
