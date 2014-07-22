//
//  MorphExceptionData.h
//  Data
//
//  Created by nadu on 18/04/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MorphExceptionData : NSManagedObject

@property (nonatomic, retain) NSString * word;
@property (nonatomic, retain) NSString * morph1;
@property (nonatomic, retain) NSString * morph2;
@property (nonatomic, retain) NSString * morph3;
@property (nonatomic, retain) NSString * morph4;
@property (nonatomic, retain) NSString * morph5;
@property (nonatomic, retain) NSString * morph6;
@property (nonatomic, retain) NSString * morph_extra;
@property (nonatomic, retain) NSString * part_of_speech;

@end
