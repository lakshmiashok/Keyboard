//
//  ImageData+UtilityMethods.m
//  Data
//
//  Created by nadu on 25/10/12.
//
//

#import "ImageData+UtilityMethods.h"

@implementation ImageData (UtilityMethods)

-(NSString*) csvFormat {
    return [NSString stringWithFormat:@"%d,%@,%@,%@",[[self index] intValue],[self directory_path],[self file_name],[self key_words]];
}

@end
