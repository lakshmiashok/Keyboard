//
//  NSString+Additions.h
//  Data
//
//  Created by Prathab on 17/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface NSString(MD5)

- (NSString *)MD5;
- (UIImage*) getUIImage;
- (BOOL) containsOnlyAlphabets;
- (NSString *)firstCharacter;
- (BOOL) isDelimiter;
- (BOOL) hasDelimiter;
- (BOOL) isEqualToRestrictedTagName;
- (BOOL) hasAudioFileExtension;
-(BOOL) compareUsingUnicodeNormalizationFormC:(NSString *)aString;
- (BOOL) hasImageFileExtension;
-(BOOL) isInPNGWhitelist;
-(BOOL) isCustomImage;
-(NSNumber *)getNumber;

@end