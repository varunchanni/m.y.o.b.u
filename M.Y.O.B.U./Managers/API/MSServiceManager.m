//
//  MSServiceManager.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 12/23/13.
//  Copyright (c) 2013 MYOB University. All rights reserved.
//

#import "MSServiceManager.h"
#import "MSUIManager.h"
#import "AFNetworking.h"

static NSString *const kAccountScriptKey = @"accounts.php";
//static NSString *const kMYOBUDevURL = @"http://mfxstudios.com/myob/";
//static NSString *const kMYOBUProductionURL = @"";

static NSString *const kStatusKey = @"status";
static NSString *const kStatusErrorKey = @"error";
static NSString *const kStatusSuccessKey = @"success";
static NSString *const kAccountIdKey = @"accountId";
static NSString *const kActionKey = @"action";
static NSString *const kFirstnameKey = @"firstname";
static NSString *const kLastnameKey = @"lastname";
static NSString *const kEmailKey = @"email";
static NSString *const kPasswordKey = @"password";

static NSString *const kCreateAccountAction = @"create account";
static NSString *const kValidateEmailAction = @"valid email";
static NSString *const kAuthenicateAccountKey = @"authenicate account";
static NSString *const kChangePasswordKey = @"change password";
static NSString *const kGetPasswordKey = @"get password";
static NSString *const kLinkAccountsKey = @"link accounts";
static NSString *const kGetAccountInfoKey = @"get account info";
static NSString *const kLinkRequestKey = @"link request";
static NSString *const kBreakLinkKey = @"break link";
//////


static NSString *const kMYOBUDevURL = @"http://mfxstudios.net/api/myobu/";
static NSString *const kMYOBUProductionURL = @"";

static NSString *const kMYOBU_Action_CreateUser = @"CreateUser";
static NSString *const kMYOBU_Action_FindUser = @"FindUser";
static NSString *const kMYOBU_Action_EditUser = @"EditUserInfo";
static NSString *const kMYOBU_Action_LogIn = @"LogIn";
static NSString *const kMYOBU_Action_LogOut= @"LogOut";
static NSString *const kMYOBU_Action_RecoverPassword = @"RecoverPassword";
static NSString *const kMYOBU_Action_ChangePassword = @"ChangePassword";
static NSString *const kMYOBU_Action_SendLinkRequest = @"SendLinkRequest";
static NSString *const kMYOBU_Action_DenyLinkRequest = @"DenyLinkRequest";
static NSString *const kMYOBU_Action_ApproveLinkRequest = @"ApproveLinkRequest";


static NSString *const kMYOBU_Response_Status = @"Status";

@interface MSServiceManager()
@property (nonatomic, strong) NSString *AUTH_KEY;
@property (nonatomic, strong) NSString *MYOBU_URL;
@end
@implementation MSServiceManager

+ (id)sharedManager
{
	static MSServiceManager *_sharedManager = nil;
    static dispatch_once_t onceQueue;
	
    dispatch_once(&onceQueue, ^{
        _sharedManager = [[MSServiceManager alloc] initWithBaseURL:[NSURL URLWithString:kMYOBUDevURL]];
        [_sharedManager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey]];
    });
	
    //@TODO make check for dev or prod
     _sharedManager.MYOBU_URL = kMYOBUDevURL;
    
	return _sharedManager;
}

/*
- (void)getAllUsers:(UserAccount *)account
          completed:(void (^)(BOOL successful, id response))completed
{
    NSString * poststring =  [self.MYOBU_URL stringByAppendingPathComponent:@"/getUsers"];
    NSDictionary * params = nil;
   
    [self GET:poststring parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if([[responseObject objectForKey:@"Status"] isEqualToString:@"Success"])
        {
            completed(YES, responseObject);
        }
        else
        {
            completed(NO, responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
        
}

*/
#pragma mark account services
- (void)createAccount:(UserAccount *)account
            completed:(void (^)(BOOL successful, id response))completed
{
    NSString * poststring =  [self.MYOBU_URL stringByAppendingPathComponent:@"/post"];
    NSDictionary * params = @{@"Action":kMYOBU_Action_CreateUser,
                              @"Username":account.username,
                              @"Email":account.email,
                              @"Password":account.password};
    
    [self POST:poststring parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if([[responseObject objectForKey:@"Status"] isEqualToString:@"Success"])
        {
            completed(YES, responseObject);
        }
        else
        {
            completed(NO, responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        completed(NO, error);
    }];
}

- (void)recoverAccountPassword:(NSString *)accountEmail
                     completed:(void (^)(BOOL successful, id response))completed;
{
    NSString * poststring =  [self.MYOBU_URL stringByAppendingPathComponent:@"/post"];
    NSDictionary * params = @{@"Action":kMYOBU_Action_RecoverPassword,
                              @"Email":accountEmail};
    
    [self POST:poststring parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completed(YES, responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        completed(NO, error);
    }];
}

- (void)changeAccountPassword:(NSString *)accountId password:(NSString *)password
                    completed:(void (^)(BOOL successful, id response))completed
{
    NSString * poststring =  [self.MYOBU_URL stringByAppendingPathComponent:@"/post"];
    NSDictionary * params = @{@"AUTH_KEY":self.AUTH_KEY,
                              @"Action":kMYOBU_Action_ChangePassword,
                              @"AccountId":accountId,
                              @"Password":password};
    
    [self POST:poststring parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completed(YES, responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        completed(NO, error);
    }];
}

- (void)sendAccountLinkRequest:(UserAccount *)account1 toAccount:(UserAccount *)account2
                     completed:(void (^)(BOOL successful, id response))completed
{
    NSString * poststring =  [self.MYOBU_URL stringByAppendingPathComponent:@"/post"];
    NSDictionary * params = @{@"AUTH_KEY":self.AUTH_KEY,
                              @"Action":kMYOBU_Action_SendLinkRequest,
                              @"RequesterId":account1,
                              @"RequestedId":account2};
    
    [self POST:poststring parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completed(YES, responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        completed(NO, error);
    }];
}

- (void)approveAccountLinkRequest:(NSString *)accountLinkId
                        completed:(void (^)(BOOL successful, id response))completed
{
    NSString * poststring =  [self.MYOBU_URL stringByAppendingPathComponent:@"/post"];
    NSDictionary * params = @{@"AUTH_KEY":self.AUTH_KEY,
                              @"Action":kMYOBU_Action_ApproveLinkRequest,
                              @"RequestLinkId":accountLinkId};
    
    [self POST:poststring parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completed(YES, responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        completed(NO, error);
    }];
}

- (void)denyAccountLinkRequest:(NSString *)accountLinkId
                     completed:(void (^)(BOOL successful, id response))completed
{
    NSString * poststring =  [self.MYOBU_URL stringByAppendingPathComponent:@"/post"];
    NSDictionary * params = @{@"AUTH_KEY":self.AUTH_KEY,
                              @"Action":kMYOBU_Action_DenyLinkRequest,
                              @"RequestLinkId":accountLinkId};
    
    [self POST:poststring parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completed(YES, responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        completed(NO, error);
    }];
}

#pragma mark user services
- (void)loginUser:(NSString *)emailOrUsername password:(NSString *)password
        completed:(void (^)(BOOL successful, id response))completed
{
    NSString * poststring =  [self.MYOBU_URL stringByAppendingPathComponent:@"/post"];
    NSDictionary * params = @{@"Action":kMYOBU_Action_LogIn,
                              @"UserOrEmail":emailOrUsername,
                              @"Password":password};
    
    [self POST:poststring parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        self.AUTH_KEY = [responseObject objectForKey:@"AUTH_KEY"];
        completed(YES, responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        completed(NO, error);
    }];
}

- (void)logoutUser:(NSString *)accountId
         completed:(void (^)(BOOL successful, id response))completed
{
    NSString * poststring =  [self.MYOBU_URL stringByAppendingPathComponent:@"/post"];
    NSDictionary * params = @{@"Action":kMYOBU_Action_LogOut,
                              @"UserId":accountId};
    
    [self POST:poststring parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completed(YES, responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        completed(NO, error);
    }];
}

- (void)findUserByEmailOrUsername:(NSString *)emailOrUsername userId:(NSString *)userId
         completed:(void (^)(BOOL successful, id response))completed
{
    NSString * poststring =  [self.MYOBU_URL stringByAppendingPathComponent:@"/post"];
    NSDictionary * params = @{@"Action":kMYOBU_Action_FindUser,
                              @"AUTH_KEY":self.AUTH_KEY,
                              @"UserId":userId,
                              @"UserOrEmail":emailOrUsername};
    
    [self POST:poststring parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completed(YES, responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        completed(NO, error);
    }];
}

- (void)editUserInfo:(NSString *)userId otherParams:(NSDictionary *)otherParams
           completed:(void (^)(BOOL successful, id response))completed
{
    NSString * poststring =  [self.MYOBU_URL stringByAppendingPathComponent:@"/post"];
    NSMutableDictionary * params = @{@"Action":kMYOBU_Action_EditUser,
                              @"AUTH_KEY":self.AUTH_KEY,
                              @"UserId":userId}.mutableCopy;
   
    [params addEntriesFromDictionary:otherParams];
    
    [self POST:poststring parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completed(YES, responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        completed(NO, error);
    }];
}

#pragma mark old account services
- (void)createAccountFromUserAccount:(UserAccount *)account completed:(void (^)(BOOL accountCreated))completed
{
    [self isEmailRegistered:account.email success:^(id responseObject) {
        
        
        NSString * accountId = [responseObject valueForKey:kAccountIdKey];

        if(accountId.length == 0)
        {
            NSDictionary *parameters = @{ kActionKey:kCreateAccountAction,
                                          //kFirstnameKey:account.firstname,
                                          //kLastnameKey:account.lastname,
                                          kEmailKey:account.email,
                                          kPasswordKey:account.password};
            
            [self POST:kAccountScriptKey parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                
                NSLog(@"account saved online, response:  %@", responseObject);
                completed(YES);
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                NSLog(@"account FAILED to save online with error:  %@", error);
                completed(NO);
            }];
        }
        else
        {
            NSString * message = @"Email already associated with a MYOBU Account.";
            [MSUIManager alertWithTitle:@"Error" andMessage:message];
            completed(NO);
        }
        
    } failure:^(NSError *error) {
        
        completed(NO);
        NSLog(@"error: %@", error);
    }];
}

- (void)authenicateUser:(NSString *)email password:(NSString *)password completed:(void (^)(id userAuthenicatedId))completed
{
    NSDictionary *parameters = @{ kActionKey:kAuthenicateAccountKey,
                                  kEmailKey:email,
                                  kPasswordKey:password};
    
    [self POST:kAccountScriptKey parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completed([responseObject valueForKey:kAccountIdKey]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Incorrect Email or Password:  %@", error);
        completed(nil);
    }];
}

- (void)getAccountInfoByAccountId:(NSString *)accountId
                        completed:(void (^)(id userInfo))completed
{
    
    NSDictionary *parameters = @{ kActionKey:kGetAccountInfoKey,
                                  kAccountIdKey:accountId};
    
    [self POST:kAccountScriptKey parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completed(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Incorrect accountId: %@", error);
        completed(nil);
    }];
}


- (void)recoverPasswordByEmail:(NSString *)accountEmail
                     completed:(void (^)(BOOL emailSent))completed
{
    NSDictionary *parameters = @{ kActionKey:kGetPasswordKey,
                                  kEmailKey:accountEmail};
    
    [self POST:kAccountScriptKey parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"Recover Password: %@", responseObject);
        if([[responseObject valueForKey:kStatusKey] isEqualToString:kStatusSuccessKey])
        {
            completed(YES);        }
        else if([[responseObject valueForKey:kStatusKey] isEqualToString:kStatusErrorKey])
        {
            completed(NO);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@", error);
        completed(NO);
    }];
}

- (void)changePasswordForAccountWithId:(NSString *)accountId password:(NSString *)password
                             completed:(void (^)(BOOL passwordChanged))completed
{
    NSDictionary *parameters = @{ kActionKey:kChangePasswordKey,
                                  kAccountIdKey:accountId,
                                  kPasswordKey:password};
    
    [self POST:kAccountScriptKey parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"Change Password: %@", responseObject);
        if([[responseObject valueForKey:kStatusKey] isEqualToString:kStatusSuccessKey])
        {
            completed(YES);        }
        else if([[responseObject valueForKey:kStatusKey] isEqualToString:kStatusErrorKey])
        {
            completed(NO);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@", error);
        completed(NO);
    }];
}

- (void)resetAccountPasswordFromEmail:(NSString *)email
{
    
}
- (void)linkAccount:(UserAccount *)account1 toAccount:(UserAccount *)account2
{
    
}


#pragma mark private account services
- (void)isEmailRegistered:(NSString *)email success:(void (^)(id responseObject))success failure:(void (^)(NSError * error))failure
{
    NSDictionary *parameters = @{ kActionKey:kValidateEmailAction,
                                  kEmailKey:email};
    
    [self POST:kAccountScriptKey parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
    }];
}




@end
