//
//  MenuViewController.m
//  weather
//
//  Created by Adam Hayek on 5/1/13.
//  Copyright (c) 2013 Adam Hayek. All rights reserved.
//

#import "MenuViewController.h"

@implementation MenuViewController

@synthesize unitSwitch;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *isCelsiusTrue = [defaults objectForKey:@"celsius"];
    
    if ([isCelsiusTrue isEqualToString:@"true"]) {
        unitSwitch.selectedSegmentIndex = 0;
    } else {
        unitSwitch.selectedSegmentIndex = 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (IBAction)segmentedControlIndexChanged:(id)sender{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *isCelsiusTrue = [defaults objectForKey:@"celsius"];
    
    switch (self.unitSwitch.selectedSegmentIndex) {
        case 0:
            isCelsiusTrue = @"true";
            break;
        case 1:
            isCelsiusTrue = @"false";
            break;
        default:
            break;
            
    }
    
    [defaults setObject:isCelsiusTrue forKey:@"celsius"];
    [defaults synchronize];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dealNotification" object: nil];
}

@end
