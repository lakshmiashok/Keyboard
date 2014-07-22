//
//  PronounciationData+UtilityMethods.m
//  Data
//
//  Created by nadu on 25/10/12.
//
//

#import "PronounciationData+UtilityMethods.h"

@implementation PronounciationData (UtilityMethods)

-(NSString*) csvFormat {
    return [NSString stringWithFormat:@"%@,%@",[self actual],[self spoken]];
}

@end
