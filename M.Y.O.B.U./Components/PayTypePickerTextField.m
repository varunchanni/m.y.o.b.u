//
//  PayTypePickerTextField.m
//  M.Y.O.B.U.
//
//  Created by Raymond on 2/25/15.
//  Copyright (c) 2015 MYOB University. All rights reserved.
//

#import "PayTypePickerTextField.h"
#import "PayTypePicker.h"
#import "MSUIManager.h"

@interface PayTypePickerTextField() <UITextFieldDelegate, PayTypePickerDelegate>
@property (strong, nonatomic) PayTypePicker * payTypePicker;
@property (strong, nonatomic) MSUIManager * uiManager;
@end

@implementation PayTypePickerTextField

@synthesize payType = _payType;

- (MSUIManager *)uiManager {
    return [MSUIManager sharedManager];
}

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
    self.delegate = self;
    self.payTypePicker = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                                     instantiateViewControllerWithIdentifier:@"PayTypePicker"];
    self.payTypePicker.customDelegate = self;
}


- (void)setPayType:(PayType *)payType {
    
    _payType = payType;
    self.text = payType.name;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self resignFirstResponder];
    self.payTypePicker.selectedPayType = self.payType;
    [self.uiManager pushFadeViewController:self.navController toViewController:self.payTypePicker];
}

- (void)payTypeValueSelected:(PayType *)payType {

    self.payType = payType;
}
@end
