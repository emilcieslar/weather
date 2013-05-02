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

- (IBAction)segmentedControlIndexChanged:(id)sender;

@end
