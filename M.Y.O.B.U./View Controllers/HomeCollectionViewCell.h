//
//  HomeCollectionViewCell.h
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 12/21/13.
//  Copyright (c) 2013 MYOB University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feature.h"

@protocol HomeCollectionViewCellDelegate <NSObject>
- (void)loadViewController:(NSString *)viewControllerName WithCellFrameAnimation:(CGRect)cellFrame;
@end

@interface HomeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) id <HomeCollectionViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (nonatomic, strong) Feature * feature;
@end