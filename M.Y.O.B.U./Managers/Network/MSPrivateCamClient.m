//
//  MSPrivateCamClient.m
//  PrivateCam
//
//  Created by Prince Ugwuh on 10/6/12.
//  Copyright (c) 2012 MFX Studios. All rights reserved.
//

#import "MSPrivateCamClient.h"
#import "MSAccount.h"

static NSString *const kPrivateCamDevelopmentCheck = @"Use Development Server";
static NSString *const kPrivateCamProductionURL = @"http://mfxstudios.com/restserver/public/index.php/api/";
static NSString *const kPrivateCamDevURL = @"http://mfxstudios.com/restserver_dev/public/index.php/api/";
static NSString *const kPrivateCamAccountsPath = @"accounts/accounts";
static NSString *const kPrivateCamMessagesPath = @"messages/messages";
static NSString *const kPrivateCamContactsPath = @"contacts/contacts";

@interface MSPrivateCamClient()

@end

@implementation MSPrivateCamClient

+ (MSPrivateCamClient *)sharedManager
{
    static MSPrivateCamClient *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] initWithPrivateCamURL];
    });
    
    return _sharedManager;
}

- (id)initWithPrivateCamURL
{
    bool useDev = [[[NSBundle mainBundle] objectForInfoDictionaryKey:kPrivateCamDevelopmentCheck] boolValue];
    
    if(useDev)
    {
        self = [self initWithBaseURL:[NSURL URLWithString:kPrivateCamDevURL]];
    }
    else
    {
        self = [self initWithBaseURL:[NSURL URLWithString:kPrivateCamProductionURL]];
    }

    
    if (self)
	{
        [self setParameterEncoding:AFFormURLParameterEncoding];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }
    return self;
}

#pragma mark - Account Management

- (void)notifyUserSecurityIsBreachedWithAccountId:(NSString *)accountId caughtImage:(UIImage *)caughtImage success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
{
    
    NSDictionary *parameters = @{ @"action":@"security-triggered", @"id":accountId, @"token":self.token };
    NSData *imageData = UIImageJPEGRepresentation(caughtImage, 0.8);
	NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:kPrivateCamAccountsPath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
		[formData appendPartWithFileData:imageData name:@"caughtImage" fileName:@"caughtImage.jpg" mimeType:@"image/jpeg"];
	}];
	
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        //		progressBlock(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
	}];
	
	[operation start];
}

- (void)createAccountWithAccountInfo:(MSAccount *)account success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
{
    NSArray *keys = @[@"name", @"email", @"imageURL", @"password", @"facebookId", @"twitterId"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[account dictionaryWithValuesForKeys:keys]];
    [parameters setValue:@"create" forKey:@"action"];
    
    
    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:kPrivateCamAccountsPath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if (account.image != nil)
        {
            NSData *imageData = UIImageJPEGRepresentation(account.image, 0.9f);
            [formData appendPartWithFileData:imageData name:@"profile" fileName:@"profile.jpg" mimeType:@"image/jpeg"];
            account.image = nil;
        }
        
	}];
	
	__block AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                                 JSONRequestOperationWithRequest:request
                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                     success(operation, operation.responseJSON);
                                                 }
                                                 failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                     
                                                     failure(operation, error);
                                                 }];
	[operation start];
}

- (void)authenticateUserWithAccountInfo:(MSAccount *)account success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSArray *keys = @[@"name", @"email", @"password"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[account dictionaryWithValuesForKeys:keys]];
    [parameters setValue:@"authenticate" forKey:@"action"];
    
    [self postPath:kPrivateCamAccountsPath parameters:parameters success:success failure:failure];
}

/*
- (void)authenticateUserWithFacebookId:(NSString *)facebookId email:(NSString *)email success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSDictionary *parameters = @{ @"action":@"authenticate-facebook", @"facebookId":facebookId, @"email":email };
    [self postPath:kPrivateCamAccountsPath parameters:parameters success:success failure:failure];
}

- (void)authenticateUserWithTwitterId:(NSString *)twitterId name:(NSString *)name success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSDictionary *parameters = @{ @"action":@"authenticate-twitter", @"twitterId":twitterId, @"name":name };
    [self postPath:kPrivateCamAccountsPath parameters:parameters success:success failure:failure];    
}
*/
- (void)authenticateUserWithFacebookId:(NSString *)facebookId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSDictionary *parameters = @{ @"action":@"authenticate-facebook", @"facebookId":facebookId};
    [self postPath:kPrivateCamAccountsPath parameters:parameters success:success failure:failure];
}
- (void)checkForUserWithTwitterId:(NSString *)accountId twitterId:(NSString *)twitterId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSDictionary *parameters = @{ @"action":@"check-twitter", @"accountId":accountId, @"twitterId":twitterId};
    [self postPath:kPrivateCamAccountsPath parameters:parameters success:success failure:failure];
}
- (void)authenticateUserWithTwitterId:(NSString *)twitterId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSDictionary *parameters = @{ @"action":@"authenticate-twitter", @"twitterId":twitterId};
    [self postPath:kPrivateCamAccountsPath parameters:parameters success:success failure:failure];
}
- (void)linkTwitterAccountToPrivatecamAccount:(NSString *)accountId twitterAccount:(ACAccount *)twitterAccount success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    //NSDictionary *parameters = @{ @"action":@"link-twitter", @"accountId":accountId, @"twitterUsername":twitterAccount.username, @"twitterId":twitterAccount.identifier};
    NSDictionary *parameters = @{ @"action":@"link-twitter", @"accountId":accountId, @"twitterId":twitterAccount.identifier};
    [self postPath:kPrivateCamAccountsPath parameters:parameters success:success failure:failure];
}
- (void)unlinkTwitterAccountToPrivatecamAccount:(NSString *)accountId twitterAccount:(ACAccount *)twitterAccount success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    //NSDictionary *parameters = @{ @"action":@"unlink-twitter", @"accountId":accountId, @"twitterUsername":twitterAccount.username, @"twitterId":twitterAccount.identifier};
    NSDictionary *parameters = @{ @"action":@"unlink-twitter", @"accountId":accountId, @"twitterId":twitterAccount.identifier};
    [self postPath:kPrivateCamAccountsPath parameters:parameters success:success failure:failure];
}
- (void)unauthenticateUserWithAccountId:(NSString *)accountId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    if (!accountId.length) // fake it for now. this shouldnt hurt there login process 
    {
        if (success != nil)
        {
            success(nil, @[]);
        }
        return;
    }
    
    NSDictionary *parameters = @{ @"action":@"unauthenticate", @"accountId":accountId, @"token":self.token };
    [self putPath:kPrivateCamAccountsPath parameters:parameters success:success failure:failure];
}

- (void)registerDeviceWithAccountId:(NSString *)accountId deviceToken:(NSString *)deviceToken success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSDictionary *parameters = @{  @"action":@"registerDevice", @"accountId":accountId, @"deviceToken":deviceToken, @"token":self.token };
    [self putPath:kPrivateCamAccountsPath parameters:parameters success:success failure:failure];
}

- (void)unregisterDeviceWithAccountId:(NSString *)accountId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSDictionary *parameters = @{  @"action":@"unregisterDevice", @"accountId":accountId, @"token":self.token };
    [self putPath:kPrivateCamAccountsPath parameters:parameters success:success failure:failure];
}

- (void)checkIfAccountExist:(MSAccount *)account success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSArray *keys = @[ @"email", @"name" ];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[account dictionaryWithValuesForKeys:keys]];
    [parameters setValue:@"check" forKey:@"action"];
    
    [self getPath:kPrivateCamAccountsPath parameters:parameters success:success failure:failure];
}

- (void)setProfileImageForAccount:(MSAccount *)account image:(UIImage *)image success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{

    NSArray *keys = @[ @"accountId" ];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[account dictionaryWithValuesForKeys:keys]];
    [parameters setValue:@"set-profile-pic" forKey:@"action"];
    [parameters setValue:self.token forKey:@"token"];
    
    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:kPrivateCamAccountsPath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
            NSData *imageData = UIImageJPEGRepresentation(image, 0.9f);
            [formData appendPartWithFileData:imageData name:@"profile" fileName:@"profile.jpg" mimeType:@"image/jpeg"];        
	}];
	
	__block AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                                 JSONRequestOperationWithRequest:request
                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                     success(operation, operation.responseJSON);
                                                 }
                                                 failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                     
                                                     failure(operation, error);
                                                 }];
	[operation start];
}

- (void)updateAccountWithAccountInfo:(MSAccount *)account success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSArray *keys = @[ @"accountId", @"name", @"email", @"password", @"imageURL" ];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[account dictionaryWithValuesForKeys:keys]];
    [parameters setValue:@"update" forKey:@"action"];
    [parameters setValue:self.token forKey:@"token"];
    
    [self putPath:kPrivateCamAccountsPath parameters:parameters success:success failure:failure];
}

- (void)removeAccountWithAccountId:(NSString *)accountId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSDictionary *parameters = @{ @"accountId":accountId, @"token":self.token };
    [self deletePath:kPrivateCamAccountsPath parameters:parameters success:success failure:failure];
}

#pragma mark - Contacts

- (void)fetchContactsForAccountId:(NSString *)accountId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSDictionary *parameters = @{ @"action":@"contacts", @"accountId":accountId, @"token":self.token };
    [self getPath:kPrivateCamContactsPath parameters:parameters success:success failure:failure];
}

- (void)fetchContactsByNameOrUsername:(NSString *)nameOrUsername success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    [self.operationQueue cancelAllOperations];
    
    //[self cancelAllHTTPOperationsWithMethod:@"GET" path:kPrivateCamContactsPath];
    
    if(!nameOrUsername.length)
    {
        if (success != nil)
        {
            success(nil, @[]);
        }
        return;
    }
    
    NSDictionary *parameters = @{ @"action":@"browse", @"nameOrUsername":nameOrUsername, @"token":self.token };
    [self getPath:kPrivateCamContactsPath parameters:parameters success:success failure:failure];
    
}


- (void)fetchContactById:(NSString *)contactId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSDictionary *parameters = @{ @"id":contactId, @"token":self.token };
    [self getPath:kPrivateCamContactsPath parameters:parameters success:success failure:failure];
}

- (void)fetchRequestsForAccountId:(NSString *)accountId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSDictionary *parameters = @{ @"action":@"requests", @"accountId":accountId, @"token":self.token };
    [self getPath:kPrivateCamContactsPath parameters:parameters success:success failure:failure];
}

- (void)removeContactWithContactId:(NSString *)contactId accountId:(NSString *)accountId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSDictionary *parameters = @{ @"contactId":contactId, @"accountId":accountId, @"token":self.token };
    [self deletePath:kPrivateCamContactsPath parameters:parameters success:success failure:failure];
}
- (void)requestContactWithSocialId:(NSString *)socialId accountId:(NSString *)accountId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSDictionary *parameters = @{ @"action":@"social", @"socialId":socialId, @"accountId":accountId, @"token":self.token };
    [self postPath:kPrivateCamContactsPath parameters:parameters success:success failure:failure];
}
- (void)requestContactWithContactId:(NSString *)contactId accountId:(NSString *)accountId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSDictionary *parameters = @{ @"action":@"requests", @"contactId":contactId, @"accountId":accountId, @"token":self.token };
    [self postPath:kPrivateCamContactsPath parameters:parameters success:success failure:failure];
}

- (void)acceptContactWithRequestId:(NSString *)requestId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSDictionary *parameters = @{ @"action":@"contacts", @"requestId":requestId, @"token":self.token };
    
    [self postPath:kPrivateCamContactsPath parameters:parameters success:success failure:failure];
}

- (void)removeRequestWithRequestId:(NSString *)requestId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSDictionary *parameters = @{ @"action":@"removeRequest", @"requestId":requestId, @"token":self.token };
    [self postPath:kPrivateCamContactsPath parameters:parameters success:success failure:failure];
}

- (void)fetchSuggestedFriendsFromSocialFriendsList:(NSDictionary *)socialFriendsList success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSDictionary *parameters = @{ @"list":socialFriendsList, @"token":self.token };
    [self getPath:kPrivateCamContactsPath parameters:parameters success:success failure:failure];
}
- (void)fetchRequestsSentByMe:(NSString *)accountId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSDictionary *parameters = @{ @"action":@"my_requests", @"accountId":accountId, @"token":self.token };
    [self getPath:kPrivateCamContactsPath parameters:parameters success:success failure:failure];
}


#pragma mark - Messages

- (void)fetchMessagesForAccountId:(NSString *)accountId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSDictionary *parameters = @{ @"action":@"fetchMessagesForAccountId", @"accountId":accountId, @"token":self.token };
    [self getPath:kPrivateCamMessagesPath parameters:parameters success:success failure:failure];
}

- (void)fetchMessagesById:(NSString *)messagesId limit:(NSInteger)limit multiplier:(NSInteger)multiplier success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSDictionary *parameters = @{ @"action":@"fetchMessagesById", @"messagesId":messagesId, @"limit":@(limit), @"multiplier":@(multiplier), @"token":self.token };
    [self getPath:kPrivateCamMessagesPath parameters:parameters success:success failure:failure];
}

- (void)createMessageThreadWithAccountId:(NSString *)accountId contactId:(NSString *)contactId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSDictionary *parameters = @{ @"action":@"createMessageThread", @"accountId":accountId, @"contactId":contactId, @"token":self.token };
    [self postPath:kPrivateCamMessagesPath parameters:parameters success:success failure:failure];
}

- (void)markMessagesReadWithMessagesId:(NSString *)messagesId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSDictionary *parameters = @{ @"action":@"markMessagesRead", @"messagesId":messagesId, @"token":self.token };
    [self postPath:kPrivateCamMessagesPath parameters:parameters success:success failure:failure];
}

- (void)sendMessageWithMessagesId:(NSString *)messagesId accountId:(NSString *)accountId message:(NSString *)message success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSDictionary *parameters = @{ @"action":@"sendMessage", @"accountId":accountId, @"messagesId":messagesId, @"message":message, @"token":self.token };
    [self postPath:kPrivateCamMessagesPath parameters:parameters success:success failure:failure];
}

- (void)sendImageWithMessagesId:(NSString *)messagesId accountId:(NSString *)accountId images:(NSArray *)images success:(MSAPISuccessBlock)success progress:(MSAPIProgressBlock)progress failure:(MSAPIFailureBlock)failure
{
    NSDictionary *parameters = @{ @"action":@"sendImage", @"accountId":accountId, @"messagesId":messagesId, @"token":self.token };

	NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:kPrivateCamMessagesPath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (UIImage *image in images)
        {
            NSInteger index = [images indexOfObject:image];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.9f);
            NSString *filename = [NSString stringWithFormat:@"image-%d.jpg", index];
            NSArray *fileComponents = [filename componentsSeparatedByString:@"."];
            [formData appendPartWithFileData:imageData name:fileComponents[0] fileName:filename mimeType:@"image/jpeg"];
        }
		
	}];
	
	__block AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         JSONRequestOperationWithRequest:request
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                             success(operation, operation.responseJSON);
                                         }
                                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                             
                                             failure(operation, error);
                                         }];
	[operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        		progress(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
	}];
    	
	[operation start];
}

- (void)removeMessageById:(NSString *)messageId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSDictionary *parameters = @{ @"messageId":messageId, @"token":self.token };
    [self deletePath:kPrivateCamMessagesPath parameters:parameters success:success failure:failure];
}

- (void)removeMessagesById:(NSString *)messagesId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure
{
    NSDictionary *parameters = @{ @"messageId":messagesId, @"token":self.token };
    [self deletePath:kPrivateCamMessagesPath parameters:parameters success:success failure:failure];
}


@end
