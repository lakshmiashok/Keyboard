//
//  Context.h
//  Data
//
//  Created by Prathab on 16/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Context : NSObject 

//NSManagedObjectContext *managedObjectContext;


+(void) setContext:(NSManagedObjectContext*) context;
+(NSManagedObjectContext*) getContext;
//+ (void)recreateManagedObjectContext;
+(NSString *) getVersionIdentifierForStore:(NSURL *)storeURL;

@end
