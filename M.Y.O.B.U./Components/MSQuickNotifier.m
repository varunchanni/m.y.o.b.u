//
//  MSQuickNotifier.m
//  The Envelope Filler
//
//  Created by Raymond Kelly on 10/22/13.
//  Copyright (c) 2013 MFX Studios. All rights reserved.
//

#import "MSQuickNotifier.h"

//static NSInteger const kViewHeight = 20;
//static NSInteger const kLabelYOffset = 2;
static NSInteger const kLabelXOffset = 5;
static NSInteger const kLabelHeightOffset = 4;
static NSInteger const kLabelWidthOffset = 10;
static NSTimeInterval const kAnimationDuration = 0.5;
static NSTimeInterval const kAnimationShowTime = 3;
static NSTimeInterval const kAnimationDelayTime = 0.5;

@interface MSQuickNotifier()
@property (nonatomic, strong) UIView * background;
@property (nonatomic, strong) UILabel * label;
@end
@implementation MSQuickNotifier



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize:frame];
    }
    return self;
}

- (void)initialize:(CGRect)frame
{
    self.background = [[UIView alloc] initWithFrame:frame];
    self.background .backgroundColor = [UIColor darkGrayColor];
    self.background.alpha = .8;

    CGPoint backgroundOrigin = self.background.frame.origin;
    CGSize backgroundSize = self.background.frame.size;
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(backgroundOrigin.x + kLabelXOffset,
                                                           backgroundOrigin.y + kLabelHeightOffset,
                                                           backgroundSize.width - kLabelWidthOffset,
                                                           backgroundSize.height - kLabelHeightOffset)];
    self.label.textColor = [UIColor whiteColor];
    self.label.font = [UIFont fontWithName:@"Arial" size:11.0f];
    
    [self addSubview:self.background];
    [self addSubview:self.label];
}

- (void)show:(NSString *)text
{
    self.label.text = text;
    
    [NSTimer scheduledTimerWithTimeInterval: kAnimationDelayTime
                                     target: self
                                   selector: @selector(animateIn)
                                   userInfo: nil
                                    repeats: NO];
}
- (void)setShowTimer:(int)seconds
{
    
}

- (void)animateIn
{
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        
        self.frame = CGRectMake(self.frame.origin.x,
                                self.frame.origin.y + self.frame.size.height,
                                self.frame.size.width,
                                self.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [NSTimer scheduledTimerWithTimeInterval: kAnimationShowTime
                                         target: self
                                       selector: @selector(animateOut)
                                       userInfo: nil
                                        repeats: NO];
    }];
}

- (void)animateOut
{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        
        self.frame = CGRectMake(self.frame.origin.x,
                                self.frame.origin.y - self.frame.size.height,
                                self.frame.size.width,
                                self.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        self.label.text = @"";
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
