//
//  PredictionDictController.h
//  Data
//
//  Created by Prathab on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PredictionDict.h"
#import "PredictionDict+UtilityMethods.m"
#import "NSString+Additions.h"
@interface PredictionDictController : NSObject {
    NSManagedObjectContext *managedObjectContext;
    NSFetchRequest *prediction_request;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

-(id) init;

-(void) setContext:(NSManagedObjectContext*) context;

//add a prediction entry from a file entry
//example of,the,131190
-(BOOL) addPredictionFromString:(NSString*) prediction_data;

-(BOOL) addPrediction:(NSString*) parent:(NSString*) prediction:(NSDecimalNumber*) frequency;

//update the prediction data from the sentence
//Who am I updates the bigrams who am , am i 
-(BOOL) updateFromSentence:(NSString*) sentence;

//returns a array of PredictionDict for a given parent string
-(NSArray*) getPrediction:(NSString*) parent;

//populate from a file
-(void) populateFromFile:(NSString*) file:(NSString*) type;

-(PredictionDict*) isValidPrediction:(NSString*) parent:(NSString*) prediction;

//clears the whole dictionary
-(void) reset;

@end
