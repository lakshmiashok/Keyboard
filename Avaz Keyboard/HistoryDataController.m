//
//  HistoryDataController.m
//  Data
//
//  Created by Prathab on 06/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HistoryDataController.h"
#import "Context.h"

@implementation HistoryDataController 

@synthesize managedObjectContext;
static HistoryDataController *static_object;

-(id) init {
    if(static_object != nil) {
        return static_object;
    }
    if(self = [super init]) {
        [self setContext:[Context getContext]];
        MAX_HISTORY_LIMIT = 10;
        static_object = self;
    }
    return self;
}

-(void) setContext:(NSManagedObjectContext *)context {
    managedObjectContext = context;
}

-(BOOL) addHistory:(NSString *)history {
    if([history isEqualToString:@""]) return false;
    return [self addHistory:history :[NSDate date]];
}

//add a new pair
-(BOOL) addHistory:(NSString *)history :(NSDate *)date { 
    DLog(@"Adding history\n");
    NSArray* all_history = [self getHistoryList];
    int history_count = [all_history count];
    
    //if history already present remove it
    for(id each_history in all_history) {
        if([[each_history history] compare:history] == 0) {
            [managedObjectContext deleteObject:each_history];
            history_count--;
        }
    }
    
    //if limit not meet remove oldest history
    if(history_count == MAX_HISTORY_LIMIT) {
        [managedObjectContext deleteObject:[all_history lastObject]];
    }
        
    DLog(@"Updating database\n");
    HistoryData *history_data = (HistoryData*)[NSEntityDescription insertNewObjectForEntityForName:@"HistoryData" inManagedObjectContext:managedObjectContext];
    [history_data setHistory:history];
    [history_data setDate:date];
    NSError *error = nil;
    if(![managedObjectContext save:&error]) {
        //Handle Error
        DLog(@"Error committing history - %@", [error userInfo]);
        return NO;
    } 
    return YES;
}

-(void) deleteHistory:(NSDate *)reference_date {
    NSArray *history_list = [self getHistoryList];
    for(int i =0;i<[history_list count];i++) {
        HistoryData *data = [history_list objectAtIndex:i];
        if([[data date] compare:reference_date] < 0) { 
            [managedObjectContext deleteObject:[history_list objectAtIndex:i]];
        }
    }
}

-(NSArray*) getHistoryList{
    //returns history in descending order
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"HistoryData"
                                              inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSSortDescriptor *sort_descriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sort_descriptors = [[NSArray alloc] initWithObjects:sort_descriptor, nil];
    [request setSortDescriptors:sort_descriptors];

    
    NSError *error = nil;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    
    return array;
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

@end
