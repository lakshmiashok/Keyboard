//
//  SettingsViewController.m
//  Keyboard
//
//  Created by Lakshmi Ashok on 15/07/14.
//  Copyright (c) 2014 Invention. All rights reserved.
//

#import "SettingsViewController.h"
#import "Keys.h"
@interface SettingsViewController ()
@property (nonatomic, strong)Keys *keys;
@end

@implementation SettingsViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"Black" forKey:@"BackgroundColour"];
    [defaults synchronize];
    
    NSString *colorDefaults = [defaults stringForKey: @"BackgroundColour"];
    if([colorDefaults isEqualToString:@"White"])
        self.keys.backgroundColor = [UIColor darkGrayColor];
    else if([colorDefaults isEqualToString:@"Black"])
        self.keys.backgroundColor = [UIColor blackColor];
}

- (void)viewDidLoad
{    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    /*NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"White" forKey:@"BackgroundColour"];
    [defaults synchronize];*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)ChangeColour:(UISegmentedControl *)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(self.colourSegment.selectedSegmentIndex == 0)
    {
        [defaults setObject:@"White" forKey:@"BackgroundColour"];
    }
    else if (self.colourSegment.selectedSegmentIndex == 1)
    {
        [defaults setObject:@"Black" forKey:@"BackgroundColour"];
    }
    
    [defaults synchronize];
}
@end
