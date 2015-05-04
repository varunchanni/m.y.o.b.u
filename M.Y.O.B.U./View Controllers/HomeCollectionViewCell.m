//
//  HomeCollectionViewCell.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 12/21/13.
//  Copyright (c) 2013 MYOB University. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import "HomeViewController.h"

@implementation HomeCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib
{
    
    UIButton *button = [[UIButton alloc] initWithFrame:self.frame];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
}

- (void)buttonClicked:(id)sender
{
    HomeViewController * homeController = (HomeViewController *)self.delegate;
    CGRect frame = [self convertRect:self.frame toView:homeController.view];
    frame.origin.y += 3;
    frame.origin.x += 8;
    frame.size.width -= 40;
    frame.size.height -= 40;
    
    [self loadViewController:self.feature.viewController WithCellFrameAnimation:frame];
}

- (void)loadViewController:(NSString *)viewControllerName WithCellFrameAnimation:(CGRect)cellFrame
{
    if([self.delegate respondsToSelector:@selector(loadViewController:WithCellFrameAnimation:)])
    {
        [self.delegate loadViewController:(NSString *)viewControllerName WithCellFrameAnimation:cellFrame];
    }
}
@end
