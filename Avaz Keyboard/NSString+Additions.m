//
//  NSString+Additions.m
//  Data
//
//  Created by Prathab on 17/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

@implementation NSString(MD5)

- (NSString*)MD5
{
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) 
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

- (UIImage*) getUIImage {
    NSString* image_path;
    if([self hasPrefix:@"custom_images/"]) {
        NSString* picture_file = [[self componentsSeparatedByString:@"/"] lastObject];
        image_path = [LIB_FOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",picture_file]];
    } else if ([self hasPrefix:@"ci_"]){
        image_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/%@",self];
    } else {
        image_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/png/%@",self];
    }
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:image_path];
    return img;
}

- (BOOL) containsOnlyAlphabets {
    NSString *regex = @"[a-z]+";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:self];
}

-(BOOL)hasDelimiter{
    if([self hasSuffix:@" "] || [self hasSuffix:@"\n"]
       || [self hasSuffix:@"?"] || [self hasSuffix:@"!"]
       || [self hasSuffix:@"."] || [self hasSuffix:@","]){
        return YES;
    }else{
        return NO;
    }
}
-(BOOL)isDelimiter{
    if([self isEqualToString:@" "] || [self isEqualToString:@"\n"]
       || [self isEqualToString:@"?"] || [self isEqualToString:@"!"]
       || [self isEqualToString:@"."] || [self isEqualToString:@","] ){
        return YES;
    }
    else{
        return NO;
    }
}


- (BOOL) isEqualToRestrictedTagName{
    if([[self lowercaseString] isEqualToString:[NSLocalizedString(@"quick",@"quick") lowercaseString]]
     || [[self lowercaseString] isEqualToString:[NSLocalizedString(@"core words",@"core words") lowercaseString]]) {
        return YES;
    }
    return NO;
}

- (BOOL) hasAudioFileExtension {
    if([self hasSuffix:@".wav"] || [self hasSuffix:@".mp3"]){
        return YES;
    }
    return NO;
}

- (BOOL) hasImageFileExtension {

    NSString *extension = [[self pathExtension] lowercaseString];
    NSSet *validImageExtensions = [NSSet setWithObjects:@"tif", @"tiff", @"jpg", @"jpeg", @"gif", @"png", @"bmp", @"bmpf", @"ico", @"cur", @"xbm", nil];
    if([validImageExtensions containsObject:extension]){
        return YES;
    } else {
        return NO;
    }

}

-(BOOL) compareUsingUnicodeNormalizationFormC:(NSString *)aString{
    return [[self precomposedStringWithCanonicalMapping] isEqualToString:
            [aString precomposedStringWithCanonicalMapping]];
}

-(BOOL) isInPNGWhitelist{
   return YES;
}

-(BOOL)isCustomImage{
    if([self hasPrefix:@"custom_images/"]){
        return YES;
    }
    return NO;
}

-(NSNumber *)getNumber{
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * numberValue = [f numberFromString:self];
    return numberValue;
}

@end