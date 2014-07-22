//
//  SettingsDataController.h
//  Data
//
//  Created by Prathab on 24/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingsData.h"

@interface SettingsDataController : NSObject {
    
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

-(id) init;
-(void) setContext:(NSManagedObjectContext*) context;

-(SettingsData*) getSettingsData: (NSString*) identifier;
-(SettingsData*) addSettingsData: (NSString*) identifier; //create and return a reference
-(SettingsData*) getDefault;
-(void) commit;

@end
