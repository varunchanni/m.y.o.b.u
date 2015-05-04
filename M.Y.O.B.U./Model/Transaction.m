//
//  Transaction.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 3/28/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "Transaction.h"
#import "MSUIManager.h"


@implementation Transaction

- (NSString *)displayAmount
{
    return [MSUIManager addCurrencyStyleCommaToDouble:[self.amount doubleValue]];
}

- (void)initCustomProperties
{
    self.amount = (self.amount == nil) ? @(0): self.amount;
    self.notes = ([self.notes length] == 0) ? @"": self.notes;
    self.systemNotes = ([self.systemNotes length] == 0) ? @"": self.systemNotes;
    self.paytype = ([self.paytype length] == 0) ? @"": self.paytype;
    self.date = (self.date == nil) ? [NSDate date] : self.date;
    self.user = (self.user == nil) ? [[UserAccount alloc] init] : self.user;
    self.linkedEnvelopeIdentifier = ([self.linkedEnvelopeIdentifier length] == 0) ? @"": self.linkedEnvelopeIdentifier;
    self.linkID = ([self.linkID length] == 0) ? @"": self.linkID;
    
    self.customProperties = @{@"amount":self.amount,
                              @"notes":self.notes,
                              @"systemNotes":self.systemNotes,
                              @"paytype":self.paytype,
                              @"date":self.date,
                              @"user":self.user,
                              @"transactionType":@(self.transactionType),
                              @"linkedEnvelopeIdentifier": self.linkedEnvelopeIdentifier,
                              @"linkID":self.linkID};
}


- (void)update {
    
    [self initCustomProperties];
}

- (NSString *)fullNotes {
    
    NSString * tempNotes = @"";
    if (self.notes != nil) {
        
        tempNotes = self.notes;
    }
    
    NSString * tempSystemNotes = @"";
    if (self.systemNotes != nil) {
        tempSystemNotes = self.systemNotes;
    }
    
    return [tempSystemNotes stringByAppendingString:tempNotes];
}

@end
