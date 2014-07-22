//
//  AppDelegate.m
//  AvazPrediction
//
//  Created by Malar Kannan on 7/19/14.
//  Copyright (c) 2014 Malar Kannan. All rights reserved.
//

#import "AppDelegate.h"
#import "PicModeDictController.h"
#import "PredictionModeController.h"
#import "Context.h"

@implementation AppDelegate

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
   [self setGlobalManagedObjectContext];
    PredictionModeController* pdc = [[PredictionModeController alloc] init];
    NSArray* predictionArray;
    NSLog(@"\nNext Words:\n");
    predictionArray = [pdc getNextWords:@"Hello "];
    for(id i in predictionArray){
            NSLog(@"%@ %@",i, [pdc getImageForWord:i]);
    }
    NSLog(@"\nExact Suffix:\n");
    predictionArray = [pdc getExactSuffixCompletion:@"Hell"];
    for(id i in predictionArray){
            NSLog(@"%@ %@",i, [pdc getImageForWord:i]);
    }
    NSLog(@"\nMeta Suffix:\n");
    predictionArray = [pdc getMetaSuffixCompletion:@"Hell"];
    for(id i in predictionArray){
            NSLog(@"%@ %@",i, [pdc getImageForWord:i]);
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }


    NSString *storeDir = LIB_FOLDER;
    NSError *err;
    if (![[NSFileManager defaultManager] fileExistsAtPath:storeDir])
        [[NSFileManager defaultManager] createDirectoryAtPath:storeDir withIntermediateDirectories:NO attributes:nil error:&err];

    NSString *storePath = [LIB_FOLDER stringByAppendingPathComponent:@"Data.sqlite"];
    NSURL *storeURL = [NSURL fileURLWithPath:storePath];

    //NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent: @"Data.sqlite"];
    //NSString *storePath = [storeURL path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
#ifndef CREATE_SETTINGS
    if ( ![fileManager fileExistsAtPath:storePath] ) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"sqlite"];
        if(path) {
            [fileManager copyItemAtPath:path toPath:storePath error:NULL];
        }

    } else {
        DLog(@"Data.sqlite exists, opening");
    }
#endif

    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             @{@"journal_mode" : @"DELETE"}, NSSQLitePragmasOption,
                             nil];
    //    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:1] forKey:NSReadOnlyPersistentStoreOption];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.

         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.


         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.

         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]

         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.

         */
        DLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return __persistentStoreCoordinator;
}


- (NSManagedObjectModel *) managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Data" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    if(__managedObjectModel == nil) {
        DLog(@"Managed Object Model is nil\n");
        __managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
        if(__managedObjectModel == nil) {
            DLog(@"Managed Object Model is still null\n");
        }
    }
    return __managedObjectModel;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
        [__managedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    }
    return __managedObjectContext;
}

-(void)setGlobalManagedObjectContext{
    [Context setContext:[self managedObjectContext]];
    NSError *error;
    [[self managedObjectContext] save:&error];
}

@end
