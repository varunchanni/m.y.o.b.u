//
//  UserAccount.h
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 12/8/13.
//  Copyright (c) 2013 MYOB University. All rights reserved.
//

#import "MSModelObject.h"

enum UserAccountType {
    UserAccountGuestUser,
    UserAccountMYOBUser
};

@interface UserAccount : MSModelObject
@property (nonatomic, strong, readonly) NSString * userId;
@property (nonatomic, strong, readonly) NSString * accountId;
@property (nonatomic, strong, readonly) NSString * joinedAccount;
@property (nonatomic, strong, readonly) NSString * firstname;
@property (nonatomic, strong, readonly) NSString * lastname;
@property (nonatomic, strong, readonly) NSString * username;
@property (nonatomic, strong, readonly) NSString * email;
@property (nonatomic, strong, readonly) NSString * password;
@property (nonatomic, strong, readonly) NSString * avtarId;
@property (nonatomic, assign, getter = isSignedIn, readonly) BOOL signedIn;

- (instancetype)initAsGuest;
- (void)setNewPin:(NSString *)pin;
- (BOOL)isCorrectPin:(NSString *)pin;
- (void)logout;
- (void)login;

#pragma static methods
+ (BOOL)isUsernameValid:(NSString *)username1Input username2:(NSString *)username2Input;
+ (BOOL)areNamesValid:(NSString *)firstNameInput lastName:(NSString *)lastNameInput;
+ (BOOL)isEmailValid:(NSString *)emailInput1 email2:(NSString *)emailInput2;
+ (BOOL)isPasswordValid:(NSString *)passwordInput1 password2:(NSString *)passwordInput2;
@end
