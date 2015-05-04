//
//  MSDataManager.h
//  The Envelope Filler
//
//  Created by Raymond Kelly on 9/27/13.
//  Copyright (c) 2013 MFX Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserAccount.h"
#import "Currency.h"
#import "Envelope.h"
#import "UICustomTextField.h"
#import "LFGlassView.h"

#define kFEATURE_WITHDRAWER_KEY          @"Withdrawer"
#define kFEATURE_ENVELOPE_FILLER_KEY     @"Envelope Filler"
/*
extern NSString * const kEnvelopeFillerPlistName;
extern NSString * const kBudgetPlistName;
extern NSString * const kStandardCurrenciesKey;
extern NSString * const kStandardBudgetItemsKey;
extern NSString * const kCurrencyObjectsKey;
extern NSString * const kBudgetItemsKey;
*/

@interface MSDataManager : NSObject
@property (nonatomic, strong) NSMutableArray * accounts;
@property (nonatomic, strong) UserAccount * currentUserAccount;
@property (nonatomic, strong) UserAccount * systemUserAccount;
@property (nonatomic, strong) NSString * lastLoggedOutEmail;
@property (nonatomic, strong) NSArray * features;

#pragma widthdrawer variables
@property (nonatomic, strong) NSMutableArray * currencyObjects;

#pragma envelope filler variables
@property (nonatomic, strong) NSArray * envelopeCategories;
@property (nonatomic, strong) NSMutableArray * envelopes;
//@property (nonatomic, strong) NSMutableArray * envelopePayTpyes;

@property (nonatomic, strong) UIView *activeResponder;
@property (nonatomic, strong) LFGlassView * dimOverlay;

+ (id)sharedManager;

//init
- (void)initializeData;

//saving data
- (void)updateCurrencyObjects;
- (void)updateEnvelopesObjects;
- (void)updateEnvelopePayTypesObjects;

//undo actions
- (BOOL)hasUndoActions:(NSString *)key;
- (void)addCurrencyUndoAction:(id)value;
- (id)removeAndGetLastestCurrencyUndoAction;

//helper
- (NSString *)GetUUID;
- (Envelope *)GetEnvelopeByName:(NSString *)name;
- (Envelope *)GetEnvelopeByIdentifier:(NSString *)identifier;
@end
