//
//  UIPickerTextField.h
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 4/27/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPickerTextField : UITextField <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UIPickerView * pickerView;
@property (nonatomic, strong) NSArray * options;
@property (nonatomic, assign) NSInteger numberOfComponentsInPickerView;
@end
