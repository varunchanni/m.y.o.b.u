//
//  TransitionAnimator.h
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 1/5/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TransitionAnimatorDelegate <NSObject>
@required;
- (void)presentAnimation:(id <UIViewControllerContextTransitioning>)transitionContext;
- (void)dismissAnimation:(id <UIViewControllerContextTransitioning>)transitionContext;
@end

@interface TransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, weak) id <TransitionAnimatorDelegate> delegate;
@property (nonatomic, assign, getter = isPresenting) BOOL presenting;
@end
