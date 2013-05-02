//
//  InitialViewController.m
//  weather
//
//  Created by Adam Hayek on 5/1/13.
//  Copyright (c) 2013 Adam Hayek. All rights reserved.
//

#import "InitialViewController.h"
#import "ViewController.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //initiate sliding controller with this wiev
    
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"weather"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
