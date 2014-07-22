//
//  ImageController.h
//  Data
//
//  Created by Prathab on 05/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageData.h"
#import "ImageData+UtilityMethods.h"

@interface ImageController : NSObject {
    NSManagedObjectContext *managedObjectContext;
    NSMutableDictionary *imageData;
    NSMutableArray *cache_exact;
    NSMutableArray *cache_secondary;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

-(id) init;

-(void) setContext:(NSManagedObjectContext*) context;

//adds a image data to persistent store 
//input data format <index>,<directory_path>,<file_name>,<keywords separated by '.'>
//eg. 7,actions,arrested,arrested,criminal
-(BOOL) addImageData:(NSString*) img_data_str;

//search for a list of images using the keyword
-(NSMutableArray*) searchWithKeyWord:(NSString*) key_word;

//populate the store with a file
-(void) populateFromFile:(NSString*) file :(NSString*) type;

-(NSMutableArray*) populateCacheFromFile:(NSString*) file :(NSString*) type;

-(void) reset;

-(void) backupTo:(NSString*) backup_file;

-(void) restoreFrom:(NSString*) restore_file;

-(ImageData*) searchForExactMatch:(NSString*) key_word;

-(NSMutableArray*) getSearchResultsFromCache:(NSMutableArray*) search_words :(BOOL) get_top_result;

-(NSMutableArray*) getSearchResults:(NSMutableArray*) search_words :(BOOL) get_top_result;

-(ImageData*) getDefaultImage:(NSString*) sentence;
-(NSString*) getDefaultImageFromCache:(NSString*) sentence;

@end
