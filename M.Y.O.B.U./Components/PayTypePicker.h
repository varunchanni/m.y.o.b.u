//
//  PayTypePicker.h
//  M.Y.O.B.U.
//
//  Created by Raymond on 2/25/15.
//  Copyright (c) 2015 MYOB University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayType.h"

@protocol PayTypePickerDelegate;
@protocol PayTypePickerDelegate
- (void)payTypeValueSelected:(PayType *)payType;
@end

@interface PayTypePicker : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) id <PayTypePickerDelegate> customDelegate;
@property (strong, nonatomic) PayType * selectedPayType;
@end


