//
//  MSPrivateCamClient.h
//  PrivateCam
//
//  Created by Prince Ugwuh on 10/6/12.
//  Copyright (c) 2012 MFX Studios. All rights reserved.
//

#import "AFNetworking.h"

@class MSAccount;

typedef void (^MSAPISuccessBlock) (AFHTTPRequestOperation *operation, id responseObject);
typedef void (^MSAPIFailureBlock) (AFHTTPRequestOperation *operation, NSError *error);
typedef void (^MSAPIProgressBlock) (NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);

@interface MSPrivateCamClient : AFHTTPClient

@property (nonatomic, strong) NSString *token;

+ (MSPrivateCamClient *)sharedManager;

- (id)initWithPrivateCamURL;

// accounts management
- (void)notifyUserSecurityIsBreachedWithAccountId:(NSString *)accountId caughtImage:(UIImage *)caughtImage success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
- (void)createAccountWithAccountInfo:(MSAccount *)account success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
- (void)authenticateUserWithAccountInfo:(MSAccount *)account success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
//- (void)authenticateUserWithFacebookId:(NSString *)facebookId email:(NSString *)email success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
//- (void)authenticateUserWithTwitterId:(NSString *)twitterId name:(NSString *)name success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
- (void)authenticateUserWithFacebookId:(NSString *)facebookId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
- (void)checkForUserWithTwitterId:(NSString *)accountId twitterId:(NSString *)twitterId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
- (void)authenticateUserWithTwitterId:(NSString *)twitterId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
- (void)linkTwitterAccountToPrivatecamAccount:(NSString *)accountId twitterAccount:(ACAccount *)twitterAccount success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
- (void)unlinkTwitterAccountToPrivatecamAccount:(NSString *)accountId twitterAccount:(ACAccount *)twitterAccount success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;


- (void)unauthenticateUserWithAccountId:(NSString *)accountId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
- (void)registerDeviceWithAccountId:(NSString *)accountId deviceToken:(NSString *)deviceToken success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
- (void)unregisterDeviceWithAccountId:(NSString *)accountId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
- (void)checkIfAccountExist:(MSAccount *)account success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
- (void)setProfileImageForAccount:(MSAccount *)account image:(UIImage *)image success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
- (void)updateAccountWithAccountInfo:(MSAccount *)account success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
- (void)removeAccountWithAccountId:(NSString *)accountId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;

// contact management
- (void)fetchContactsForAccountId:(NSString *)accountId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
- (void)fetchContactsByNameOrUsername:(NSString *)nameOrUsername success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
- (void)fetchRequestsForAccountId:(NSString *)accountId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
- (void)removeContactWithContactId:(NSString *)contactId accountId:(NSString *)accountId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
- (void)requestContactWithContactId:(NSString *)contactId accountId:(NSString *)accountId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
- (void)requestContactWithSocialId:(NSString *)socialId accountId:(NSString *)accountId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
- (void)acceptContactWithRequestId:(NSString *)requestId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
- (void)removeRequestWithRequestId:(NSString *)requestId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
- (void)fetchSuggestedFriendsFromSocialFriendsList:(NSDictionary *)socialFriendsList success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
- (void)fetchRequestsSentByMe:(NSString *)accountId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;

//  messages management
- (void)fetchMessagesForAccountId:(NSString *)accountId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
- (void)fetchMessagesById:(NSString *)messagesId limit:(NSInteger)limit multiplier:(NSInteger)multiplier success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
//- (void)removeMessageById:(NSString *)messageId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
//- (void)removeMessagesById:(NSString *)messagesId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
- (void)createMessageThreadWithAccountId:(NSString *)accountId contactId:(NSString *)contactId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
- (void)sendMessageWithMessagesId:(NSString *)messagesId accountId:(NSString *)accountId message:(NSString *)message success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;
- (void)sendImageWithMessagesId:(NSString *)messagesId accountId:(NSString *)accountId images:(NSArray *)images success:(MSAPISuccessBlock)success progress:(MSAPIProgressBlock)progress failure:(MSAPIFailureBlock)failure;
- (void)markMessagesReadWithMessagesId:(NSString *)messagesId success:(MSAPISuccessBlock)success failure:(MSAPIFailureBlock)failure;

@end
