//
//  EnvelopeManager.h
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 5/3/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Envelope.h"
#import "EnvelopeSectionData.h"
#import "UIPickerTextField.h"

enum EnvelopeMode {
    EnvelopeModeNormal,
    EnvelopeModeFill
};


@interface EnvelopeManager : NSObject
@property (assign, nonatomic) enum EnvelopeMode envelopeMode;
@property (nonatomic, strong) NSString * totalEnvelopeAmount;
@property (nonatomic, strong) NSString * fillFundsBudget;
+ (id)sharedManager;


- (void)initialize;

- (NSString *)GetTotalForEnvelopes:(NSArray *)envelopes;


//Validating Envelopes
- (BOOL)doesEnvelopeExistWithName:(NSString *)envelopeName andPayTypeName:(NSString *)payTypeName;

//Delete Envelopes
- (void)deleteEnvelope:(Envelope *)envelope;

//Modifying Envelopes
- (void)changeDisplayOrder:(NSNumber *)defaultOrder ofEnvelope:(Envelope *)envelope inEnvelopes:(NSMutableArray *)envelopes;
-(NSNumber *)totalYTDAmountFromFilterTransactions:(NSArray *)transactions type:(enum TransactionType)transactionType;
//Transactions
-(NSNumber *)totalAmountFromFilterTransactions:(NSArray *)transactions type:(enum TransactionType)transactionType;

//Filling Envelopes
- (void)fillEnvelopes:(NSArray *)envelopes withNotes:(NSString *)notes onDate:(NSDate *)date;
- (double)GetFillTotalDouble;
- (NSString *)GetFillTotal;
- (NSString *)GetFillTotalForSection:(NSInteger)Section;
- (NSString *)getFillValueForRow:(NSInteger)Row inSection:(NSInteger)Section;
- (NSString *)GetFillBalanceOfRemainingFunds;
- (void)UpdateFillDataAtSection:(NSInteger)Section AtRow:(NSInteger)Row withValue:(CGFloat)Value;
- (void)executeFillEnvelopes;
- (void)resetFillSection;
- (void)showPayTypeAlert:(UIPickerTextField *)pickerView;

- (BOOL)doesEnvelopeExistWithName:(NSString *)Name AndPayType:(NSString *)payType;
@end
