//
//  AudioController.h
//  Data
//
//  Created by Prathab on 06/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioData.h"
#import "AudioData+UtilityMethods.h"

@interface AudioController : NSObject {
    
    NSManagedObjectContext *managedObjectContext;
    
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

-(void) setContext:(NSManagedObjectContext*) context;

//adds a new file to the list and return YES on success
//on failure returns NO
-(BOOL) addAudioFile:(NSString*) new_file;

//returns the instance if file is available else returns nil
-(AudioData*) isValidFile:(NSString*) file;

//remove a file from the list
-(BOOL) removeAudioFile:(NSString*) file;

-(void) reset;

@end
