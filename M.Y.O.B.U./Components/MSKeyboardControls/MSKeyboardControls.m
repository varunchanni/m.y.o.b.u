//
//  MSKeyboardControls.m
//  Based on BSKeyboardControls.m
//
//  Updated by Raymond Kelly on 11/05/13.
//  Created by Simon B. Støvring on 11/01/13.
//  Copyright (c) 2013 simonbs. All rights reserved.
//

#import "MSKeyboardControls.h"
#import "UINumberTextField.h"
#import "UICurrencyTextField.h"
#import "UIDateSelect.h"
#import "UIPickerTextField.h"

@interface MSKeyboardControls ()
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIBarButtonItem *doneButton;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UIBarButtonItem *saveButton;
@property (nonatomic, strong) UIBarButtonItem *segmentedControlItem;
@property (nonatomic, strong) NSArray * validateOptions;
@end

@implementation MSKeyboardControls

#pragma mark -
#pragma mark Lifecycle
/*
- (UIView *)activeField
{
    if(!self.activeField)
    {
        self.activeField = [[UIView alloc] init];
    }
    
    return self.activeField;
}*/

- (id)init
{
    return [self initWithFields:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    
    return [self initWithFields:nil];
}


- (void)initialize
{
    /*
    [self setToolbar:[[UIToolbar alloc] initWithFrame:self.frame]];
    [self.toolbar setBarStyle:UIBarStyleDefault];
    [self.toolbar setBackgroundColor:[UIColor whiteColor]];
    [self.toolbar setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth)];
    [self addSubview:self.toolbar];
    */
    
    /*
    [self setSegmentedControl:[[UISegmentedControl alloc] initWithItems:@[ NSLocalizedStringFromTable(@"Previous", @"MSKeyboardControls", @"Previous button title."),
                                                                           NSLocalizedStringFromTable(@"Next", @"MSKeyboardControls", @"Next button title.") ]]];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.segmentedControl setMomentary:YES];
    
    [self.segmentedControl setEnabled:NO forSegmentAtIndex:MSKeyboardControlsDirectionPrevious];
    [self.segmentedControl setEnabled:NO forSegmentAtIndex:MSKeyboardControlsDirectionNext];
    [self setSegmentedControlItem:[[UIBarButtonItem alloc] initWithCustomView:self.segmentedControl]];
*/
     }


- (id)initWithFields:(NSArray *)fields validateOptions:(NSArray *)validateOptions
{
    if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f)])
    {
        [self initialize];
        
        
        
        [self setCancelButton:[[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(cancelButtonPressed:)]];
        
        [self setSaveButton:[[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                               style:UIBarButtonItemStyleDone
                                                              target:self
                                                              action:@selector(saveButtonPressed:)]];
        
        
        
        //[self setVisibleControls:(MSKeyboardControlPreviousNext | MSKeyboardControlCancel | MSKeyboardControlSave)];
        
        [self setValidateOptions:validateOptions];
        [self setFields:fields];
        //[self createFormView];
    }
    
    return self;
}


- (id)initWithFields:(NSArray *)fields
{
    if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f)])
    {
        [self initialize];
        
        
        
        [self setDoneButton:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @"MSKeyboardControls", @"Done button title.")
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(doneButtonPressed:)]];
        
        [self setVisibleControls:(MSKeyboardControlPreviousNext | MSKeyboardControlDone)];
        
        [self setFields:fields];
    }
    
    return self;
}

- (void)setToolbarVisibility:(BOOL)visible
{
    self.toolbar.hidden = !visible;
    
    if(self.toolbar.hidden)
    {
        CGRect frame = CGRectMake(0,0,0,0);
        self.toolbar.frame = frame;
    }
    else
    {
        CGRect frame = CGRectMake(0,0,320,44);
        self.toolbar.frame = frame;
    }
}

/*
- (void)createFormView
{
    // Update this to handle different phone sizes
    UIScrollView * view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -200, 320, 200)];
    view.backgroundColor = [UIColor redColor];
    
    UIView * labelFrame = [[UIView alloc]initWithFrame:CGRectMake(5, self.frame.size.height - 10, 200, 30)];
    labelFrame.backgroundColor = [UIColor whiteColor];
    labelFrame.layer.cornerRadius = 5;
    labelFrame.layer.masksToBounds = YES;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(15, self.frame.size.height - 45, 250, 40)];
    [labelFrame addSubview:label];
    
    [view addSubview:labelFrame];
    //[view addSubview:text2];
    //[view addSubview:text3];
    
    [self addSubview:view];
}
*/
- (void)dealloc
{
    [self setFields:nil];
    [self setSegmentedControlTintControl:nil];
    [self setPreviousTitle:nil];
    [self setBarTintColor:nil];
    [self setNextTitle:nil];
    [self setDoneTitle:nil];
    [self setDoneTintColor:nil];
    [self setActiveField:nil];
    [self setToolbar:nil];
    [self setSegmentedControl:nil];
    [self setSegmentedControlItem:nil];
    [self setDoneButton:nil];
}

#pragma mark -
#pragma mark Public Methods
- (void)setActiveField:(id)activeField
{
    if (activeField != _activeField)
    {
        if ([self.fields containsObject:activeField])
        {
            _activeField = activeField;
        
            if (![activeField isFirstResponder])
            {
                [activeField becomeFirstResponder];
            }
        
            [self updateSegmentedControlEnabledStates];
        }
    }
}

- (void)setFields:(NSArray *)fields
{
    if (fields != _fields)
    {
        for (UIView *field in fields)
        {
            if ([field isKindOfClass:[UITextView class]])
            {
                [(UITextView *)field setInputAccessoryView:self];
            }
            else if ([field isKindOfClass:[UICurrencyTextField class]])
            {
                [(UICurrencyTextField *)field setInputAccessoryView:self];
            }
            else if ([field isKindOfClass:[UINumberTextField class]])
            {
                [(UINumberTextField *)field setInputAccessoryView:self];
            }
            else if ([field isKindOfClass:[UIDateSelect class]])
            {
                [(UIDateSelect *)field setInputAccessoryView:self];
            }
            else if([field isKindOfClass:[UISearchBar class]])
            {
                [(UISearchBar *)field setInputAccessoryView:self];
            }
            else if([field isKindOfClass:[UIPickerTextField class]])
            {
               [(UIPickerTextField *)field setInputAccessoryView:self];
            }
            else if ([field isKindOfClass:[UITextField class]])
            {
                [(UITextField *)field setInputAccessoryView:self];
            }
        }
        
        _fields = fields;
    }
}

- (void)setBarStyle:(UIBarStyle)barStyle
{
    if (barStyle != _barStyle)
    {
        [self.toolbar setBarStyle:barStyle];
        
        _barStyle = barStyle;
    }
}

- (void)setBarTintColor:(UIColor *)barTintColor
{
    if (barTintColor != _barTintColor)
    {
        [self.toolbar setTintColor:barTintColor];
        
        _barTintColor = barTintColor;
    }
}

- (void)setSegmentedControlTintControl:(UIColor *)segmentedControlTintControl
{
    if (segmentedControlTintControl != _segmentedControlTintControl)
    {
        [self.segmentedControl setTintColor:segmentedControlTintControl];
        
        _segmentedControlTintControl = segmentedControlTintControl;
    }
}

- (void)setPreviousTitle:(NSString *)previousTitle
{
    if (![previousTitle isEqualToString:_previousTitle])
    {
        [self.segmentedControl setTitle:previousTitle forSegmentAtIndex:MSKeyboardControlsDirectionPrevious];
        
        _previousTitle = previousTitle;
    }
}

- (void)setNextTitle:(NSString *)nextTitle
{
    if (![nextTitle isEqualToString:_nextTitle])
    {
        [self.segmentedControl setTitle:nextTitle forSegmentAtIndex:MSKeyboardControlsDirectionNext];
        
        _nextTitle = nextTitle;
    }
}

- (void)setDoneTitle:(NSString *)doneTitle
{
    if (![doneTitle isEqualToString:_doneTitle])
    {
        [self.doneButton setTitle:doneTitle];
        
        _doneTitle = doneTitle;
    }
}

- (void)setDoneTintColor:(UIColor *)doneTintColor
{
    if (doneTintColor != _doneTintColor)
    {
        [self.doneButton setTintColor:doneTintColor];
        
        _doneTintColor = doneTintColor;
    }
}

- (void)setVisibleControls:(MSKeyboardControl)visibleControls
{
    if (visibleControls != _visibleControls)
    {
        _visibleControls = visibleControls;

        [self.toolbar setItems:[self toolbarItems]];
    }
}

#pragma mark -
#pragma mark Private Methods

- (void)segmentedControlValueChanged:(id)sender
{
    switch (self.segmentedControl.selectedSegmentIndex)
    {
        case MSKeyboardControlsDirectionPrevious:
            [self selectPreviousField];
            break;
        case MSKeyboardControlsDirectionNext:
            [self selectNextField];
            break;
        default:
            break;
    }
}

- (void)doneButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(keyboardControlsDonePressed:)])
    {
        [self.delegate keyboardControlsDonePressed:self];
    }
}

- (void)cancelButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(keyboardControlsCancelPressed:)])
    {
        [self.delegate keyboardControlsCancelPressed:self];
    }
}

- (void)saveButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(keyboardControlsSavePressed:)])
    {
        [self.delegate keyboardControlsSavePressed:self];
    }
}
- (void)updateSegmentedControlEnabledStates
{
    NSInteger index = [self.fields indexOfObject:self.activeField];
    if (index != NSNotFound)
    {
        [self.segmentedControl setEnabled:(index > 0) forSegmentAtIndex:MSKeyboardControlsDirectionPrevious];
        [self.segmentedControl setEnabled:(index < [self.fields count] - 1) forSegmentAtIndex:MSKeyboardControlsDirectionNext];
    }
}

- (void)selectPreviousField
{
    NSInteger index = [self.fields indexOfObject:self.activeField];
    if (index > 0)
    {
        index -= 1;
        UIView *field = [self.fields objectAtIndex:index];
        [self setActiveField:field];
        
        if ([self.delegate respondsToSelector:@selector(keyboardControls:selectedField:inDirection:)])
        {
            [self.delegate keyboardControls:self selectedField:field inDirection:MSKeyboardControlsDirectionPrevious];
        }
    }
}

- (void)selectNextField
{
    NSInteger index = [self.fields indexOfObject:self.activeField];
    if (index < [self.fields count] - 1)
    {
        index += 1;
        UIView *field = [self.fields objectAtIndex:index];
        [self setActiveField:field];
        
        if ([self.delegate respondsToSelector:@selector(keyboardControls:selectedField:inDirection:)])
        {
            [self.delegate keyboardControls:self selectedField:field inDirection:MSKeyboardControlsDirectionNext];
        }
    }
}

- (NSArray *)toolbarItems
{
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:3];
    if (self.visibleControls & MSKeyboardControlPreviousNext)
    {
        //[items addObject:self.segmentedControlItem];
    }
    
    if (self.visibleControls & MSKeyboardControlDone)
    {
        [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
        [items addObject:self.doneButton];
    }
    
    if (self.visibleControls & MSKeyboardControlCancel)
    {
        [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
        [items addObject:self.cancelButton];
    }
    
    if (self.visibleControls & MSKeyboardControlSave)
    {
        [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
        [items addObject:self.saveButton];
    }
    
    return items;
}

@end
