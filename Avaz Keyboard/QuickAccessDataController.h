//
//  QuickAccessDataController.h
//  Data
//
//  Created by Prathab on 06/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuickAccessData.h"
#import "QuickAccessData+UtilityMethods.h"

@interface QuickAccessDataController : NSObject {
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

//constructor
-(id) init;

//set the context
-(void) setContext:(NSManagedObjectContext*) context;

//add a new pair
-(BOOL) addPair:(NSString*) key:(NSString*) text;

//remove a key if it is available
-(BOOL) removeKey:(NSString*) key;

-(BOOL) removeQuickText:(NSString*) quick_text;

//get text from key
-(NSString*) getText:(NSString*) key;

//get the object containing the key
-(QuickAccessData*) isValidKey:(NSString*) key;

-(NSArray*) getAllQuickAccessData;

-(NSArray*) getQuickAccessBarData;

-(void) insertDefaultQuickAccessData;

-(void) reset;

@end
