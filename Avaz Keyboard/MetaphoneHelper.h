//
//  MetaphoneHelper.h
//  Data
//
//  Created by Malar Kannan on 5/19/14.
//
//

#import "Metaphone3.h"
#import <Foundation/Foundation.h>

@interface MetaphoneHelper : NSObject{
    void* meta;
}
-(MetaphoneHelper*) initWithString : (NSString*) wordtoencode;
-(NSString*) getMetaph;
-(NSString*) altGetMetaph;

@end
