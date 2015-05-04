//
//  AppDelegate.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 12/7/13.
//  Copyright (c) 2013 MYOB University. All rights reserved.
//

#import "AppDelegate.h"
#import "MSDataManager.h"
#import "MSUIManager.h"
#import "PinViewController.h"
#import "PayTypeManager.h"

@interface AppDelegate()
@property (nonatomic, strong) MSDataManager * dataManager;
@property (nonatomic, strong) MSUIManager * uiManager;
@end

@implementation AppDelegate

- (MSDataManager *)dataManager
{
	return [MSDataManager sharedManager];
}

- (MSUIManager *)uiManager
{
	return [MSUIManager sharedManager];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
     self.window.backgroundColor = [UIColor whiteColor];
    
    // Override point for customization after application launch.
    [[PayTypeManager sharedManager] initialize];
    [self.dataManager initializeData];
    [self.uiManager initializeUI];
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
/*
    PinViewController * pinView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PinViewController"];
    pinView.pinViewControllerType = PinViewControllerTypeAuthenicate;
    [self.window.rootViewController presentViewController:pinView animated:NO completion:nil];
 */
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
/*
    NSLog(@"self.dataManager: %@", self.dataManager);
    if(self.dataManager.currentUserAccount != nil && ![self.dataManager.currentUserAccount isCorrectPin:nil])
    {
        PinViewController * pinView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PinViewController"];
        pinView.pinViewControllerType = PinViewControllerTypeAuthenicate;
    }
 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
