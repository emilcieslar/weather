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

@interface MenuViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISegmentedControl *unitSwitch;
@property (strong, nonatomic) IBOutlet UIButton *addLocationButton;
@property (strong, nonatomic) IBOutlet UITableView *locationsTable;
- (IBAction)segmentedControlIndexChanged:(id)sender;
- (IBAction)addLocation:(id)sender;
@end
