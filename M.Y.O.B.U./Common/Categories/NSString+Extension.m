//
//  NSString+Extension.m
//  PrivateCam
//
//  Created by Prince Ugwuh on 8/26/12.
//  Copyright (c) 2012 MFX Studios. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (BOOL)isEmailString
{
	BOOL stricterFilter = YES; 
	NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
	NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:self];
}

- (NSString *)stringLowercaseFirstLetter
{
	
	NSMutableString *ret = [NSMutableString string];
	
	unichar ch = [self characterAtIndex:0];
	
	[ret appendFormat:@"%C",ch];
	ret = [NSMutableString stringWithString:[ret lowercaseString]];
	[ret appendFormat:@"%@",[self substringFromIndex:1]];
	
	return [ret stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)stringCapitalizeFirstLetter
{
    
	NSMutableString *ret = [NSMutableString string];
	
	unichar ch = [self characterAtIndex:0];
	
	[ret appendFormat:@"%C",ch];
	ret = [NSMutableString stringWithString:[ret capitalizedString]];
	[ret appendFormat:@"%@",[self substringFromIndex:1]];
	
	return [ret stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}


+ (NSString *) stringWithUUID
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuidString;
}

+ (NSString *)tinyURLWithURLString:(NSString *)urlString
{
    NSString *longURLString = [NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", urlString];
    NSURL *longURL = [NSURL URLWithString:longURLString];
    NSString *tinyURL = [NSString stringWithContentsOfURL:longURL encoding:NSASCIIStringEncoding error:nil];
    return tinyURL;
}

+ (NSString *) stringWithCurrencyDecimals:(NSString *)string{
    
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString * decimalPlacholders = @"000";
    
    if(string.length < 3)
    {
        decimalPlacholders = [decimalPlacholders substringToIndex:decimalPlacholders.length - string.length];
        string = [decimalPlacholders stringByAppendingString:string];
    }
    
    
    NSString *stringInFrontDecimal = [string substringToIndex:string.length-2];
    NSString *stringBehindDecimal = [string substringFromIndex:string.length-2];
    
    if([string rangeOfString:@"."].location != NSNotFound)
    {
        stringInFrontDecimal = [stringInFrontDecimal stringByReplacingOccurrencesOfString:@"." withString:@""];
        stringBehindDecimal = [stringBehindDecimal stringByReplacingOccurrencesOfString:@"." withString:@""];
    }
    
    return [NSString stringWithFormat:@"%@.%@", stringInFrontDecimal, stringBehindDecimal];
}

+ (NSString *) stringWithCurrencyCommas:(NSString *)string{
    
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSNumberFormatter *frmtr = [[NSNumberFormatter alloc] init];
    [frmtr setGroupingSize:3];
    [frmtr setGroupingSeparator:@","];
    [frmtr setUsesGroupingSeparator:YES];
    
    NSString * stringToEdit = string;
    
    //if decimal present
    NSRange decimalLocation = [string rangeOfString:@"."];
    if (decimalLocation.length > 0 ) {
        
        stringToEdit = [[string componentsSeparatedByString: @"."] objectAtIndex:0];
    }
    
    CGFloat doubleValue = [stringToEdit doubleValue];
    NSNumber *numberValue = [NSNumber numberWithDouble:doubleValue];
    NSString *commaString = [frmtr stringFromNumber:numberValue];
    
    //if decimal present
    if (decimalLocation.length > 0 ) {
        
        commaString = [NSString stringWithFormat:@"%@.%@",commaString, [[string componentsSeparatedByString: @"."] objectAtIndex:1]];
    }
    
    return commaString;
}

+ (NSString *) stringWithCurrency:(NSString*)string
{
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return [NSString stringWithFormat:@"$%@",[self stringWithCurrencyCommas:[self stringWithCurrencyDecimals:string]]];
}

+ (NSString *)stringByRemovingCurrencyCharacters:(NSString *)string
{
    return [[string stringByReplacingOccurrencesOfString:@"," withString:@""] stringByReplacingOccurrencesOfString:@"$" withString:@""];
}


@end
