//
//  MSUIManager.h
//  The Envelope Filler
//
//  Created by Raymond Kelly on 10/29/13.
//  Copyright (c) 2013 MFX Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "TransitionAnimator.h"
//#import "MSQuickNotifier.h"

@interface MSUIManager : NSObject <TransitionAnimatorDelegate>
@property (nonatomic, strong) UIColor * myobuBlue;
@property (nonatomic, strong) UIColor * myobuGreen;
@property (nonatomic, strong) UIColor * myobuGreenBold;
@property (nonatomic, strong) UIColor * myobuOrange;
@property (nonatomic, strong) UIColor * myobuRed;
+ (id)sharedManager;


//init
- (void)initializeUI;

//Static functions

+ (void)alertWithTitle:(NSString *)title andMessage:(NSString *)message;
+ (NSString *) getLongDateString:(NSDate *)date;
+ (NSString *) getTimeString:(NSDate *)date;
+ (NSString *) addDecimalsToString:(NSString *)string isCurrency:(BOOL)isCurrency;
//+ (NSString *) addCurrencyStyleCommaToString:(NSString *)string;
+ (NSString *) stripCommasFromString:(NSString *)string;
+ (NSString *) stripDollarSignFromString:(NSString *)string;
+ (NSString *) stripDecimalsFromString:(NSString *)string;
+ (NSString *) addCurrencyStyleCommaToDouble:(double)doubleValue;
+ (double) convertStringToDoubleValue:(NSString *)stringValue;
+ (NSString *) shortDateFormat:(NSDate *)date;
+ (NSString *)longDateFormat:(NSDate *)date;

+ (void)findFonts;
+ (BOOL)isIPhone5;
+ (UIColor *)colorFrom:(NSString *)string;


- (CAGradientLayer *) whiteToColorGradient:(UIColor *)color;
- (UIActivityViewController *)SharePressed:(UIView *)view;
- (void)pushFadeViewController:(UINavigationController *)fromNavigationController toViewController:(UIViewController *)toViewController;
- (void)popFadeViewController:(UINavigationController *)toNavigationController;
//- (void)pushFadePinViewController:(UINavigationController *)fromNavigationController toViewController:(UIViewController *)toViewController;
- (void)pushAppearController:(UINavigationController *)fromNavigationController toViewController:(UIViewController *)toViewController;
- (void)popAppearController:(UINavigationController *)toNavigationController;
- (void)pushRevealViewController:(UINavigationController *)fromNavigationController toViewController:(UIViewController *)toViewController;
- (void)popRevealViewController:(UINavigationController *)toNavigationController;

/*
- (UIImage *)getScreenShot;
- (UIColor *)getColorFromHexString:(NSString *)hexString;
- (void)ensureTextfieldIsInView:(UITextField *)textfield;
- (void)resetViewFromTextfield:(UITextField *)textfield;
 */
@end
