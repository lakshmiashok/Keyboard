//
//  PredictionMode.m
//  Data
//
//  Created by Prathab on 11/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PredictionModeController.h"
//#import "Metaphone3.h"
#define MAX_METADICTION 4
#define MAX_PREDICTION 4
#define MAX_SUGGESTION 8

typedef enum
{
    PREDICTWITHPICTURES = 1 << 0,
    WORDPREDICTION      = 1 << 1,
    LETTERPREDICTION    = 1 << 2,
    METAPREDICTION      = 1 << 3,
    PREDICTION          = 1 << 4,
    PREDICTWITHDELAY    = 1 << 5,
} PredictionSwitches;


@implementation PredictionModeController

@synthesize prediction_dict_controller;

@synthesize word_data_controller;

@synthesize managedObjectContext;

-(void) setContext:(NSManagedObjectContext *)context {
    [self setManagedObjectContext:context];
    [[self prediction_dict_controller] setContext:context];
    [[self word_data_controller] setContext:context];
}

- (id)init
{
    prediction_button = [[NSMutableArray alloc] init];
    prediction_dict_controller = [[PredictionDictController alloc] init];
    word_data_controller = [[WordDataController alloc] init];
    image_controller = [[ImageController alloc] init];
    return self;
}

-(NSArray*) prunePredictedWords:(NSMutableArray*) prediction{
    NSString *prediction_label;
    NSMutableArray *predicted_labels = [NSMutableArray array];
    NSMutableArray *duplicate_indices = [NSMutableArray array]; 
    for(int i=0;i<[prediction count]; i++){
        //DLog(@"Not object of class NSString!");
        prediction_label = [NSString stringWithFormat:@"%@",[[prediction objectAtIndex:i] prediction]];
        [predicted_labels addObject:prediction_label];
        //DLog(@"Predicted Label #%d is %@", i+1,prediction_label);
    }
    // get me duplicate indices
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (int i=0; i<[predicted_labels count]; ++i) {
        id obj = [predicted_labels objectAtIndex:i];
        // if the object already exists, store the index
        NSMutableIndexSet *ids = [dict objectForKey:obj];
        if (!ids) {
            ids = [NSMutableIndexSet indexSet];
            [dict setObject:ids forKey:obj];
        }
        [ids addIndex:i];
        if([ids count] > 1){
            ///DLog(@"Must be duplicates %@", ids);
            [duplicate_indices addObject:[NSNumber numberWithInt:i]];
        }
    }
    //DLog(@"%@", duplicate_indices);
    // remove those elements from the array
    NSMutableArray *discardedLabels = [NSMutableArray array];
    for (int i=0; i<[duplicate_indices count]; ++i) {
        NSNumber *index = [duplicate_indices objectAtIndex:i];
        [discardedLabels addObject:[prediction objectAtIndex:[index integerValue]]];
    }
    [prediction removeObjectsInArray:discardedLabels];
    NSArray *topPredictions = [prediction subarrayWithRange:NSMakeRange(0, MIN(MAX_PREDICTION, [prediction count]))];
    return topPredictions;
}


-(NSString*) filterSpaces:(NSString*) current_text {
    int last_space = [current_text length] - 1;
    while(last_space >= 1 && ([current_text characterAtIndex:last_space ] == ' ' || [current_text characterAtIndex:last_space] == '\n' ) && ([current_text characterAtIndex:last_space-1] == ' ' || [current_text characterAtIndex:last_space-1] == '\n') ){
        last_space --;
    }
    if(last_space == -1) return @"";
    return [current_text substringToIndex:last_space+1];
}


-(NSString*) getLastWord:(NSString*) current_text {
    int last_valid = [current_text length]-1;
    while(last_valid >= 0 && ([current_text characterAtIndex:last_valid] == ' ' || [current_text characterAtIndex:last_valid] == '\n')) {
        last_valid--;
    }
    if(last_valid == -1) {
        return @"";
    } else {
        current_text = [current_text substringToIndex:last_valid+1];
    }
    DLog(@"Stage one the text is %@",current_text);
    int last_delimiter = [current_text length] -1;
    while(last_delimiter >= 0 && ([current_text characterAtIndex:last_delimiter] != ' ' && [current_text characterAtIndex:last_delimiter] != '\n')) {
        last_delimiter--;
    }
    last_delimiter++;
    DLog(@"Stage two the text is %@",[current_text substringFromIndex:last_delimiter]);
    return [current_text substringFromIndex:last_delimiter];
}

-(NSArray*) getPredictedWords:(NSString*) current_text {
    NSArray *words = [current_text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \n,?!"]];
    NSMutableArray *prediction_prefixes = [[NSMutableArray alloc] init]; // Up to 4-grams
    NSMutableArray* prediction = [NSMutableArray array] ;
    NSString *parent;
    // on separation, the last element of words is a blank string ""  hence the -2 in the loop
    int len = [words count];
    // send the concatenated string of the previous words max up to 4
    // I am going to
    // _to, _going_to, _am_going_to
    
    for (int i=0;i<4 && (len-2)-i >= 0 ;i++){
        if (i==0)
            parent = [NSString stringWithFormat:@"%@",[words objectAtIndex:(len-2)-i]];
        else
            parent = [NSString stringWithFormat:@"%@ %@",[words objectAtIndex:(len-2)-i], parent];
        [prediction_prefixes addObject:[NSString stringWithString:parent]];
    }
    
    for (int i=[prediction_prefixes count]-1; i>=0; i--)
    {
        [prediction addObjectsFromArray:[prediction_dict_controller getPrediction:[prediction_prefixes objectAtIndex:i]]];
        //DLog(@"Parent string sent to getPrediction in getPredictedWords is '%@' and count returned is %d", [prediction_prefixes objectAtIndex:i], [prediction count]);
    }
    
    return [self prunePredictedWords:prediction];
}

-(NSArray*) getFinalPrediction:(NSString*) current_text{
    NSArray* finaldiction;
    current_prediction_text = current_text; //save a copy to handle changes in settings
    if([current_text hasSuffix:@" "] || [current_text hasSuffix:@"\n"]) {
            finaldiction = [self getPredictedWords:current_text];
    } else {
        NSArray* prediction = [word_data_controller getPrediction:[self getLastWord:current_text]];
        NSArray* metadiction = [word_data_controller getMetadiction:[self getLastWord:current_text]];
        if([metadiction isEqual:word_data_controller.root_prediction] || [prediction isEqual:word_data_controller.root_prediction]){
            finaldiction = word_data_controller.root_prediction;
        }
        else{
            NSMutableArray* predfiltmetadict = [[NSMutableArray alloc] init];
            for(WordData* entry in metadiction){
                BOOL found = false;
                for(WordData* pred in prediction){
                    if([[entry word] isEqualToString:[pred word]]){
                        found=true;
                        break;
                    }
                }
                if(!found){
                    [predfiltmetadict addObject:entry];
                }
            }
            metadiction = [[NSArray alloc] initWithArray:predfiltmetadict];
            if([prediction count]+[metadiction count]>MAX_SUGGESTION){
                if([prediction count]<MAX_PREDICTION){
                    metadiction = [metadiction subarrayWithRange:NSMakeRange(0, MAX_SUGGESTION-[prediction count])];
                }
                else{
                    metadiction = [metadiction subarrayWithRange:NSMakeRange(0,MIN(MAX_PREDICTION,[metadiction count]))];
                }
                if([metadiction count]<MAX_METADICTION){
                    prediction = [prediction subarrayWithRange:NSMakeRange(0, MAX_SUGGESTION-[metadiction count])];
                }
                else{
                    prediction = [prediction subarrayWithRange:NSMakeRange(0,MIN(MAX_PREDICTION,[prediction count]))];
                }
            }
            if(prediction !=nil)
                finaldiction = [prediction arrayByAddingObjectsFromArray:metadiction];
            else{
                finaldiction = metadiction;
            }
        }
    }
    
    if([finaldiction count] == 0) {
//        current_prediction_text = nil;
        finaldiction = [word_data_controller getPrediction:@""];
    }
    return finaldiction;
}

-(NSArray*) getFinalPredictionStrings:(NSString *)current_text{
    NSArray* predictionArray = [self getFinalPrediction:current_text];
    NSMutableArray* results = [[NSMutableArray alloc] init];
    for(id i in predictionArray){
        if([i isMemberOfClass:[WordData class]]) {
            NSString* prediction_label = [NSString stringWithFormat:@"%@",[[i word] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"_"]]];
            NSString *image_filename = [image_controller getDefaultImageFromCache:prediction_label];
            //            NSString *image_file_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/%@.png", [[image_filename componentsSeparatedByString:@"/"] lastObject]];
            NSString *image_file_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/png/%@.png", image_filename];
            [results addObject:[NSString stringWithFormat:@"%@ %@",prediction_label,image_file_path]];
        }
        else if([i isKindOfClass:[NSString class]]){
            [results addObject:i];
        }
    }
    return results;
}

-(NSArray*) getNextWords:(NSString*) current_text{
    NSArray* predictions =  [self getPredictedWords:[current_text lowercaseString]];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for(PredictionDict *i in predictions){
        [resultArray addObject:[i prediction]];
    }
    return resultArray;
}

-(NSArray*) getExactSuffixCompletion:(NSString*) current_text{
    NSArray* wordata = [word_data_controller getPrediction:[self getLastWord:[current_text lowercaseString]]];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for(id i in wordata){
        NSString* prediction_label = [NSString stringWithFormat:@"%@",[[i word] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"_"]]];
        [resultArray addObject:prediction_label];
    }
    return resultArray;
}

-(NSArray*) getMetaSuffixCompletion:(NSString*) current_text{
    NSArray* wordata = [word_data_controller getMetadiction:[self getLastWord:[current_text lowercaseString]]];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for(id i in wordata){
        NSString* prediction_label = [NSString stringWithFormat:@"%@",[[i word] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"_"]]];
        [resultArray addObject:prediction_label];
    }
    return resultArray;
}

-(NSString*) getImageForWord:(NSString*) current_word{
    NSString *image_filename = [image_controller getDefaultImageFromCache:current_word];
    if(image_filename){
        NSString *image_file_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/png/%@.png", image_filename];
        return image_file_path;
    }
    else{
        return @"";
    }
}

@end
