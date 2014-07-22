//
//  PicModeDictController.m
//  Data
//
//  Created by Prathab on 08/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PicModeDictController.h"
#import "Context.h"
#import "NSString+Additions.h"
#import "SettingsDataController.h"
#import "SettingsData+UtilityMethods.h"
static id static_object;
static NSString *folderShortcut;

@implementation PicModeDictController

@synthesize managedObjectContext;

-(id) init {
    if(static_object != nil) {
        return static_object;
    }
    if(self = [super init]) {
        [self setContext:[Context getContext]];
        DEFAULT_VERSION = [NSDecimalNumber numberWithInt:2];
        DEFAULT_ENABLE_STATUS = [NSNumber numberWithBool:YES];
        DEFAULT_IMAGE = @"";
        DEFAULT_SENTENCE_BOX_ENABLE_STATUS = [NSNumber numberWithBool:NO];
        static_object = self;
        imageController = [[ImageController alloc] init];
    }
    return self;
}

-(void) saveContext {
    NSError *error = nil;
    if(![managedObjectContext save:&error]) {
        //Handle Error
        DLog(@"Error committing PicModeDict - %@", [error userInfo]);
    } 
}

-(void) setContext:(NSManagedObjectContext*) context{
    managedObjectContext = context;
}

-(NSString*) computeIdentifierWithBackgroundMOC:(NSString*) tag_name {
    int randomValue = arc4random() % 100000000;
    NSString *randomString = [NSString stringWithFormat:@"%d",1000000000 +  randomValue];
    NSDate *start_checkingIndentifierExists = [NSDate date];
    if([allPicModeDictIds valueForKey:randomString] != nil)
        return [self computeIdentifierWithBackgroundMOC:nil];
    //    if ([self getPicModeDictWithBackgroundMOC:randomString] != nil)
    //        return [self computeIdentifierWithBackgroundMOC:nil];
    DLog(@"Time to check if identifier exists %f",-[start_checkingIndentifierExists timeIntervalSinceNow]);
    [allPicModeDictIds setValue:@"YES" forKey:randomString];
    return randomString;
    
}

-(NSString*) computeIdentifier:(NSString*) tag_name {
    int randomValue = arc4random() % 100000000;
    NSString *randomString = [NSString stringWithFormat:@"%d",1000000000 +  randomValue];
    if ([self getPicModeDict:randomString] != nil)
        return [self computeIdentifier:nil];
    return randomString;
    NSString *toAscii = [[NSString alloc]  init];
    for(int i = 0;i<[tag_name length];i++) {
        toAscii = [toAscii stringByAppendingString:[NSString stringWithFormat:@"%d",[tag_name characterAtIndex:i]]];
    }
    //prefixed with 5 to make it consistent with customization tool
    toAscii = [[NSString stringWithFormat:@"%d",5] stringByAppendingString:toAscii];
    while( [self getPicModeDict:[toAscii MD5]] != nil) {
        toAscii = [toAscii MD5];
    }
    return [toAscii MD5];;   
}

-(BOOL) addPicModeDataFromObject:(PicModeDict *)picModeDict {
    PicModeDict *pic_mode_dict = (PicModeDict*)[NSEntityDescription insertNewObjectForEntityForName:@"PicModeDict" inManagedObjectContext:managedObjectContext];
    [pic_mode_dict setIdentifier:[picModeDict identifier]];
    [pic_mode_dict setVersion:[picModeDict version]];
    [pic_mode_dict setParent_id:[picModeDict parent_id]];
    [pic_mode_dict setIs_enabled:[picModeDict is_enabled]];
    [pic_mode_dict setCategory_or_template:[picModeDict category_or_template]];
    [pic_mode_dict setTag_name:[picModeDict tag_name]];
    [pic_mode_dict setAudio_data:[picModeDict audio_data]];
    [pic_mode_dict setPicture:[picModeDict picture]];
    [pic_mode_dict setIs_sentence_box_enabled:[picModeDict is_sentence_box_enabled]];
    [pic_mode_dict setSerial:[picModeDict serial]];
    NSError *error = nil;
    if(![managedObjectContext save:&error]) {
            //Handle Error
        return NO;
    } 
    return YES;
}

-(BOOL) addPicModeData:(NSString*) identifier :(NSDecimalNumber*) version :(NSString*) parent :(NSNumber*) is_enabled :(NSString*) category_type :(NSString*) tag_name :(NSString*) audio_data :(NSString*) picture :(NSNumber*) is_sentence_box_enabled :(NSDecimalNumber*) serial {
    if(!backgroundMOC)
        [self createBackgroundMOC];
    PicModeDict *pic_mode_dict = (PicModeDict*)[NSEntityDescription insertNewObjectForEntityForName:@"PicModeDict" inManagedObjectContext:backgroundMOC];
    [pic_mode_dict setIdentifier:identifier];
    [pic_mode_dict setVersion:version];
    [pic_mode_dict setParent_id:parent];
    [pic_mode_dict setIs_enabled:is_enabled];
    [pic_mode_dict setCategory_or_template:category_type];
    [pic_mode_dict setTag_name:tag_name];
    [pic_mode_dict setAudio_data:audio_data];
    [pic_mode_dict setPicture:picture];
    [pic_mode_dict setIs_sentence_box_enabled:is_sentence_box_enabled];
    [pic_mode_dict setSerial:serial];
    NSError *error = nil;
    if(![backgroundMOC save:&error]) {
        //Handle Error
        return NO;
    } 
    return YES;
}

-(void) adaptToIndex:(NSString *)parent :(PicModeDict *)current :(int)index {
    
    //rearrange old parent
    NSArray* old_brothers = [self getChildren:[current parent_id]];
    for(id brother in old_brothers) {
        if([brother serial] > [current serial]) {
            [brother setSerial:[[brother serial] decimalNumberBySubtracting:[NSDecimalNumber one]]];
        }
    }
    
    if(parent == nil) {
       // [managedObjectContext deleteObject:current];
        return;
    }
    
    [current setParent_id:parent];
    
    NSArray* new_brothers = [self getChildren:parent];
    for(id brother in new_brothers) {
        for(id brother in old_brothers) {
            if([brother serial] >= [NSDecimalNumber numberWithInt:index]) {
                [brother setSerial:[[brother serial] decimalNumberByAdding:[NSDecimalNumber one]]];
            }
        }
    }
}


-(PicModeDict*) addAtIndex:(NSString*) parent :(NSString *)text :(int)index {
    DLog(@"Adding %@",text);
    PicModeDict *pic_mode_dict = (PicModeDict*)[NSEntityDescription insertNewObjectForEntityForName:@"PicModeDict" inManagedObjectContext:managedObjectContext];
    [pic_mode_dict setIdentifier: [self computeIdentifier:text]];
    [pic_mode_dict setVersion:DEFAULT_VERSION];
    [pic_mode_dict setIs_enabled:[NSNumber numberWithBool:YES]];
    [pic_mode_dict setCategory_or_template:@"T"];
    [pic_mode_dict setTag_name:text];
    [pic_mode_dict setAudio_data:nil];
    NSString* default_image = [[[ImageController alloc] init] getDefaultImageFromCache:text];
    if(default_image != nil) {
        DLog(@"Setting default image %@",default_image);
        [pic_mode_dict setPicture:[default_image stringByAppendingString:@".png"]];
    } else {
        DLog(@"Setting default image how.png");
        [pic_mode_dict setPicture:@"how.png"];
    }
    [pic_mode_dict setIs_sentence_box_enabled:[NSNumber numberWithBool:NO]];
    
    NSArray* children = [self getChildren:parent];
    index = [children count] >= 1 ? [children count]+1: 1;
//    for(int i = index;i<[children count];i++) {
//        NSDecimalNumber *serial = [[children objectAtIndex:i] serial];
//        [[children objectAtIndex:i] setSerial:[serial decimalNumberByAdding:[NSDecimalNumber one]]];
//    }
    
    [pic_mode_dict setParent_id:parent];
    [pic_mode_dict setSerial:[NSDecimalNumber numberWithInt:index]];

     return pic_mode_dict;
}

-(PicModeDict*) getPicModeDict:(NSString*) identifier {
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"PicModeDict"
                                              inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@",identifier];
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

-(PicModeDict*) getPicModeDictWithTag:(NSString*) tag_name {
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"PicModeDict"
                                              inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = [cd]%@",tag_name];
    [request setPredicate:predicate];

    NSError *error = nil;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    if(array == nil) {
        //error occurred
        return nil;
    }
    if( [array count] >= 1 ) {
        return [array objectAtIndex:0];
    } else {
        return nil;
    }

}

-(PicModeDict*) getPicModeDictWithBackgroundMOC:(NSString*) identifier{
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"PicModeDict"
                                              inManagedObjectContext:backgroundMOC];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@",identifier];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    //DLog(@"before id fetch req");
    NSDate *start = [NSDate date];
    NSArray *array = [backgroundMOC executeFetchRequest:request error:&error];
    DLog(@"getpicmodedict using identifier == - time taken = %f", -[start timeIntervalSinceNow]);
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

-(NSArray*) getAll {
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"PicModeDict"
                                              inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSError *error = nil;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    return array;
}

-(NSArray*) getAllWithLimit:(int) limit{
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"PicModeDict"
                                              inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    [request setFetchLimit:limit];
    NSError *error = nil;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    return array;
}

-(NSArray*) getAllChildren:(NSString*) parent {
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"PicModeDict"
                                              inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent_id = %@",parent];
    [request setPredicate:predicate];
    
    //sort by frequency
    NSSortDescriptor *sort_descriptor = [[NSSortDescriptor alloc] initWithKey:@"serial" ascending:YES];
    NSArray *sort_descriptors = [[NSArray alloc] initWithObjects:sort_descriptor, nil];
    [request setSortDescriptors:sort_descriptors];
    
    NSError *error = nil;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    if(array == nil) {
        //error occurred
        return nil;
    } else {
        return array;
    }
}

-(NSArray*) getChildren:(NSString*) parent {
    NSArray* allChildren = [self getAllChildren:parent];
    NSMutableArray* filteredChildren = [[NSMutableArray alloc] init];
    for(int i = 0;i<[allChildren count] ;i++) {
        if(true || [[[allChildren objectAtIndex:i] is_enabled] boolValue]) {
            [filteredChildren addObject:[allChildren objectAtIndex:i]];
        }
    }
    return filteredChildren;
}

-(int) getQuickCount {
    NSArray *top_level_children = [self getChildren:@"0"];
    int count = 0;
    for(id each_child in top_level_children) {
        if([each_child isCategory] && [[[each_child tag_name] lowercaseString] isEqualToString:NSLocalizedString(@"quick","@quick")]) {
            count ++;
        }
    }
    return count;
}
static NSString *quick_identifier = nil;

-(NSString*) getQuickIdentifier {
    NSDate *start = [NSDate date];
    SettingsData *settings = [[[SettingsDataController alloc] init] getDefault];
    DLog(@"Time taken for retrieving settings - %f",-[start timeIntervalSinceNow]);
    if(quick_identifier != nil &&
       folderShortcut != nil &&
       [folderShortcut isEqualToString:[settings folderShortcut]]){
        return quick_identifier;
    }
    folderShortcut = [settings folderShortcut];
    NSArray *top_level_children = [self getChildren:@"0"];
    for(id each_child in top_level_children) {
        NSString *tag_name_space_removed = [[[each_child tag_name] 
                                             stringByTrimmingCharactersInSet:
                                                                     [NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                            lowercaseString];
        if([each_child isCategory] && [tag_name_space_removed isEqualToString:[folderShortcut lowercaseString]]) {
            DLog(@"Quick Identifier is %@",[each_child identifier]);
            quick_identifier = [each_child identifier];
            return [each_child identifier];
        }
    }
    return nil;
}

-(void) remove:(PicModeDict *)picModeDict {
    NSMutableArray * objectsToBeRemoved = [[NSMutableArray alloc]  init];
    [objectsToBeRemoved addObject:picModeDict];
    while([objectsToBeRemoved count] > 0) {
        PicModeDict *front = [objectsToBeRemoved objectAtIndex:0];
        [objectsToBeRemoved removeObjectAtIndex:0];
        if([front isCategory]) {
            [objectsToBeRemoved addObjectsFromArray:[self getAllChildren:[front identifier]]];
        } 
        [managedObjectContext deleteObject:front];
    }
}

-(void) reset {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PicModeDict" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *all_data= [managedObjectContext executeFetchRequest:request error:&error];
    for(int i = 0;i<[all_data count];i++) {
        [managedObjectContext deleteObject:[all_data objectAtIndex:i]];
    }
    [self commit];
}

-(BOOL) commit {
    NSError *error = nil;
    if(![managedObjectContext save:&error]) {
        //Handle Error
        return NO;
    } 
    return YES;
}

-(BOOL) resetWithBackgroundMOC {
    if(!backgroundMOC)
        [self createBackgroundMOC];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PicModeDict" inManagedObjectContext:backgroundMOC];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *all_data= [backgroundMOC executeFetchRequest:request error:&error];
    for(int i = 0;i<[all_data count];i++) {
        [backgroundMOC deleteObject:[all_data objectAtIndex:i]];
    }
    return [self commitWithBackgroundMOC];

}

-(BOOL) addPicModeDataAsBulk:(NSArray*)newEntries{
    if(!backgroundMOC)
        [self createBackgroundMOC];
    int ctr = 0;
    for(NSMutableDictionary *newEntry in newEntries){
        PicModeDict *pic_mode_dict = (PicModeDict*)[NSEntityDescription insertNewObjectForEntityForName:@"PicModeDict" inManagedObjectContext:backgroundMOC];
        [pic_mode_dict setIdentifier:[newEntry objectForKey:@"identifier"]];
        [pic_mode_dict setVersion:[newEntry objectForKey:@"version"]];
        [pic_mode_dict setParent_id:[newEntry objectForKey:@"parent_id"]];
        [pic_mode_dict setIs_enabled:[newEntry objectForKey:@"is_enabled"]];
        [pic_mode_dict setCategory_or_template:[newEntry objectForKey:@"category_or_template"]];
        [pic_mode_dict setTag_name:[newEntry objectForKey:@"tag_name"]];
        [pic_mode_dict setAudio_data:[newEntry objectForKey:@"audio_data"]];
        [pic_mode_dict setPicture:[newEntry objectForKey:@"picture"]];
        [pic_mode_dict setIs_sentence_box_enabled:[newEntry objectForKey:@"is_sentence_box_enabled"]];
        [pic_mode_dict setSerial:[newEntry objectForKey:@"serial"]];
        [pic_mode_dict setColor:[newEntry objectForKey:@"color"]];
        [pic_mode_dict setPart_of_speech:[newEntry objectForKey:@"part_of_speech"]];
        ctr++;
    }
    DLog(@"adding to picmodedict entries = %d", [[backgroundMOC insertedObjects] count]);
    NSError *error = nil;
    if(![backgroundMOC save:&error]) {
        //Handle Error
        DLog(@"Error while saving %@", [error userInfo]);
        return NO;
    }
    quick_identifier = nil;
    return YES;
}

-(NSArray*) getAllChildrenWithBackgroundMOC:(NSString*) parent {
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"PicModeDict"
                                              inManagedObjectContext:backgroundMOC];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent_id == %@",parent];
    [request setPredicate:predicate];
    
    //sort by frequency
    NSSortDescriptor *sort_descriptor = [[NSSortDescriptor alloc] initWithKey:@"serial" ascending:YES];
    NSArray *sort_descriptors = [[NSArray alloc] initWithObjects:sort_descriptor, nil];
    [request setSortDescriptors:sort_descriptors];
    
    NSError *error = nil;
    NSDate *start = [NSDate date];
    //DLog(@"before parent fetch req");
    NSArray *array = [backgroundMOC executeFetchRequest:request error:&error];
    DLog(@"get all children for parent id = %f", -[start timeIntervalSinceNow]);
    if(array == nil) {
        //error occurred
        return nil;
    } else {
        return array;
    }
}

#pragma mark Background thread business

-(void)createBackgroundMOC{
    // re-create every time
    backgroundMOC = [[NSManagedObjectContext alloc] init];
    [backgroundMOC setPersistentStoreCoordinator:[managedObjectContext persistentStoreCoordinator]];
    [backgroundMOC setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backgroundMOCDidSave:) name:NSManagedObjectContextDidSaveNotification object:backgroundMOC];
    DLog(@"getting all children start");
    NSArray *allPicModeDicts = [[NSMutableArray alloc] initWithArray:[self getAll]];
    DLog(@"got all children");
    allPicModeDictIds = [[NSMutableDictionary alloc] init];
    for (PicModeDict *p in allPicModeDicts){
        [allPicModeDictIds setValue:@"YES" forKey:[p identifier]];
    }
}

-(BOOL) commitWithBackgroundMOC {
    NSError *error = nil;
    if(![backgroundMOC save:&error]) {
        //Handle Error
        return NO;
    }
    return YES;
}



- (void)backgroundMOCDidSave:(NSNotification*)notification {
    if (![NSThread isMainThread]) {
        DLog(@"backgroundMOCDidSave is going to get called on main thread");
        [self performSelectorOnMainThread:@selector(backgroundMOCDidSave:) withObject:notification waitUntilDone:YES];
        return;
    }
    
    // We merge the background moc changes in the main moc
    [self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
    DLog(@"should be done merging all changes with the main thread");
}

#pragma mark -

#pragma mark Copy Methods

-(void) makeCopy:(NSString *)parent :(NSString *)child :(BOOL) first {
    //NSDate *start = [NSDate date];
    //DLog(@"A - start time %@", start);
    
    NSDate *start_getPicModeDict = [NSDate date];
    PicModeDict *pmdobj = [self getPicModeDict:child];
    DLog(@"done getting the picmodedict object to be copied - time taken = %f", -[start_getPicModeDict timeIntervalSinceNow]);
    PicModeDict *copy = [self copyPicModeDataFromObject:pmdobj];
    //DLog(@"B - time taken to create a copy %f", -[start timeIntervalSinceNow]);
    if (first)
    {
        //DLog(@"B1 starting to generate serial");
        //start = [NSDate date];
        NSDecimalNumber *new_serial = [self getLargestSerialWithBackgroundMOC:parent];
        if (new_serial == nil) {
            new_serial = [NSDecimalNumber zero];
        } else {
            new_serial = [new_serial decimalNumberByAdding:[NSDecimalNumber one]];
        }
        [copy setSerial:new_serial];
        //DLog(@"B2 done generating serial - time taken %f", -[start timeIntervalSinceNow]);
    }
    
    NSDate *start_getAllChildren = [NSDate date];
    //DLog(@"C - retrieving all children ");
    NSArray* children = [self getAllChildren:child];
    DLog(@"D - done retrieving all children - time taken = %f", -[start_getAllChildren timeIntervalSinceNow]);
    //NSDate *forAllChildren = [NSDate date];
    for (id c in children) {
        //start = [NSDate date];
        //DLog(@"E -  call to makeCopy function - for each child ");
        [self makeCopy:[copy identifier] :[c identifier] :NO];
        //DLog(@"E -  done call to makeCopy function - for each child - time taken = %f", -[start timeIntervalSinceNow]);
    }
    //DLog(@"E -  total time for makeCopy for all children = %f", -[forAllChildren timeIntervalSinceNow]);
    //DLog(@"F");
    [copy setParent_id:parent];
    //DLog(@"G");
}

-(NSDecimalNumber*) getLargestSerial:(NSString *)parent {
    return [[[self getAllChildren:parent]  lastObject ] serial];
}

-(NSDecimalNumber*) getLargestSerialWithBackgroundMOC:(NSString *)parent {
    return [[[self getAllChildrenWithBackgroundMOC:parent]  lastObject ] serial];
}


-(PicModeDict*) copyPicModeDataFromObject:(PicModeDict *)picModeDict {
    //DLog(@"%@ copying tag name", [picModeDict tag_name]);
    PicModeDict *pic_mode_dict = (PicModeDict*)[NSEntityDescription insertNewObjectForEntityForName:@"PicModeDict" inManagedObjectContext:backgroundMOC];
    //DLog(@"1");
    [pic_mode_dict setIdentifier:[self computeIdentifierWithBackgroundMOC:[picModeDict tag_name]]];
    //DLog(@"2");
    [pic_mode_dict setVersion:[picModeDict version]];
    [pic_mode_dict setParent_id:nil];//[picModeDict parent_id]];
    
    [pic_mode_dict setIs_enabled:[picModeDict is_enabled]];
    [pic_mode_dict setCategory_or_template:[picModeDict category_or_template]];
    [pic_mode_dict setTag_name:[picModeDict tag_name]];
    [pic_mode_dict setAudio_data:[picModeDict audio_data]];
    [pic_mode_dict setPicture:[picModeDict picture]];
    [pic_mode_dict setIs_sentence_box_enabled:[picModeDict is_sentence_box_enabled]];
    [pic_mode_dict setSerial:[picModeDict serial]];
    [pic_mode_dict setColor:[picModeDict color]];
    [pic_mode_dict setPart_of_speech:[picModeDict part_of_speech]];
    //DLog(@"3");
    
    return pic_mode_dict;
}

#pragma mark -

@end
