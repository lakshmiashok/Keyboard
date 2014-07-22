//
//  AudioController.m
//  Data
//
//  Created by Prathab on 06/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AudioController.h"

@implementation AudioController

@synthesize managedObjectContext;

-(void) setContext:(NSManagedObjectContext *)context {
    managedObjectContext = context;
}

-(BOOL) addAudioFile:(NSString*) new_file {
     AudioData *audio_data = (AudioData*)[NSEntityDescription insertNewObjectForEntityForName:@"AudioData" inManagedObjectContext:managedObjectContext];
    [audio_data setAudio_file_path:new_file];
        
    NSError *error = nil;
    if(![managedObjectContext save:&error]) {
        //Handle Error
        return NO;
    } 
    return YES;
}

-(BOOL) removeAudioFile:(NSString*) file {
    AudioData* audio_file = [self isValidFile:file];
    if(audio_file != nil) {
        [managedObjectContext deleteObject:audio_file];
    }
    
    NSError *error = nil;
    if(![managedObjectContext save:&error]) {
        return NO;  //return NO in case of error
    }
    return YES; //return YES if successfull
}

-(AudioData*) isValidFile:(NSString *)file {
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"AudioData"
                                              inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"audio_file_path like %@",file];
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


-(void) reset {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AudioData" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *all_prediction_data = [managedObjectContext executeFetchRequest:request error:&error];
    for(int i = 0;i<[all_prediction_data count];i++) {
        [managedObjectContext deleteObject:[all_prediction_data objectAtIndex:i]];
    }
}

@end
