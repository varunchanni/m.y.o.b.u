//
//  UIColor+HexString.h
//  MFX Studios
//
//  Created by Raymond Kelly on 10/27/13.
//  Copyright (c) 2013 MFX Studios. All rights reserved.
//

//#import <UIKit/UIKit.h>

@interface UIColor_HexString : UIColor
+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length;

@end


@implementation UIColor_HexString : UIColor

+ (UIColor *) colorWithHexString: (NSString *) hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

/*
+ (NSString *)hexString_AARRGGBB_OfColor :(CGColorRef) colorRef {
    
    
    NSString * hexString;
    int _countComponents = CGColorGetNumberOfComponents(colorRef);
    const CGFloat *_components = CGColorGetComponents(colorRef);
    
    
    CGFloat alpha, red, blue, green;
    
    switch (_countComponents) {
        case 3: // #RGB
            
            alpha = 1.0;
            green = _components[1];
            blue  = _components[2];
            red   = _components[3];
            
            hexString = [NSString stringWithFormat:@"%f,%f,%f,%f",alpha,red,green,blue];
            break;
        case 6: // #RRGGBB
            break;
        case 4:// #ARGB

            alpha = _components[0];
            green = _components[1];
            blue  = _components[2];
            red   = _components[3];
        
            hexString = [NSString stringWithFormat:@"%f,%f,%f,%f",alpha,red,green,blue];
            break;
        case 8: // #AARRGGBB
            break;
        default:
            break;
    }

    return hexString;
}
*/
+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}



@end