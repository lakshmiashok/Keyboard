//
//  QuickAccessDataController.m
//  Data
//
//  Created by Prathab on 06/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuickAccessDataController.h"
#import "Context.h"

@implementation QuickAccessDataController

@synthesize managedObjectContext;
static QuickAccessDataController *static_object;

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

//add a new pair
-(BOOL) addPair:(NSString*) key:(NSString*) text {
    
    QuickAccessData *lookup = [self isValidKey:key];
    //if pair already exists return NO
    if( lookup != nil ) {
        [lookup setQuick_text:text];
    } else {
        QuickAccessData *quick_access_data = (QuickAccessData*)[NSEntityDescription insertNewObjectForEntityForName:@"QuickAccessData" inManagedObjectContext:managedObjectContext];
        [quick_access_data setKey:key];
        [quick_access_data setQuick_text:text];
    }
    NSError *error = nil;
    
    if(![managedObjectContext save:&error]) {
        //Handle Error
        DLog(@"Error committing QuickAccess - %@", [error userInfo]);
        return NO;
    } 
    return YES;
}

//remove a key if it is available
-(BOOL) removeKey:(NSString*) key {
    
    QuickAccessData* quick_access_data = [self isValidKey:key];
    if(quick_access_data != nil) {
        [managedObjectContext deleteObject:quick_access_data];
    }
    
    NSError *error = nil;
    if(![managedObjectContext save:&error]) {
        return NO;  //return NO in case of error
    }
    return YES; //return YES if successfull
}

-(BOOL) removeQuickText:(NSString *)quick_text {
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"QuickAccessData"
                                              inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"quick_text like [c] %@",quick_text];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    if([array count] >= 1) {
        [managedObjectContext deleteObject:[array objectAtIndex:0]];
    
        NSError *error = nil;
        if(![managedObjectContext save:&error]) {
            return NO;  //return NO in case of error
        }
    }
    return YES;
}

-(NSArray*) getAllQuickAccessData {
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"QuickAccessData"
                                              inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError *error = nil;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    
    return array;
}

-(NSArray*) getQuickAccessBarData {
    NSString *quickAccessBarIdentifier = @"Quick";
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"QuickAccessData"
                                              inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key like[c] %@",[quickAccessBarIdentifier stringByAppendingString:@"*"]];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sort_descriptor = [[NSSortDescriptor alloc] initWithKey:@"key" ascending:YES];
    NSArray *sort_descriptors = [[NSArray alloc] initWithObjects:sort_descriptor, nil];
    [request setSortDescriptors:sort_descriptors];
    
    NSError *error = nil;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    return array;
}

-(QuickAccessData*) isValidKey:(NSString*) key{
    DLog(@"Key is %@\n",key);
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"QuickAccessData"
                                              inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key like[c] %@",key];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    if(array == nil) {
        //error occurred
        DLog(@"Array is nil\n");
        return nil;
    }
    if( [array count] == 1 ) {
        return [array objectAtIndex:0];
    } else {
        NSArray *arr= [self getAllQuickAccessData];
        DLog(@"All quick access data\n");
        for(int i =0;i<[arr count];i++) {
            DLog(@"%@ %@\n",[[arr objectAtIndex:i] key],[[arr objectAtIndex:i] quick_text]);
        }
        DLog(@"Array count is not 1 it is %d\n",[array count]);
        return nil;
    }
 
}

-(NSString*) getText:(NSString *)key {
    QuickAccessData *quick_data = [self isValidKey:key];
    if(quick_data != nil) {
        return [quick_data quick_text];
    } else {
        return @"";
    }
}

-(void) reset {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuickAccessData" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *all_data= [managedObjectContext executeFetchRequest:request error:&error];
    for(int i = 0;i<[all_data count];i++) {
        [managedObjectContext deleteObject:[all_data objectAtIndex:i]];
    }
}

-(void) insertDefaultQuickAccessData {
    [self addPair:@"Quick1" :NSLocalizedString(@"Yes",nil)];
    [self addPair:@"Quick2" :NSLocalizedString(@"No",nil)];
    [self addPair:@"Quick3" :NSLocalizedString(@"Thank You",nil)];
    [self addPair:@"Quick4" :NSLocalizedString(@"How are you?",nil)];
    [self addPair:@"Quick5" :NSLocalizedString(@"Sorry",nil)];
    [self addPair:@"Quick6" :NSLocalizedString(@"Please help me",nil)];
}

@end
