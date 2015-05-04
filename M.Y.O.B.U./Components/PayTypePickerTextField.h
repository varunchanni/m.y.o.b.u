//
//  PayTypePickerTextField.h
//  M.Y.O.B.U.
//
//  Created by Raymond on 2/25/15.
//  Copyright (c) 2015 MYOB University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayType.h"


@interface PayTypePickerTextField : UITextField
@property (strong, nonatomic) UINavigationController * navController;
@property (strong, nonatomic) PayType * payType;
@end
