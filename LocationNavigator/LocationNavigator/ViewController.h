//
//  ViewController.h
//  LocationNavigator
//
//  Created by Roshan Lamichhane on 4/14/15.
//  Copyright (c) 2015 Vastika. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, UITextFieldDelegate,MKMapViewDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong,atomic) NSMutableArray *locationsArray;
@property (strong, nonatomic) CLLocation *location;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)Sign:(id)sender;
- (IBAction)signOut:(id)sender;

@end

