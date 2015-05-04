//
//  SideMenuSettings.h
//  M.Y.O.B.U.
//
//  Created by Raymond on 10/5/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SideMenuSettings;
@protocol SideMenuSettingsDelegate;

@interface SideMenuSettings : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) NSDictionary * menuItems;
@property (weak, nonatomic) id<SideMenuSettingsDelegate> delegate;
@end

@protocol SideMenuSettingsDelegate<NSObject>

- (void)tableCellPressed:(NSIndexPath *)indexPath;

@end
