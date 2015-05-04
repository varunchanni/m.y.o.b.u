//
//  TransitionAnimator.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 1/5/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "TransitionAnimator.h"

@interface TransitionAnimator()
@property (nonatomic, strong) UIViewController * presentedViewController;
@end

@implementation TransitionAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    // Grab the from and to view controllers from the context
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    
    if (self.presenting) {
        
        if([self.delegate respondsToSelector:@selector(presentAnimation:)])
        {
            [self.delegate presentAnimation:transitionContext];
        }
        else
        {
            //Do some basic animation here
            // Set our ending frame. We'll modify this later if we have to
            CGRect endFrame = CGRectMake(0, 280, 320, 200);
            fromViewController.view.userInteractionEnabled = NO;
            
            [transitionContext.containerView addSubview:fromViewController.view];
            [transitionContext.containerView addSubview:toViewController.view];
            
            CGRect startFrame = endFrame;
            startFrame.origin.y += 320;
            
            toViewController.view.frame = startFrame;
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
                toViewController.view.frame = endFrame;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
        }
    }
    else {
        
        if([self.delegate respondsToSelector:@selector(dismissAnimation:)])
        {
            [self.delegate dismissAnimation:transitionContext];
        }
        else
        {
            // Set our ending frame. We'll modify this later if we have to
            CGRect endFrame = CGRectMake(0, 280, 320, 200);
            toViewController.view.userInteractionEnabled = YES;
            
            [transitionContext.containerView addSubview:toViewController.view];
            [transitionContext.containerView addSubview:fromViewController.view];
            
            endFrame.origin.y += 320;
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                toViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
                fromViewController.view.frame = endFrame;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
        }
    }
    
}
@end
