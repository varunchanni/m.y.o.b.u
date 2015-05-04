//
//  MSPickerViewButton.m
//  The Envelope Filler
//
//  Created by Raymond Kelly on 10/30/13.
//  Copyright (c) 2013 MFX Studios. All rights reserved.
//

#import "MSPickerViewButton.h"
#import "MSUIManager.h"

@interface MSPickerViewButton()
@property (nonatomic, strong) UIToolbar * toolBar;
@property (nonatomic, strong) UIPickerView * pickerView;
@property (nonatomic, strong) MSUIManager * uiManager;
@end

@implementation MSPickerViewButton


- (MSUIManager *)uiManager
{
    return [MSUIManager sharedManager];
}

#pragma mark - initialization
- (id)init{
    self = [super init];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}


- (void)initialize
{
    CGRect toolbarFrame = CGRectMake(0, 0, 320, 30);
    CGRect pickerFrame = CGRectMake(0, 30, 320, 100);
    
    self.toolBar = [[UIToolbar alloc] initWithFrame:toolbarFrame];
    self.pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    
    //[self.uiManager.MainNavigationController.view addSubview:self.toolBar];
    [self.superview addSubview:self.pickerView];
}

@end
