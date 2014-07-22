//
//  Context.m
//  Data
//
//  Created by Prathab on 16/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Context.h"

static NSManagedObjectContext *managedObjectContext;
static NSManagedObjectContext *managedObjectContextReadOnly;

@implementation Context


+(void) setContext:(NSManagedObjectContext *)context {
    managedObjectContext = context;
}

+(NSManagedObjectContext*) getContext {
    return managedObjectContext;
}


#pragma mark - Core Data stack

//+ (void)recreateManagedObjectContext
//{
//    //[managedObjectContext reset];
//    
//    NSManagedObjectModel *newModel = [Context managedObjectModel];
//    NSPersistentStoreCoordinator *newCoordinator = [Context persistentStoreCoordinatorWithManagedObjectModel:newModel andStoreURL:[Context getDataStoreURL]];
//    if (newCoordinator != nil)
//    {
//        managedObjectContext = [[NSManagedObjectContext alloc] init];
//        [managedObjectContext setPersistentStoreCoordinator:newCoordinator];
//        [managedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
//    }
//}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
*/
+ (NSManagedObjectModel *)managedObjectModel
{

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Data" withExtension:@"momd"];
    NSManagedObjectModel *newManagedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    if(newManagedObjectModel == nil) {
        DLog(@"Managed Object Model is nil\n");
        newManagedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
        if(newManagedObjectModel == nil) {
            DLog(@"Managed Object Model is still null\n");
        }
    }
    return newManagedObjectModel;
}


//+(NSURL *)getDataStoreURL{
//    NSString *storePath = [LIB_FOLDER stringByAppendingPathComponent:@"Data.sqlite"];
//    NSURL *storeURLV2 = [NSURL fileURLWithPath:storePath];
//    return storeURLV2;
//}


//+(NSURL *)getDefaultDataStoreURL{
//    NSURL *defaultStoreURL =  [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"User-Data" ofType:@"sqlite"]];
//    return defaultStoreURL;
//}

+(NSString *) getVersionIdentifierForStore:(NSURL *)storeURL{
    //NSString *storePath = [LIB_FOLDER stringByAppendingPathComponent:@"Data.sqlite"];
    //NSURL *storeURL = [NSURL fileURLWithPath:storePath];
    NSError *err = nil;
    NSDictionary *metadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:@"sqlite" URL:storeURL error:&err];
    NSSet *versionIds = [[NSManagedObjectModel mergedModelFromBundles:nil forStoreMetadata:metadata] versionIdentifiers];
    if([versionIds count] > 0){
        return [[versionIds allObjects] objectAtIndex:0];
    }
    return @"";
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
+ (NSPersistentStoreCoordinator *)persistentStoreCoordinatorWithManagedObjectModel:(NSManagedObjectModel*) model andStoreURL:(NSURL *)storeURL
{

    NSPersistentStoreCoordinator *newPersistentStoreCoordinator;
    NSError *error = nil;
    newPersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             @{@"journal_mode" : @"DELETE"}, NSSQLitePragmasOption,
                             nil];

    if (![newPersistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
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
    return newPersistentStoreCoordinator;
}

@end
