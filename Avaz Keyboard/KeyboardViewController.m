//
//  KeyboardViewController.m
//  Avaz Keyboard
//
//  Created by Lakshmi Ashok on 14/07/14.
//  Copyright (c) 2014 Invention. All rights reserved.
//

#import "KeyboardViewController.h"
#import "Keys.h"
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import "DataController.h"


@interface KeyboardViewController ()
//@property (nonatomic, strong) UIButton *nextKeyboardButton;
@property (nonatomic, strong)Keys *keys;
@property (nonatomic,strong)DataController *data;
@end

@implementation KeyboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Perform custom initialization work here
    }
    return self;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

/*-(void) viewWillAppear:(BOOL)animated
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"Black" forKey:@"BackgroundColour"];
    [defaults synchronize];

    NSString *colorDefaults = [defaults stringForKey: @"BackgroundColour"];
    //NSLog(@"Value of background colour is: %@",colorDefaults);
    if([colorDefaults isEqualToString:@"White"])
        self.keys.backgroundColor = [UIColor darkGrayColor];
    else if([colorDefaults isEqualToString:@"Black"])
        self.keys.backgroundColor = [UIColor blackColor];
}*/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"Lower" forKey:@"KeyCase"];
    //[defaults setObject:@"Unset" forKey:@"Shift"];
    [defaults synchronize];
    
    self.keys = [[[NSBundle mainBundle]loadNibNamed:@"Keys" owner:nil options:nil]objectAtIndex:0];
    self.data = [[DataController alloc] init];
    /*for(UIButton *key in self.keys.numericKeyboard)
    {
        CALayer *layer = [key layer];
        [layer setCornerRadius:5.0f];
    }*/
    for(UIButton *key in self.keys.keysArray)
    {
        CALayer *layer = [key layer];
        [layer setCornerRadius:5.0f];
    }
    for(UIView *views in self.keys.predictionArray)
    {
        CALayer *layer = [views layer];
        [layer setCornerRadius:5.0f];
    }
    
    self.keys.getWord.layer.cornerRadius = 5.0f;
    self.keys.getSentence.layer.cornerRadius = 5.0f;
    //self.keys.closeKey.layer.cornerRadius = 5.0f;
    self.keys.deleteKey.layer.cornerRadius = 5.0f;
    self.keys.spaceKey.layer.cornerRadius = 5.0f;
    self.keys.returnKey.layer.cornerRadius = 5.0f;
    self.keys.globeKey.layer.cornerRadius = 5.0f;
    self.keys.capsKey.layer.cornerRadius = 5.0f;
  //  self.keys.firstPunc.layer.cornerRadius = 5.0f;
  //  self.keys.secondPunc.layer.cornerRadius = 5.0f;
    
    NSString *colorDefaults = [defaults stringForKey: @"BackgroundColour"];
    if([colorDefaults isEqualToString:@"White"])
        self.keys.backgroundColor = [UIColor darkGrayColor];
    else if([colorDefaults isEqualToString:@"Black"])
        self.keys.backgroundColor = [UIColor blackColor];
    
    [self addGesturesToKeyboard];
     NSLog(@"In view did load\n");
    
    self.inputView = self.keys;
    
    // Perform custom UI setup here
    /*self.nextKeyboardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.nextKeyboardButton setTitle:NSLocalizedString(@"Next Keyboard", @"Title for 'Next Keyboard' button") forState:UIControlStateNormal];
    [self.nextKeyboardButton sizeToFit];
    self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.nextKeyboardButton addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.nextKeyboardButton];
    
    NSLayoutConstraint *nextKeyboardButtonLeftSideConstraint = [NSLayoutConstraint constraintWithItem:self.nextKeyboardButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    NSLayoutConstraint *nextKeyboardButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:self.nextKeyboardButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    [self.view addConstraints:@[nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint]];*/
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    //[self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
}

#pragma mark Keyboards

-(void)addGesturesToKeyboard{
    
    //[self.keys.closeKey addTarget:self action:"dismissKeyboard" forControlEvents:UIControlEventTouchUpInside];
    
    [self.keys.deleteKey addTarget:self action:@selector(pressDeleteKey) forControlEvents:UIControlEventTouchUpInside];
    
    [self.keys.spaceKey addTarget:self action:@selector(pressSpaceKey) forControlEvents:UIControlEventTouchUpInside];
    
    [self.keys.returnKey addTarget:self action:@selector(pressReturnKey) forControlEvents:UIControlEventTouchUpInside];
    
    [self.keys.capsKey addTarget:self action:@selector(pressCapsKey) forControlEvents:UIControlEventTouchUpInside];
    
    //Change to next keyboard
    [self.keys.globeKey addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];
    
    for(UIButton *key in self.keys.keysArray)
        [key addTarget:self action:@selector(pressKey:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.keys.getWord addTarget:self action:@selector(callRetrieveWord) forControlEvents:UIControlEventTouchUpInside];
    
    [self.keys.getSentence addTarget:self action:@selector(callRetrieveSentence) forControlEvents:UIControlEventTouchUpInside];
    
    //[self.keys.firstPunc addTarget:self action:@selector(pressFirstPunc) forControlEvents:UIControlEventTouchUpInside];
    
    //[self.keys.secondPunc addTarget:self action:@selector(pressSecondPunc) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)pressViewKey
{
    CGRect viewRect = CGRectMake(840, 214, 30, 30);
    UIView* myView= [[UIView alloc] initWithFrame:viewRect];
    [self.view addSubview:myView];
}

/*-(void) pressFirstPunc
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *caseDefaults = [defaults stringForKey: @"Shift"];
    if([caseDefaults isEqualToString:@"Set"])
    {
        [self.textDocumentProxy insertText:@"!"];
        [self.data keyPressed:@"!"];
        [defaults setObject:@"Unset" forKey:@"Shift"];
    }
    else
    {
        [self.textDocumentProxy insertText:@"."];
        [self.data keyPressed:@"."];
    }
}

-(void) pressSecondPunc
{
    [self.textDocumentProxy insertText:@","];
}*/

-(void)callRetrieveWord
{
    
    NSLog(@"Retrieved word is: %@ ",[self.data retrieveWord]);
}
-(void)callRetrieveSentence
{
    [self.data retrieveSentence];
}
-(void)pressCapsKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"Upper" forKey:@"KeyCase"];
    [defaults setObject:@"Set" forKey:@"Shift"];
    
    [defaults synchronize];

}
-(void)pressDeleteKey
{
    [self.textDocumentProxy deleteBackward];
    [self.data deletePressed];
}

-(void)pressSpaceKey
{
    [self.textDocumentProxy insertText:@" "];
    //START FROM HERE
    [self.data spacePressed];
}

-(void)pressReturnKey
{
    [self.textDocumentProxy insertText:@"\n"];
}
-(void) pressKey: (UIButton *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *caseDefaults = [defaults stringForKey: @"KeyCase"];
    

    if([caseDefaults isEqualToString:@"Upper"])
    {
        [self.textDocumentProxy insertText:[[key currentTitle]uppercaseString]];
        [defaults setObject:@"Lower" forKey:@"KeyCase"];
        [self.data keyPressed:[[key currentTitle]uppercaseString]];
    }
    
    else
    {
         [self.textDocumentProxy insertText:[[key currentTitle]lowercaseString]];
         [self.data keyPressed:[[key currentTitle]lowercaseString]];
    }
}

@end
