//
//  WordDataController.m
//  Data
//
//  Created by Prathab on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WordDataController.h"
#import "MetaphoneHelper.h"
#import "Context.h"

static id static_object;


@implementation WordDataController

@synthesize managedObjectContext;
@synthesize root_prediction;

-(id) init {
    if(static_object != nil) {
        return  static_object;
    }
    
    if(self = [super init]) {
        
        DLog(@"Starting init in word data");
        BOOL readOnly = YES;
        [self setContext:[Context getContext]];
        
        NSFetchRequest *prediction_request;  //to avoid creating fetch and entity object for every call
        NSFetchRequest *metaphone_request;

        prediction_request = [[NSFetchRequest alloc] init];
        metaphone_request = [[NSFetchRequest alloc] init];
         
         NSEntityDescription *entity = [NSEntityDescription entityForName:@"WordData" inManagedObjectContext:managedObjectContext];
         [prediction_request setEntity:entity];
        [metaphone_request setEntity:entity];

        NSSortDescriptor *sort_descriptor = [[NSSortDescriptor alloc] initWithKey:@"frequency" ascending:NO];
        NSArray *sort_descriptors = [[NSArray alloc] initWithObjects:sort_descriptor, nil];
        [prediction_request setSortDescriptors:sort_descriptors];
        [metaphone_request setSortDescriptors:sort_descriptors];
        NSArray *alphabets = [NSArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",@"æ",@"å",@"ø",nil];
        NSArray *metastarters = [NSArray arrayWithObjects:@"0",@"A",@"B",@"D",@"F",@"G",@"H",@"J",@"K",@"L",@"M",@"N",@"P",@"R",@"S",@"T",@"V",@"X", nil];
        NSPredicate *all_words_predicate = [NSPredicate
                                     predicateWithFormat:@"word like[cd] %@",@"*_"];
        NSPredicate *all_meta_predicate = [NSPredicate predicateWithFormat:@"meta1 like[cd] %@",@"*"];
        [prediction_request setPredicate:all_words_predicate];
        [metaphone_request setPredicate:all_meta_predicate];
        NSError *error;
        NSArray *all_words = [managedObjectContext executeFetchRequest:prediction_request error:&error];
        NSArray *all_meta = [managedObjectContext executeFetchRequest:metaphone_request error:&error];
        DLog(@"Number of words is %d",[all_words count]);
        NSMutableArray *prediction = [[NSMutableArray alloc] init];//]WithCapacity:26];
        NSMutableArray *metadiction = [[NSMutableArray alloc] init];
        for(int i = 0;i< [alphabets count];i++) {
            [prediction addObject:[[NSMutableArray alloc] init]];
        }
        for(NSString* i in metastarters){
            [metadiction addObject:[[NSMutableArray alloc] init]];
        }
        for(id word in all_words) {
            int char_ascii = [[word word] characterAtIndex:0] - 'a';
            // if ascii value is greater than 25, i.e. something other than a-z
            // use the array index of the alphabets array instead
            if(char_ascii > 25){
                NSString *first_char = [[word word] substringToIndex:1];
                char_ascii = [alphabets indexOfObject:first_char];
                //DLog(@"Char ascii== %d %@ %@ ", char_ascii, [word word], [[word word] substringToIndex:1]);
            }
            if(char_ascii < 0 || char_ascii > [alphabets count]){
                continue;
            }
            
            //DLog(@"ascii value is %d word is %@ uichar is %d szie is %d",char_ascii,[word word],[[word word] characterAtIndex:0],[prediction count]);
            [[prediction objectAtIndex:char_ascii] addObject:word];
        }
        for(id meta in all_meta){
            if([[meta meta1] length]>=1){
                NSString* first_char = [[meta meta1] substringToIndex:1];
                int char_asii = [metastarters indexOfObject:first_char];
                if(char_asii < 0 || char_asii > [metastarters count]){
                    continue;
                }
                [[metadiction objectAtIndex:char_asii] addObject:meta];
            }
        }
        /*
        for(int i = 0;i<[alphabets count];i++) {
            NSPredicate *match_parent = [NSPredicate
                                         predicateWithFormat:@"word like[cd] %@",[[alphabets objectAtIndex:i] stringByAppendingString:@"*_"]]; 
            [prediction_request setPredicate:match_parent];
            
            NSError *error;
            NSArray *entry = [managedObjectContext executeFetchRequest:prediction_request error:&error];
            [prediction addObject:[entry mutableCopy]];
        }*/
        DLog(@"in mem pred start");

        in_memory_prediction = [NSDictionary dictionaryWithObjects:prediction forKeys:alphabets];
        DLog(@"in mem pred stop");
        
        DLog(@"in mem meta start");
        in_memory_metadiction = [NSDictionary dictionaryWithObjects:metadiction forKeys:metastarters];
        DLog(@"in mem meta stop");

       root_prediction = [[NSArray alloc] initWithObjects:NSLocalizedString(@"I",@"default prediction: I"),
                          NSLocalizedString(@"you",@"default prediction: you"),
                          NSLocalizedString(@"the",@"default prediction the"),
                          NSLocalizedString(@"it",@"default prediction it"),
                          NSLocalizedString(@"what",@"default prediction what"),
                          NSLocalizedString(@"how",@"default prediction how"),
                          NSLocalizedString(@"please",@"default prediction please"),
                          NSLocalizedString(@"let",@"default prediction let"),
                          nil];
        [prediction_request setFetchLimit:20];
        [metaphone_request setFetchLimit:20];
        static_object = self;
        DLog(@"Starting init in word data");

    }
    return self;
}

-(void) setContext:(NSManagedObjectContext*) context {
    managedObjectContext = context;
}

//add a prediction entry from a file entry
//example of,the,131190
-(BOOL) addWordDataFromString:(NSString*) word_data{
    NSArray *word_split = [word_data componentsSeparatedByString:@","];
    NSRange children_range;
    children_range.location = 3;
    children_range.length = [word_split count] - 3;
    NSArray *children_list = [word_split subarrayWithRange:children_range];
    NSString *chilren = [children_list componentsJoinedByString:@","];
    return [self addWordData:[word_split objectAtIndex:0] :[NSDecimalNumber decimalNumberWithDecimal:[[word_split objectAtIndex:1] decimalValue]] :[word_split objectAtIndex:2] :chilren];
}

-(void) addWordDataToCache:(WordData *)word_data {
    NSString *first_char = [[word_data word] substringToIndex:1];
    [[in_memory_prediction objectForKey:first_char]  addObject:word_data];
}

-(BOOL) addWordData:(NSString*) word:(NSDecimalNumber*) frequency:(NSString*) parent:(NSString*) children {
    WordData *word_data = (WordData*)[NSEntityDescription insertNewObjectForEntityForName:@"WordData" inManagedObjectContext:managedObjectContext];
    [word_data setParent:parent];
    [word_data setWord:word];
    [word_data setFrequency:frequency];
    [word_data setChildren:children];
     
    NSError *error = nil;
    if(![managedObjectContext save:&error]) {
        //Handle Error
        return NO;
    } 
    return YES;
}

//populate the word dictionary from file
-(void) populateFromFile:(NSString*) file :(NSString*) type{
    NSString *file_name = [[NSBundle mainBundle] pathForResource:file ofType:type];
    NSError *error;
    NSString *file_content_as_string = [NSString stringWithContentsOfFile:file_name encoding:NSASCIIStringEncoding error:&error];
    NSArray *prediction_data = [file_content_as_string componentsSeparatedByString:@"\n"];
    for(int i =0;i<[prediction_data count] ;i++) {
   //     DLog(@"Adding %@\n",[prediction_data objectAtIndex:i]);
        [self addWordDataFromString:[prediction_data objectAtIndex:i]];
    }
}

-(WordData*) getWord:(NSString*) word {
    //get all the image details and do a in-memory search
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WordData" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    //match parent
    NSPredicate *match_parent = [NSPredicate
                                 predicateWithFormat:@"word like[cd] %@",word]; 
    [request setPredicate:match_parent];
    
    NSError *error;
    NSArray *entry = [managedObjectContext executeFetchRequest:request error:&error];
    if(entry == nil || [entry count] == 0) {
        return nil;
    }
    return [entry objectAtIndex:0];
}

//return frequency assumes word is present in data
-(NSDecimalNumber*) getFrequency:(NSString*) word {
    WordData *entry = [self getWord:word];
    return [entry frequency];
}

-(NSArray*) getChildrenList:(NSString*) parent {
    WordData *entry = [self getWord:parent];
    NSString *child_list = [entry children];
    NSArray *children = [child_list componentsSeparatedByString:@","];
    
    NSArray *sorted_children = [children sortedArrayUsingComparator:^(id obj1,id obj2) {
        return [self getFrequency:obj1] > [self getFrequency:obj2];  
    }];
    return sorted_children;
}


-(void) reset {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WordData" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *all_data= [managedObjectContext executeFetchRequest:request error:&error];
    for(int i = 0;i<[all_data count];i++) {
        [managedObjectContext deleteObject:[all_data objectAtIndex:i]];
    }
}

-(WordData*) getWordFromCache:(NSString*) word {
    if ([word length] == 0) return nil;
    NSString *search_word = [word stringByAppendingString:@"_"];
    char c_string[2];
    c_string[0] = [word characterAtIndex:0];
    c_string[1] = '\0';
    //NSString *first_char = [NSString stringWithUTF8String:c_string];
    NSString *first_char = [NSString stringWithFormat:@"%s", c_string];
    NSMutableArray *prediction_result = [in_memory_prediction objectForKey:first_char];
    int current_index = 0;
    while(current_index < [prediction_result count]) {
        WordData *current_data = [prediction_result objectAtIndex:current_index];
        if( [[current_data word] isEqualToString:search_word] ) {
            return current_data;
        } 
        current_index += 1;
    }
    DLog(@"Returning nil for <%@>",word);
    return nil;
}

-(NSMutableArray*) sortByFrequency:(NSString *)sentence {
    NSMutableArray* word_list = [[NSMutableArray alloc] init];
    NSMutableArray* words_array = [[NSMutableArray alloc] init];
    
    for(id word in [sentence componentsSeparatedByString:@" "]) {
            
       // if([word length] < 3) continue; //neglect a of an ...   
        WordData *word_data = [self getWordFromCache:word];
        if(word_data != nil) {
            [word_list addObject:word_data];
        } else {
            [words_array addObject:[[word stringByAppendingString:@"_"] lowercaseString]];
        }
    }
    
    NSArray *sorted =  [word_list sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        return [(WordData *)a frequency] < [(WordData *)b frequency];
    }]; // mutableCopy];
    
    for (id word in sorted)
        [words_array addObject:[word word]];
    
    return words_array;
}

-(void) addWordToParent:(NSString*) word :(NSString*) parent {
    [self addWordData:word :[NSDecimalNumber one] :parent :@""];
    WordData *parent_data = [self getWord:parent];
    [parent_data setFrequency:[[parent_data frequency] decimalNumberByAdding:[NSDecimalNumber one]]];
    [parent_data setChildren:[[parent_data children] stringByAppendingFormat:@",%@",word]];
}

-(void) addNewWordData:(NSString *)word {
    // word ends with '_' when entering here
    NSString *parent = [word substringToIndex:[word length] - 2];
    while ([parent length] != 0) { 
        if ([self getWord:parent] != nil) {
            [self addWordToParent:word :parent];
            return;
        }
        parent  = [parent substringToIndex:[parent length] - 1];
    }
    
    // if no match is found add to __ROOT__
    [self addWordToParent:word :@"__ROOT__"];
}

-(void) updateFrequencyTillRoot:(NSString*) node :(NSDecimalNumber*)increment {
    NSString* parent = [[self getWord:node]  parent];
    DLog(@"Update frequency parent is %@",parent);
    while (![parent isEqualToString:@"__ROOT__"]) {
        WordData *word_data = [self getWord:parent];
        [word_data setFrequency:[[word_data frequency] decimalNumberByAdding:increment]];
        parent = [[self getWord:parent]  parent];
        DLog(@"Update frequency parent is %@",parent);
    }
    DLog(@"Update frequency returning");
}

-(BOOL) updateFromSentence:(NSString*) sentence{
    BOOL all_updated = YES;
    NSArray *words = [sentence componentsSeparatedByString:@" "];
    for(int i =0;i<[words count] ;i++) {
        if ([[words objectAtIndex:i] length] == 0) {
            continue;
        }
        NSString *word_to_be_added = [[words objectAtIndex:i] stringByAppendingString:@"_"];
        DLog(@"Word to be added is <%@>",word_to_be_added);
        WordData *word = [self getWord:word_to_be_added];
        if(word == nil) {
            if ([[words objectAtIndex:i] containsOnlyAlphabets]) {
                [self addNewWordData:word_to_be_added];
                [self addWordDataToCache:[self getWord:word_to_be_added]];
        } 
            [word setFrequency:[[word frequency] decimalNumberByAdding:[NSDecimalNumber one]]];
            [self updateFrequencyTillRoot:word_to_be_added :[NSDecimalNumber one]];
    }
    NSError *error = nil;
    if(![managedObjectContext save:&error]) {
        all_updated = NO;
    }
    }
    return all_updated;
}

-(NSArray*) getPrediction:(NSString *)prefix {
//    DLog(@"prefix is %@",prefix);
    if(prefix.length == 0 || ( prefix.length == 1 && [prefix compare:@" "] == 0) || [prefix hasSuffix:@"\n"]) {
        return root_prediction;
    }
    NSString *first_char = [prefix substringToIndex:1];
    NSMutableArray *prediction_result = [in_memory_prediction objectForKey:first_char];
    int MAX_NUM_RESULT = 20;
    int current_index = 0;
    NSMutableArray *matches_from_buffer = [[NSMutableArray alloc] init];
    while(current_index < [prediction_result count] && [matches_from_buffer count] < MAX_NUM_RESULT) {
        WordData *current_data = [prediction_result objectAtIndex:current_index];
        if( [[current_data word] hasPrefix:prefix]) {
            [matches_from_buffer addObject:current_data];
        }
        current_index += 1;
    }
    return matches_from_buffer;
/*
    NSString *prefix_copy = [prefix copy];
    //get the prefix of the prefix present in the tree as a node
    WordData *prefix_node;
    
    while([prefix_copy length] > 0) {
        DLog(@"Finding minimum prefix %@\n",prefix_copy);
        prefix_node = [self getWord:prefix_copy];
        if(prefix_node != nil) break;
        prefix_copy = [prefix_copy substringToIndex:[prefix_copy length]-1];
    }
    
    if(prefix_node == nil) return nil;
    NSMutableArray *queue = [[NSMutableArray alloc] init];
    NSMutableArray *prediction= [[NSMutableArray alloc] init];
    
    [queue addObject:[prefix_node word]];
    
    while([queue count] > 0) {
        NSString *root = [queue objectAtIndex:0];
        DLog(@"Root is %@\n",root);
        [queue removeObjectAtIndex:0];
        WordData *root_node = [self getWord:root];
        NSArray *children = [[root_node children] componentsSeparatedByString:@","];
        for(int i =0;i<[children count];i++) {
           NSString *child = [children objectAtIndex:i];
           if([child hasSuffix:@"_"]) {
               if([child hasPrefix:prefix]) {
                   [prediction addObject:[self getWord:child]];
               }
           } else {
               if([child length] < [prefix length] || [child hasPrefix:prefix]) {
                   [queue addObject:child];
               }
           }
         }
    }
    NSMutableArray *sorted_prediction = [[prediction sortedArrayUsingComparator:^(id a, id b) {
      return  [(WordData*)a frequency] >[(WordData*)b frequency];
    }] mutableCopy]; 
    
    prediction_result = prediction;
    prediction_query = prefix;
    
    NSRange top_result;
    top_result.location = 0;
    if([sorted_prediction count] > MAX_NUM_RESULT) {
        top_result.length = MAX_NUM_RESULT;
        return [sorted_prediction subarrayWithRange:top_result];
    }
    else {
        return sorted_prediction;
    }*/
        
}

-(NSArray*) getMetadiction:(NSString *)prefix {
    //    DLog(@"prefix is %@",prefix);
    MetaphoneHelper* metaobj = [[MetaphoneHelper alloc] initWithString:prefix];
    NSString* meta = [metaobj getMetaph];
    NSString* altmeta = [metaobj altGetMetaph];
    if(meta.length == 0 || ( meta.length == 1 && [meta compare:@" "] == 0) || [meta hasSuffix:@"\n"]) {
        return root_prediction;
    }
    NSString *first_meta = [meta substringToIndex:1];
    NSMutableArray *metadiction_result = [in_memory_metadiction objectForKey:first_meta];
    int MAX_NUM_RESULT = 20;
    int current_index = 0;
    NSMutableArray *matches_from_buffer = [[NSMutableArray alloc] init];
    while(current_index< [metadiction_result count] && [matches_from_buffer count] < MAX_NUM_RESULT){
        WordData *current_meta = [metadiction_result objectAtIndex:current_index];
        if ([[current_meta meta1] hasPrefix:meta])
        {
            [matches_from_buffer addObject:current_meta];
        }
        else if ([[current_meta meta2] hasPrefix:altmeta]){
            [matches_from_buffer addObject:current_meta];
        }
        current_index+=1;
    }
    return matches_from_buffer;  
}

@end
