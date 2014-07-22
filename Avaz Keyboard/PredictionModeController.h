//
//  PredictionMode.h
//  Data
//
//  Created by Prathab on 11/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PredictionDictController.h"
#import "WordDataController.h"
#import "ImageController.h"



@interface PredictionModeController : NSObject {
    NSMutableArray* prediction_button;
    ImageController *image_controller;
    NSString *current_prediction_text;
}


@property(strong,readwrite) NSManagedObjectContext* managedObjectContext;

@property(strong,readwrite) PredictionDictController* prediction_dict_controller;

@property(strong,readwrite) WordDataController* word_data_controller;

- (id)init;

-(NSArray*) getFinalPrediction:(NSString*) current_text;
-(NSArray*) getFinalPredictionStrings:(NSString *)current_text;
-(NSArray*) getNextWords:(NSString*) current_text;
-(NSArray*) getExactSuffixCompletion:(NSString*) current_text;
-(NSArray*) getMetaSuffixCompletion:(NSString*) current_text;
-(NSString*) getImageForWord:(NSString*) current_word;

-(void) setContext:(NSManagedObjectContext*) context;

@end
