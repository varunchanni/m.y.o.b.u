//
//  MYOBViewController.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 12/8/13.
//  Copyright (c) 2013 MYOB University. All rights reserved.
//

#import "MYOBViewController.h"
#import "LiveFrost.h"
#import "UICustomTextField.h"
#import "MYOBUTextView.h"


@interface MYOBViewController ()
@property (nonatomic, assign) BOOL screenMoved;
@property (nonatomic, assign) BOOL screenShouldReset;
@property (nonatomic, strong) UIView * textViewDisplayView;
@property (nonatomic, strong) UITextView * textViewDisplay;
@end

@implementation MYOBViewController

- (MSDataManager *)dataManager
{
	return [MSDataManager sharedManager];
}

- (MSUIManager *)uiManager
{
	return [MSUIManager sharedManager];
}

- (MSServiceManager *)serviceManager
{
	return [MSServiceManager sharedManager];
}


- (UIView *)dimOverlay {
    
    if (_dimOverlay == nil)
    {
        _dimOverlay = [[LFGlassView alloc] initWithFrame:self.view.frame];
        _dimOverlay.blurRadius = 1.0;
        
        UIView * view = [[UIView alloc] initWithFrame:self.view.frame];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        
        [_dimOverlay addSubview:view];
        [self.view addSubview:_dimOverlay];
    }
    
    return _dimOverlay;
}




- (UIImage *)imageWithGaussianBlur:(UIImage *)image {
    
    
    
    float weight[5] = {0.2270270270, 0.1945945946, 0.1216216216, 0.0540540541, 0.0162162162};
    // Blur horizontally
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height) blendMode:kCGBlendModePlusLighter alpha:weight[0]];
    for (int x = 1; x < 5; ++x) {
        [image drawInRect:CGRectMake(x, 0, image.size.width, image.size.height) blendMode:kCGBlendModePlusLighter alpha:weight[x]];
        [image drawInRect:CGRectMake(-x, 0, image.size.width, image.size.height) blendMode:kCGBlendModePlusLighter alpha:weight[x]];
    }
    UIImage *horizBlurredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // Blur vertically
    UIGraphicsBeginImageContext(image.size);
    [horizBlurredImage drawInRect:CGRectMake(0, 0, image.size.width, image.size.height) blendMode:kCGBlendModePlusLighter alpha:weight[0]];
    for (int y = 1; y < 5; ++y) {
        [horizBlurredImage drawInRect:CGRectMake(0, y, image.size.width, image.size.height) blendMode:kCGBlendModePlusLighter alpha:weight[y]];
        [horizBlurredImage drawInRect:CGRectMake(0, -y, image.size.width, image.size.height) blendMode:kCGBlendModePlusLighter alpha:weight[y]];
    }
    UIImage *blurredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //
    return blurredImage;
}

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
    self.dimOverlay.alpha = 0;
    self.keyboardControlsSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [self.keyboardControlsSingleTap setNumberOfTapsRequired:1];
    [self.keyboardControlsSingleTap setNumberOfTouchesRequired:1];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    // unregister for keyboard notifications while moving to the other screen.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    // register keyboard notifications to appear / disappear the keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // unregister for keyboard notifications while moving to the other screen.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    // register keyboard notifications to appear / disappear the keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while moving to the other screen.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    self.dataManager.dimOverlay = self.dimOverlay;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fadeInObject:(UIView *)view WithInterval:(NSTimeInterval)interval toAlpha:(NSNumber *)alpha
           completed:(void (^)(BOOL finshed))done
{
    [UIView animateWithDuration:interval animations:^{
        view.alpha = [alpha floatValue];
    }completion:^(BOOL finished) {
        done(finished);
    }];
}

- (void)resignOnTap:(id)sender {
    
    [self resetView];
}

- (void)releaseControl:(id)sender
{
    //[self.textViewDisplay resignFirstResponder];
    [self resetView];
}

- (void)createTextViewDisplay
{
    self.textViewDisplayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.textViewDisplayView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.9];
    
    self.textViewDisplay = [[UITextView alloc] initWithFrame:CGRectMake(10, 40, 300, 210)];
    self.textViewDisplay.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7];
    self.textViewDisplay.delegate = self;
    self.textViewDisplay.tag = 100;
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [doneButton addTarget:self
               action:@selector(releaseControl:)
     forControlEvents:UIControlEventTouchUpInside];
    [doneButton setTitle:@"Close" forState:UIControlStateNormal];
    doneButton.frame = CGRectMake(250.0, 5.0, 60.0, 40.0);
    [doneButton setTintColor:[UIColor whiteColor]];
    
    [self.textViewDisplayView addSubview:doneButton];
    [self.textViewDisplayView addSubview:self.textViewDisplay];
    [self.view addSubview:self.textViewDisplayView];
}

#define INPUT_MAX_Y_TO_SHOW_KEYBOARD 200
#define SCREEN_UP_ANIMATION_DURATION 0.4
#define SCREEN_DOWN_ANIMATION_DURATION 0.2
#define ANIMATION_DELAY 0.1
#define KEYBOARD_OFFSET 0


- (void)keyboardWillAppear
{
    [self setActiveField];
    [self animateResponderIntoView];
    

    if([self.dataManager.activeResponder class] == [UICustomTextField class])
    {
        UICustomTextField *activeResponder = (UICustomTextField *)self.dataManager.activeResponder;
        if (activeResponder.accessoryBackgroundType == CustomAccessoryViewTypeBlurAndDim)
        {
            [self dimAndBlurScreen];
        }
    }
    else if([self.dataManager.activeResponder class] == [MYOBUTextView class])
    {
        MYOBUTextView *activeResponder = (MYOBUTextView *)self.dataManager.activeResponder;
        if (activeResponder.accessoryBackgroundType == CustomAccessoryViewTypeBlurAndDim)
        {
            [self dimAndBlurScreen];
        }
    }
    
}

- (void)keyboardWillHide
{
    [self hideDimAndBlurScreen];
    
}



// This is a recursive function
- (UIView *)findFirstResponder:(UIView *)view {
    
    if ([view isFirstResponder]) {
        
    return view; // Base case
    }
    for (UIView *subView in [view subviews]) {
        if ([self findFirstResponder:subView]) return subView; // Recursion
    }
    return nil;
}

- (void)dimAndBlurScreen {
    
    //add dim
    self.dimOverlay.alpha = 1;
    
}

- (void)hideDimAndBlurScreen {
    
    //remove dim
    self.dimOverlay.alpha = 0;
    
}

- (void)setActiveField
{
    [self.keyboardControls.fields enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL *stop) {
        if(obj.isFirstResponder)
        {
            self.keyboardControls.activeField = obj;
            *stop = YES;
        }
    }];
}

- (void)animateResponderIntoView
{
    //UITextField * activeField = (UITextField *)self.keyboardControls.activeField;
    if(self.shouldAnimateScreen)
    {
    NSInteger distance = self.Form_Y_Origin;
    if(distance == 0)
    {
        distance = [self distanceToAnimateScreenToMakeResponderVisible];
    }
    
    
    CGRect frame = self.view.frame;
    if(frame.origin.y < 0)
    {
       distance = distance + frame.origin.y;
    }
    frame.origin.y -= distance;
    /*
    if(distance != frame.origin.y)
    {
        NSInteger fieldY = activeField.frame.origin.y;
        
        if((fieldY + distance) < 0)
        {
            frame.origin.y = (fieldY - fieldY*2) + 10;
        }
        else
        {
            frame.origin.y = distance;
        }
        
        */
        
        [UIView animateWithDuration:SCREEN_UP_ANIMATION_DURATION
                              delay:ANIMATION_DELAY
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.view.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             self.screenMoved = YES;
                         }];
    //}
    
    [self.view addGestureRecognizer:self.keyboardControlsSingleTap];
    }
}

- (NSInteger)distanceToAnimateScreenToMakeResponderVisible
{
    //NSInteger distanceToAnimateScreen = 0;
    
    CGRect frame =[self.keyboardControls.activeField convertRect:[self.keyboardControls.activeField frame] toView:self.view];
    NSInteger distanceToAnimateScreen = frame.origin.y;
    
    if(distanceToAnimateScreen > INPUT_MAX_Y_TO_SHOW_KEYBOARD)
    {
        distanceToAnimateScreen = INPUT_MAX_Y_TO_SHOW_KEYBOARD;
    }
    /*
    //CGRect frame = [self.keyboardControls.activeField frame];
    NSInteger frameY = frame.origin.y;
    
    if(frameY > INPUT_MAX_Y_TO_SHOW_KEYBOARD)
    {
        distanceToAnimateScreen = INPUT_MAX_Y_TO_SHOW_KEYBOARD - frameY;
    }
    */
    return distanceToAnimateScreen;
}


#pragma TextField Base Delegates
- (void)base_textFieldDidBeginEditing:(UITextField *)textField {
    
    textField.placeholder = @"";
    self.screenShouldReset = NO;
    self.keyboardControls.activeField = textField;
    [self animateResponderIntoView];
    
    if([textField class] == [UICustomTextField class])
    {
        self.dataManager.activeResponder = (UICustomTextField *)textField;
    }
}

- (void)base_textFieldDidEndEditing:(UITextField *)textField
{
    self.dataManager.activeResponder = nil;
    //[self resetView];
    /*
    if(self.screenMoved)
    {
        self.screenShouldReset = YES;
        
        // adds small delay that stops jumpy behavior //[self resetView]; = jumpy
        [NSTimer scheduledTimerWithTimeInterval:0.1
                                         target:self
                                        selector:@selector(resetView)
                                       userInfo:nil
                                         repeats:NO];
    }
     */
}



#pragma TextView Base Delegates

- (void)base_textViewDidBeginEditing:(UITextView *)textView
{
    if([textView class] == [MYOBUTextView class])
    {
        self.dataManager.activeResponder = (MYOBUTextView *)textView;
    }
    
    /*
    
    if(!self.textViewDisplayView)
    {
        [self createTextViewDisplay];
    }
    
    self.textViewDisplay.text = textView.text;
    self.textViewDisplayView.hidden = NO;
    */
    
    self.keyboardControls.activeField = textView;
}

- (void)base_textViewDidEndEditing:(UITextView *)textView
{
    self.dataManager.activeResponder = nil;
    self.textViewDisplay.delegate = self;
}

- (void)base_textViewDidChange:(UITextView *)textView
{
    if(textView.tag == 100)
    {
        [(UITextView *)self.keyboardControls.activeField setText:textView.text];
    }
    else
    {
        self.textViewDisplay.text = textView.text;
    }
}

-(BOOL)base_textFieldShouldReturn:(UITextField *)textField
{
    [self resetView];
    
    return NO;
}

#pragma mark Keyboard Controls Base Delegate
- (void)base_keyboardControlsDonePressed:(MSKeyboardControls *)keyboardControls
{
   [self.keyboardControls.activeField resignFirstResponder];
}

- (void)base_keyboardControlsCancelPressed:(MSKeyboardControls *)keyboardControls
{
    [self.keyboardControls.activeField resignFirstResponder];
}

- (void)base_keyboardControlsSavePressed:(MSKeyboardControls *)keyboardControls
{
    [self.keyboardControls.activeField resignFirstResponder];
}


#pragma private methods
- (void)resetView
{
    //if(self.screenShouldReset)
    {
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        [UIView animateWithDuration:SCREEN_DOWN_ANIMATION_DURATION
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                                self.view.frame = frame;
                                
                            } completion:^(BOOL finished) {
                                self.screenMoved = NO;
                                [self.keyboardControls.activeField resignFirstResponder];
                            }];
        
        [self.view removeGestureRecognizer:self.keyboardControlsSingleTap];
    }
    
    self.textViewDisplayView.hidden = YES;
}

- (void)hideKeyboard
{
   [self resetView];
}

#pragma mark UITextview delegate
- (void)textViewDidChange:(UITextView *)textView
{
    textView.text = self.textViewDisplay.text;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}
@end
