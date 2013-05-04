//
//  MenuViewController.h
//  weather
//
//  Created by Adam Hayek on 5/1/13.
//  Copyright (c) 2013 Adam Hayek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "ECSlidingViewController.h"

@interface MenuViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *locationsTable;

// addLocation
@property (strong, nonatomic) IBOutlet UITextField *addLocation;
// unitSwitchP
@property (strong, nonatomic) IBOutlet UISegmentedControl *unitSwitchP;
// unitSwitchP action
- (IBAction)unitSwitchChanged:(id)sender;

@end
