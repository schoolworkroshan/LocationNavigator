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
//test

//test test
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    // Code to check if the app can respond to the new selector found in iOS 8. If so, request it.
        [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
     
   }

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
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


- (IBAction)Sign:(id)sender {
    [PFUser logInWithUsernameInBackground:self.userName.text password:self.password.text block:^(PFUser *user, NSError *error) {if (user) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Signed in"
                                                        message:@"Thanks"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

        NSLog(@"Successfully signed in");
    } else {
        // The login failed. Check error to see why.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot sign in"
                                                        message:@"Sorry"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }
    }];// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)signOut:(id)sender {
    [PFUser logOutInBackground];
}
@end
