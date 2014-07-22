//
//  SettingsData+UtilityMethods.h
//  Data
//
//  Created by nadu on 15/12/12.
//
//

#import "SettingsData.h"

#define AVZ_FACEBOOK NSLocalizedString(@"Facebook", @"Facebook")
#define AVZ_TWITTER NSLocalizedString(@"Twitter", @"Twitter")
#define AVZ_EMAIL NSLocalizedString(@"Email", @"Email")
#define AVZ_NONE NSLocalizedString(@"None",@"None")


@interface SettingsData (UtilityMethods)
typedef enum {
    HighContrast = 0,
    SpeakActionKeys,
    WhatToSpeak,
    AudioSpeed,
    AudioVoice,
    StartAppWith,
    SettingsPassword,
    ColorCodeOption,
    AutoHome,
    TextCaptionSize,
    ZoomOnSelect,
    MessageBoxOn,
    PicsInMsgBox,
    PicsPerScreen,
    HomeScreen,
    RearrangeOnDisable,
    SocialMedia,
    KeyboardFormat,
    TextPredictionWithPictures,
    CaptionPosition,
    ShortcutNavFolder,
    PageUpDownKeys,
    AvazTracking
    
} SettingType;

-(BOOL) isRearrangeOnDisable;
-(BOOL) showScrollArrows;
-(BOOL) picturesInMessageBox;
-(BOOL) isMessageBoxOn;
-(BOOL) isCaptionPositionTop;
-(void) setCaptionPosition:(NSNumber *)val;
-(NSString *) folderShortcut;
-(int) colorPattern;
-(void) setSpeakAsYouType:(NSNumber *) val;
-(NSNumber *) getSpeakAsYouType;
-(BOOL) isSpeakWordsTrue;
-(BOOL) isSpeakAsYouTypeTrue;
-(BOOL) isDontSpeakAsYouTypeTrue;
@end
