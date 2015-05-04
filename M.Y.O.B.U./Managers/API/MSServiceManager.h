//
//  MSServiceManager.h
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 12/23/13.
//  Copyright (c) 2013 MYOB University. All rights reserved.
//

#import "UserAccount.h"
#import "AFHTTPSessionManager.h"


@interface MSServiceManager : AFHTTPSessionManager

+ (id)sharedManager;

/*- (void)getAllUsers:(UserAccount *)account
            completed:(void (^)(BOOL successful, id response))completed;
*/
#pragma account services
- (void)createAccount:(UserAccount *)account
            completed:(void (^)(BOOL successful, id response))completed;

- (void)recoverAccountPassword:(NSString *)accountEmail
                     completed:(void (^)(BOOL successful, id response))completed;

- (void)changeAccountPassword:(NSString *)accountId password:(NSString *)password
                    completed:(void (^)(BOOL successful, id response))completed;

- (void)sendAccountLinkRequest:(UserAccount *)account1 toAccount:(UserAccount *)account2
                     completed:(void (^)(BOOL successful, id response))completed;

- (void)approveAccountLinkRequest:(NSString *)accountLinkId
                        completed:(void (^)(BOOL successful, id response))completed;

- (void)denyAccountLinkRequest:(NSString *)accountLinkId
                     completed:(void (^)(BOOL successful, id response))completed;

#pragma user services
- (void)loginUser:(NSString *)emailOrUsername password:(NSString *)password
                     completed:(void (^)(BOOL successful, id response))completed;

- (void)logoutUser:(NSString *)accountId
        completed:(void (^)(BOOL successful, id response))completed;

- (void)findUserByEmailOrUsername:(NSString *)emailOrUsername userId:(NSString *)userId
                        completed:(void (^)(BOOL successful, id response))completed;

- (void)editUserInfo:(NSString *)userId otherParams:(NSDictionary *)otherParams
                        completed:(void (^)(BOOL successful, id response))completed;

#pragma old account services
- (void)createAccountFromUserAccount:(UserAccount *)account
                           completed:(void (^)(BOOL accountCreated))completed;

- (void)authenicateUser:(NSString *)email password:(NSString *)password
              completed:(void (^)(id userAuthenicatedId))completed;

- (void)getAccountInfoByAccountId:(NSString *)accountId
                        completed:(void (^)(id userInfo))completed;

- (void)recoverPasswordByEmail:(NSString *)accountEmail
                     completed:(void (^)(BOOL emailSent))completed;

- (void)changePasswordForAccountWithId:(NSString *)accountId password:(NSString *)password
                     completed:(void (^)(BOOL passwordChanged))completed;

- (void)linkAccount:(UserAccount *)account1 toAccount:(UserAccount *)account2;


@end
