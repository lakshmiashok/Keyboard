//
//  PicModeDict+UtilityMethods.m
//  Data
//
//  Created by nadu on 24/11/12.
//
//

#import "PicModeDict+UtilityMethods.h"
#import "NSString+Additions.h"

@implementation PicModeDict (UtilityMethods)
-(NSString*) csvFormat {
    return @"";
}

-(NSString *) getStringToSpeak {
    
    if(([self audio_data] == nil) || ([[self audio_data] isEqualToString:@""]) || ([[self audio_data] isEqualToString:@"none"]))
    {
        return [self tag_name];
    } else {
        return [self audio_data];
    }
}

//helper functions to avoid comparison in top level code
-(BOOL) isTemplate {
    return ([[self category_or_template] isEqualToString:@"T"]);
}

-(BOOL) isCategory {
    return ![self isTemplate];
}

-(BOOL) isDisabled {
    return  ![[self is_enabled] boolValue];
}
@end
