//
//  WithdrawerTableViewCell.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 1/2/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "WithdrawerTableViewCell.h"

@interface WithdrawerTableViewCell()
@property (nonatomic, assign) BOOL isAnimating;
@end

@implementation WithdrawerTableViewCell

-(void)awakeFromNib
{
    self.highlightView.alpha = 0.7;
    self.currencyLabel.font = [UIFont fontWithName:@"HelveticaNeueLTStd-ThCn" size:15];
    self.quanityTextfield.font = [UIFont fontWithName:@"HelveticaNeueLTStd-ThCn" size:15];
    self.currencyTotalLabel.font = [UIFont fontWithName:@"HelveticaNeueLTStd-ThCn" size:15];;
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



- (void)playClickedAnimation:(UIColor *)highlightColor
{
    self.highlightView.backgroundColor = highlightColor;
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         
                         self.highlightView.backgroundColor = [UIColor clearColor];
                         
                         
                     }
                     completion:nil];
}


@end
