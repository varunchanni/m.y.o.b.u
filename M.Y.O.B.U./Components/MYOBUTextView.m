//
//  MYOBUTextView.m
//  M.Y.O.B.U.
//
//  Created by Raymond on 11/30/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "MYOBUTextView.h"
#import "MSDataManager.h"
#import "MSUIManager.h"
#import "UIView+Screenshot.h"


@interface MYOBUTextView()
@property (nonatomic, strong) NSString * placeholder;
@property (nonatomic, strong) UITextView * cloneTextView;
@property (nonatomic, strong) MSDataManager * dataManager;
@property (nonatomic, assign) BOOL finished;
@property (nonatomic, strong) UITextView * fakeTextView;
@end

@implementation MYOBUTextView 

- (MSDataManager *)dataManager
{
    return [MSDataManager sharedManager];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)initialize {
    
    self.delegate = self;
    self.textColor = [UIColor lightGrayColor];
    self.placeholder = @"Notes";
    self.inputAccessoryView = [self GetAccessoryView];
    
    if (self.showBlur) {
        self.accessoryBackgroundType = CustomAccessoryViewTypeBlurAndDim;
    }
    
    [self setTintColor:[UIColor clearColor]];
    self.fakeTextView.text = self.text;
}

- (void)reset {
    
    self.text = @"";
    self.cloneTextView.text = @"";
    self.fakeTextView.text = @"";
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(self.finished == true){
        
        self.finished = false;
        self.textColor = [UIColor blackColor];
    }
    else if(textView.tag == 999)
    {
        self.dataManager.dimOverlay.alpha = 1;
    }
    else
    {
        self.previousValue = textView.text;
        self.cloneTextView.text = textView.text;
        self.textColor = [UIColor blackColor];
    
        if([textView.text isEqualToString:self.placeholder])
        {
            textView.text = @"";
        }
    
        [self.cloneTextView becomeFirstResponder];
    }
    
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.tag == 999)
    {
        self.dataManager.dimOverlay.alpha = 0;
    }
    else {
        if([textView.text isEqualToString:@""])
        {
            self.textColor = [UIColor lightGrayColor];
            textView.text = self.placeholder;
        }
    
        self.scrollsToTop = YES;
    }
    
    if (self.displayLabel != nil) {
        
        self.displayLabel.text = self.cloneTextView.text;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
    self.text = self.cloneTextView.text;
    [self.cloneTextView scrollRangeToVisible:NSMakeRange([self.cloneTextView.text length], 0)];
}

- (UIView *)GetAccessoryView{
    
    UIView * mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 110)];
    [mainView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
    
    
    self.cloneTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 15, 290, 50)];
    self.cloneTextView.textAlignment = NSTextAlignmentLeft;
    [self.cloneTextView  setFont:[UIFont fontWithName: @"Century Gothic" size:14.0f]];
    self.cloneTextView.scrollEnabled = YES;
    self.cloneTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.cloneTextView.autoresizesSubviews = YES;
    self.cloneTextView.tag = 999;
    self.cloneTextView.delegate = self;
    
    [mainView addSubview:self.cloneTextView];
    
    
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 320, 30)];
    [bottomView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.4]];
    
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(0, 5, 150, 21);
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTintColor:[MSUIManager colorFrom:@"FF0000"]];
    [cancelButton.titleLabel setFont:[UIFont fontWithName: @"Avenir Next" size:13.0f]];
    [cancelButton addTarget:self action:@selector(cancelPressed) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cancelButton];
    
    UIButton * doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    doneButton.frame = CGRectMake(160, 5, 150, 21);
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTintColor:[MSUIManager colorFrom:@"005493"]];
    [doneButton.titleLabel setFont:[UIFont fontWithName: @"Avenir Next" size:13.0f]];
    [doneButton addTarget:self action:@selector(donePressed) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:doneButton];
    
    [mainView addSubview:bottomView];
    //[mainView addSubview:headerView];
    
    return mainView;
}

- (void)cancelPressed
{
    self.finished = true;
    
    //Reset to prevoius value
    self.text = self.previousValue;
    self.cloneTextView.text = self.previousValue;
    [self.cloneTextView resignFirstResponder];
    [self resignFirstResponder];
}

- (void)donePressed
{
    self.finished = true;
    [self.cloneTextView resignFirstResponder];
    [self resignFirstResponder];
}

@end
