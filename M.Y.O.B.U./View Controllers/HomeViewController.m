//
//  HomeViewController.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 12/16/13.
//  Copyright (c) 2013 MYOB University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "HomeCollectionViewCell.h"
#import "TransitionAnimator.h"
#import "WithdrawerViewController.h"
#import "EnvelopeFillerViewController.h"
#import "MSProfileButton.h"

@interface HomeViewController () <UIViewControllerTransitioningDelegate, UICollectionViewDataSource, UICollectionViewDelegate, HomeCollectionViewCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *accountButton;
@end

@implementation HomeViewController

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
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.welcomeLabel.text = [NSString stringWithFormat:@"Welcome, %@", self.dataManager.currentUserAccount.username];
    self.welcomeLabel.textColor = self.uiManager.myobuGreenBold;
    
    if([MSUIManager isIPhone5])
    {
        NSInteger offset = 40;
        CGRect frame = self.collectionView.frame;
        frame.origin.y += offset;
        self.collectionView.frame = frame;
        
        frame = self.pageControl.frame;
        frame.origin.y += offset;
        self.pageControl.frame = frame;
    }
    
    [self addProfileButton];
}

-(void)addProfileButton
{
    CGRect frame = CGRectMake(10, 10, 38, 38);
    MSProfileButton * profileButton = [[MSProfileButton alloc] initWithFrame:frame];
    profileButton.parentNavController = self.navigationController;
    //[profileButton addTarget:self action:@selector(logoutPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:profileButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma IBActions
- (IBAction)logoutPressed:(id)sender {
    
    if(![self.dataManager.currentUserAccount.userId isEqualToString:@"0"])
    {
        [self.serviceManager logoutUser:self.dataManager.currentUserAccount.userId completed:^(BOOL successful, id response) {
            
            if(!successful)
            {
                NSLog(@"Error Signing Out!");
            }
        }];
    }
    [self.dataManager.currentUserAccount logout];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)changePage:(id)sender {
    
    NSInteger x = self.pageControl.currentPage;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:x inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = self.dataManager.features.count;
    self.pageControl.numberOfPages = count;
    
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"HomeCollectionCell";
    
    HomeCollectionViewCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    Feature * feature = [self.dataManager.features objectAtIndex:indexPath.row];
    
    cell.delegate = self;
    cell.feature = feature;
    cell.iconImageView.image = [UIImage imageNamed:[[self.dataManager.features objectAtIndex:indexPath.row] iconImage]];
    cell.titleLabel.text = [[self.dataManager.features objectAtIndex:indexPath.row] title];
    
    return cell;
}

#pragma HomeCollectionViewCell Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
        
        NSInteger x = [self.collectionView convertPoint:cell.frame.origin toView:self.navigationController.view].x;
        
        if(x > 0)
        {
            self.pageControl.currentPage = [self.collectionView indexPathForCell:cell].row;
            break;
        }
    }
}

- (void)loadViewController:(NSString *)viewControllerName WithCellFrameAnimation:(CGRect)cellFrame
{
    if([viewControllerName isEqualToString:@"WithdrawerViewController"])
    {
        
        WithdrawerViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
        instantiateViewControllerWithIdentifier:@"WithdrawerViewController"];
        [self.uiManager pushFadeViewController:self.navigationController toViewController:viewController];
    }
    else if([viewControllerName isEqualToString:@"EnvelopeFillerViewController"])
    {
        EnvelopeFillerViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                                     instantiateViewControllerWithIdentifier:@"EnvelopeFillerViewController"];
        [self.uiManager pushFadeViewController:self.navigationController toViewController:viewController];
    }
    
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
