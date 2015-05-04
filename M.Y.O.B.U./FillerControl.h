//
//  FillerControl.h
//  M.Y.O.B.U.
//
//  Created by Raymond on 10/15/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPickerTextField.h"
#import "UICurrencyTextField.h"
#import "UIDateSelect.h"

@class FillerControl;
@protocol FillerControlDelegate;

@interface FillerControl : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *incomeSourcePicker;
@property (weak, nonatomic) IBOutlet UICurrencyTextField *amountRemaining;
@property (weak, nonatomic) IBOutlet UIDateSelect *datePicker;
@property (weak, nonatomic) id<FillerControlDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;
- (void)reset;
@end

@protocol FillerControlDelegate <NSObject>

- (void)fillerControlCancelPressed;
- (void)fillerControlFillPressed:(FillerControl *)control;


@end