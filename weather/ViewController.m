//
//  ViewController.m
//  weather
//
//  Created by Adam Hayek on 4/4/13.
//  Copyright (c) 2013 Adam Hayek. All rights reserved.
//

#import "ViewController.h"
#import "customCell.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize locationManager, currentLocation, icona, icon, week, dayNum, weekdays, finalTheDay, day6,day5,day4,day3,day2,day1, displayTime, json, daily, lastSelected, currentMidnight, humidityText,windText,cloudsText,tempText, sumText, slider;

//when app is loaded

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //setting up location manager
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = (id)self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    //update data everytime app becames active
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    day1.selected = TRUE;
    
}

//sliding menu with gestures

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Add a shadow to the top view so it looks like it is on top of the others
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 2.0f;
    self.view.layer.shadowColor = [[UIColor blackColor] CGColor];
    
    // Tell it which view should be created under left
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuView"];
    }
    
    // Add the pan gesture to allow sliding
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

//application did become active
- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    // Kick off your CLLocationManager
    //call the function to get the data and current date
    int timeNow = [self getUnixTime:[NSDate date]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int lastUpdate = [[defaults objectForKey:@"lastUpdateTime"]intValue];
    NSData *lastData = [defaults objectForKey:@"lastData"];
    NSString *lastAddress = [defaults objectForKey:@"lastAddress"];
    
    if (timeNow > lastUpdate+36000 || lastData == nil) {
        [locationManager startUpdatingLocation];
        [self getJSON];
    } else {
        NSLog(@"Your data are up to date!");
        [self fetchedData:lastData];
        if (lastAddress ==  NULL) {
            [locationManager startUpdatingLocation];
        }
        self.location.text = lastAddress;
    }
    
    [self getDate];
    
}

//get current unix time

- (int)getUnixTime:(NSDate *)date{
    int unixTime = [date timeIntervalSince1970];
    return unixTime;
}

//update location
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    //we got the location
    self.currentLocation = newLocation;
    [locationManager stopUpdatingLocation];
    [self geolocateAddress:newLocation];
    
}

//get current midnight

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}

//location manager failed
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if(error.code == kCLErrorDenied) {
        [locationManager stopUpdatingLocation];
    } else if(error.code == kCLErrorLocationUnknown) {
        // retry
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location"
                                                        message:[error description]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

//geolocate address

-(void)geolocateAddress:(CLLocation *) location{
    //get address from lat, lng
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        
        //display the current city nad state
        NSString *lastAddress = [NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.country];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:lastAddress forKey:@"lastAddress"];
        [defaults synchronize];
        
        self.location.text = lastAddress;
        
    }];
}

//getting json from weather api
- (void) getJSON
{
    
    //current lat and lng
    NSObject *latitude = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.latitude];
    NSObject *longitude = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.longitude];
    
    //send the HTTP request
    NSString *URL = [NSString stringWithFormat:@"https://api.forecast.io/forecast/c7c86b43186eb3f662a15dbc61a93d32/%@,%@", latitude, longitude];
    NSURL *fullURL = [NSURL URLWithString:URL];
    NSError *error = nil;
    NSData *dataURL = [NSData dataWithContentsOfURL:fullURL options:0 error:&error];
    
    NSNumber *currentTime = [NSNumber numberWithInt:[self getUnixTime:[NSDate date]]];
    NSDate *today = [self dateAtBeginningOfDayForDate:[NSDate date]];
    NSNumber *midnight = [NSNumber numberWithInt:[self getUnixTime:today]];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:currentTime forKey:@"lastUpdateTime"];
    [defaults setObject:midnight forKey:@"lastMidnight"];
    [defaults setObject:dataURL forKey:@"lastData"];
    [defaults synchronize];
    
    [self fetchedData:dataURL];
    
}

//parsing json
- (void)fetchedData:(NSData *)responseData {
    
    //parse forecast
    NSError* error;
    json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          options:kNilOptions
                          error:&error];
    
    week = [[json objectForKey:@"daily"] valueForKey:@"data"];
    daily = [[json objectForKey:@"hourly"] valueForKey:@"data"];
    
    [self updateData];
}

- (void)updateData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int lastUpdate = [[defaults objectForKey:@"lastUpdateTime"]intValue];
    int currentTime = [[NSNumber numberWithInt:[self getUnixTime:[NSDate date]]] integerValue]+lastSelected*3600;
    
    NSUInteger index = (currentTime - lastUpdate)/3600;
    
    if (index < 48 ) {
        
        [self displayData:&index :@"hourly"];
        
    } else {
        
        index = (index/24);
        
        [self displayData:&index :@"daily"];
    }

}

-(void)displayData:(NSUInteger *)index :(NSString *)type{
    
    if ([type isEqualToString:@"hourly"]) {
        self.icon = [[daily objectAtIndex:*index] valueForKey:@"icon"];
        tempText= [[daily objectAtIndex:*index] valueForKey:@"temperature"];
        sumText = [[daily objectAtIndex:*index] valueForKey:@"summary"];
        cloudsText = [[daily objectAtIndex:*index] valueForKey:@"cloudCover"];
        windText = [[daily objectAtIndex:*index] valueForKey:@"windSpeed"];
        humidityText = [[daily objectAtIndex:*index] valueForKey:@"humidity"];
    } else{
        self.icon = [[week objectAtIndex:*index] valueForKey:@"icon"];
        tempText= [[week objectAtIndex:*index] valueForKey:@"temperatureMax"];
        sumText = [[week objectAtIndex:*index] valueForKey:@"summary"];
        cloudsText = [[week objectAtIndex:*index] valueForKey:@"cloudCover"];
        windText = [[week objectAtIndex:*index] valueForKey:@"windSpeed"];
        humidityText = [[week objectAtIndex:*index] valueForKey:@"humidity"];
    }
    
    //convert F to C°
    NSInteger far = [tempText intValue];
    NSInteger cel = (far -32)/1.8;
    
    //convert to percents
    
    NSInteger percipPercents = [humidityText floatValue]*100;
    NSInteger cloudPercents = [cloudsText floatValue]*100;
    
    //miles per hour to metres per second
    
    float windMeters = [windText floatValue]*0.44704;
    
    //display current values
    self.temperature.text = [NSString stringWithFormat:@"%i°", cel];
    self.sum.text = [NSString stringWithFormat:@"%@", sumText];
    self.clouds.text = [NSString stringWithFormat:@"%i %%", cloudPercents];
    self.wind.text = [NSString stringWithFormat:@"%.01f m/s", windMeters];
    self.rain.text = [NSString stringWithFormat:@"%i %%", percipPercents];
    
    
    //display the right icon
    if ([self.icon isEqual: @"cloudy"] || [self.icon isEqual: @"fog"] || [self.icon isEqual: @"wind"]) {
        [self.icona setImage:[UIImage imageNamed:@"cloud.png"]];
    } else if ([self.icon isEqual: @"clear-day"]  || [self.icon isEqual: @"clear-night"]) {
        [self.icona setImage:[UIImage imageNamed:@"sun.png"]];
    } else if ([self.icon isEqual: @"rain"]) {
        [self.icona setImage:[UIImage imageNamed:@"rain.png"]];
    } else if ([self.icon isEqual: @"snow"]  || [self.icon isEqual: @"sleet"]) {
        [self.icona setImage:[UIImage imageNamed:@"snow.png"]];
    } else if ([self.icon isEqual: @"partly-cloudy-day"]  || [self.icon isEqual: @"partly-cloudy-night"]) {
        [self.icona setImage:[UIImage imageNamed:@"cloud-sun.png"]];
    }
    
}

- (void)getDate{
    // get the current date
    NSDate *date = [NSDate date];
    
    [self setSliderInit];
    
    // format it
    NSDateFormatter *dayFormat = [[NSDateFormatter alloc]init];
    [dayFormat setDateFormat:@"c"];
    
    // convert it to a string
    NSString *dayString = [dayFormat stringFromDate:date];
    dayNum = [dayString intValue];
    
    //find the days of the week
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setLocale: [NSLocale currentLocale]];
    weekdays = [df shortStandaloneWeekdaySymbols];
    
    NSMutableArray *buttonArray =  [[NSMutableArray alloc] initWithObjects:day1,day2,day3,day4,day5,day6,nil];
    
    for (int i = 0; i <= [buttonArray count]-1; i++) {
        int dayNumNew = dayNum-1+i;
        
        if (dayNumNew > 6 ) {
            dayNumNew = dayNumNew-7;
        };
        
        [[buttonArray objectAtIndex:i] setTitle:[weekdays objectAtIndex:dayNumNew] forState:UIControlStateNormal];
    }

    
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    
    float currentVal = [self.slider value];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int midnight = [[defaults objectForKey:@"lastMidnight"]intValue];
    int updated = [[defaults objectForKey:@"lastUpdateTime"]intValue];
    int displayedTime = updated+currentVal*3600;
    NSDate *displayedTimeReal = [NSDate dateWithTimeIntervalSince1970:displayedTime];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"H:mm"];
    
    NSString *theDate = [format stringFromDate:displayedTimeReal];
    
    self.displayTime.text = theDate;
    
    int currentInt = currentVal;
    
    if (currentInt != lastSelected) {
        lastSelected = currentInt;
        [self updateData];
    }
    
    
    day1.selected = FALSE;
    day2.selected = FALSE;
    day3.selected = FALSE;
    day4.selected = FALSE;
    day5.selected = FALSE;
    day6.selected = FALSE;
    
    if(displayedTime > midnight+(5*24*3600)) {
        day6.selected = TRUE;
    } else if(displayedTime > midnight+(4*24*3600)) {
        day5.selected = TRUE;
    } else if(displayedTime > midnight+(3*24*3600)) {
        day4.selected = TRUE;
    } else if(displayedTime > midnight+(48*3600)) {
        day3.selected = TRUE;
    } else if (displayedTime > midnight+(24*3600)) {
        day2.selected = TRUE;
    } else{
        day1.selected = TRUE;
    }
    
   
    
}

- (IBAction)slideMenu:(id)sender {
      [self.slidingViewController anchorTopViewTo:ECRight];
}

-(void)setSliderInit{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    float updated = [[defaults objectForKey:@"lastUpdateTime"]floatValue];
    
    float currentTime = [[NSNumber numberWithInt:[self getUnixTime:[NSDate date]]]floatValue];
    
    float intialValue = (522000-(522000-(currentTime-updated)))/3600;
    
    self.slider.value = intialValue;
    [self sliderValueChanged:slider];
}

- (IBAction)refresh:(id)sender {
    // Kick off your CLLocationManager
    [locationManager startUpdatingLocation];
    //call the function to get the data and current date
    [self getJSON];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dayPressed:(id)sender {
    float x = 0;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    float midnight = [[defaults objectForKey:@"lastMidnight"]intValue];
    float updated = [[defaults objectForKey:@"lastUpdateTime"]intValue];
    
    if (sender == day1) {
        x = 0;
    } else if (sender == day2) {
        x = 1;
    } else if (sender == day3) {
        x = 2;
    } else if (sender == day4) {
        x = 3;
    } else if (sender == day5) {
        x = 4;
    } else if (sender == day6) {
        x = 5;
    }
    
    self.slider.value = ((midnight + (12+x*24)*3600)-updated)/3600;
    [self sliderValueChanged:slider];
}

@end
