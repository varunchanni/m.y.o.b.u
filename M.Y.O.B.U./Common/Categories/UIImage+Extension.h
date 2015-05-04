//
//  UIImage+Resize.h
//  PrivateCam
//
//  Created by Prince Ugwuh on 8/25/12.
//  Copyright (c) 2012 MFX Studios. All rights reserved.
//

@interface UIImage (Extension)
- (UIImage *)thumbnailImageWithSize:(CGSize)size;
+ (UIImage *)maskImage:(UIImage *)image withMask:(UIImage *)maskImage;
@end
