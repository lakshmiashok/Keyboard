//
//  DataController.h
//  Keyboard
//
//  Created by Lakshmi Ashok on 18/07/14.
//  Copyright (c) 2014 Invention. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataController : NSObject
@property NSMutableArray *storeData;
@property NSMutableString *word;
@property NSMutableArray *sentence;
@property (nonatomic, assign)unsigned int pointer;
@property (nonatomic, assign) int lastSpace;

-(void)keyPressed : (NSString *)text;
-(void)spacePressed;
-(void)deletePressed;
-(NSString *)retrieveWord;//Change to NSString later to return the data in the array
-(void)retrieveSentence;
@end

