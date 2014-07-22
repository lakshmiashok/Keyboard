//
//  PicModeDict.h
//  Data
//
//  Created by nadu on 27/03/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PicModeDict : NSManagedObject

@property (nonatomic, retain) NSString * audio_data;
@property (nonatomic, retain) NSString * category_or_template;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * is_enabled;
@property (nonatomic, retain) NSNumber * is_sentence_box_enabled;
@property (nonatomic, retain) NSString * parent_id;
@property (nonatomic, retain) NSString * picture;
@property (nonatomic, retain) NSDecimalNumber * serial;
@property (nonatomic, retain) NSString * tag_name;
@property (nonatomic, retain) NSDecimalNumber * version;
@property (nonatomic, retain) NSString * part_of_speech;
@property (nonatomic, retain) NSNumber * extraColumn1;
@property (nonatomic, retain) NSString * extraColumn2;

@end
