//
//  MorphExceptionDataController.m
//  Data
//
//  Created by nadu on 19/04/14.
//
//

#import "MorphExceptionDataController.h"
#import "Context.h"

@implementation MorphExceptionDataController
static MorphExceptionDataController *static_object;

-(id) init {
    if(static_object != nil) {
        return static_object;
    }
    if(self = [super init]) {
        [self setContext:[Context getContext]];
        static_object = self;
    }
    return self;
}

-(void) setContext:(NSManagedObjectContext*) context{
    managedObjectContext = context;
}

-(void) commit {
    NSError *error = nil;
    if(![managedObjectContext save:&error]) {
        //Handle Error
        DLog(@"Error committing MorphExceptionData - %@", [error userInfo]);
    }
}

-(MorphExceptionData *) getMorphForms:(NSString*) word withTense:(NSString *) pos anyForm:(BOOL) anyForm{
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MorphExceptionData"
                                              inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word = [cd]%@ and part_of_speech = [cd]%@",word,pos];
    [request setPredicate:predicate];

    NSError *error = nil;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    if(array == nil) {
        //error occurred
        if(anyForm)
            return [self getMorphForms:word];
        else
            return nil;
    }
    if( [array count] > 0 ) {
        return [array objectAtIndex:0];
    } else {
        if(anyForm)
            return [self getMorphForms:word];
        else
            return nil;
    }
}

-(MorphExceptionData *) getMorphForms:(NSString*) word {
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"MorphExceptionData"
                                              inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word = [cd]%@",word];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    if(array == nil) {
        //error occurred
        return nil;
    }
    if( [array count] > 0 ) {
        
        for(MorphExceptionData * elem in array)
        {
            if([elem.part_of_speech isEqualToString:elem.morph_extra])
                return elem;
        }
        return [array objectAtIndex:0];
    } else {
        return nil;
    }
}


+(BOOL) addDataAsBulk:(NSArray*)newEntries withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{

    int ctr = 0;
    for(NSMutableDictionary *newEntry in newEntries){
        MorphExceptionData *mxd = (MorphExceptionData*)[NSEntityDescription insertNewObjectForEntityForName:@"MorphExceptionData" inManagedObjectContext:managedObjectContext];
        [mxd setMorph1:[newEntry objectForKey:@"morph1"]];
        [mxd setMorph2:[newEntry objectForKey:@"morph2"]];
        [mxd setMorph3:[newEntry objectForKey:@"morph3"]];
        [mxd setMorph4:[newEntry objectForKey:@"morph4"]];
        [mxd setMorph5:[newEntry objectForKey:@"morph5"]];
        [mxd setMorph6:[newEntry objectForKey:@"morph6"]];
        [mxd setMorph_extra:[newEntry objectForKey:@"morph7"]];
        [mxd setWord:[newEntry objectForKey:@"word"]];
        [mxd setPart_of_speech:[newEntry objectForKey:@"part_of_speech"]];
        ctr++;
    }
    return YES;
}

-(void)insert: (NSMutableDictionary *) newEntry
{
    NSString *wd = [newEntry objectForKey:@"word"];
    NSString *pos = [newEntry objectForKey:@"part_of_speech"];
    
    MorphExceptionData *mxd = [self getMorphForms:wd withTense:pos anyForm:NO];
    
    if(mxd == nil)
    {
        mxd = (MorphExceptionData*)[NSEntityDescription insertNewObjectForEntityForName:@"MorphExceptionData" inManagedObjectContext:managedObjectContext];
        [mxd setMorph_extra:[newEntry objectForKey:@"part_of_speech"]];
    }
    
    [mxd setMorph1:[newEntry objectForKey:@"morph1"]];
    [mxd setMorph2:[newEntry objectForKey:@"morph2"]];
    [mxd setMorph3:[newEntry objectForKey:@"morph3"]];
    [mxd setMorph4:[newEntry objectForKey:@"morph4"]];
    [mxd setMorph5:[newEntry objectForKey:@"morph5"]];
    [mxd setMorph6:[newEntry objectForKey:@"morph6"]];
    [mxd setWord:[newEntry objectForKey:@"word"]];
    [mxd setPart_of_speech:[newEntry objectForKey:@"part_of_speech"]];
    [self commit];
}

-(NSString *) getPOSforWord:(NSString *) word
{
    MorphExceptionData *mxd = [self getMorphForms:word];
    
    if(mxd == nil)
        return nil;
    else
        return mxd.morph_extra;
}


@end
