//
//  UIPickerTextField.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 4/27/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "UIPickerTextField.h"
#import "MSUIManager.h"

@interface UIPickerTextField()
@property (nonatomic, strong) NSString * pickerPlaceholder;
@end

@implementation UIPickerTextField

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
    CGRect pickerFrame = CGRectMake(0, 30, 320, 100);
    self.options = [[NSArray alloc] init];
    self.pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    //self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    self.inputAccessoryView = [self GetAccessoryView];
    self.inputView = self.pickerView;
    self.pickerPlaceholder = self.placeholder;
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
    if ([self.text isEqualToString:@""])
    {
        self.placeholder = self.pickerPlaceholder;
    }
    [self resignFirstResponder];
}

// Number of components.
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.numberOfComponentsInPickerView;
}

// Total rows in our component.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.options count];
}

// Display each row's data.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.options objectAtIndex: row];
}

// Do something with the selected row.
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.text = [self.options objectAtIndex: row];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
