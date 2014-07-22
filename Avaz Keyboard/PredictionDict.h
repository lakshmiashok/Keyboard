//
//  PredictionDict.h
//  Data
//
//  Created by nadu on 15/12/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PredictionDict : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * frequency;
@property (nonatomic, retain) NSString * parent;
@property (nonatomic, retain) NSString * prediction;

@end
