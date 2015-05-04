//
//  TransactionCell.h
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 5/14/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transaction.h"

@interface TransactionCell : UITableViewCell
@property (nonatomic, strong) Transaction * transaction;
@property (nonatomic, weak) IBOutlet UILabel * usernameLabel;
@property (nonatomic, weak) IBOutlet UILabel * dateLabel;
@property (nonatomic, weak) IBOutlet UILabel * paytypeLabel;
@property (nonatomic, weak) IBOutlet UILabel * amountLabel;
@property (nonatomic, weak) IBOutlet UILabel * notesLabel;
- (void) setLabels;
@end
