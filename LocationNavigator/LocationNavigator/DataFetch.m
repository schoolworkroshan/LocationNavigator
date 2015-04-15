//
//  DataFetch.m
//  LocationNavigator
//
//  Created by Roshan Lamichhane on 4/14/15.
//  Copyright (c) 2015 Vastika. All rights reserved.
//

#import "DataFetch.h"
#import <Parse/Parse.h>


@interface DataFetch ()

@end

@implementation DataFetch

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // [PFUser logInWithUsername:@"rosh" password:@"rosh"];
       [PFUser logOutInBackground];
}
- (IBAction)mapButton:(id)sender {
    _mapView.delegate = self;
   
}




-(void) viewDidAppear:(BOOL)animated     {
//    PFQuery *query = [PFUser query];
//    [query whereKey:@"username" equalTo:@"parivesh"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            // The find succeeded.
//            // Do something with the found objects
//            for (PFObject *object in objects) {
//                double lat;
//                double longi;
//                NSLog(@"location %@",object[@"location"]);
//                
//                //Converting the data fetched from the PFObject and converting it to the object of latitude and longitude
//                PFGeoPoint *local = object[@"location"];
//                NSLog(@"%@ is local",local);
//                lat= local.latitude;
//                longi= local.longitude;
//                CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//                CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:longi];
//                [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//                    
//                    if (error) {
//                        NSLog(@"failed with error: %@", error);
//                        return;
//                    }
//                    if(placemarks.count > 0) {
//                        
//                        
//                        CLPlacemark *placemark = [placemarks lastObject];
//                        NSLog(@"%@",placemark.addressDictionary);
//                    }
//                }];
//                NSLog(@"location is %@", object[@"location"]);
//            }
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return true;
}



- (IBAction)done:(id)sender {
    //Pushed
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:self.user.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //Changed here
            //Again
            // The find succeeded.
            // Do something with the found objects
            for (PFObject *object in objects) {
                double lat;
                double longi;
                NSLog(@"location %@",object[@"location"]);
                
                //Converting the data fetched from the PFObject and converting it to the object of latitude and longitude
                PFGeoPoint *local = object[@"location"];
                NSLog(@"%@ is local",local);
                lat= local.latitude;
                longi= local.longitude;
                CLGeocoder *geocoder = [[CLGeocoder alloc] init];
                CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:longi];
                [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
                    
                    if (error) {
                        NSLog(@"failed with error: %@", error);
                        return;
                    }
                    if(placemarks.count > 0) {
                        
                        
                        CLPlacemark *placemark = [placemarks lastObject];
                      //  NSLog(@"%@",placemark.addressDictionary);
                       // NSLog(@"%@",placemark.locality);
                        self.locality.text= placemark.locality;
                        self.zipcode.text= placemark.postalCode;
                        
                    }
                }];
                NSLog(@"location is %@", object[@"location"]);
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}
@end
