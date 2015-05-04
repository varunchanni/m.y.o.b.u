//
//  UIImage+Resize.h
//  PrivateCam
//
//  Created by Prince Ugwuh on 8/25/12.
//  Copyright (c) 2012 MFX Studios. All rights reserved.
//

#import "UIImage+Extension.h"
#import <ImageIO/ImageIO.h>

@implementation UIImage (Extension)

- (UIImage *)thumbnailImageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *i = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return i;
}

+ (UIImage *)maskImage:(UIImage *)image withMask:(UIImage *)maskImage
{
	CGImageRef maskRef = maskImage.CGImage;
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
	CGImageRef masked = CGImageCreateWithMask(image.CGImage, mask);
    UIImage *img = [UIImage imageWithCGImage:masked];
    CFRelease(mask);
    CFRelease(masked);
	return img;
}

@end
