//
//  UIDateSelect.m
//  The Envelope Filler
//
//  Created by Raymond Kelly on 11/8/13.
//  Copyright (c) 2013 MFX Studios. All rights reserved.
//

#import "UIDateSelect.h"
#import "MSUIManager.h"

@interface UIDateSelect() 
@property (nonatomic, strong) UIDatePicker * picker;
@property (nonatomic, strong) NSDateFormatter *dateFormat;
@end

@implementation UIDateSelect

- (id) init
{
    self = [super init];
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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    if (self.date != nil) {
    
        self.picker = [[UIDatePicker alloc] init];
        self.inputView = self.picker;
        self.dateFormat = [[NSDateFormatter alloc] init];
        [self.dateFormat setDateFormat:@"MM/dd/yy"];
    
        [self.picker addTarget:self action:@selector(dateChanged:)
              forControlEvents:UIControlEventValueChanged];
    
        self.text = [self.dateFormat stringFromDate:self.date];
        [self.picker setDate:self.date];
        self.inputAccessoryView = [self GetAccessoryView];
    }    
}


- (void)setDate:(NSDate *)newDate {
    
     _date = newDate;
     self.text = [self.dateFormat stringFromDate:self.date];
}

- (UIView *)GetAccessoryView{
    
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

- (void)donePressed
{
    [self resignFirstResponder];
}

- (void) dateChanged:(id)sender{
    
    self.date = self.picker.date;
    self.text = [self.dateFormat stringFromDate:self.date];
}

@end
