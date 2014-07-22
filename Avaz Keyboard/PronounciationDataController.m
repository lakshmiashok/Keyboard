//
//  PronounciationDataController.m
//  Data
//
//  Created by Prathab on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PronounciationDataController.h"

@implementation PronounciationDataController

@synthesize managedObjectContext;

-(void) setContext:(NSManagedObjectContext *)context {
    managedObjectContext = context;
}

//add a new pair
-(BOOL) addPronounciationData:(NSString *)actual :(NSString *)spoken {
    //if pair already exists return NO
    if( [self isValidPronounciationData:actual] != nil ) {
        return NO;
    }
    PronounciationData *pronounciation_data = (PronounciationData*)[NSEntityDescription insertNewObjectForEntityForName:@"PronounciationData" inManagedObjectContext:managedObjectContext];
    [pronounciation_data setActual:actual];
    [pronounciation_data setSpoken:spoken];
    NSError *error = nil;
    if(![managedObjectContext save:&error]) {
        //Handle Error
        return NO;
    } 
    return YES;
}

//remove a key if it is available
-(BOOL) removePronounciationData:(NSString *)actual {
    
    PronounciationData* pronounciation_data = [self isValidPronounciationData:actual];
    if(pronounciation_data != nil) {
        [managedObjectContext deleteObject:pronounciation_data];
    }
    
    NSError *error = nil;
    if(![managedObjectContext save:&error]) {
        return NO;  //return NO in case of error
    }
    return YES; //return YES if successfull
}

-(PronounciationData*) isValidPronounciationData:(NSString *)actual {
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"PronounciationData"
                                              inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"actual like %@",actual];
    [request setPredicate:predicate];
    
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

-(NSString*) getPronounciationData:(NSString *)actual {
    PronounciationData *pronounciation_data = [self isValidPronounciationData:actual];
    return [pronounciation_data spoken];
}

-(NSString*) getPronounciationSentence:(NSString *)sentence {
    NSArray* sentence_split = [sentence componentsSeparatedByString:@" "];
    NSMutableArray* pronounced_sentence = [[NSMutableArray alloc] init];
    for(int i = 0;i<[sentence_split count] ;i++) {
        NSString *pronounciation = [self getPronounciationData:[sentence_split objectAtIndex:i]];
        [pronounced_sentence addObject:pronounciation];
    }
    return [pronounced_sentence componentsJoinedByString:@" "];
}


-(void) reset {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PronounciationData" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *all_prediction_data = [managedObjectContext executeFetchRequest:request error:&error];
    for(int i = 0;i<[all_prediction_data count];i++) {
        [managedObjectContext deleteObject:[all_prediction_data objectAtIndex:i]];
    }
}


@end
