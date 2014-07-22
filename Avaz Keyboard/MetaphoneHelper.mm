//
//  MetaphoneHelper.m
//  Data
//
//  Created by Malar Kannan on 5/19/14.
//
//

#import "MetaphoneHelper.h"


@implementation MetaphoneHelper

-(MetaphoneHelper*) initWithString :(NSString*) wordtoencode{
    const char* encoded = [wordtoencode UTF8String];
    meta = Metaphone_new(encoded);
    [self encodeVowels:true];
    [self encodeExact:true];
    [self encode];
    return self;
}

-(void)encodeExact: (BOOL) val{
    setEncodeExact((Metaphone3*) meta, val);
}

-(void)encodeVowels: (BOOL) val{
    setEncodeVowels((Metaphone3*) meta, val);
}

-(void)encode{
    encode((Metaphone3*) meta);
}

-(NSString*) getMetaph{
    NSString* metaph = [[NSString alloc] initWithUTF8String:getMetaph((Metaphone3*)meta)];
    return metaph;
}

-(NSString*) altGetMetaph{
    NSString* metaph = [[NSString alloc] initWithUTF8String:altGetMetaph((Metaphone3*)meta)];
    return metaph;
}

@end
