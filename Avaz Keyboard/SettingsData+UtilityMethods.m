//
//  SettingsData+UtilityMethods.m
//  Data
//
//  Created by nadu on 15/12/12.
//
//

#import "SettingsData+UtilityMethods.h"

@implementation SettingsData (UtilityMethods)

-(BOOL) isRearrangeOnDisable {
    return NO;
    //return  [[self rearrange_on_disable] boolValue];
}

-(BOOL) showScrollArrows{
    return  [[self show_scroll] boolValue];
}

-(BOOL) picturesInMessageBox{
    DLog(@"Pictures in message box %@", [self picModeMsgBoxPictures]);
    return  [[self picModeMsgBoxPictures] boolValue];
}

-(BOOL) isMessageBoxOn{
    return  [[self picModeMsgBox] boolValue];
}

-(BOOL) isCaptionPositionTop{
    //return YES;
    return ![[self textModeQuickResponse] boolValue];
}

-(void) setCaptionPosition:(NSNumber *)val{
    //return YES;
    [self setTextModeQuickResponse:val];
}

-(NSString *) folderShortcut{
    return [self textModeSize];
}

-(int) colorPattern {
    return [[self picModeAddShortcut] intValue];
}

-(void) setSpeakAsYouType:(NSNumber *) val {
     [self setAudioSpeakOnSelection:val];
}

-(NSNumber *) getSpeakAsYouType{
    return [self audioSpeakOnSelection];
}

-(BOOL) isSpeakWordsTrue{
    return ([self audioSpeakOnSelection] == [NSNumber numberWithInt:2]);
}

-(BOOL) isSpeakAsYouTypeTrue{
    return ([self audioSpeakOnSelection] == [NSNumber numberWithInt:1]);
}

-(BOOL) isDontSpeakAsYouTypeTrue{
    return ([self audioSpeakOnSelection] == [NSNumber numberWithInt:0]);
}

@end
