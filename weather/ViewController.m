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

@synthesize locationManager, currentLocation, icona, icon, week, dayNum, weekdays, finalTheDay, day6,day5,day4,day3,day2,day1, displayTime, json, daily, lastSelected, currentMidnight, humidityText,windText,cloudsText,tempText, sumText, slider, defaults;

//when app is loaded

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* ######################################################## SETTING UP EARTH SLIDER ################################################ */
    
    // Add earth
    //UIImageView *earth = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 264, 155)];
    self.earth = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 225, 132)];
    [self.earth setCenter:CGPointMake(160, 329)];
    //[earth setImage: [UIImage imageNamed:@"earth.png"]];
    [self.earth setImage: [UIImage imageNamed:@"earth-around1.png"]];
    [self.view addSubview:self.earth];
    
    // Init baseView (UIView)
    self.baseView = [[UIView alloc] init];
    //[self.baseView setFrame:CGRectMake(0, 0, 34, 304)];
    [self.baseView setFrame:CGRectMake(0, 0, 30, 258)];
    [self.baseView setCenter: CGPointMake(160,373)];
    //[baseView setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [self.view addSubview:self.baseView];
    
    // Add sun to baseView
    //UIImageView *baseImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 34, 152)];
    self.baseImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 129)];
    //[baseImg setImage: [UIImage imageNamed:[NSString stringWithFormat:@"sun.png"]]];
    [self.baseImg setImage: [UIImage imageNamed:[NSString stringWithFormat:@"sun1.png"]]];
    [self.baseView addSubview:self.baseImg];
    self.baseImg.userInteractionEnabled = YES;
    // Add gesture recognizer
    UIPanGestureRecognizer *sunRecog = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTouchSun:)];
    sunRecog.delegate = self;
    [self.baseImg addGestureRecognizer:sunRecog];
    
    // Add moon to baseView
    self.baseMoon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 129, 30, 129)];
    [self.baseMoon setImage: [UIImage imageNamed:[NSString stringWithFormat:@"moon.png"]]];
    [self.baseView addSubview:self.baseMoon];
    self.baseMoon.userInteractionEnabled = YES;
    // Add gesture recognizer
    UIPanGestureRecognizer *moonRecog = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTouchMoon:)];
    moonRecog.delegate = self;
    [self.baseMoon addGestureRecognizer:moonRecog];
    
    // Add hideView (UIView)
    self.hideView = [[UIView alloc] init];
    [self.hideView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-373)];
    [self.hideView setCenter: CGPointMake(160,(self.view.frame.size.height-373)/2+373)];
    [self.hideView setBackgroundColor:[UIColor colorWithHue:0 saturation:0 brightness:0.09 alpha:1]];
    [self.view addSubview:self.hideView];
    
    // Add label to baseView
    /*UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
     time.center = CGPointMake(20, -12);
     time.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
     time.textColor = [UIColor colorWithWhite:1 alpha:1];
     time.text = @"10:00";
     [self.baseView addSubview:time];*/
    
    // Add actual earth
    //UIImageView *earthAlone = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 264, 155)];
    self.earthAlone = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 225, 132)];
    [self.earthAlone setCenter:CGPointMake(160, 329)];
    //[earthAlone setImage: [UIImage imageNamed:@"earth-alone.png"]];
    [self.earthAlone setImage: [UIImage imageNamed:@"earth-without1.png"]];
    [self.view addSubview:self.earthAlone];
    
    float targetRotation = -83.0;
    self.baseView.transform = CGAffineTransformMakeRotation(targetRotation / 180.0 * M_PI);
    
    /* ####################################################### END SETTING UP EARTH SLIDER ############################################## */
    
	// setting up day buttons width
    int rectX = 0;
    CGRect buttonFrame1 = CGRectMake(rectX,0,53,50);
    CGRect buttonFrame2 = CGRectMake(rectX+53,0,53,50);
    CGRect buttonFrame3 = CGRectMake(rectX+53*2,0,53,50);
    CGRect buttonFrame4 = CGRectMake(rectX+53*3,0,53,50);
    CGRect buttonFrame5 = CGRectMake(rectX+53*4,0,53,50);
    CGRect buttonFrame6 = CGRectMake(rectX+53*5,0,53,50);

    [day1 setFrame:buttonFrame1];
    [day2 setFrame:buttonFrame2];
    [day3 setFrame:buttonFrame3];
    [day4 setFrame:buttonFrame4];
    [day5 setFrame:buttonFrame5];
    [day6 setFrame:buttonFrame6];
    
    //z-index of view that holds all the buttons goes to the top (because UIView for sun overlaps it and you can't tap day that overlaps it)
    [self.view insertSubview:self.menuView atIndex:100];
    
    //setting up location manager
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = (id)self;
    locationManager.distanceFilter = 1000.0f;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    //update data everytime app becames active
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    //update data if users chooses °C or °F
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(updateData) name:@"dealNotification" object: nil];
    
    //init user defaults
    defaults = [NSUserDefaults standardUserDefaults];
    
}

//sliding menu with gestures

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Add a shadow to the top view so it looks like it is on top of the others
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 0.0f;
    self.view.layer.shadowOffset = CGSizeMake(-4.0, 4.0);
    self.view.layer.shadowColor = [[UIColor blackColor] CGColor];
    
    // Tell it which view should be created under left
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuView"];
    }
    
    // Add the pan gesture to allow sliding
    [self.menuOpenView addGestureRecognizer:self.slidingViewController.panGesture];
}

//application did become active
- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    //call the function to get the data and current date
    int timeNow = [self getUnixTime:[NSDate date]];
    
    int lastUpdate = [[defaults objectForKey:@"lastUpdateTime"]intValue];
    NSData *lastData = [defaults objectForKey:@"lastData"];
    
    NSDate *lastUpdateDate = [NSDate dateWithTimeIntervalSince1970:lastUpdate];
    //display days in buttons
    [self getDate:lastUpdateDate];
    
    NSString *lastAddress = [defaults objectForKey:@"lastAddress"];
    
    if (timeNow > lastUpdate+36000 || lastData == nil) {
        [locationManager startUpdatingLocation];
    } else {
        NSLog(@"Your data are up to date!");
        [self fetchedData:lastData];
        if (lastAddress ==  NULL) {
            [locationManager startUpdatingLocation];
        }
        self.location.text = lastAddress;
    }
    
}

//get current unix time

- (int)getUnixTime:(NSDate *)date{
    int unixTime = [date timeIntervalSince1970];
    return unixTime;
}

//update location
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    //we got the location
    [locationManager stopUpdatingLocation];
    self.currentLocation = newLocation;
    [self geolocateAddress:newLocation];
    //NSLog(@"updated");
    [self getJSON];
    
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

    [defaults setObject:currentTime forKey:@"lastUpdateTime"];
    [defaults setObject:midnight forKey:@"lastMidnight"];
    [defaults setObject:dataURL forKey:@"lastData"];
    [defaults synchronize];
    
    NSLog(@"Loaded new data");
    
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
    
    
    // Get sunRise and sunSet
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"H"];
    int sunRise;
    int sunSet;
    NSDate *sunRiseReal;
    NSDate *sunSetReal;
    int sunRiseFin;
    int sunSetFin;
    self.eachDay = [[NSMutableArray alloc] init];
        
    for(int i=0;i<6;i++) {
        sunRise = [[[week objectAtIndex:i] valueForKey:@"sunriseTime"] intValue];
        sunRiseReal = [NSDate dateWithTimeIntervalSince1970:sunRise];
        sunRiseFin = [[format stringFromDate:sunRiseReal] intValue];
        sunSet = [[[week objectAtIndex:i] valueForKey:@"sunsetTime"] intValue];
        sunSetReal = [NSDate dateWithTimeIntervalSince1970:sunSet];
        sunSetFin = [[format stringFromDate:sunSetReal] intValue];
        //NSLog(@"sunRise: %i",sunRiseFin);
        //NSLog(@"sunSet: %i",sunSetFin);
        self.dayLong = sunSetFin-sunRiseFin;
        //NSLog(@"dayLong: %i",self.dayLong);
        for(int j=0;j<24;j++) {
            if(sunRiseFin+j <= 24) {
                [self.eachDay addObject:[NSNumber numberWithInt:sunRiseFin+j]];
                //NSLog(@"eachDay: %@",[self.eachDay objectAtIndex:j]);
            } else {
                [self.eachDay addObject:[NSNumber numberWithInt:sunRiseFin+j-24]];
                //NSLog(@"eachDay: %@",[self.eachDay objectAtIndex:j]);
            }
        }
    }
    
    [self updateData];
}

- (void)updateData{
    int lastUpdate = [[defaults objectForKey:@"lastUpdateTime"]intValue];
    int currentTime = [[NSNumber numberWithInt:[self getUnixTime:[NSDate date]]] integerValue]+lastSelected*3600;
    
    NSUInteger index = (currentTime - lastUpdate)/3600;
    
    // Get last update to set time for earth controller
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"H"];
    NSDate *lastUpdateReal = [NSDate dateWithTimeIntervalSince1970:lastUpdate];
    int lastUpdateFin = [[format stringFromDate:lastUpdateReal] intValue];
    NSLog(@"lastUpdate: %i",lastUpdateFin);
    
    if (index < 48 ) {
        
        [self displayData:&index :@"hourly"];
        
    } else {
        
        index = (index/24);
        
        [self displayData:&index :@"daily"];
    }
    
    // initialize the earth controller to its basic position depending on day 0 long
    [self earthControllerInit];

}

- (void)displayData:(NSUInteger *)index :(NSString *)type{
    //set values for hourly or daily forecast
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
    
    //convert to percents
    
    NSInteger percipPercents = [humidityText floatValue]*100;
    NSInteger cloudPercents = [cloudsText floatValue]*100;
    
    //miles per hour to metres per second
    
    float windMeters = [windText floatValue]*0.44704;
    
    //display current values
    NSString *isCelsiusTrue = [defaults objectForKey:@"celsius"];
    if ([isCelsiusTrue isEqualToString:@"true"]) {
        //convert F to C°
        NSInteger far = [tempText intValue];
        NSInteger cel = (far -32)/1.8;
        self.temperature.text = [NSString stringWithFormat:@"%i°", cel];
    } else {
        self.temperature.text = [NSString stringWithFormat:@"%i°", [tempText integerValue]];
    }
    self.sum.text = [NSString stringWithFormat:@"%@", sumText];
    self.clouds.text = [NSString stringWithFormat:@"%i %%", cloudPercents];
    self.wind.text = [NSString stringWithFormat:@"%.01f m/s", windMeters];
    self.rain.text = [NSString stringWithFormat:@"%i %%", percipPercents];
    
    //display the right icon
    if ([self.icon isEqual: @"cloudy"]) {
        [self.icona setImage:[UIImage imageNamed:@"cloudy.png"]];
    } else if([self.icon isEqual: @"fog"]){
        [self.icona setImage:[UIImage imageNamed:@"fog.png"]];
    } else if([self.icon isEqual: @"wind"]){
        [self.icona setImage:[UIImage imageNamed:@"wind.png"]];
    } else if ([self.icon isEqual: @"clear-day"]) {
        [self.icona setImage:[UIImage imageNamed:@"clear.png"]];
    } else if([self.icon isEqual: @"clear-night"]){
        [self.icona setImage:[UIImage imageNamed:@"clear-night.png"]];
    } else if ([self.icon isEqual: @"rain"]) {
        [self.icona setImage:[UIImage imageNamed:@"rain.png"]];
    } else if ([self.icon isEqual: @"snow"]) {
        [self.icona setImage:[UIImage imageNamed:@"snow.png"]];
    } else if([self.icon isEqual: @"sleet"]){
        [self.icona setImage:[UIImage imageNamed:@"sleet.png"]];
    } else if ([self.icon isEqual: @"partly-cloudy-day"]) {
        [self.icona setImage:[UIImage imageNamed:@"partly-cloudy-day.png"]];
    } else if ([self.icon isEqual: @"partly-cloudy-night"]){
        [self.icona setImage:[UIImage imageNamed:@"partly-cloudy-night.png"]];
    } else if ([self.icon isEqual: @"tornado"]){
        [self.icona setImage:[UIImage imageNamed:@"tornado.png"]];
    } else if ([self.icon isEqual: @"hail"]){
        [self.icona setImage:[UIImage imageNamed:@"hail.png"]];
    } else if ([self.icon isEqual: @"thunderstorm"]){
        [self.icona setImage:[UIImage imageNamed:@"storm.png"]];
    }
    
}

- (void)getDate:(NSDate *)date{
    
    [self setSliderInit];
    
    // format it
    NSDateFormatter *dayFormat = [[NSDateFormatter alloc]init];
    [dayFormat setDateFormat:@"c"];
    
    [dayFormat setDateFormat:@"EEE"];
    NSString *dayOfWeek = [dayFormat stringFromDate:date];
    
    //find the days of the week
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    weekdays = [df shortStandaloneWeekdaySymbols];
    
    //check current day number
    int count = 0;
    while (![dayOfWeek isEqualToString:[weekdays objectAtIndex:count]]) {
        dayNum = count;
        count++;
    }
    
    //set day buttons titles
    NSMutableArray *buttonArray =  [[NSMutableArray alloc] initWithObjects:day1,day2,day3,day4,day5,day6,nil];
    
    for (int i = 0; i <= [buttonArray count]-1; i++) {
        int dayNumNew = dayNum+i;
        
        if (dayNumNew > 6 ) {
            dayNumNew = dayNumNew-7;
        };
        
        [[buttonArray objectAtIndex:i] setTitle:[weekdays objectAtIndex:dayNumNew] forState:UIControlStateNormal];
    }
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    
    //[self.slider setValue:self.dayPart+self.whichDay];
    float currentVal = [self.slider value];
    int midnight = [[defaults objectForKey:@"lastMidnight"]intValue];
    int updated = [[defaults objectForKey:@"lastUpdateTime"]intValue];
    int displayedTime = updated+currentVal*3600;
    NSDate *displayedTimeReal = [NSDate dateWithTimeIntervalSince1970:displayedTime];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    //[format setDateFormat:@"H:mm"];
    [format setDateFormat:@"h a"];
    
    NSString *theDate = [format stringFromDate:displayedTimeReal];
    
    self.timeEarth.text = theDate;
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
    
    float updated = [[defaults objectForKey:@"lastUpdateTime"]floatValue];
    
    float currentTime = [[NSNumber numberWithInt:[self getUnixTime:[NSDate date]]]floatValue];
    
    float intialValue = (522000-(522000-(currentTime-updated)))/3600;
    
    self.slider.value = intialValue;
    [self sliderValueChanged:slider];
}

- (IBAction)refresh:(id)sender {
    // Kick off your CLLocationManager
    [locationManager startUpdatingLocation];
    
    NSLog(@"Refresh tapped!");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dayPressed:(id)sender {
    float x = 0;
    
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


/* ###################################################################### EARTH CONTROLLER STUFF ################################################ */

// Set variables for day count
int day = 0;
bool daySet = NO;

// Set variables for day time
int sunRiseFin;
int sunSetFin;
int currentTimeFin;
int dayLong;
int nightLong;
bool isDayOrNight;
float day0AngleBack;

- (void)earthControllerInit
{
    // Get sunRise and sunSet
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"H"];
    int sunRise;
    int sunSet;
    int currentTime;
    NSDate *sunRiseReal;
    NSDate *sunSetReal;
    NSDate *currentTimeReal;
    
    //int updatedLast = [[defaults objectForKey:@"lastUpdateTime"] intValue];
    currentTime = [[NSNumber numberWithInt:[self getUnixTime:[NSDate date]]] intValue];
    currentTimeReal = [NSDate dateWithTimeIntervalSince1970:currentTime];
    currentTimeFin = [[format stringFromDate:currentTimeReal] intValue];
    NSLog(@"currentTime: %i",currentTimeFin);

    sunRise = [[[week objectAtIndex:0] valueForKey:@"sunriseTime"] intValue];
    sunRiseReal = [NSDate dateWithTimeIntervalSince1970:sunRise];
    sunRiseFin = [[format stringFromDate:sunRiseReal] intValue];
    sunSet = [[[week objectAtIndex:0] valueForKey:@"sunsetTime"] intValue];
    sunSetReal = [NSDate dateWithTimeIntervalSince1970:sunSet];
    sunSetFin = [[format stringFromDate:sunSetReal] intValue];
    NSLog(@"sunRise: %i",sunRiseFin);
    NSLog(@"sunSet: %i",sunSetFin);
    dayLong = sunSetFin-sunRiseFin;
    nightLong = 24 - dayLong;
    NSLog(@"dayLong: %i, nightLong: %i",dayLong,nightLong);
    
    // Is it night or day?
    if(currentTimeFin > sunRiseFin && currentTimeFin < sunSetFin) {
        NSLog(@"It's daytime! = YES");
        isDayOrNight = YES;
        [self setAngleForEarthControllerForLong:dayLong withAngleMultiple:currentTimeFin-sunRiseFin];
    } else {
        NSLog(@"It's nighttime! = NO");
        isDayOrNight = NO;
        if(currentTimeFin >= 0 && currentTimeFin <= sunRiseFin) {
            [self setAngleForEarthControllerForLong:nightLong withAngleMultiple:currentTimeFin-sunSetFin+24];
        } else {
            [self setAngleForEarthControllerForLong:nightLong withAngleMultiple:currentTimeFin-sunSetFin];
        }
    }
}

- (void)setAngleForEarthControllerForLong:(int)dayNightLong withAngleMultiple:(int)angMult
{
    float divAngle = (-defAngle*2)/dayNightLong;
    if(isDayOrNight) {
        day0AngleBack = defAngle+divAngle*angMult;
        self.baseView.transform = CGAffineTransformMakeRotation(day0AngleBack);
    } else {
        day0AngleBack = defAngle+divAngle*angMult+(-defAngle)*2;
        self.baseView.transform = CGAffineTransformMakeRotation(day0AngleBack);
    }
    NSLog(@"angMult: %i, divAngle*angMult: %f, divAngle: %f",angMult,day0AngleBack,divAngle);
    
}

- (void)getAngleAndSetTimeWithAngle:(float)angle
{
    if(day == 0) {

    } else if(day == 1) {
    
    } else if(day == 2) {
        
    } else if(day == 3) {
        
    }
}

- (void)handleTouchSun:(UIPanGestureRecognizer *)recognizer
{
    recognizer.cancelsTouchesInView=NO;
    CGPoint location = [recognizer locationInView:self.view];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
        {   // Here goes stuff when you moving
            CGPoint center = CGPointMake(160.0f, 373.0f);
            float angle = AngleBetweenThreePoints(center, CGPointMake(160.0f, 220.0f), location);
            // Rotate baseView which holds Sun and Moon
            // If we're at starting point, we cannot go back than what's the current time
            if(day == 0) {
                if(!(angle < day0AngleBack && angle > defAngle)) {
                    self.baseView.transform = CGAffineTransformMakeRotation(angle);
                } else {
                    self.baseView.transform = CGAffineTransformMakeRotation(day0AngleBack);
                }
            } else {
                self.baseView.transform = CGAffineTransformMakeRotation(angle);
            }
            // counts up days (YES = sun is up)
            [self daySet:YES withAngle:angle];
        }
            break;
        case UIGestureRecognizerStateEnded:
            break;
        default:
            break;
    }
    
}

- (void)handleTouchMoon:(UIPanGestureRecognizer *)recognizer
{
    recognizer.cancelsTouchesInView=NO;
    CGPoint location = [recognizer locationInView:self.view];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
        {   // Here goes stuff when you moving
            CGPoint center = CGPointMake(160.0f, 373.0f);
            float angle = AngleBetweenThreePoints(center, CGPointMake(160.0f, 526.0f), location);
            // Rotate baseView which holds Sun and Moon
            // If we're at starting point, we cannot go back than what's the current time
            if(day == 0) {
                if(!(angle < day0AngleBack && angle > defAngle)) {
                    self.baseView.transform = CGAffineTransformMakeRotation(angle);
                } else {
                    self.baseView.transform = CGAffineTransformMakeRotation(day0AngleBack);
                }
            } else {
                self.baseView.transform = CGAffineTransformMakeRotation(angle);
            }
            // counts up days (NO = moon is up)
            [self daySet:NO withAngle:angle];
        }
            break;
        case UIGestureRecognizerStateEnded:
            break;
        default:
            break;
    }
}

// Get the angle
double AngleBetweenThreePoints(CGPoint point1,CGPoint point2, CGPoint point3)
{
    CGPoint p1 = CGPointMake(point2.x - point1.x, -1*point2.y - point1.y *-1);
    CGPoint p2 = CGPointMake(point3.x -point1.x, -1*point3.y -point1.y*-1);
    double angle = atan2(p2.x*p1.y-p1.x*p2.x,p1.y*p2.y);
    return angle;
}

// Set variables for defining if you go forth or back
bool goesBack = NO;
bool startAngleSet = NO;
float startAngle;
float nextAngle;

CGPoint touchStart;

// Degrees to radians definition
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)
// Default angle (around 1.57)
float defAngle = DEGREES_TO_RADIANS(-90);

// Touches began method
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    
    CGPoint center = CGPointMake(160.0f, 373.0f);
    float xLeg = (center.x - touchPoint.x);
    float yLeg = (center.y - touchPoint.y);
    float angle = -atan(xLeg / yLeg);
    //NSLog(@"angle: %f",angle);
    startAngle = angle;
    touchStart = touchPoint;
}

// Touches moved method
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    
    CGPoint center = CGPointMake(160.0f, 373.0f);
    float angle = AngleBetweenThreePoints(center, CGPointMake(160.0f, 220.0f), touchPoint);
    
    // If it goes back in time or forward in time
    if(startAngleSet) {
        nextAngle = angle;
        startAngleSet = NO;
        if(startAngle < nextAngle) {
            goesBack = NO;
        } else {
            goesBack = YES;
        }
    } else {
        startAngle = angle;
        startAngleSet = YES;
    }
    
}

// Counts days if sun is up or moon is up
- (void)daySet:(bool)sun withAngle:(float)angle
{
    [self getAngleAndSetTimeWithAngle:angle];
    NSLog(@"day: %i, daySet: %d, angle: %f",day,daySet, angle);
    if(angle <= -1.45 && angle >= defAngle) {
        if(!daySet) {
            if(goesBack) {
                if(day > 0) {
                    day--;
                    daySet = YES;
                }
            } else {
                if(day < 6) {
                    day++;
                    daySet = YES;
                }
            }
        }
    } else {
        daySet = NO;
    }
}

/* ###################################################################### END END EARTH CONTROLLER STUFF ################################################ */

@end


