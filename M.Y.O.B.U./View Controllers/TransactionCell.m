//
//  TransactionCell.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 5/14/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "TransactionCell.h"
#import "MSUIManager.h"


@implementation TransactionCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) setLabels
{
    self.usernameLabel.text = self.transaction.user.username;
    self.dateLabel.text = [MSUIManager longDateFormat:self.transaction.date];
    self.paytypeLabel.text = self.transaction.paytype;
    self.amountLabel.text = self.transaction.displayAmount;
    self.notesLabel.text = [self.transaction fullNotes];
    if(self.transaction.transactionType == transactionTypeAdd || self.transaction.transactionType == transactionTypeCreated)
    {
        [self.amountLabel setTextColor:[MSUIManager colorFrom:@"6BAE7B"]];
    }
    else if(self.transaction.transactionType == transactionTypeMinus)
    {
        [self.amountLabel setTextColor:[MSUIManager colorFrom:@"BD4300"]];
    }
    else if(self.transaction.transactionType == transactionTypeMoveAdd || self.transaction.transactionType == transactionTypeMoveMinus)
    {
        [self.amountLabel setTextColor:[MSUIManager colorFrom:@"679CBD"]];
    }
}
@end
