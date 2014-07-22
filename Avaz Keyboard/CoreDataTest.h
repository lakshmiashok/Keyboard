//
//  CoreDataTest.h
//  Data
//
//  Created by Prathab on 08/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataTest : NSObject {
    NSManagedObjectContext *managedObjectContext;
    BOOL debug;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property  BOOL debug;

-(void) setContext:(NSManagedObjectContext*) context;
-(void) testAll;
-(void) testWordData;
-(void) testHistoryData;
-(void) testPredictionDictData;
-(void) testPronounciationData;
-(void) testQuickAccessData;
-(void) testAudioData;
-(void) testImageData;
-(void) testPicModeDict;

@end
