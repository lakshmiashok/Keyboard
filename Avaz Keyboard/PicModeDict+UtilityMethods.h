//
//  PicModeDict+UtilityMethods.h
//  Data
//
//  Created by nadu on 17/11/12.


#import "PicModeDict.h"

@interface PicModeDict (UtilityMethods)

-(NSString *) getStringToSpeak;
-(NSString*) csvFormat;
-(BOOL) isTemplate;
-(BOOL) isCategory;
-(BOOL) isDisabled;


@end
