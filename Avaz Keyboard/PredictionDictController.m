//
//  PredictionDictController.m
//  Data
//
//  Created by Prathab on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PredictionDictController.h"
#import "Context.h"
@implementation PredictionDictController

@synthesize managedObjectContext;

-(id) init {
    if(self = [super init]) {
        [self setContext:[Context getContext]];
        prediction_request = [[NSFetchRequest alloc] init];
        [prediction_request setFetchLimit:20];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"PredictionDict" inManagedObjectContext:managedObjectContext];
        [prediction_request setEntity:entity];
        
         NSSortDescriptor *sort_descriptor = [[NSSortDescriptor alloc] initWithKey:@"frequency" ascending:NO];
         NSArray *sort_descriptors = [[NSArray alloc] initWithObjects:sort_descriptor, nil];
         [prediction_request setSortDescriptors:sort_descriptors];
    }
    return self;
}

-(void) setContext:(NSManagedObjectContext*) context{
    managedObjectContext = context;
}

//add a prediction entry from a file entry
//example of,the,131190
-(BOOL) addPredictionFromString:(NSString*) prediction_data{
    NSArray *prediction_split = [prediction_data componentsSeparatedByString:@","];
    return [self addPrediction:[prediction_split objectAtIndex:0]
                       :[prediction_split objectAtIndex:1]
                       :[NSDecimalNumber decimalNumberWithDecimal:[[prediction_split objectAtIndex:2] decimalValue]]];
}

-(BOOL) addPrediction:(NSString*) parent:(NSString*) prediction: (NSDecimalNumber*) frequency {
    PredictionDict *prediction_dict = (PredictionDict*)[NSEntityDescription insertNewObjectForEntityForName:@"PredictionDict" inManagedObjectContext:managedObjectContext];
    [prediction_dict setParent:parent];
    [prediction_dict setPrediction:prediction];
    [prediction_dict setFrequency:frequency];
    
    NSError *error = nil;
    if(![managedObjectContext save:&error]) {
        //Handle Error
        return NO;
    } 
    return YES;
}

-(PredictionDict*) isValidPrediction:(NSString*) parent:(NSString*) prediction {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PredictionDict" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    //match parent
    NSPredicate *match_parent = [NSPredicate
                                 predicateWithFormat:@"parent like[cd] %@ AND prediction like[cd] %@",parent,prediction]; 
    [request setPredicate:match_parent];
    
    NSError *error = nil;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    if(array == nil) {
        //error occurred
        return nil;
    }
    if( [array count] == 1 ) {
        return [array objectAtIndex:0];
    } else {
        return nil;
    }
}

//update the prediction data from the sentence
//Who am I updates the bigrams who am , am i 
-(BOOL) updateFromSentence:(NSString*) sentence{
    BOOL all_updated = YES;
    NSArray *words = [sentence componentsSeparatedByString:@" "];
    for(int i =0;i<[words count] -1 ;i++) {
        if ( [[words objectAtIndex:i] length] == 0 ||
            [[words objectAtIndex:(i+1)] length] == 0) {
            continue;
        }
        PredictionDict *prediction = [self isValidPrediction:[words objectAtIndex:i] :[words objectAtIndex:(i+1)]];
        if(prediction == nil) {
            if ([[words objectAtIndex:i] containsOnlyAlphabets] && [[words objectAtIndex:(i+1)] containsOnlyAlphabets]) {
                [self addPrediction:[words objectAtIndex:i] :[words objectAtIndex:(i+1)] :[NSDecimalNumber one]];
            }
        } else {
            [prediction setFrequency:[[prediction frequency] decimalNumberByAdding:[NSDecimalNumber one]]];
        }
    }
    NSError *error = nil;
    if(![managedObjectContext save:&error]) {
        all_updated = NO;
    }
    return all_updated;
}

//returns a array of PredictionDict for a given parent string
-(NSArray*) getPrediction:(NSString*) parent{
    //get all the image details and do a in-memory search
   /* DLog(@"Parent is <%@>\n",parent);
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setFetchLimit:20];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PredictionDict" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    */
    //match parent
    NSPredicate *match_parent = [NSPredicate
                                 predicateWithFormat:@"parent= %@",parent]; 
    [prediction_request setPredicate:match_parent];
    
    //sort by frequency
   /* NSSortDescriptor *sort_descriptor = [[NSSortDescriptor alloc] initWithKey:@"frequency" ascending:NO];
    NSArray *sort_descriptors = [[NSArray alloc] initWithObjects:sort_descriptor, nil];
    [request setSortDescriptors:sort_descriptors];*/
    
    NSError *error = nil;
    NSArray *prediction_data = [managedObjectContext executeFetchRequest:prediction_request error:&error];
    return prediction_data;
}

//populate from a file
-(void) populateFromFile:(NSString*) file:(NSString*) type{
    NSString *file_name = [[NSBundle mainBundle] pathForResource:file ofType:type];
    NSError *error;
    NSString *file_content_as_string = [NSString stringWithContentsOfFile:file_name encoding:NSASCIIStringEncoding error:&error];
    NSArray *prediction_data = [file_content_as_string componentsSeparatedByString:@"\n"];
    for(int i =0;i<[prediction_data count] ;i++) {
        [self addPredictionFromString:[prediction_data objectAtIndex:i]];
    }
}

-(void) reset {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PredictionDict" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *all_prediction_data = [managedObjectContext executeFetchRequest:request error:&error];
    for(int i = 0;i<[all_prediction_data count];i++) {
        [managedObjectContext deleteObject:[all_prediction_data objectAtIndex:i]];
    }
}

@end
