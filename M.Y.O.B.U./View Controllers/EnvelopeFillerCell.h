//
//  EnvelopeFillerCell.h
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 4/1/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICurrencyTextField.h"
#import "Envelope.h"


@interface EnvelopeFillerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *envelopeLabel;
@property (weak, nonatomic) IBOutlet UILabel *envelopeTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *envelopePayLabel;
@property (weak, nonatomic) IBOutlet UILabel *envelopeDateLabel;
@property (weak, nonatomic) IBOutlet UICurrencyTextField *envelopeFillAmount;
@property (weak, nonatomic) IBOutlet UICurrencyTextField *fillInput;
@property (weak, nonatomic) IBOutlet UIImageView *line;
@property (strong, nonatomic) NSString * envelopeID;
@end
