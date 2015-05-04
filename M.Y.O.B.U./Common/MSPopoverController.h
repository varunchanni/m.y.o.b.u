//
//  GCPopoverViewController.h
//  FiveStar
//
//  Created by Prince Ugwuh on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSBaseViewController;
@class MSPopoverController;

typedef enum
{
	MSPopoverArrowDirectionAny		= 0,
    MSPopoverArrowDirectionUp		= 1 << 0,
    MSPopoverArrowDirectionDown		= 1 << 1,
    MSPopoverArrowDirectionLeft		= 1 << 2,
    MSPopoverArrowDirectionRight	= 1 << 3,
} MSPopoverArrowDirection;

@protocol MSPopoverControllerDelegate <NSObject>
@optional
- (void)popoverControllerDidChanegOrientation:(MSPopoverController *)popoverController;
- (void)popoverControllerDidDismissPopover:(MSPopoverController *)popoverController;
- (BOOL)popoverControllerShouldDismissPopover:(MSPopoverController *)popoverController;
@end

@interface MSPopoverController : UIViewController
@property (nonatomic, weak) id<MSPopoverControllerDelegate> delegate;
@property (nonatomic, assign) MSPopoverArrowDirection popoverArrowDirection;
@property (nonatomic, strong) MSBaseViewController *contentViewController;
@property (nonatomic, assign) CGSize popoverContentSize;
@property (nonatomic, assign) UIEdgeInsets popoverEdgeInset;
@property (nonatomic, strong) UIColor *popoverBackgroundColor;
@property (nonatomic, assign) NSInteger cornerRadius;
@property (nonatomic, assign) NSInteger borderWidth;
@property (nonatomic, assign) BOOL shadowEnabled;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIImage *arrowImageUp;
@property (nonatomic, strong) UIImage *arrowImageDown;
@property (nonatomic, strong) UIImage *arrowImageLeft;
@property (nonatomic, strong) UIImage *arrowImageRight;
@property (nonatomic, assign) BOOL allowAutoRotation;
@property (nonatomic, assign) CGFloat paddingFromEdge;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, assign) CGFloat popoverSpacing;

- (id)initWithContentViewController:(MSBaseViewController *)contentViewController;
- (void)setContentViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view arrowDirection:(MSPopoverArrowDirection)arrowDirection animated:(BOOL)animated;
- (void)presentPopoverFromControl:(UIButton *)item inView:(UIView *)view arrowDirection:(MSPopoverArrowDirection)arrowDirection animated:(BOOL)animated;
- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)item fromToolbar:(UIToolbar *)toolbar inView:(UIView *)view arrowDirection:(MSPopoverArrowDirection)arrowDirection animated:(BOOL)animated;
- (void)repositionPopoverFromRect:(CGRect)rect inView:(UIView *)view arrowDirection:(MSPopoverArrowDirection)arrowDirection animated:(BOOL)animated;
- (void)repositionPopoverFromBarButtonItem:(UIBarButtonItem *)barButtonItem fromToolbar:(UIToolbar *)toolbar inView:(UIView *)view arrowDirection:(MSPopoverArrowDirection)arrowDirection animated:(BOOL)animated;
- (void)dismissPopoverAnimated:(BOOL)animated;
@end
