//
//  DropdownTableViewCell.m
//  M.Y.O.B.U.
//
//  Created by Raymond on 9/13/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "DropdownTableViewCell.h"

@implementation DropdownTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
