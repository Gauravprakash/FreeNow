//
//  AppDelegate.m
//  FreeNow
//
//  Created by Techwin Labs 28 Dec on 20/03/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "NotificationScreen.h"
#import "Reachability.h"
#import "ContactsView.h"
#import "ShareContacts.h"
#import "LoginScreen.h"
#import "FreeStatus.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate (){
    FreeStatus* status_free;
    UIView *viewToAdd;
}
@end

# pragma mark => Application Life Cycle

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    Reachability *rHostName=[Reachability reachabilityWithHostName:@"http://54.229.178.2/freenow/api/index.php"];
    [rHostName startNotifier];
    [rHostName currentReachabilityStatus];
    NetworkStatus networkStatus = [rHostName currentReachabilityStatus];
    if (networkStatus != NotReachable) {
        NSLog(@"Connected successfully!");
    }
    else {
        NSLog(@"Not Connected!");
    }
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"isLogin"]){
        ShareContacts* screen=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ShareContacts"];
        UINavigationController* navBar=[[UINavigationController alloc]initWithRootViewController:screen];
        [[navBar navigationBar]setHidden:YES];
        self.window.rootViewController=navBar;
    }
    else{
        LoginScreen* login=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"LoginScreen"];
        UINavigationController* navBar=[[UINavigationController alloc]initWithRootViewController:login];
        [[navBar navigationBar]setHidden:YES];
        self.window.rootViewController=navBar;
    }
    [application registerForRemoteNotifications];
    [self registerForRemoteNotification];
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

# pragma mark => Push Notification delegates

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
 if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]){
    NSString *deviceTokens = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokens = [deviceTokens stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"registered device token %@", deviceTokens);
    self.deviceToken = deviceTokens;
    NSLog(@"Did Register for Remote Notifications with Device Token (%@)", deviceToken);
}
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
       [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    NSLog(@"Received remote notification: %@",userInfo);
    for (id key in userInfo){
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"pushNotification" object:nil];
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
}
// facebook delegates
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}
-(void)applicationWillResignActive:(UIApplication *)application{
    NSLog(@"Resign Active state");
}
- (void)applicationDidEnterBackground:(UIApplication *)application{
    NSLog(@"App enters in Background mode");
    [[NSNotificationCenter defaultCenter]postNotificationName:UIApplicationDidEnterBackgroundNotification object:nil];
    }
- (void)applicationWillEnterForeground:(UIApplication *)application{
     NSLog(@"App enters in Foreground mode");
}
- (void)applicationDidBecomeActive:(UIApplication *)application{
    [FBSDKAppEvents activateApp];
}
- (void)applicationWillTerminate:(UIApplication *)application{
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory{
    // The directory the application uses to store the Core Data store file. This code uses a directory named "Techwin.FreeNow" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
- (NSManagedObjectModel *)managedObjectModel{
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
}
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FreeNow" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil){
        return _persistentStoreCoordinator;
    }
// Create the coordinator and store
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FreeNow.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}
- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil){
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator){
        return nil;
    }
_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

# pragma mark - Core Data Saving support

- (void)saveContext{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

# pragma mark => Registering for remote notification

-(void)registerForRemoteNotification{
// For iOS 8 and above
[[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
[[UIApplication sharedApplication] registerForRemoteNotifications];
}

@end
