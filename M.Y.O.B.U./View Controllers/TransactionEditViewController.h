//
//  TransactionEditViewController.h
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 7/20/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "MYOBViewController.h"
#import "Transaction.h"
#import "Envelope.h"

@interface TransactionEditViewController : MYOBViewController

@property (nonatomic, strong) Transaction * transaction;
@property (nonatomic, strong) NSString * envelopeID;
@end
