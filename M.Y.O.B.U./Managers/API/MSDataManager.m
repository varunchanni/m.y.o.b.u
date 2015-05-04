//
//  MSDataManager.m
//  The Envelope Filler
//
//  Created by Raymond Kelly on 9/27/13.
//  Copyright (c) 2013 MFX Studios. All rights reserved.
//

#import "MSDataManager.h"
#import "MSDataUtilities.h"
#import "Currency.h"
#import "Feature.h"
#import "EnvelopeCategory.h"
#import "Envelope.h"
#import "PayTypeManager.h"

#define kFEATURES_KEY                    @"M.Y.O.B.U. Features"
#define kFEATURE_NAME                    @"Feature Name"
#define kFEATURE_CONTENT                 @"Content"

#define kWITHDRAWER_PLIST_NAME           @"WithdrawerConfig"
//#define kWITHDRAWER_CONTENT_ROOT         @"US Currencies"


#define kENVELOPEFILLERPLIST_NAME           @"EnvelopeFillerConfig"
#define kENVELOPEFILLER_CONTENT_ENVELOPES   @"Envelopes"
#define kENVELOPEFILLER_CONTENT_PAYTYPES    @"PayTypes"

#define kMAX_UNDO_ACTIONS                1000

NSString * const kEnvelopesKey = @"Envelopes";
NSString * const kEnvelopesDefaultKey = @"DefaultEnvelopes";
NSString * const kEnvelopeCategoriesDefaultKey = @"DefaultEnvelopeCategories";
//NSString * const kEnvelopePayTypesKey = @"EnvelopePayTypes";
NSString * const kEnvelopePayTypesDefaultKey = @"DefaultEnvelopePayTypes";

/*
NSString * const kEnvelopeFillerPlistName = @"envelopeFillerFeature";
NSString * const kBudgetPlistName = @"budgetFeature";
NSString * const kStandardCurrenciesKey = @"StandardCurrencies";
NSString * const kStandardBudgetItemsKey  = @"StandardBudgetItems";
NSString * const kCurrencyObjectsKey = @"CurrencyObjects";
NSString * const kBudgetItemsKey  = @"BudgetItems";

static NSInteger const kMaxUndoActions = 5;
*/

@interface MSDataManager()
//@property (nonatomic, strong) NSArray * bugdetCategoryNames;
//@property (nonatomic, strong) NSArray * bugdetCategoryColors;
//@property (nonatomic, strong) NSMutableArray * transitionLog;
@property (nonatomic, strong) NSMutableDictionary *undoActions;
@property (nonatomic, strong) NSMutableArray * defaultEnvelopes;
@end

@implementation MSDataManager


+ (id)sharedManager
{
	static MSDataManager *_sharedManager = nil;
    static dispatch_once_t onceQueue;
	
    dispatch_once(&onceQueue, ^{
        _sharedManager = [[self alloc] init];
    });
    
	return _sharedManager;
}

- (void)initializeData
{
    NSDictionary * systemAccounData = @{@"userId":@"0",@"firstname":@"System",@"lastname":@"System", @"username":@"System"};
    self.systemUserAccount = [[UserAccount alloc] initWithDictionary:systemAccounData];
    
    self.undoActions = [[NSMutableDictionary alloc] init];
    
    //load custom features
    
    __block NSMutableArray * tempFeatures = [[NSMutableArray alloc] init];
    NSArray * featuresArrayInfo = [[NSBundle mainBundle] objectForInfoDictionaryKey:kFEATURES_KEY];
    
    [featuresArrayInfo enumerateObjectsUsingBlock:^(NSDictionary *featureDictionaryInfo, NSUInteger idx, BOOL *stop) {
        
        Feature * feature = [[Feature alloc] initWithDictionary:featureDictionaryInfo];
        [tempFeatures addObject:feature];
    }];
    
    
    self.features = tempFeatures;
    [self.features enumerateObjectsUsingBlock:^(Feature * feature, NSUInteger idx, BOOL *stop) {
        
        [self loadFeatureDataPlistName:feature.plist];
    }];
    
    if(self.envelopes == nil)
    {
        self.envelopes = self.defaultEnvelopes;
    }
}
#pragma Account Data
- (UserAccount *)createUserAccount
{
    UserAccount * userAccount = nil;
    
    return userAccount;
}

#pragma Loading Property List Data
- (void)loadFeatureDataPlistName:(NSString *)plistName
{
    //Load Feature Configuration Settings
    NSMutableDictionary * rootData = [MSDataUtilities getDataFromPlistByName:plistName];

    // if data has been saved pull from object, else pull from standard.. the reset object
    if([[rootData allKeys] containsObject:kFEATURE_NAME])
    {
        if([[rootData objectForKey:kFEATURE_NAME] isEqualToString:kFEATURE_WITHDRAWER_KEY])
        {
            [self loadWithdrawer:[rootData objectForKey:kFEATURE_CONTENT]];
        }
        else if([[rootData objectForKey:kFEATURE_NAME] isEqualToString:kFEATURE_ENVELOPE_FILLER_KEY])
        {
            [self loadEnvelopeFiller:[rootData objectForKey:kFEATURE_CONTENT]];
        }
    }
}

- (void)loadWithdrawer:(NSDictionary *)content
{
    if(content)
    {
        NSString * key = [Currency getCurrencyObjectsKey];
        
        if([[content allKeys] containsObject:key])
        {
            [self loadWithdrawerFromContent:content withKey:key];
        }
        else
        {
            [self loadWithdrawerFromDefault:content];
        }
        
    }
}

- (void)loadWithdrawerFromContent:(NSDictionary *)content withKey:(NSString *)key
{
    NSData * currencyObjectsData = [content objectForKey:key];
    self.currencyObjects = [NSKeyedUnarchiver unarchiveObjectWithData:currencyObjectsData];
}

- (void)loadWithdrawerFromDefault:(NSDictionary *)content
{
    NSString * key = [Currency getCurrencyObjectsDefaultKey];
    
    self.currencyObjects = @[].mutableCopy;
    NSArray * currencyObjectsData = [content objectForKey:key];
    [currencyObjectsData enumerateObjectsUsingBlock:^(NSDictionary * currencyData, NSUInteger idx, BOOL *stop) {
        
        Currency * currencyObject = [[Currency alloc] initWithDictionary:currencyData];
        [self.currencyObjects addObject:currencyObject];
    }];
}

- (void)loadEnvelopeFiller:(NSDictionary *)content
{
    
    
    //[NSKeyedUnarchiver unarchiveObjectWithData:data]
    /*
    NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"MyCount"];
    NSNumber * counter = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (counter == nil) {
        counter = 0;
    }
    NSLog(@"Count %@", counter);
    
    counter = @(counter.doubleValue + 1);
    
    data = [NSKeyedArchiver archivedDataWithRootObject:counter];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"MyCount"];
    data = [[NSUserDefaults standardUserDefaults] valueForKey:@"MyCount"];
    counter = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    
    NSLog(@"Count %@", counter);
    */
    
    
    if(content)
    {
        //load defaults envelope categories
        NSString *key = kEnvelopeCategoriesDefaultKey;
        NSArray *array = [content objectForKey:key];
        
        NSMutableArray * tempEnvelopeCategories = @[].mutableCopy;
        
        [array enumerateObjectsUsingBlock:^(NSDictionary * envelopeCategoryInfo, NSUInteger idx, BOOL *stop) {
            
            EnvelopeCategory * envelopeCat = [[EnvelopeCategory alloc] initWithDictionary:envelopeCategoryInfo];
            [tempEnvelopeCategories addObject:envelopeCat];
        }];
        
        self.envelopeCategories = [[NSArray alloc] initWithArray:tempEnvelopeCategories];
        
       
        NSData * data = [[NSUserDefaults standardUserDefaults] valueForKey:@"_ENVELOPES"];
        self.envelopes = [NSKeyedUnarchiver unarchiveObjectWithData:data];

        
        
        if(self.envelopes != nil) {
            
            // set paytypes
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([defaults valueForKey:kPayTypesKey] == nil) {
                for (Envelope * e in self.envelopes){
                    [[PayTypeManager sharedManager] addPayType:e.paytype];
                }
            }
        }
        else
        {
            //load defaults
            key = kEnvelopesDefaultKey;
            NSArray *array = [content objectForKey:key];
            
            self.defaultEnvelopes = [[NSMutableArray alloc] init];
            [array enumerateObjectsUsingBlock:^(NSDictionary * envelopeInfo, NSUInteger idx, BOOL *stop) {
                
                Envelope * envelope = [[Envelope alloc] initWithDictionary:envelopeInfo andUser:self.systemUserAccount OnDate:[NSDate date]];
                [self.defaultEnvelopes addObject:envelope];
            }];
            self.envelopes = self.defaultEnvelopes;
        }
    }
}



- (void)updateCurrencyObjects{

    NSData *currenyData = [NSKeyedArchiver archivedDataWithRootObject:self.currencyObjects];
    
    [MSDataUtilities saveDataToPlistByName:kWITHDRAWER_PLIST_NAME key:[Currency getCurrencyObjectsKey]
                                     data:currenyData feature:kFEATURE_WITHDRAWER_KEY];
    self.currencyObjects = [NSKeyedUnarchiver unarchiveObjectWithData:currenyData];
}

- (void)updateEnvelopesObjects{

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.envelopes];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"_ENVELOPES"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    data = [[NSUserDefaults standardUserDefaults] valueForKey:@"_ENVELOPES"];
    self.envelopes = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"Data Saved");
    /*
    [MSDataUtilities saveDataToPlistByName:kENVELOPEFILLERPLIST_NAME
                                       key:kEnvelopesKey
                                      data:data
                                   feature:kEnvelopesKey];
    */
    
    //self.envelopes = [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (void)updateEnvelopePayTypesObjects{
    
    [[PayTypeManager sharedManager] savePayTypes];
    /*
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.envelopePayTpyes];
    [MSDataUtilities saveDataToPlistByName:kENVELOPEFILLERPLIST_NAME
                                       key:kEnvelopePayTypesKey
                                      data:data
                                   feature:kEnvelopesKey];
    self.envelopePayTpyes = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    */
}
/*
- (void)updateEnvelopeFillerObjects:(NSArray *)dataToSave key:(NSString *)key{

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dataToSave];
    [MSDataUtilities saveDataToPlistByName:kENVELOPEFILLERPLIST_NAME
                                       key:key
                                     data:data
                                   feature:kEnvelopesKey];
}
*/
-(BOOL)hasUndoActions:(NSString *)key
{
    BOOL hasUndoActions = NO;
    
    NSArray * array = [self.undoActions objectForKey:key];
    
    if(array != nil)
    {
        if(array.count > 0)
        {
            hasUndoActions = YES;
        }
    }
    
    return hasUndoActions;
}


- (void)addCurrencyUndoAction:(id)value
{
    NSMutableArray * undos = [self getUndoArrayOfFeature:kFEATURE_WITHDRAWER_KEY];
    [undos insertObject:value atIndex:0];
    [self setUndoArrayOfFeature:kFEATURE_WITHDRAWER_KEY withArray:undos];
    
}
- (id)removeAndGetLastestCurrencyUndoAction
{
    NSMutableArray * undos = [self getUndoArrayOfFeature:kFEATURE_WITHDRAWER_KEY];
    id value = [undos objectAtIndex:0];
    [undos removeObjectAtIndex:0];
    [self setUndoArrayOfFeature:kFEATURE_WITHDRAWER_KEY withArray:undos];
    
    return value;
}


- (NSMutableArray *)getUndoArrayOfFeature:(NSString *)feature
{
    NSMutableArray * array;
    if([self.undoActions valueForKey:feature] == nil)
    {
        array =  [[NSMutableArray alloc] init];
    }
    else
    {
        array = [self.undoActions valueForKey:feature];
    }
    
    return array;
}

- (void)setUndoArrayOfFeature:(NSString *)feature withArray:(NSArray *)array
{
    [self.undoActions setValue:array forKey:feature];
}

- (void)resetToPreviousUndoAction:(NSString *)key
{
    NSMutableArray * array = [[NSMutableArray alloc] initWithArray:[self.undoActions valueForKey:key]];
    
    if([key isEqualToString:kFEATURE_WITHDRAWER_KEY] == YES)
    {
        // set global var back to undo state and remove action
        self.currencyObjects = [array objectAtIndex:0];
        [array removeObjectAtIndex:0];
    }
    
    [self.undoActions setObject:array forKey:key];
}

- (Envelope *)GetEnvelopeByName:(NSString *)name
{
    __block Envelope * evelope;
    
    [self.envelopes enumerateObjectsUsingBlock:^(Envelope * obj, NSUInteger idx, BOOL *stop) {
        
        if([obj.name isEqualToString:name])
        {
            evelope = obj;
            *stop = YES;
        }
        
    }];
    
    return evelope;
}

- (Envelope *)GetEnvelopeByIdentifier:(NSString *)identifier
{
    __block Envelope * evelope;
    
    [self.envelopes enumerateObjectsUsingBlock:^(Envelope * obj, NSUInteger idx, BOOL *stop) {
        
        if([obj.identifier isEqualToString:identifier])
        {
            evelope = obj;
            *stop = YES;
        }
        
    }];
    
    return evelope;
}


- (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    
    return (__bridge NSString *)string;
}

@end

