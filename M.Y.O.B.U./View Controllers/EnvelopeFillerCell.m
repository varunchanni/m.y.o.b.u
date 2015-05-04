//
//  EnvelopeFillerCell.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 4/1/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "EnvelopeFillerCell.h"
#import "MSDataManager.h"

@interface EnvelopeFillerCell()
@property (strong, nonatomic) Envelope * envelope;
@end

@implementation EnvelopeFillerCell 

- (Envelope *)envelope {
    return [[MSDataManager sharedManager] GetEnvelopeByIdentifier:self.envelopeID];
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



@end
