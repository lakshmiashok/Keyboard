//
//  WordData+CSVFormat.m
//  Data
//
//  Created by nadu on 25/10/12.
//
//

#import "WordData+UtilityMethods.h"

@implementation WordData (UtilityMethods)

-(NSString*) csvFormat {
    return [NSString stringWithFormat:@"%@,%d,%@,%@",[self word],[[self frequency] intValue],[self parent],[self children]];
}

@end
