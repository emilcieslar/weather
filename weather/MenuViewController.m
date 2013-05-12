//
//  MenuViewController.m
//  weather
//
//  Created by Adam Hayek on 5/1/13.
//  Copyright (c) 2013 Adam Hayek. All rights reserved.
//

#import "MenuViewController.h"

@implementation MenuViewController

@synthesize locationData;

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
    // Add it to view
    [self.view addSubview:self.addLocation];
    
    // unitSwitchP set up
    self.unitSwitchP = [[UISegmentedControl alloc] initWithItems:@[@"",@""]];
    self.unitSwitchP.frame = CGRectMake(185, self.view.frame.size.height-11-26, 69, 26);
    [self.unitSwitchP setBackgroundImage:[UIImage imageNamed:@"unitSwitchNormal.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.unitSwitchP setBackgroundImage:[UIImage imageNamed:@"unitSwitchSelected.png"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self.unitSwitchP setDividerImage:[UIImage imageNamed:@"unitSwitchRight.png"]
                  forLeftSegmentState:UIControlStateNormal
                    rightSegmentState:UIControlStateSelected
                           barMetrics:UIBarMetricsDefault];
    [self.unitSwitchP setDividerImage:[UIImage imageNamed:@"unitSwitchLeft.png"]
                  forLeftSegmentState:UIControlStateSelected
                    rightSegmentState:UIControlStateNormal
                           barMetrics:UIBarMetricsDefault];
    // Add target for action
    [self.unitSwitchP addTarget:self action:@selector(unitSwitchChanged:) forControlEvents: UIControlEventValueChanged];
    // Add it to view
    [self.view addSubview:self.unitSwitchP];
    
    
    // Set defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *isCelsiusTrue = [defaults objectForKey:@"celsius"];
    
    if ([isCelsiusTrue isEqualToString:@"true"]) {
        self.unitSwitchP.selectedSegmentIndex = 0;
    } else {
        self.unitSwitchP.selectedSegmentIndex = 1;
    }
    
    //add something to the array
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"PLIST_locations.plist"];
	
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]){
		locationData = [NSMutableArray arrayWithContentsOfFile: plistPath];
        NSLog(@"it loaded saved data from plist");
	} else {
		locationData = [[NSMutableArray alloc] init];
        
        NSMutableDictionary *current = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Current location",@"location", @"49.229257", @"lat", @"17.663269", @"lng", nil];
        
        NSMutableDictionary *location = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Praha, Czech republic",@"location", @"50.068599", @"lat", @"14.438782", @"lng", nil];
        
        [locationData addObject:current];
        [locationData addObject:location];
        
	}
    
    [self writeLocationsToFile];
    
}

- (void)writeLocationsToFile {
	
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"PLIST_locations.plist"];
	
	[locationData writeToFile:plistPath atomically:YES];
	
	NSLog(@"[INFO] PLIST: Document was written to disk!");
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [locationData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"customCell";
    
    customCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"customCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // Configure the cell...
    cell.locationLabel.text = [[locationData objectAtIndex:indexPath.row] objectForKey:@"location"];
    
    return cell;
}

//select location

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *indexNumber = [NSString stringWithFormat:@"%i",indexPath.row];
    [defaults setObject:indexNumber forKey:@"selectedLocation"];
    
    [self.slidingViewController resetTopView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"locationNotification" object: nil];
    
}

// unitSwitch changed action
- (IBAction)unitSwitchChanged:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *isCelsiusTrue = [defaults objectForKey:@"celsius"];
    
    switch (self.unitSwitchP.selectedSegmentIndex) {
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
