//
//  QuickTransactionCell.h
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 5/13/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transaction.h"

@interface QuickTransactionCell : UITableViewCell
@property (nonatomic, strong) Transaction * transaction;
- (void)setLabels;
@end
