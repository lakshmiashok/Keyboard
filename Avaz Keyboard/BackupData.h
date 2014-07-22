//
//  BackupData.h
//  Data
//
//  Created by Malar Kannan on 7/18/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BackupData : NSManagedObject

@property (nonatomic, retain) NSString * backupname;
@property (nonatomic, retain) NSNumber * action;
@property (nonatomic, retain) NSString * owner;
@property (nonatomic, retain) NSDate * date;

@end
