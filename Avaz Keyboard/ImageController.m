//
//  ImageController.m
//  Data
//
//  Created by Prathab on 05/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageController.h"
#import "Context.h"
#import "WordDataController.h"

static id static_object;

@implementation ImageController

@synthesize managedObjectContext;

-(id) init {
    
    if(static_object != nil)
        return static_object;
    
    if(self = [super init]) {
        [self setContext:[Context getContext]];
        cache_exact = [self populateCacheFromFile:@"picFileNewSort" :@"csv"];
        cache_secondary = [self populateCacheFromFile:@"picFileNewSecondaryWordsSort" :@"csv"];
        
        NSArray *results;
        imageData = [[NSMutableDictionary alloc] init];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ImageData" inManagedObjectContext:managedObjectContext];
        [request setEntity:entity];
        NSError *error = nil;
        results = [managedObjectContext executeFetchRequest:request error:&error];
      //  DLog(@"Total results (image data) are %d\n",[results count]);
        for(id result in results) {
            NSArray *key_words = [[result key_words] componentsSeparatedByString:@","];
            for(id key_word in key_words) {
                if([key_word length] > 0) {
                    if([imageData objectForKey:key_word] == nil ) {
                        int i;
                        for(i=0;i<[key_word length];i++) {
                            if([key_word characterAtIndex:i] == 32)
                                break;
                        }
                        if(i == [key_word length]) {
                          //  DLog(@"Adding key word %@\n",key_word);
                        [imageData setObject:result forKey:key_word];
                        }
                    }
                }
            }
        }
        
        static_object = self;
    }
    return self;
}

-(void) setContext:(NSManagedObjectContext *)context {
    managedObjectContext = context;
}

-(NSString*) getDefaultImageFromCache:(NSString*) sentence {
    NSMutableArray *words_list = [[[WordDataController alloc] init] sortByFrequency:sentence];
    NSMutableArray *search_results = [self getSearchResultsFromCache :words_list :true];
    if (search_results == nil || [search_results count] == 0)
        return nil;
    return [search_results objectAtIndex:0];
}

-(NSMutableArray*) getSearchResultsFromCache:(NSMutableArray *)search_words :(BOOL)get_top_result {
    NSString *exact_match = [[NSString alloc]  init];
    NSString *prefix_match = [[NSString alloc] init];
    
    DLog(@"Searching for words...");
    // do exact match in exact and secondary cache for get_top_result
    for (id word_ in search_words) {
        DLog(@"[%@]", word_);
        if ([word_ length] <= 1)
            continue;
        
        NSString *word = [word_ substringToIndex:[word_ length]-1];
        int index;
        index = [word characterAtIndex:0] - 'a';
        if ((index < 0) || (index > 25))
            index = 26;
        
        for (id entry in [cache_exact objectAtIndex:index]) {
            NSString * key = [entry objectAtIndex:0];
            if ([key isEqualToString:word]) {
                exact_match = [exact_match stringByAppendingFormat:@"%@,",[entry objectAtIndex:1]];
                if (get_top_result) break;
                continue;
            } 
        }
        
        for (id entry in [cache_secondary objectAtIndex:index]) {
            NSString * key = [entry objectAtIndex:0];
            if ([key isEqualToString:word]) {
                exact_match = [exact_match stringByAppendingFormat:@"%@,",[entry objectAtIndex:1]];
                if (get_top_result) break;
                continue;
            } 
        }
    }
    DLog(@"Search done");
    
    if (!get_top_result) {
        for (id word_ in search_words) {
            if ([word_ length] <= 1)
                continue;            
            NSString *word = [word_ substringToIndex:[word_ length]-1];
            int index = [word characterAtIndex:0] - 'a';
            if ((index < 0) || (index > 25))
                index = 26;
            
            for (id entry in [cache_exact objectAtIndex:index]) {
                NSString * key = [entry objectAtIndex:0];
                if ([key hasPrefix:word]) {
                    prefix_match = [prefix_match stringByAppendingFormat:@"%@,",[entry objectAtIndex:1]];
                }
            }
            
            for (id entry in [cache_secondary objectAtIndex:index]) {
                NSString * key = [entry objectAtIndex:0];
                if ([key hasPrefix:word]) {
                    prefix_match = [prefix_match stringByAppendingFormat:@"%@,",[entry objectAtIndex:1]];
                }
            }
        }
    }
    if ([exact_match length] == 0 && [prefix_match length] == 0) {
        return nil;
    }
    NSMutableArray* exact_results =  [[exact_match componentsSeparatedByString:@","] mutableCopy];
    [exact_results addObjectsFromArray:[prefix_match componentsSeparatedByString:@","]];
    //return exact_results;
    NSMutableArray *exact_results_unique = [[NSMutableArray alloc] init];
    for (id result in exact_results) {
        if ([result length] ==0  || [exact_results_unique containsObject:result]) continue;
        [exact_results_unique addObject:result];
    }
    return exact_results_unique;

}

/*
//used in customization tool for getting search results
-(NSMutableArray*) getSearchResults:(NSMutableArray*) search_words :(BOOL) get_top_result {
    NSMutableArray* search_results = [[NSMutableArray alloc] init];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ImageData" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    NSError *error = nil;

    for(id each_word_data in search_words) {
        // remove _ at the end of word
        NSString* word = [[each_word_data word]substringToIndex:[[each_word_data word] length] - 1];
        //exact matches with keyword,
        NSPredicate *exact_match_predicate = [NSPredicate
                                              predicateWithFormat:@"key_words like[cd] %@",[@"*," stringByAppendingString:[word stringByAppendingString:@",*"]]]; 
        [request setPredicate:exact_match_predicate];
        
        //redundant use a regular expression in the above ?
        NSPredicate *match_in_start = [NSPredicate
                                       predicateWithFormat:@"key_words like[cd] %@",[word stringByAppendingString:@",*"]];
        
        NSArray* result1 = [managedObjectContext executeFetchRequest:request                                                                   error:&error];
        
        [request setPredicate:match_in_start];

        NSArray* result2 = [managedObjectContext executeFetchRequest:request                                                                   error:&error];

        [search_results addObjectsFromArray:result1];
        [search_results addObjectsFromArray:result2];
        // hack to optimize delay in AddToPictures
        if (get_top_result && [search_results count]!=0) {
            return search_results;
        }
    }
    
    //get unique results
    NSMutableArray *unique_search_results = [[NSMutableArray alloc] init];
    for(int result1 = 0;result1 < [search_results count];result1++) {
        bool isunique = true;
        for(int result2 = 0;result2 < [unique_search_results count];result2++) {
                if([[search_results objectAtIndex:result1] index] == [[unique_search_results objectAtIndex:result2] index]) {
                    isunique = false;
                }
        }
        if(isunique) {
            [unique_search_results addObject:[search_results objectAtIndex:result1]];
        }
    }
    return unique_search_results;
}
*/

-(BOOL) addImageData:(NSString *)img_data_str {
    ImageData *img_data = (ImageData*)[NSEntityDescription insertNewObjectForEntityForName:@"ImageData" inManagedObjectContext:managedObjectContext];
    
    NSArray *img_data_split = [img_data_str componentsSeparatedByString:@","];
    NSRange key_words_range;
    key_words_range.location = 3;
    key_words_range.length = [img_data_split count] - 3;
    NSArray *key_words_list = [img_data_split subarrayWithRange:key_words_range];
    NSString *key_words = [key_words_list componentsJoinedByString:@","];
    
    [img_data setIndex:[NSDecimalNumber decimalNumberWithDecimal:[[img_data_split objectAtIndex:0] decimalValue]]];
    [img_data setDirectory_path:[img_data_split objectAtIndex:1]];
    [img_data setFile_name:[img_data_split objectAtIndex:2]];
    [img_data setKey_words:key_words];
    
    NSError *error = nil;
    
    if(![managedObjectContext save:&error]) {
      //Handle Error
        return NO;
    } 
    
    return YES;
}

//returns the first result used in Prediction Bar
-(ImageData*) searchForExactMatch:(NSString*) key_word {
  //  DLog(@"Image data searching for %@\n",key_word);
    return [imageData objectForKey:[key_word lowercaseString]];
}

-(NSMutableArray*) searchWithKeyWord:(NSString *)key_word {
    //get all the image details and do a in-memory search
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ImageData" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSMutableArray *result;
    //exact matches with keyword,
    NSPredicate *exact_match_predicate = [NSPredicate
                                          predicateWithFormat:@"key_words like[cd] %@",[key_word stringByAppendingString:@","]]; 
    [request setPredicate:exact_match_predicate];
    
    result = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    /*
    NSPredicate *substring_match = [NSPredicate
                                          predicateWithFormat:@"key_words like %@",[@"*" stringByAppendingString:[key_word stringByAppendingString:@"*,"]]]; */

   /* if(all_image_data == nil || [all_image_data count] == 0) {
        printf("Error in fetch\n");
        return nil;
    } else {
        //extract exact matches
        NSPredicate *exact_match_predicate = [NSPredicate
                                              predicateWithFormat:@"key_words like %@",key_word]; 
        NSArray *exact_match = [all_image_data filteredArrayUsingPredicate:exact_match_predicate];
        printf("Got %d results\n",[exact_match count]);
        return exact_match;
    }*/
    return [result mutableCopy];
}

-(NSMutableArray*) populateCacheFromFile:(NSString*)file :(NSString*) type {
    NSString *pathComponent = [NSString stringWithFormat:@"%@", file];
    
    NSString *file_name =  [[NSBundle mainBundle] pathForResource:pathComponent ofType:type];
    

    NSError *error;
    NSString *file_content_as_string = [NSString stringWithContentsOfFile:file_name encoding:NSUTF16StringEncoding error:&error];
    NSArray *image_data = [file_content_as_string componentsSeparatedByString:@"\n"];
   
    NSMutableArray *prediction = [[NSMutableArray alloc] init];
    for(int i = 0;i<26;i++) {
        [prediction addObject:[[NSMutableArray alloc] init]];
    }
    [prediction addObject:[[NSMutableArray alloc] init]];
    
    for(id data in image_data) {
        if ([data length] == 0) continue;
        int char_ascii = [data characterAtIndex:0] - 'a';
        if (char_ascii >=0 && char_ascii <26) {
            [[prediction  objectAtIndex:char_ascii] addObject:[data componentsSeparatedByString:@":"]];
        } else {
            [[prediction objectAtIndex:26] addObject:[data componentsSeparatedByString:@":"]];
        }
    }
    return prediction;
}

-(void) populateFromFile:(NSString *)file :(NSString*) type{
    NSString *pathComponent = [NSString stringWithFormat:@"%@", file];
    
    NSString *file_name =  [[NSBundle mainBundle] pathForResource:pathComponent ofType:type];
    
    NSError *error;
    NSString *file_content_as_string = [NSString stringWithContentsOfFile:file_name encoding:NSASCIIStringEncoding error:&error];
     NSArray *image_data = [file_content_as_string componentsSeparatedByString:@"\n"];
    printf("Number of images is %d\n",[image_data count]);
    for(int i =0;i< 1/*[image_data count]*/ ;i++) {
        [self addImageData:[image_data objectAtIndex:i]];
    }
    printf("Successful\n");
}

-(void) reset {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuickAccessData" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *all_data= [managedObjectContext executeFetchRequest:request error:&error];
    for(int i = 0;i<[all_data count];i++) {
        [managedObjectContext deleteObject:[all_data objectAtIndex:i]];
    }
}

-(void) backupTo:(NSString *)backup_file {
   
    NSString *resource_directory = [[NSBundle mainBundle] resourcePath];
    NSString *resource_backup_file = [resource_directory stringByAppendingString:[@"/" stringByAppendingString:backup_file]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuickAccessData" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *all_data= [managedObjectContext executeFetchRequest:request error:&error];
    NSMutableArray *csv_data = [NSMutableArray alloc];
    
    for(int i =0;i<[all_data count];i++) {
        [csv_data addObject:[[csv_data objectAtIndex:i] csvFormat]]; 
    }
        
    NSString* csv_format = [csv_data componentsJoinedByString:@"\n"]; 
    
    [csv_format writeToFile:resource_backup_file atomically:YES encoding:NSASCIIStringEncoding error:&error];
    
}

@end
