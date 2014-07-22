//
//  HistoryDataController.h
//  Data
//
//  Created by Prathab on 06/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HistoryData.h"
#import "HistoryData+UtilityMethods.h"
@interface HistoryDataController : NSObject {
    NSManagedObjectContext *managedObjectContext;
    int MAX_HISTORY_LIMIT;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

-(id) init;

-(void) setContext:(NSManagedObjectContext*) context;

//add a new string with the history object
-(BOOL) addHistory:(NSString*) history;

-(BOOL) addHistory:(NSString*) history: (NSDate*) date;

//get list of all valid history
-(NSArray*) getHistoryList;

//delete history before a reference date
-(void) deleteHistory:(NSDate*) reference_date;

-(void) reset;

@end
