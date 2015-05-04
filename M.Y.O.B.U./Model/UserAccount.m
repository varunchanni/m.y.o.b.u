//
//  UserAccount.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 12/8/13.
//  Copyright (c) 2013 MYOB University. All rights reserved.
//

#import "UserAccount.h"
#import "MSServiceManager.h"
#import "MSUIManager.h"

#define kInvalidName                "Invalid Name"
#define kInvalidEmail               "Invalid Email"
#define kInvalidPassword            "Invalid Password"
#define kInvalidFirstNameMessage    "Please enter a valid first name."
#define kInvalidLastNameMessage     "Please enter a valid last name."
#define kInvalidEmailMessage        "Please enter a valid email address.";
#define kInvalidPasswordMessage     "Please enter a valid password."
#define kNonMatchedEmailMessage     "Email's do not match! Please re-enter email address.";
#define kNonMatchedPasswordMessage  "Password's do not match! Please re-enter password.";
#define kOKMessage                  "OK"

static const NSInteger minPasswordLength = 6;
static const NSInteger maxPasswordLength = 15;

@interface UserAccount()
@property (nonatomic, strong, readwrite) NSString * userId;
@property (nonatomic, strong, readwrite) NSString * accountId;
@property (nonatomic, strong, readwrite) NSString * username;
@property (nonatomic, strong, readwrite) NSString * firstname;
@property (nonatomic, strong, readwrite) NSString * lastname;
@property (nonatomic, strong, readwrite) NSString * email;
@property (nonatomic, strong, readwrite) NSString * password;
@property (nonatomic, strong, readwrite) NSString * joinedAccount;
@property (nonatomic, strong, readwrite) NSString * avtarId;
@property (nonatomic, assign, readwrite) BOOL signedIn;
@property (nonatomic, strong) NSString * securityPin;
@property (nonatomic, strong) MSServiceManager * serviceManager;

@end

@implementation UserAccount

- (MSServiceManager *)serviceManager
{
	return [MSServiceManager sharedManager];
}

- (void)initCustomProperties
{
    self.userId = ([self.userId length] == 0) ? @"": self.userId;
    self.accountId = ([self.accountId length] == 0) ? @"": self.accountId;
    self.username = ([self.username length] == 0) ? @"": self.username;
    self.firstname = ([self.firstname length] == 0) ? @"": self.firstname;
    self.lastname = ([self.lastname length] == 0) ? @"": self.lastname;
    self.email = ([self.email length] == 0) ? @"": self.email;
    self.avtarId = ([self.avtarId length] == 0) ? @"": self.avtarId;
    
    
    self.customProperties = @{@"userId":self.userId,
                              @"accountId":self.accountId,
                              @"username":self.username,
                              @"firstname":self.firstname,
                              @"lastname":self.lastname,
                              @"email":self.email,
                              @"avtarId":self.avtarId,};
}

#pragma instance types
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self) {
        
    }
    return self;
}

- (instancetype)initAsGuest
{
    self = [super initWithDictionary:
            [[NSDictionary alloc] initWithObjects:@[@"0",@"Guest",@"", @"Guest"]
                                          forKeys:@[@"userId",@"firstname", @"lastname", @"username"]]];
    
    if (self) {
        
    }
    return self;
}

- (void)setValue:(NSString *)value forUndefinedKey:(NSString *)key
{

}

#pragma static methods
+ (BOOL)areNamesValid:(NSString *)firstNameInput lastName:(NSString *)lastNameInput
{
    BOOL areNamesValid = YES;
    NSString * message;
    
    if(firstNameInput.length == 0)
    {
        areNamesValid = NO;
        message = @"Please enter a valid first name.";
    }
    else if(lastNameInput.length == 0)
    {
        areNamesValid = NO;
        message = @"Please enter a valid last name.";
    }
    
    if (!areNamesValid)
    {
        [MSUIManager alertWithTitle:@"Invalid Name" andMessage:message];
    }
    
    return areNamesValid;
}

+ (BOOL)isUsernameValid:(NSString *)username1Input username2:(NSString *)username2Input
{
    BOOL isUsernameValid = YES;
    NSString * message;
    
    if(username1Input.length < 5)
    {
        isUsernameValid = NO;
        message = @"Please enter a valid username. Between 5 - 15 characters";
    }
    else if(username1Input.length > 25)
    {
        isUsernameValid = NO;
        message = @"Please enter a valid username. Between 5 - 15 characters";
    }
    else if(![username1Input isEqualToString:username2Input])
    {
        isUsernameValid = NO;
        message = @"Username's do not match! Please re-enter username.";
    }
    
    if (!isUsernameValid)
    {
        [MSUIManager alertWithTitle:@"Invalid Username" andMessage:message];
    }
    
    return isUsernameValid;
}

+ (BOOL)isEmailValid:(NSString *)emailInput1 email2:(NSString *)emailInput2
{
    BOOL isEmailValid = YES;
    NSString * message;
    
    if(emailInput1.length == 0 ||
       [emailInput1 rangeOfString:@"@"].length == 0  ||
       [emailInput1 rangeOfString:@"."].length == 0)
    {
        isEmailValid = NO;
        message = @"Please enter a valid email address.";
    }
    else if(![emailInput1 isEqualToString:emailInput2])
    {
        isEmailValid = NO;
        message = @"Email's do not match! Please re-enter email address.";
    }
    
    if (!isEmailValid)
    {
        [MSUIManager alertWithTitle:@"Invalid Email" andMessage:message];
    }
    
    return isEmailValid;
}

+ (BOOL)isPasswordValid:(NSString *)passwordInput1 password2:(NSString *)passwordInput2
{
    BOOL isPasswordValid = YES;
    NSString * message;
    
    if(![passwordInput1 isEqualToString:passwordInput2])
    {
        isPasswordValid = NO;
        message = @"Password's do not match! Please re-enter password.";
    }
    else if(passwordInput1.length < minPasswordLength || passwordInput1.length > maxPasswordLength)
    {
        isPasswordValid = NO;
        message = [NSString stringWithFormat:@"Please enter a password with %li to %li characters.", minPasswordLength, maxPasswordLength];
    }
    
    
    NSRange upperCaseRange;
    NSCharacterSet *upperCaseSet = [NSCharacterSet uppercaseLetterCharacterSet];
    upperCaseRange = [passwordInput1 rangeOfCharacterFromSet: upperCaseSet];
    if (upperCaseRange.location == NSNotFound)
    {
        isPasswordValid = NO;
        message = @"Please enter a password at least both upper-case and lower-case characters.";
    }
    
    NSRange lowerCaseRange;
    NSCharacterSet *lowerCaseSet = [NSCharacterSet lowercaseLetterCharacterSet];
    lowerCaseRange = [passwordInput1 rangeOfCharacterFromSet: lowerCaseSet];
    if (lowerCaseRange.location == NSNotFound)
    {
        isPasswordValid = NO;
        message = @"Please enter a password at least both upper-case and lower-case characters.";
    }
    
    NSRange numericRange;
    NSCharacterSet *numericCaseSet = [NSCharacterSet decimalDigitCharacterSet];
    numericRange = [passwordInput1 rangeOfCharacterFromSet: numericCaseSet];
    if (numericRange.location == NSNotFound)
    {
        isPasswordValid = NO;
        message = @"Please enter a password at least one numeric characters.";
    }
    
    //#warning add special characters check
    
    
    NSRange illegalCaseRange;
    NSCharacterSet *illegalCaseSet = [NSCharacterSet illegalCharacterSet];
    illegalCaseRange = [passwordInput1 rangeOfCharacterFromSet: illegalCaseSet];
    if (illegalCaseRange.location != NSNotFound)
    {
        isPasswordValid = NO;
    //#warning add special chars
        message = @"Illegal Character detected. Please using only the following special characters: ";
    }
    
    
    if(!isPasswordValid)
    {
        [MSUIManager alertWithTitle:@"Invalid Password" andMessage:message];
    }
    
    return isPasswordValid;
}






#pragma methods
- (void)setNewPin:(NSString *)pin
{
    self.securityPin = pin;
}

- (BOOL)isCorrectPin:(NSString *)pin
{
    if(pin == self.securityPin)
    {
        return YES;
    }
    
    return NO;
}

- (void)logout
{
    self.signedIn = NO;
}

- (void)login
{
    self.signedIn = YES;
}

#pragma private
- (void)createAccountOnline
{
    //[self.serviceManager createAccountFromUserAccount:self];
}


@end
