//
//  SplashScreenViewController.m
//  M.Y.O.B.U.
//
//  Created by Raymond on 9/6/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "SplashScreenViewController.h"
#import "MainViewController.h"
#import "TransitionAnimator.h"

@interface SplashScreenViewController () <UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *myobLabel;
@property (weak, nonatomic) IBOutlet UILabel *powerLabel;

@end

@implementation SplashScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [UIView animateWithDuration:1.2 delay:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.logo.frame = CGRectMake(110, 175, 100, 100);
        
    } completion:^(BOOL finished) {
        
        self.myobLabel.alpha = 0;
        self.powerLabel.alpha = 0;
        self.myobLabel.hidden = NO;
        self.powerLabel.hidden = NO;
        
        [UIView animateWithDuration:1.0 animations:^{
            
            self.myobLabel.frame = CGRectMake(43, 273, 235, 32);
            self.myobLabel.alpha = 1;
        }];
        
        [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.powerLabel.frame = CGRectMake(40, 295, 238, 32);
            self.powerLabel.alpha = 1;
            
        } completion:^(BOOL finished) {
            
            MainViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                                        instantiateViewControllerWithIdentifier:@"MainViewController"];
            [self.uiManager pushFadeViewController:self.navigationController toViewController:viewController];

        }];
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma View Controller Transition Delegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    
    //use this if statement for handing different types of animations on same controller
    //if([[presented class] isSubclassOfClass:[MSMenuViewController class]])
    
    TransitionAnimator *animator = [TransitionAnimator new];
    animator.presenting = YES;
    animator.delegate = self.uiManager;
    return animator;
    
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    //use this if statement for handing different types of animations on same controller
    //if([[presented class] isSubclassOfClass:[MSMenuViewController class]])
    
    
    TransitionAnimator *animator = [TransitionAnimator new];
    animator.presenting = NO;
    animator.delegate = self.uiManager;
    return animator;
}

@end
