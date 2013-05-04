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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.addLocation) {
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    
    // addLocation set up
    self.addLocation = [[UITextField alloc] initWithFrame:CGRectMake(12, 8, 246, 28)];
    self.addLocation.font = [UIFont fontWithName:@"Proxima Nova" size:14.0];
    self.addLocation.placeholder = @"Add Location";
    [self.addLocation setValue:[UIColor colorWithHue:0.0 saturation:0.0 brightness:0.47 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [self.addLocation setBackground:[UIImage imageNamed:@"addLocation.png"]];
    self.addLocation.textColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.25 alpha:1.0];
    self.addLocation.returnKeyType = UIReturnKeyDone;
    self.addLocation.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.addLocation.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.addLocation.delegate = self;
    // Add padding to text
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 28)];
    self.addLocation.leftView = paddingView;
    self.addLocation.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.addLocation];
    
    
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

- (IBAction)addLocation:(id)sender {
}
@end
