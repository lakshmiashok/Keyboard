//
//  PicModeDictController.h
//  Data
//
//  Created by Prathab on 08/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PicModeDict.h"
#import "PicModeDict+UtilityMethods.h"
#import "WordDataController.h"
#import "ImageController.h"

@interface PicModeDictController : NSObject {
    NSManagedObjectContext *managedObjectContext;
    NSDecimalNumber* DEFAULT_VERSION;
    NSNumber* DEFAULT_ENABLE_STATUS;
    NSString* DEFAULT_IMAGE;
    NSNumber* DEFAULT_SENTENCE_BOX_ENABLE_STATUS;
    
    WordDataController *wordDataController;
    ImageController *imageController;
    NSManagedObjectContext *backgroundMOC;
    NSMutableDictionary *allPicModeDictIds;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

-(id) init;

-(void) setContext:(NSManagedObjectContext*) context;

-(void) saveContext;

-(BOOL) addPicModeDataFromObject:(PicModeDict*) picModeDict;

-(BOOL) addPicModeData:(NSString*) identifier :(NSDecimalNumber*) version :(NSString*) parent :(NSNumber*) is_enabled :(NSString*) category_type :(NSString*) tag_name :(NSString*) audio_data :(NSString*) picture :(NSNumber*) is_sentence_box_enabled :(NSDecimalNumber*) serial;

-(PicModeDict*) copyPicModeDataFromObject:(PicModeDict*) picModeDict;
-(PicModeDict*) getPicModeDict:(NSString*) identifier;
-(PicModeDict*) getPicModeDictWithTag:(NSString*) tag_name;

-(NSArray*) getChildren:(NSString*) parent;
-(NSArray*) getAllChildren:(NSString*) parent;

-(PicModeDict*) addAtIndex:(NSString*) parent: (NSString*) text:(int) index;

-(void) adaptToIndex:(NSString*) parent: (PicModeDict*) current:(int) index;
-(NSArray*) getAll;
-(NSArray*) getAllWithLimit:(int) limit;
-(void) reset;

-(void) remove:(PicModeDict*) picModeDict;

-(NSString*) computeIdentifier:(NSString*) tag_name; //compute identifier for tag_name
-(NSDecimalNumber*) getLargestSerial:(NSString*) parent;
-(void) makeCopy:(NSString*) parent: (NSString*) child :(BOOL) first;

-(NSString*) getQuickIdentifier;
-(int) getQuickCount;
-(BOOL) commit;
-(BOOL) addPicModeDataAsBulk:(NSArray*)newEntries;
-(BOOL) commitWithBackgroundMOC;
-(void)createBackgroundMOC;
-(BOOL) resetWithBackgroundMOC;
@end
