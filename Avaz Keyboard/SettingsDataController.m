//
//  SettingsDataController.m
//  Data
//
//  Created by Prathab on 24/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsDataController.h"
#import "Context.h"

@implementation SettingsDataController 

@synthesize managedObjectContext;
static SettingsDataController *static_object;

-(id) init {
    if(static_object != nil) {
        return static_object;
    }
    if(self = [super init]) {
        [self setContext:[Context getContext]];
        static_object = self;
    }
    return self;
}

-(void) setContext:(NSManagedObjectContext *)context {
    managedObjectContext = context;
}

-(void) commit {
    NSError *error = nil;
    if(![managedObjectContext save:&error])
    {
        DLog(@"ERROR in committing Settings !- %@", [error userInfo]);
    }
}

-(SettingsData*) getDefault {
    return [self getSettingsData:NSLocalizedString(@"Default",nil)];
}

-(SettingsData*) addSettingsData:(NSString*) identifier {
    SettingsData *settings_data = (SettingsData*)[NSEntityDescription insertNewObjectForEntityForName:@"SettingsData" inManagedObjectContext:managedObjectContext];
    [settings_data setIdentifier:identifier];
    
    NSError *error = nil;
    if(![managedObjectContext save:&error]) {
        //Handle Error
        DLog(@"ERROR in committing after add in Settings !- %@", [error userInfo]);
        return nil;
    } 
    return settings_data;
}

-(BOOL) removeSettingsData:(NSString*) identifier {
    SettingsData* settings_data = [self isValid:identifier];
    if(settings_data != nil) {
        [managedObjectContext deleteObject:settings_data];
    }
    
    NSError *error = nil;
    if(![managedObjectContext save:&error]) {
        DLog(@"Error committing after removing settings - %@", [error userInfo]);
        return NO;  //return NO in case of error
    }
    return YES; //return YES if successfull
}

-(SettingsData*) getSettingsData:(NSString *)identifier {
    return [self isValid:identifier];
}

-(SettingsData*) isValid:(NSString *)identifier {
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"SettingsData"
                                              inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier like[cd] %@",identifier];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    
    if(array == nil) {
        //error occurred
        DLog(@"Error array is nil");
        return nil;
    }
    if( [array count] == 1 ) {
        return [array objectAtIndex:0];
    } else {
        for(int i =0;i<[array count]-1;i++) {
            [managedObjectContext deleteObject:[array objectAtIndex:i]];
        }
        return [array objectAtIndex:[array count] -1];
    }
    
}

-(void) reset {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SettingsData" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *all_prediction_data = [managedObjectContext executeFetchRequest:request error:&error];
    for(int i = 0;i<[all_prediction_data count];i++) {
        [managedObjectContext deleteObject:[all_prediction_data objectAtIndex:i]];
    }
}


@end
