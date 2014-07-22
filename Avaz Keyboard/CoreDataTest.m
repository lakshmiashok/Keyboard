//
//  CoreDataTest.m
//  Data
//
//  Created by Prathab on 08/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoreDataTest.h"
#import "AudioController.h"
#import "HistoryDataController.h"
#import "ImageController.h"
#import "PicModeDictController.h"
#import "PredictionDictController.h"
#import "PronounciationDataController.h"
#import "QuickAccessDataController.h"
#import "WordDataController.h"

@implementation CoreDataTest

-(void) setContext:(NSManagedObjectContext*) context {
    managedObjectContext = context;
}

-(void) testAll {
    debug = true;
    [self testAudioData];
    [self testHistoryData];
    [self testImageData];
    [self testPicModeDict];
    [self testPredictionDictData];
    [self testPronounciationData];
    [self testQuickAccessData];
    [self testWordData];
}

-(void) testWordData {
    WordDataController *wdc = [ WordDataController alloc];
    [wdc setContext:managedObjectContext];
    [wdc addWordData:@"onion" :[NSDecimalNumber decimalNumberWithString:@"100"] :@"on" :@"onioni,onion_"];
    [wdc addWordData:@"onioni" :[NSDecimalNumber decimalNumberWithString:@"25"] :@"onion" :@""];
    [wdc addWordData:@"onion" :[NSDecimalNumber decimalNumberWithString:@"75"] :@"onion" :@""];
    NSArray *result = [wdc getChildrenList:@"onion"];
    if(debug) {
        printf("TestWordData: Total results is %d\n",[result count]);
        for(int i = 0;i<[result count];i++) {
            printf("TestWordData: Result %d- %s\n",i,[[result objectAtIndex:i] cStringUsingEncoding:NSASCIIStringEncoding]);
        }
    }
    if( [[result objectAtIndex:0] caseInsensitiveCompare:@"onion_"] != 0 || 
       [[result objectAtIndex:1] caseInsensitiveCompare:@"onioni"] != 0) {
        printf("TestWordData: Failed\n");
    } else {
        printf("TestWordData: Passed\n");
    }
    printf("\n\n");
}

-(void) testHistoryData {
    HistoryDataController *hdc = [HistoryDataController alloc];
    [hdc setContext:managedObjectContext];
    //add 2 history data
    [hdc addHistory:@"Test History" :[NSDate date]];
    [hdc addHistory:@"Test Successful" :[NSDate date]];
    //retrieve and check
    
    NSArray *all_history = [hdc getHistoryList];
    if([[[all_history objectAtIndex:0] history] caseInsensitiveCompare:@"Test History"] != 0 ||
       [[[all_history objectAtIndex:1] history] caseInsensitiveCompare:@"Test Successful"] != 0) {
        printf("TestHistoryData: Failed(1)\n");
    } 
    
       
    //delete all history
    [hdc deleteHistory:[NSDate date]];
    NSArray *after_delete_history = [hdc getHistoryList];
    if([after_delete_history count] != 0) {
        printf("TestHistoryData: Failed(2)\n");
    }
    printf("TestHistoryData: Passed\n");
    printf("\n\n");
}

-(void) testPredictionDictData {
    PredictionDictController *pdc = [PredictionDictController alloc];
    [pdc setContext:managedObjectContext];
    [pdc reset];
    [pdc addPredictionFromString:@"of,the,100"];
    [pdc addPrediction:@"of" :@"them":[NSDecimalNumber decimalNumberWithString:@"200"]];
    [pdc updateFromSentence:@"of the of them"];
    NSArray *of_prediction = [pdc getPrediction:@"of"];
    if(debug) {
        printf("TestPredictionDictData: Got %d results(1)\n",[of_prediction count]);
        for(int i =0;i<[of_prediction count];i++) {
            [[of_prediction objectAtIndex:i] print];
        }
    }
    if([of_prediction count]!=2) {
        printf("TestPredictionDictData: Failed(1)\n");
    } else {
        if([[(PredictionDict *)[of_prediction objectAtIndex:0] frequency] intValue] != 201||
           [[(PredictionDict *)[of_prediction objectAtIndex:1] frequency] intValue]!= 101) {
            printf("TestPredictionDictData: Failed(2)\n");
        }
    }
    
    NSArray *the_prediction = [pdc getPrediction:@"the"];
    if(debug) {
        printf("TestPredictionDictData: Got %d results(2)\n",[the_prediction count]);
        for(int i =0;i<[the_prediction count];i++) {
            [[the_prediction objectAtIndex:i] print];
        }
    }

    if([the_prediction count] != 1) {
        printf("TestPredictionDictData: Failed(3)\n");
    } else {
        if([[(WordData *)[the_prediction objectAtIndex:0] frequency] intValue]!= 1) {
            printf("TestPredictionDictData: Failed(4)\n");
        }
    }
    printf("TestPredictionDictData: Passed\n");
    printf("\n\n");
}

-(void) testPronounciationData {
    PronounciationDataController *pdc = [PronounciationDataController alloc];
    [pdc setContext:managedObjectContext];
    [pdc reset];
    [pdc addPronounciationData:@"tamil" :@"tam"];
    if([[pdc getPronounciationData:@"tamil"] caseInsensitiveCompare:@"tam"] != 0) {
        printf("TestPronounciationData: Failed(1)\n");
    }
    
    [pdc removePronounciationData:@"tamil"];
    if([[pdc getPronounciationData:@"tamil"] caseInsensitiveCompare:@"tam"] != 0) {
        printf("TestPronounciationData: Failed(1)\n");
    }
    
    printf("TestPronounciationData: Passed\n");
    printf("\n\n");
}
-(void) testQuickAccessData {
    QuickAccessDataController *qadc = [QuickAccessDataController alloc];
    [qadc setContext:managedObjectContext];
    [qadc reset];
    [qadc addPair:@"tamil" :@"tam"];
    if([[qadc getText:@"tamil"] caseInsensitiveCompare:@"tam"] != 0) {
        printf("TestQuickAccessData: Failed(1)\n");
    }
    
    [qadc removeKey:@"tamil"];
    if([[qadc getText:@"tamil"] caseInsensitiveCompare:@"tam"] != 0) {
        printf("TestQuickAccessData: Failed(1)\n");
    }
    
    printf("TestQuickAccessData: Passed\n");
    printf("\n\n"); 
}

-(void) testAudioData {
    AudioController *ac = [AudioController alloc];
    [ac setContext:managedObjectContext];
    [ac reset];
    [ac addAudioFile:@"temp"];
    if([ac isValidFile:@"temp"] == nil) {
        printf("TestAudioData: Failed(1)\n");
    }
    [ac removeAudioFile:@"temp"];
    if([ac isValidFile:@"temp"] != nil) {
        printf("TestAudioData: Failed(2)\n");
    }

    printf("TestAudioData: Passed\n");
}

-(void) testImageData{
    
}

-(void) testPicModeDict {
    
}

@end
