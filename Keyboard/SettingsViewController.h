//
//  SettingsViewController.h
//  Keyboard
//
//  Created by Lakshmi Ashok on 15/07/14.
//  Copyright (c) 2014 Invention. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *colourSegment;
- (IBAction)ChangeColour:(UISegmentedControl *)sender;
@end

