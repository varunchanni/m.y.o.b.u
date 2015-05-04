//
//  MSUIManager.m
//  The Envelope Filler
//
//  Created by Raymond Kelly on 10/29/13.
//  Copyright (c) 2013 MFX Studios. All rights reserved.
//

#import "MSUIManager.h"
#import "WithdrawerViewController.h"
#import "UIColor+HexString.h"


@interface MSUIManager()

@end

@implementation MSUIManager

+ (id)sharedManager
{
	static MSUIManager *_sharedManager = nil;
    static dispatch_once_t onceQueue;
	
    dispatch_once(&onceQueue, ^{
        _sharedManager = [[self alloc] init];
    });
	
	return _sharedManager;
}
- (void)initializeUI
{
    self.myobuBlue = [UIColor colorWithRed:103.0/255 green:156.0/255 blue:189.0/255 alpha:1.0f];
    self.myobuRed = [UIColor colorWithRed:189.0/255 green:67.0/255 blue:0.0/255 alpha:1.0f];
    self.myobuGreen = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:0.4f];
    self.myobuGreenBold = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:1.0f];
    
    /*
    //self.MainNavigationController.b
    self.mainScreenBounds = [[UIScreen mainScreen] bounds];
    
    
    self.notifier = [[MSQuickNotifier alloc] initWithFrame:CGRectMake(0, 20, 320, 20)];
    */
}

- (CAGradientLayer*) whiteToColorGradient:(UIColor *)color {
    
    NSArray *colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, color.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.8];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;

    return headerLayer;
    
}
+ (void)alertWithTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil, nil];
    [alert show];
}

+ (NSString *) getLongDateString:(NSDate *)date
{
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
    [monthFormatter setDateFormat:@"MM"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd, YYYY"];
    
    NSString * monthName = [self getMonthNameFromStringNumber:[NSString stringWithFormat:@"%@",
                                                               [monthFormatter stringFromDate:date]]];
                            
    return [NSString stringWithFormat:@"%@ %@", monthName, [dateFormatter stringFromDate:date]];
}

+ (NSString *) getTimeString:(NSDate *)date
{
    NSDateFormatter *hourFormatter = [[NSDateFormatter alloc] init];
    [hourFormatter setDateFormat:@"HH"];
    
    NSDateFormatter *minuteFormatter = [[NSDateFormatter alloc] init];
    [minuteFormatter setDateFormat:@"mm"];
    
    NSString * hour = [NSString stringWithFormat:@"%@",[hourFormatter stringFromDate:date]];
    NSString * minutes = [NSString stringWithFormat:@"%@",[minuteFormatter stringFromDate:date]];
    
    
    
    return [self getTimeFromString:hour andMinutes:minutes];
}

+ (NSString *)getTimeFromString:(NSString *)hour andMinutes:(NSString *)minutes
{
    NSString * am_pm = @"";
    NSInteger hourValue = [hour intValue];
    
    am_pm = (hourValue < 12) ? @"AM" : @"PM";
    
    hourValue = (hourValue >= 13) ? hourValue -= 12: hourValue;
    
    return [NSString stringWithFormat:@"%ld:%@ %@", (long)hourValue, minutes, am_pm];
}

+ (NSString *)getMonthNameFromStringNumber:(NSString *)month
{
    NSInteger monthInt = [month intValue];
    return [self getMonthNameFromInt:monthInt];
}

+ (NSString *)getMonthNameFromInt:(NSInteger)month
{
    NSString * monthName = @"";
    
    switch (month) {
        case 1:
            monthName = @"January";
            break;
        case 2:
            monthName = @"Febuary";
            break;
        case 3:
            monthName = @"March";
            break;
        case 4:
            monthName = @"April";
            break;
        case 5:
            monthName = @"May";
            break;
        case 6:
            monthName = @"June";
            break;
        case 7:
            monthName = @"July";
            break;
        case 8:
            monthName = @"August";
            break;
        case 9:
            monthName = @"September";
            break;
        case 10:
            monthName = @"October";
            break;
        case 11:
            monthName = @"November";
            break;
        case 12:
            monthName = @"December";
            break;
        default:
            break;
    }
    return monthName;
}




+ (NSString *) addDecimalsToString:(NSString *)string isCurrency:(BOOL)isCurrency {
    
    NSString * decimalValue;
    NSString * stringInFrontDecimal;
    NSString * stringBehindDecimal;
    
    NSRange decimalLocation = [string rangeOfString:@"."];
    if (decimalLocation.length > 0 )
    {
        NSArray *split = [string componentsSeparatedByString:@"."];
        stringInFrontDecimal = [split objectAtIndex:0];
        stringBehindDecimal = [split objectAtIndex:1];
        
        if(stringBehindDecimal.length < 2) stringBehindDecimal = [stringBehindDecimal stringByAppendingString:@"0"];
    }
    else
    {
        stringInFrontDecimal = string;
        stringBehindDecimal = @"00";
    }
    
    if(isCurrency)
    {
        decimalValue = [NSString stringWithFormat:@"$%@.%@",
                        [self addCurrencyStyleCommaToString:stringInFrontDecimal ],
                        stringBehindDecimal];
    }
    else
    {
        decimalValue = [NSString stringWithFormat:@"%@.%@", stringInFrontDecimal, stringBehindDecimal];
    }
    
    return decimalValue;
}

+ (NSString *) addCurrencyStyleCommaToString:(NSString *)string{
    
    
    NSNumberFormatter *frmtr = [[NSNumberFormatter alloc] init];
    [frmtr setGroupingSize:3];
    [frmtr setGroupingSeparator:@","];
    [frmtr setUsesGroupingSeparator:YES];
    
    string = [MSUIManager stripCommasFromString:string];
    string = [MSUIManager stripDollarSignFromString:string];
    NSNumber *numberValue = [NSNumber numberWithFloat:[string floatValue]];
    NSString *commaString = [frmtr stringFromNumber:numberValue];
    
    return commaString;
}

+ (NSString *) addCurrencyStyleCommaToDouble:(double)value{
    
    NSString * string = [NSString stringWithFormat:@"%.2f", value];
    
    NSArray* data = [string componentsSeparatedByString: @"."];
    NSString* beforeDecimal = [data objectAtIndex: 0];
    NSString*afterDecimal = [@"." stringByAppendingString:[data objectAtIndex:1]];
    
    NSNumberFormatter *frmtr = [[NSNumberFormatter alloc] init];
    [frmtr setGroupingSize:3];
    [frmtr setGroupingSeparator:@","];
    [frmtr setUsesGroupingSeparator:YES];
    
    CGFloat doubleValue = [beforeDecimal doubleValue];
    NSNumber *numberValue = [NSNumber numberWithDouble:doubleValue];
    NSString *commaString = [frmtr stringFromNumber:numberValue];
    
    
    return [@"$" stringByAppendingString:[commaString stringByAppendingString:afterDecimal]];
}

+ (NSString *) stripCommasFromString:(NSString *)string
{
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@","];
    return [[string componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
}

+ (NSString *) stripDollarSignFromString:(NSString *)string
{
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"$"];
    return [[string componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
}

+ (NSString *) stripDecimalsFromString:(NSString *)string
{
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"."];
    return [[string componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
}

+ (double) convertStringToDoubleValue:(NSString *)stringValue
{
    stringValue = [MSUIManager stripCommasFromString:stringValue];
    stringValue = [MSUIManager stripDollarSignFromString:stringValue];
    
    return [stringValue doubleValue];
}

+ (NSString *)shortDateFormat:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)longDateFormat:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    return [dateFormatter stringFromDate:date];
}

+ (void)findFonts
{
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
}

+ (BOOL)isIPhone5
{
    CGRect frame = [[[[UIApplication sharedApplication] delegate] window] frame];
    NSInteger i = frame.size.height;
    
    if(i == 568)
    {
        return YES;
    }
    
    return NO;
}

+ (UIColor *)colorFrom:(NSString *)string
{
    return [UIColor_HexString colorWithHexString:string];
}

- (UIActivityViewController *)SharePressed:(UIView *)view
{
    NSArray *objectsToShare = @[[self getScreenShot:view]];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    // Exclude any activities except AirDrop.
    NSArray *excludedActivities = @[UIActivityTypePostToWeibo, UIActivityTypeAddToReadingList,
                                    UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,
                                    UIActivityTypePostToTencentWeibo];
    controller.excludedActivityTypes = excludedActivities;
    
    // Present the controller
    return controller;
}

-(UIImage *)getScreenShot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



#pragma Tranistion Delegate
- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    if([toViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navController = (UINavigationController *)toViewController;
        toViewController = [[navController viewControllers] objectAtIndex:0];
    }
    
    
    if([toViewController isKindOfClass:[WithdrawerViewController class]])
    {
        CGRect startFrame = [(WithdrawerViewController *)toViewController startingFrame];
        CGRect endFrame = CGRectMake(0, 0, 320, 480);
        
        if([MSUIManager isIPhone5])
        {
            endFrame = CGRectMake(0, 0, 320, 568);
        }
        
        fromViewController.view.userInteractionEnabled = NO;
        
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        toViewController.view.frame = startFrame;
        toViewController.view.alpha = .4;
        
        [UIView animateWithDuration:.5 animations:^{
            fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
            toViewController.view.frame = endFrame;
            toViewController.view.alpha = 1;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    
    
    // Set our ending frame. We'll modify this later if we have to
    
}
- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    CGRect endFrame = CGRectMake(0, 0, 320, 480);
    
    if([MSUIManager isIPhone5])
    {
        endFrame = CGRectMake(0, 0, 320, 568);
    }
    
    toViewController.view.frame = endFrame;
    fromViewController.view.userInteractionEnabled = YES;
    toViewController.view.userInteractionEnabled = YES;
    toViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    
    [transitionContext.containerView addSubview:toViewController.view];
    [transitionContext completeTransition:YES];
}

- (void)pushFadeViewController:(UINavigationController *)fromNavigationController toViewController:(UIViewController *)toViewController
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
	[fromNavigationController.view.layer addAnimation:transition forKey:nil];
	[fromNavigationController pushViewController:toViewController animated:NO];
}

- (void)popFadeViewController:(UINavigationController *)toNavigationController
{
	CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
	[toNavigationController.view.layer addAnimation:transition forKey:nil];
	[toNavigationController popViewControllerAnimated:NO];
}

- (void)pushAppearController:(UINavigationController *)fromNavigationController toViewController:(UIViewController *)toViewController
{
    //CATransition *transition = [CATransition animation];
    //transition.duration = 0.5f;
    //transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //transition.type = kCATransitionFade;
    
	//[fromNavigationController.view.layer addAnimation:transition forKey:nil];
	[fromNavigationController pushViewController:toViewController animated:NO];
}

- (void)popAppearController:(UINavigationController *)toNavigationController
{
    //CATransition *transition = [CATransition animation];
    //transition.duration = 0.5f;
    //transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //transition.type = kCATransitionFade;
    
	//[fromNavigationController.view.layer addAnimation:transition forKey:nil];
	[toNavigationController popViewControllerAnimated:NO];
}

- (void)pushRevealViewController:(UINavigationController *)fromNavigationController toViewController:(UIViewController *)toViewController
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    [fromNavigationController.view.layer addAnimation:transition forKey:nil];
    [fromNavigationController pushViewController:toViewController animated:NO];
}

- (void)popRevealViewController:(UINavigationController *)toNavigationController
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    [toNavigationController.view.layer addAnimation:transition forKey:nil];
    [toNavigationController popViewControllerAnimated:NO];
}
@end
