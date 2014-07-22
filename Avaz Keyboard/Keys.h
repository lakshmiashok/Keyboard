//
//  Keys.h
//  Keyboard
//
//  Created by Lakshmi Ashok on 14/07/14.
//  Copyright (c) 2014 Invention. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Keys : UIView

@property (weak, nonatomic) IBOutlet UIButton *getWord;
@property (weak, nonatomic) IBOutlet UIButton *getSentence;
@property (weak, nonatomic) IBOutlet UIButton *spaceKey;
//@property (weak, nonatomic) IBOutlet UIButton *closeKey;
@property (weak, nonatomic) IBOutlet UIButton *globeKey;
@property (weak, nonatomic) IBOutlet UIButton *returnKey;
@property (weak, nonatomic) IBOutlet UIButton *capsKey;
@property (weak, nonatomic) IBOutlet UIButton *deleteKey;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *keysArray;
//@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *predictionArray;
//@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *numericKeyboard;
@property (weak, nonatomic) IBOutlet UIButton *firstPunc;
@property (weak, nonatomic) IBOutlet UIButton *secondPunc;

@end
