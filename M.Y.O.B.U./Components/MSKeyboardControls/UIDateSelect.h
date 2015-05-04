//
//  UIDateSelect.h
//  The Envelope Filler
//
//  Created by Raymond Kelly on 11/8/13.
//  Copyright (c) 2013 MFX Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDateSelect : UITextField
@property (nonatomic,strong) NSDate * date;

- (void)initialize;
@end
