//
//  Transaction.h
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 3/28/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "MSModelObject.h"
#import "UserAccount.h"

enum TransactionType {
    transactionTypeCreated,
    transactionTypeAdd,
    transactionTypeMinus,
    transactionTypePayTypeAdd,
    transactionTypePayTypeEdit,
    transactionTypePayTypeRemove,
    transactionTypeUserEdit,
    transactionTypeMoveAdd,
    transactionTypeMoveMinus
};

@interface Transaction : MSModelObject
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) NSNumber * amount;
@property (nonatomic, strong) NSString * notes;
@property (nonatomic, strong) NSString * systemNotes;
@property (nonatomic, strong) NSString * paytype;
@property (nonatomic, assign) enum TransactionType transactionType;
@property (nonatomic, strong) UserAccount * user;
@property (nonatomic, strong) NSString * displayAmount;
@property (nonatomic, strong) NSString * linkedEnvelopeIdentifier;
@property (strong, nonatomic) NSString * linkID;

- (void)update;
- (NSString *)fullNotes;



@end
