//
//  ViewController.m
//  LocationNavigator
//
//  Created by Roshan Lamichhane on 4/14/15.
//  Copyright (c) 2015 Vastika. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize location, locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    // Code to check if the app can respond to the new selector found in iOS 8. If so, request it.
        [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
     
   }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
     self.location = locations.lastObject;
    PFGeoPoint *currentLocation =  [PFGeoPoint geoPointWithLocation:self.location];
    PFUser *currentUser = [PFUser currentUser];
    [currentUser setObject:currentLocation forKey:@"location"];
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Saved location");
        }
    }];
    NSLog(@"%@",self.location);
    
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Sorry");
}
@end
