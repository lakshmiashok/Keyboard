//
//  SettingsData.h
//  
//
//  Created by nadu on 09/07/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SettingsData : NSManagedObject

@property (nonatomic, retain) NSNumber * accessHighlightDelay;
@property (nonatomic, retain) NSNumber * audioSpeakActionKeys;
@property (nonatomic, retain) NSNumber * audioSpeakOnSelection;
@property (nonatomic, retain) NSString * audioSpeed;
@property (nonatomic, retain) NSString * audioVoice;
@property (nonatomic, retain) NSString * genStartingScreen;
@property (nonatomic, retain) NSNumber * holdTime;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * picModeAddShortcut;
@property (nonatomic, retain) NSNumber * picModeAutoHome;
@property (nonatomic, retain) NSNumber * picModeCaptionSize;
@property (nonatomic, retain) NSNumber * picModeEnlargeImage;
@property (nonatomic, retain) NSNumber * picModeMsgBox;
@property (nonatomic, retain) NSNumber * picModeMsgBoxPictures;
@property (nonatomic, retain) NSString * picModeSize;
@property (nonatomic, retain) NSString * picModeStartingParentId;
@property (nonatomic, retain) NSNumber * rearrange_on_disable;
@property (nonatomic, retain) NSNumber * releaseTime;
@property (nonatomic, retain) NSNumber * scanMode;
@property (nonatomic, retain) NSNumber * show_scroll;
@property (nonatomic, retain) NSNumber * showMorphology;
@property (nonatomic, retain) NSString * social_network;
@property (nonatomic, retain) NSString * textModeLayout;
@property (nonatomic, retain) NSNumber * textModePredictionPictures;
@property (nonatomic, retain) NSNumber * textModeQuickResponse;
@property (nonatomic, retain) NSString * textModeSize;
@property (nonatomic, retain) NSNumber * touchOrRelease;
@property (nonatomic, retain) NSNumber * textPredictionDelay;
@property (nonatomic, retain) NSNumber * colorCodeInMsgBox;

@end
