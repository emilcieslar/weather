//
//  MenuViewController.m
//  weather
//
//  Created by Adam Hayek on 5/1/13.
//  Copyright (c) 2013 Adam Hayek. All rights reserved.
//

#import "MenuViewController.h"
#import "ECSlidingViewController.h"

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

@end
