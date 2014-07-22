//
//  QuickAccessData.h
//  Data
//
//  Created by nadu on 15/12/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface QuickAccessData : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * quick_text;

@end
