//
//  WordDataController.h
//  Data
//
//  Created by Prathab on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WordData.h"
#import "WordData+UtilityMethods.h"
#import "NSString+Additions.h"

@interface WordDataController : NSObject {
    NSManagedObjectContext *managedObjectContext;
 //   NSMutableArray *prediction_result;  //buffers the result
 //   NSString *prediction_query;  //store the last query
    NSArray *root_prediction; //prediction for empty strng
    NSDictionary *in_memory_prediction;
    NSDictionary *in_memory_metadiction;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSArray *root_prediction;

-(id) init;

-(void) setContext:(NSManagedObjectContext*) context;

//populate the word dictionary from file
-(void) populateFromFile:(NSString*) file :(NSString*) type;

-(BOOL) addWordData:(NSString*) word:(NSDecimalNumber*) frequency:(NSString*) parent:(NSString*) children;

-(void) addWordToParent:(NSString*) word :(NSString*) parent;
-(void) addNewWordData:(NSString*) word;
-(void) addWordDataToCache:(WordData*) word_data;
-(NSArray*) getChildrenList:(NSString*) parent;

-(NSArray*) getPrediction:(NSString*) prefix;
-(NSArray*) getMetadiction:(NSString*) prefix;

//helper function for image search sorts on increasing order of frequency
-(NSMutableArray*) sortByFrequency:(NSString*) sentence;

-(WordData*) getWord:(NSString*) word;
-(WordData*) getWordFromCache:(NSString*) word;

-(void) reset;
-(void) updateFrequencyTillRoot:(NSString*) node :(NSDecimalNumber*)increment;
-(BOOL) updateFromSentence:(NSString*) sentence;

@end
