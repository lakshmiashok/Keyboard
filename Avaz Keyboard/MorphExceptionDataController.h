//
//  MorphExceptionDataController.h
//  Data
//
//  Created by nadu on 19/04/14.
//
//

#import <Foundation/Foundation.h>
#import "MorphExceptionData.h"

@interface MorphExceptionDataController : NSObject{
    NSManagedObjectContext *managedObjectContext;
}

+(BOOL) addDataAsBulk:(NSArray*)newEntries withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
-(void) commit;
-(MorphExceptionData *) getMorphForms:(NSString*) word withTense:(NSString *) pos anyForm:(BOOL) anyForm;
-(void) insert: (NSMutableDictionary *) newEntry;
-(NSString *) getPOSforWord:(NSString *) word;
@end
