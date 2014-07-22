//
//  AvazConstants.h
//  Data
//
//  Created by nadu on 06/03/13.
//
//

#ifndef Data_AvazConstants_h
#define Data_AvazConstants_h

#define AVAZ_APP_ID NSLocalizedString(@"App Id",nil)
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#define FREE_OPTION 0
#define MONTHLY_OPTION 1
#define LIFETIME_OPTION 2
#define MAX_FREE_TRIALS 100
#define MAX_FREE_DAYS 7
#define SHOW_REMINDER_TO_UPGRADE 2
#define ONE_DAY_ACCESS_PERSON @"1-Day Full Access Person"
#define DEBUG_AVAZ 1

//#define USE_IVONA 1

#define LOG_AVAZ 1

//#ifndef USE_IVONA
//#define USE_ACAPELA 1
//#endif

#define DLog(...)

#define LIB_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Library/AvazData"]

#endif
