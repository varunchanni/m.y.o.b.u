//
//  WithdrawerTableViewCell.h
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 1/2/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINumberTextField.h"

@interface WithdrawerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyTotalLabel;
@property (weak, nonatomic) IBOutlet UINumberTextField *quanityTextfield;
@property (weak, nonatomic) IBOutlet UIView *highlightView;

- (void)playClickedAnimation:(UIColor *)highlightColor;
@end
