//
//  TFPCurrentLocationViewController.m
//  TheFuudProject
//
//  Created by Abbin Varghese on 22/09/16.
//  Copyright © 2016 Fuudapp. All rights reserved.
//

#import "TFPCurrentLocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "NSMutableDictionary+MLocation.h"
#import "TFPConstants.h"

@interface TFPCurrentLocationViewController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (assign, nonatomic) BOOL firstUpdate;
@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation TFPCurrentLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.geocoder = [[CLGeocoder alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)detectLocation:(id)sender {
    self.view.userInteractionEnabled = NO;
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    
    [self.locationManager requestWhenInUseAuthorization];
    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    self.view.userInteractionEnabled = YES;
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (!self.firstUpdate) {
        [self.locationManager stopUpdatingLocation];
        CLLocation *currentLocation = locations[0];
        self.firstUpdate = YES;
        [self.geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            self.view.userInteractionEnabled = YES;
            if (error == nil && [placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks lastObject];
                NSDictionary *placemarkDict = placemark.addressDictionary;
                NSMutableDictionary *loc = [NSMutableDictionary new];
                loc.locationShortName = [placemarkDict objectForKey:@"City"];
                loc.locationLatitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
                loc.locationLongitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
                NSArray * wordArray = [placemarkDict objectForKey:@"FormattedAddressLines"];
                NSString* nospacestring = [wordArray componentsJoinedByString:@", "];
                loc.locationFullName = nospacestring;
                
                [[NSUserDefaults standardUserDefaults] setObject:loc forKey:kTFPCurrentLocationKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                UITabBarController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TFPTabBarController"];
                AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                [delegate changeRootViewController:vc];
            }
        } ];
    }
}

- (IBAction)setLocationManually:(id)sender {
}

@end
