//
//  ViewController.h
//  weather
//
//  Created by Adam Hayek on 4/4/13.
//  Copyright (c) 2013 Adam Hayek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"


@interface ViewController : UIViewController

// EARTH slider
@property (strong, nonatomic) UIView *baseView;
@property (strong, nonatomic) UIImageView *baseImg;
@property (strong, nonatomic) UILabel *timeEarth;

// custom view for opening menu (only at top half of the screen)
@property (strong, nonatomic) IBOutlet UIView *menuOpenView;

// custom view that holds day buttons
@property (strong, nonatomic) IBOutlet UIView *menuView;


//icon image
@property (strong, nonatomic) IBOutlet UIImageView *icona;

//labels
@property (strong, nonatomic) IBOutlet UILabel *temperature;
@property (strong, nonatomic) IBOutlet UILabel *sum;
@property (strong, nonatomic) IBOutlet UILabel *location;
@property (strong, nonatomic) IBOutlet UILabel *wind;
@property (strong, nonatomic) IBOutlet UILabel *rain;
@property (strong, nonatomic) IBOutlet UILabel *clouds;
@property (strong, nonatomic) IBOutlet UILabel *displayTime;

//strings
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *windText;
@property (strong, nonatomic) NSString *humidityText;
@property (strong, nonatomic) NSString *cloudsText;
@property (strong, nonatomic) NSString *tempText;
@property (strong, nonatomic) NSString *sumText;
@property (nonatomic) NSInteger dayNum;
@property (nonatomic) NSInteger finalTheDay;
@property (nonatomic) NSInteger currentMidnight;

//location manager
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

//location manager functions
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;

//array
@property (strong, nonatomic) IBOutlet NSMutableArray* week;
@property (strong, nonatomic) IBOutlet NSMutableArray* daily;
@property (strong, nonatomic) IBOutlet NSArray * weekdays;
@property (strong, nonatomic) NSMutableDictionary* json;

- (IBAction)slideMenu:(id)sender;
- (IBAction)refresh:(id)sender;

//buttons
@property (strong, nonatomic) IBOutlet UIButton *showMenu;
@property (strong, nonatomic) IBOutlet UIButton *refresData;

//bolean

@property (nonatomic) BOOL *isCelsius;

//day buttons

@property (strong, nonatomic) IBOutlet UIButton *day1;
@property (strong, nonatomic) IBOutlet UIButton *day2;
@property (strong, nonatomic) IBOutlet UIButton *day3;
@property (strong, nonatomic) IBOutlet UIButton *day4;
@property (strong, nonatomic) IBOutlet UIButton *day5;
@property (strong, nonatomic) IBOutlet UIButton *day6;

//day button actions

- (IBAction)dayPressed:(id)sender;

//slider
@property (strong, nonatomic) IBOutlet UISlider *slider;

- (IBAction) sliderValueChanged:(id)sender;

@property (nonatomic) NSInteger lastSelected;

//user defaults

@property (strong, nonatomic) NSUserDefaults *defaults;

@end
