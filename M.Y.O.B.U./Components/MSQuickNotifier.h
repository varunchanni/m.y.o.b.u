//
//  MSQuickNotifier.h
//  The Envelope Filler
//
//  Created by Raymond Kelly on 10/22/13.
//  Copyright (c) 2013 MFX Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSQuickNotifier : UIView

- (void)show:(NSString *)text;
- (void)setShowTimer:(int)seconds;

@end
