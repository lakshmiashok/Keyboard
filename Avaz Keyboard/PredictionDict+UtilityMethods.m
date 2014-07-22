//
//  PredictionDict+UtilityMethods.m
//  Data
//
//  Created by nadu on 25/10/12.
//
//

#import "PredictionDict+UtilityMethods.h"

@implementation PredictionDict (UtilityMethods)

-(void) print {
    printf("Parent: %s\n",[[self parent] cStringUsingEncoding:NSASCIIStringEncoding ]);
    printf("Prediction: %s\n",[[self prediction] cStringUsingEncoding:NSASCIIStringEncoding]);
    printf("Frequency: %d\n",[[self frequency] intValue]);
}

-(NSString*) csvFormat {
    return [NSString stringWithFormat:@"%@,%@,%d",[self parent],[self prediction],[[self frequency] intValue]];
}

@end
