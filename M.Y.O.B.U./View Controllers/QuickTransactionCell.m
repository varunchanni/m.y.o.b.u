//
//  QuickTransactionCell.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 5/13/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "QuickTransactionCell.h"
#import "MSUIManager.h"

@interface QuickTransactionCell()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end

@implementation QuickTransactionCell

- (void)setTransaction:(Transaction *)transaction
{
    if (_transaction != transaction)
    {
        _transaction = transaction;
        [self setLabels];
    }
}

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


- (void)setLabels
{
    
    self.dateLabel.text = [MSUIManager shortDateFormat:self.transaction.date];
    
    self.notesLabel.text = [self.transaction fullNotes];
    self.userLabel.text = self.transaction.user.username;
    self.amountLabel.text = self.transaction.displayAmount;
    
    if(self.transaction.transactionType == transactionTypeAdd || self.transaction.transactionType == transactionTypeCreated)
    {
        [self.amountLabel setTextColor:[UIColor greenColor]];
    }
    else if(self.transaction.transactionType == transactionTypeMinus)
    {
        [self.amountLabel setTextColor:[UIColor redColor]];
    }
    else if(self.transaction.transactionType == transactionTypeMoveAdd || self.transaction.transactionType == transactionTypeMoveMinus)
    {
        [self.amountLabel setTextColor:[UIColor blueColor]];
    }
}

@end
