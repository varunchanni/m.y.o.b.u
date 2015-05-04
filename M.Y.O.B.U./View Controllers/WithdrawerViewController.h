//
//  WithdrawerViewController.h
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 12/29/13.
//  Copyright (c) 2013 MYOB University. All rights reserved.
//

#import "MYOBViewController.h"

@interface WithdrawerViewController : MYOBViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) CGRect startingFrame;
- (void)toggleAnimatingView:(BOOL)isHidden;
@end
