//
//  PronounciationData.h
//  Data
//
//  Created by nadu on 15/12/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PronounciationData : NSManagedObject

@property (nonatomic, retain) NSString * actual;
@property (nonatomic, retain) NSString * spoken;

@end
