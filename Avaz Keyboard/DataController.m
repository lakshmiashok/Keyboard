//
//  DataController.m
//  Keyboard
//
//  Created by Lakshmi Ashok on 18/07/14.
//  Copyright (c) 2014 Invention. All rights reserved.
//

#import "DataController.h"

@implementation DataController

-(id)init
{
    self = [super init];
    self.storeData = [[NSMutableArray alloc]init];
    return self;
}
-(void)initialize
{
    self.pointer = 0;
    self.lastSpace = 0;
}
-(void)keyPressed : (NSString *)text
{
    NSLog(@"Key pressed is : %@",text);
    self.pointer++;
    [self.storeData addObject:text];
    
}
-(void)spacePressed
{
    NSLog(@"In space \n");
    self.pointer++;
    [self.storeData addObject:@" "];
}
-(void)deletePressed
{
    NSLog (@"Delete pressed\n");
    [self.storeData removeLastObject];
    self.pointer--;
}
-(NSString *)retrieveWord
{
    NSLog(@"RETRIEVING WORD\n");
    self.word = [[NSMutableString alloc]init];
    int i;
    int spacePos = -1;
    int temp = 0;
    int flag = -1;
    NSString *blank = [[NSString alloc]initWithFormat:@" "];
    temp = self.pointer-1;
    while (temp>=0)
    {
        
        NSString *character = [self.storeData objectAtIndex:temp];
        if([character isEqualToString:blank])
        {
            spacePos = temp;
            temp = -1;
            flag = 0;
        }
        else
        {
            temp --;
        }
    }
    
    if(flag==0)
    {
        for(i=spacePos+1;i<=self.pointer-1;i++)
        {
            NSString *character = [self.storeData objectAtIndex:i];
            [self.word appendFormat:@"%@",character];
        }
        NSLog(@"Last word is %@",self.word);
    }
    return self.word;
}
-(void)retrieveSentence
{
    NSLog(@"RETRIEVING SENTENCE");
    self.sentence = [[NSMutableArray alloc]init];
    int i;
    NSString *blank = [[NSString alloc]initWithFormat:@" "];
    NSMutableString *eachWord = [[NSMutableString alloc]init];
    int temp = self.pointer-1;
    for(i=0; i<=temp ; i++)
    {
        NSString *character = [self.storeData objectAtIndex:i];
        if([character isEqualToString:blank])
        {
            [self.sentence addObject:eachWord];
            [self.sentence addObject:blank];
            //[eachWord setString:@" "];
            eachWord = [[NSMutableString alloc]init];
        }
        else
        {
            [eachWord appendFormat:@"%@",character];
        }
    }
    NSString *lastChar = [self.storeData objectAtIndex:self.pointer-1];
    if(![lastChar isEqualToString:blank])
    {
        
        [self.sentence addObject:[self retrieveWord]];
    }
        
    NSLog(@"The sentence is : %@",self.sentence);
    
}

@end
