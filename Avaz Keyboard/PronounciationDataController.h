//
//  PronounciationDataController.h
//  Data
//
//  Created by Prathab on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PronounciationData.h"

@interface PronounciationDataController : NSObject{
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

//set the context
-(void) setContext:(NSManagedObjectContext*) context;

//add a new pronounciation entry
-(BOOL) addPronounciationData:(NSString*) actual:(NSString*) spoken;

//remove a pronounciation entry if it is available
-(BOOL) removePronounciationData:(NSString*) actual;

//get spoken text for actual text
-(NSString*) getPronounciationData:(NSString*) actual;

//get the object containing the actual data
-(PronounciationData*) isValidPronounciationData:(NSString*) actual;

//returns pronounciation sentence for a given sentence
-(NSString*) getPronounciationSentence:(NSString*) sentence;

-(void) reset;

@end
