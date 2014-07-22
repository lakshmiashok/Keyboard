//
//  HistoryData.h
//  Data
//
//  Created by nadu on 15/12/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HistoryData : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * history;

@end
