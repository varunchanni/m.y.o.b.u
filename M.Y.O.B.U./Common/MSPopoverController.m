
//
//  Created by Prince Ugwuh on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MSPopoverController.h"
#import "MSBaseViewController.h"
#import "UIBarButtonItem+Extension.h"
#import <QuartzCore/QuartzCore.h>

static CGSize const kDefaultPopoverSize = {310.f, 325.f};
static UIEdgeInsets const kDefaultPopoverEdgeInset = {10.f, 10.f, 10.f, 10.f};
static NSInteger const kDefaultCornerRadius = 10;
static CGFloat const kPaddingFromEdge = 5.f;

@interface MSPopoverController ()
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIControl *dismissModalView;
@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, assign) CGRect originalRect;
@property (nonatomic, assign) BOOL animated;
@property (nonatomic, assign) BOOL arrowHidden;
@property (nonatomic, strong) UIBarButtonItem *barButtonItem;
@property (nonatomic, strong) UIToolbar *toolbar;
@end


@implementation MSPopoverController

@synthesize popoverContentSize = _popoverContentSize;

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
	if (_backgroundImage != backgroundImage)
	{
		_backgroundImage = backgroundImage;
		self.backgroundImageView.image = _backgroundImage;
		self.backgroundImageView.frame = CGRectMake(self.backgroundImageView.frame.origin.x,
													self.backgroundImageView.frame.origin.y,
													_backgroundImage.size.width,
													_backgroundImage.size.height);
		[self.view setNeedsLayout];
	}
}

- (UIColor *)popoverBackgroundColor
{

	if (_popoverBackgroundColor == nil)
	{
		_popoverBackgroundColor = [UIColor darkGrayColor];
	}
	return  _popoverBackgroundColor;
}

- (CGSize)popoverContentSize
{
	if (CGSizeEqualToSize(_popoverContentSize, CGSizeZero))
	{
		_popoverContentSize = kDefaultPopoverSize;
	}
	
	return _popoverContentSize;
}

- (void)setPopoverContentSize:(CGSize)popoverContentSize
{
	if (!CGSizeEqualToSize(_popoverContentSize, popoverContentSize))
	{
		_popoverContentSize = popoverContentSize;
		
		[self.view setNeedsLayout];
	}
}

- (id)initWithContentViewController:(MSBaseViewController *)contentViewController
{
	self = [super init];
	
	if (self)
	{
		_paddingFromEdge = kPaddingFromEdge;
		_popoverArrowDirection = MSPopoverArrowDirectionDown;
		_allowAutoRotation = YES;
		_popoverEdgeInset = kDefaultPopoverEdgeInset;
		self.contentViewController = contentViewController;
		self.contentViewController.popover = self;
		self.arrowHidden = NO;
		self.cornerRadius = kDefaultCornerRadius;
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.contentView = [[UIView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:self.contentView];
	
	self.dismissModalView = [[UIControl alloc] initWithFrame:self.view.bounds];
	[self.contentView addSubview:self.dismissModalView];
	[self.dismissModalView addTarget:self action:@selector(dismissPopover:) forControlEvents:UIControlEventTouchUpInside];
	
	self.arrowImageView = [[UIImageView alloc] initWithImage:nil];
	[self.contentView addSubview:self.arrowImageView];
	
	self.backgroundImageView = [[UIImageView alloc] initWithImage:self.backgroundImage];
	self.backgroundImageView.userInteractionEnabled = YES;
	self.backgroundImageView.multipleTouchEnabled = YES;
	[self.contentView addSubview:self.backgroundImageView];
	
	if (self.backgroundImage == nil)
	{
		self.backgroundImageView.backgroundColor = self.popoverBackgroundColor;
	}

	CALayer *backgroundLayer = self.backgroundImageView.layer;
	backgroundLayer.cornerRadius = self.cornerRadius;
	backgroundLayer.borderColor = [UIColor blackColor].CGColor;
    backgroundLayer.borderWidth = self.borderWidth;

	if (self.shadowEnabled)
	{
		backgroundLayer.shadowColor = [UIColor blackColor].CGColor;
		backgroundLayer.shadowOffset = CGSizeMake(0.f, 0.f);
		backgroundLayer.shadowOpacity = 0.75f;
		backgroundLayer.shadowRadius = 5.f;
        backgroundLayer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.backgroundImageView.bounds cornerRadius:self.cornerRadius].CGPath;
	}
	
	[self addChildViewController:self.contentViewController];
	[self.contentViewController willMoveToParentViewController:self];
	[self.backgroundImageView addSubview:self.contentViewController.view];
        
	CALayer *contentViewLayer = self.contentViewController.view.layer;
	contentViewLayer.masksToBounds = YES;
	contentViewLayer.cornerRadius = self.cornerRadius;
}

- (void)viewDidLayoutSubviews
{
	
	self.contentView.frame = self.view.bounds;
	self.dismissModalView.frame = self.view.bounds;
	
	self.view.alpha = 0.f;
	
	MSPopoverArrowDirection arrowDirection = self.popoverArrowDirection;
	if ((arrowDirection & MSPopoverArrowDirectionUp) == MSPopoverArrowDirectionUp)
	{
		NSLog(@"UP");
		self.arrowImageView.image = self.arrowImageUp;
		self.arrowImageView.frame = CGRectMake(0, 0, self.arrowImageUp.size.width, self.arrowImageUp.size.height);
		[self positionPopoverWithArrowDirectionUp];
	}
	else if ((arrowDirection & MSPopoverArrowDirectionDown) == MSPopoverArrowDirectionDown)
	{
		NSLog(@"DOWN");
		self.arrowImageView.image = self.arrowImageDown;
		self.arrowImageView.frame = CGRectMake(0, 0, self.arrowImageDown.size.width, self.arrowImageDown.size.height);
		[self positionPopoverWithArrowDirectionDown];
	}
	else if ((arrowDirection & MSPopoverArrowDirectionLeft) == MSPopoverArrowDirectionLeft)
	{
		NSLog(@"LEFT");
		self.arrowImageView.image = self.arrowImageRight;
		self.arrowImageView.frame = CGRectMake(0, 0, self.arrowImageRight.size.width, self.arrowImageRight.size.height);
		[self positionPopoverWithArrowDirectionLeft];

	}
	else if ((arrowDirection & MSPopoverArrowDirectionRight) == MSPopoverArrowDirectionRight)
	{
		NSLog(@"RIGHT");
		self.arrowImageView.image = self.arrowImageLeft;
		self.arrowImageView.frame = CGRectMake(0, 0, self.arrowImageLeft.size.width, self.arrowImageLeft.size.height);
		[self positionPopoverWithArrowDirectionRight];
	}
	
	[UIView
	 animateWithDuration:self.animated ? 0.15f : 0.f
	 delay:0.f
	 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowAnimatedContent
	 animations:^{
		 
		 self.view.alpha = 1.0f;
		 
	 }
	 completion:nil];
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
	{
		self.popoverArrowDirection = MSPopoverArrowDirectionRight;
		
	}
	else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
		
		self.popoverArrowDirection = MSPopoverArrowDirectionLeft;
	}
	else
	{
		self.popoverArrowDirection = MSPopoverArrowDirectionDown;
	}
	
	[self repositionPopoverFromBarButtonItem:self.barButtonItem
								 fromToolbar:self.toolbar
									  inView:self.parentView
							  arrowDirection:self.popoverArrowDirection
									animated:self.animated];
}

- (void)moveCameraViewToOriginalViewAndRotate
{
	self.contentView.transform = CGAffineTransformIdentity;
	
	[self.view addSubview:self.contentView];
	
	if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
	{
		self.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
	}
	else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
		self.contentView.transform = CGAffineTransformMakeRotation(-M_PI_2);
	}
	
	self.contentView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
}

- (void)moveCameraViewToWindow
{
	self.contentView.transform = CGAffineTransformIdentity;
	[self.view.window addSubview:self.contentView];
	self.contentView.center = self.view.window.center;
}

- (void)setContentViewController:(UIViewController *)viewController animated:(BOOL)animated
{

//	[self.contentViewController.view removeFromSuperview];
//	[self.contentViewController removeFromParentViewController];
	
}

- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view arrowDirection:(MSPopoverArrowDirection)arrowDirection animated:(BOOL)animated
{
	self.popoverArrowDirection = arrowDirection;
	self.parentView = view;
	self.rect = rect;
	self.animated = animated;
	
	UIViewController *rootViewController = view.window.rootViewController;
	[rootViewController.view addSubview:self.view];
	[rootViewController addChildViewController:self];	
}

- (void)repositionPopoverFromRect:(CGRect)rect inView:(UIView *)view arrowDirection:(MSPopoverArrowDirection)arrowDirection animated:(BOOL)animated
{
	self.popoverArrowDirection = arrowDirection;
	self.parentView = view;
	self.rect = rect;
	self.animated = animated;
	
	[self.view setNeedsLayout];
}

- (void)repositionPopoverFromBarButtonItem:(UIBarButtonItem *)barButtonItem fromToolbar:(UIToolbar *)toolbar inView:(UIView *)view arrowDirection:(MSPopoverArrowDirection)arrowDirection animated:(BOOL)animated
{
	self.barButtonItem = barButtonItem;
	self.toolbar = toolbar;
	
	CGRect frame = [self.barButtonItem frameForView:view];
	
    [self repositionPopoverFromRect:frame inView:view arrowDirection:arrowDirection animated:animated];
}

- (void)presentPopoverFromControl:(UIButton *)item inView:(UIView *)view arrowDirection:(MSPopoverArrowDirection)arrowDirection animated:(BOOL)animated {
    
    CGRect frame = [item convertRect:item.bounds toView:view];
    [self presentPopoverFromRect:frame inView:view arrowDirection:arrowDirection animated:animated];
}

- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)barButtonItem fromToolbar:(UIToolbar *)toolbar inView:(UIView *)view arrowDirection:(MSPopoverArrowDirection)arrowDirection animated:(BOOL)animated
{
	self.barButtonItem = barButtonItem;
	self.toolbar = toolbar;
	
	CGRect frame = [self.barButtonItem frameForView:view];

    [self presentPopoverFromRect:frame inView:view arrowDirection:arrowDirection animated:animated];
}

- (void)dismissPopoverAnimated:(BOOL)animated
{
	if ([self.delegate respondsToSelector:@selector(popoverControllerShouldDismissPopover:)])
	{
		if ([self.delegate popoverControllerShouldDismissPopover:self])
		{
			[UIView
			 animateWithDuration:animated ? 0.15f : 0.f
             delay:0.f
             options:UIViewAnimationOptionAllowAnimatedContent
			 animations:^{
				 self.view.alpha = 0.f;
			 } completion:^(BOOL finished) {
				 [self removePopover];
			 }];
		}
	}
	else
	{
		[UIView
		 animateWithDuration:animated ? 0.15f : 0.f
         delay:0.f
         options:UIViewAnimationOptionAllowAnimatedContent
		 animations:^{
			 self.view.alpha = 0.f;
		 } completion:^(BOOL finished) {
			 [self removePopover];
		 }];
	}
}

- (void)dismissPopover:(id)sender
{
	[self dismissPopoverAnimated:YES];
}

- (void)removePopover
{
	[self.view removeFromSuperview];
	[self removeFromParentViewController];
	
	if ([self.delegate respondsToSelector:@selector(popoverControllerDidDismissPopover:)])
	{
		[self.delegate popoverControllerDidDismissPopover:self];
	}
}

#pragma mark - Popover positioning
- (void)positionPopoverWithArrowDirectionUp
{
	CGFloat x;
	CGFloat y;// = CGRectGetMaxY(self.rect);
	CGFloat cX = CGRectGetMidX(self.rect);
	CGFloat cY = CGRectGetMidY(self.rect);
	UIWindow *window = self.view.window;
	CGFloat padding = self.paddingFromEdge;
	
//	if (self.interfaceOrientation == UIInterfaceOrientationPortrait)
//	{
//		padding = (self.view.bounds.size.width - self.popoverContentSize.width) / 2;
//	}
	
	
	x = cX;
	
	if (x - (self.popoverContentSize.width / 2) < self.view.frame.origin.x)
	{
		x = self.parentView.frame.origin.x + padding;
	}
	else if (x + (self.popoverContentSize.width / 2) > self.view.frame.size.width)
	{
		x = self.view.frame.size.width - (self.popoverContentSize.width + padding);
	}
	
	y = cY + (self.rect.size.height + self.popoverContentSize.height + self.popoverSpacing);
	
	CGRect frame = CGRectMake(x, y, self.popoverContentSize.width, self.popoverContentSize.height);
	self.backgroundImageView.frame = [self.backgroundImageView convertRect:frame fromView:window.rootViewController.view];
	self.contentViewController.view.frame = UIEdgeInsetsInsetRect(self.backgroundImageView.bounds, self.popoverEdgeInset);
	
	self.arrowImageView.frame = CGRectMake(0.f,
										   CGRectGetMinY(self.backgroundImageView.frame) - self.arrowImageView.frame.size.height,
										   self.arrowImageView.frame.size.width,
										   self.arrowImageView.frame.size.height);
	self.arrowImageView.center = CGPointMake(cX, self.arrowImageView.center.y + 3.f);
}

- (void)positionPopoverWithArrowDirectionLeft
{
	CGFloat x;
	CGFloat y;
	CGFloat cX = CGRectGetMidX(self.rect);
	CGFloat cY = CGRectGetMidY(self.rect);
	UIWindow *window = self.view.window;
	
	CGFloat padding = self.paddingFromEdge;
	
	x = cX - (self.rect.size.width + self.popoverContentSize.width + self.popoverSpacing);
    y = cY - (self.popoverContentSize.height / 2);
	
	if ((y - (self.popoverContentSize.height / 2)) < self.view.bounds.origin.y)
	{
		y = self.view.bounds.origin.y + padding;
	}
	else if ((y + (self.popoverContentSize.height / 2)) > self.view.bounds.size.height)
	{
		y = self.view.bounds.size.height - (self.popoverContentSize.height + padding);
	}
	
	CGRect frame = CGRectMake(x, y, self.popoverContentSize.width, self.popoverContentSize.height);
	self.backgroundImageView.frame = [self.backgroundImageView convertRect:frame fromView:window.rootViewController.view];
	self.contentViewController.view.frame = UIEdgeInsetsInsetRect(self.backgroundImageView.bounds, self.popoverEdgeInset);
	
	self.arrowImageView.frame = CGRectMake(CGRectGetMaxX(self.backgroundImageView.frame),
										   0.f,
										   self.arrowImageView.frame.size.width,
										   self.arrowImageView.frame.size.height);
	self.arrowImageView.center = CGPointMake(self.arrowImageView.center.x - 4.f, cY);
}

- (void)positionPopoverWithArrowDirectionRight
{
	CGFloat x;
	CGFloat y;
	CGFloat cX = CGRectGetMidX(self.rect);
	CGFloat cY = CGRectGetMidY(self.rect);
	UIWindow *window = self.view.window;
	CGFloat padding = self.paddingFromEdge;
	
	x = cX + (self.rect.size.width + self.popoverSpacing);
	y = cY - (self.popoverContentSize.height / 2);
	
	if ((y - (self.popoverContentSize.height / 2)) < self.view.bounds.origin.y)
	{
		y = self.view.bounds.origin.y + padding;
	}
	else if ((y + (self.popoverContentSize.height / 2)) > self.view.bounds.size.height)
	{
		y = self.view.bounds.size.height - (self.popoverContentSize.height + padding);
	}
	
	CGRect frame = CGRectMake(x, y, self.popoverContentSize.width, self.popoverContentSize.height);
	self.backgroundImageView.frame = [self.backgroundImageView convertRect:frame fromView:window.rootViewController.view];
	self.contentViewController.view.frame = UIEdgeInsetsInsetRect(self.backgroundImageView.bounds, self.popoverEdgeInset);
	
	self.arrowImageView.frame = CGRectMake(CGRectGetMinX(self.backgroundImageView.frame) - self.arrowImageView.frame.size.width,
										   0.f,
										   self.arrowImageView.frame.size.width,
										   self.arrowImageView.frame.size.height);
	self.arrowImageView.center = CGPointMake(self.arrowImageView.center.x + 4.f, cY);
}

- (void)positionPopoverWithArrowDirectionDown
{
	CGFloat x;
	CGFloat y;
	CGFloat cX = CGRectGetMidX(self.rect);
	CGFloat cY = CGRectGetMidY(self.rect);
	UIWindow *window = self.view.window;
	
	CGFloat padding = self.paddingFromEdge;
	
	x = cX;
	y = cY - (self.rect.size.height + self.popoverContentSize.height + self.popoverSpacing);
	
	if ((x - self.popoverContentSize.width) < self.view.bounds.origin.x)
	{
		x = self.view.bounds.origin.x + padding;
	}
	else if ((x + self.popoverContentSize.width) > self.view.bounds.size.width)
	{
		x = self.view.bounds.size.width - (self.popoverContentSize.width + padding);
	}
	
	CGRect frame = CGRectMake(x, y, self.popoverContentSize.width, self.popoverContentSize.height);
	self.backgroundImageView.frame = [self.backgroundImageView convertRect:frame fromView:window.rootViewController.view];
	self.contentViewController.view.frame = UIEdgeInsetsInsetRect(self.backgroundImageView.bounds, self.popoverEdgeInset);
	
	self.arrowImageView.frame = CGRectMake(0.f,
										   CGRectGetMaxY(self.backgroundImageView.frame),
										   self.arrowImageView.frame.size.width,
										   self.arrowImageView.frame.size.height);
	self.arrowImageView.center = CGPointMake(cX, self.arrowImageView.center.y - 3.f);
}

@end
