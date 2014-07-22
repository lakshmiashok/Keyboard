//
//  QuickAccessData+CSVFormat.m
//  Data
//
//  Created by nadu on 25/10/12.
//
//

#import "QuickAccessData+UtilityMethods.h"

@implementation QuickAccessData (UtilityMethods)

-(NSString*) csvFormat {
    return [NSString stringWithFormat:@"%@,%@",[self key],[self quick_text]];
}

@end
