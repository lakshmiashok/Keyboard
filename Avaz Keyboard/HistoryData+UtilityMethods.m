//
//  HistoryData+UtilityMethods.m
//  Data
//
//  Created by nadu on 25/10/12.
//
//

#import "HistoryData+UtilityMethods.h"

@implementation HistoryData (UtilityMethods)

-(NSString*) csvFormat {
    return [NSString stringWithFormat:@"%@,%@",[self history],[[self date] description]];
}


@end
