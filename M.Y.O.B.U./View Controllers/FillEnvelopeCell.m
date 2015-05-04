//
//  FillEnvelopeCell.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 4/21/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "FillEnvelopeCell.h"

@implementation FillEnvelopeCell

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
/*
#pragma UITextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([self.delagete respondsToSelector:@selector(fillAmountUpdatedAt:forAmount:)])
    {
        [self.delagete fillAmountUpdatedAt:self.indexPath forAmount:textField.text];
    }
}
*/
@end
