//
//  WordData.h
//  Data
//
//  Created by Malar Kannan on 5/23/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WordData : NSManagedObject

@property (nonatomic, retain) NSString * children;
@property (nonatomic, retain) NSDecimalNumber * frequency;
@property (nonatomic, retain) NSString * parent;
@property (nonatomic, retain) NSString * word;
@property (nonatomic, retain) NSString * meta1;
@property (nonatomic, retain) NSString * meta2;

@end
