//
//  MSProfileButton.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 3/7/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "MSProfileButton.h"
#import "UserProfileController.h"
#import "MSDataManager.h"
#import "MSUIManager.h"

@interface MSProfileButton()
@property (nonatomic, strong) MSDataManager *dataManager;
@property (nonatomic, strong) MSUIManager *uiManager;
@property (nonatomic, strong) UIImageView *profileImage;
@end

@implementation MSProfileButton

- (MSDataManager *)dataManager
{
	return [MSDataManager sharedManager];
}

- (MSUIManager *)uiManager
{
	return [MSUIManager sharedManager];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.profileImage = [[UIImageView alloc] initWithFrame:frame];
        [self AddProfileWithCircleMask];
        [self addTarget:self action:@selector(userViewPressed:) forControlEvents:UIControlEventTouchUpInside];
        //[self addTarget:self action:@selector(quickViewPressed:) forControlEvents:UIControlEventTouchUpInside];
        //[self addTarget:self action:@selector(userViewPressed:) forControlEvents:UIControlEventTouchDownRepeat];
    }
    return self;
}


-(void)AddProfileWithCircleMask
{
     //set the original image first
     [self.profileImage setImage:[UIImage imageNamed:@"guest_icon_thumb"]];
     self.profileImage.contentMode = UIViewContentModeScaleAspectFill;
     self.profileImage.clipsToBounds = YES;
     self.profileImage.layer.borderWidth = 1.0f;
     self.profileImage.layer.cornerRadius = 20.0f;
     self.profileImage.layer.borderColor = self.uiManager.myobuGreen.CGColor;
    
    
    
     CGRect frame = self.profileImage.frame;
     CGFloat imageCentreX = frame.size.width/2;
     CGFloat imageCentreY = frame.size.height/2;
     CGFloat radius = imageCentreX;
    
     CGContextRef context = CGBitmapContextCreate(NULL, self.bounds.size.width, self.bounds.size.height, 8, 4 * self.bounds.size.width, CGColorSpaceCreateDeviceRGB(), (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
     CGContextAddArc(context, imageCentreX, imageCentreY, radius, 0, M_PI*2.0, YES);
 
     CGContextClosePath(context);
     CGContextClip(context);
     CGContextDrawImage(context, self.bounds, self.profileImage.image.CGImage);
     CGImageRef imageMasked = CGBitmapContextCreateImage(context);
     CGContextRelease(context);
     UIImage *newImage = [UIImage imageWithCGImage:imageMasked];
     CGImageRelease(imageMasked);
     
     [self.profileImage setImage:newImage];
     UIGraphicsEndImageContext();
    
    [self addSubview:self.profileImage];
}

- (void)userViewPressed:(id)sender {
    
    
   
    UserProfileController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                                 instantiateViewControllerWithIdentifier:@"UserProfileController"];

    [self.uiManager pushFadeViewController:self.parentNavController toViewController:viewController];
    
}

- (void)quickViewPressed:(id)sender {
    
    NSLog(@"quickViewPressed");
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
