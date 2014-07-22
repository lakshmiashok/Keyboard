//
//  ImageData.h
//  Data
//
//  Created by nadu on 15/12/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ImageData : NSManagedObject

@property (nonatomic, retain) NSString * directory_path;
@property (nonatomic, retain) NSString * file_name;
@property (nonatomic, retain) NSDecimalNumber * index;
@property (nonatomic, retain) NSString * key_words;

@end
