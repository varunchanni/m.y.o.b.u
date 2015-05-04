//
//  FillEnvelopeCell.h
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 4/21/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FillEnvelopeCell;
@protocol FillEnvelopeCellDelegate;

@interface FillEnvelopeCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) id<FillEnvelopeCellDelegate> delagete;
@property (strong, nonatomic) NSIndexPath *indexPath;
@end

/*
@protocol FillEnvelopeCellDelegate<NSObject>

- (void)fillAmountUpdatedAt:(NSIndexPath*)indexPath forAmount:(NSString *)fillAmount;

@end
*/