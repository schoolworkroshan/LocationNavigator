//
//  DataFetch.m
//  LocationNavigator
//
//  Created by Roshan Lamichhane on 4/14/15.
//  Copyright (c) 2015 Vastika. All rights reserved.
//
////stationary user

#import "DataFetch.h"
#import <Parse/Parse.h>


@interface DataFetch () <MKMapViewDelegate> {
    MKPolyline *_routeOverlay;
    MKRoute *_currentRoute;


    double lat;
    double longi;
    
}

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
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = YES;
    [_mapView setMapType: MKMapTypeStandard];
    CLLocationDistance distance = 800;
    CLLocationCoordinate2D myCoordinate;
    myCoordinate.latitude = lat;
    myCoordinate.longitude = longi;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(myCoordinate,
                                                                   distance,
                                                                   distance);
    MKCoordinateRegion adjusted_region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:adjusted_region animated:YES];

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

-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = YES;
    
    MKCoordinateRegion viewregion=  MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 0.03f, 0.03f);
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    annotation.coordinate=userLocation.coordinate;
    [self.mapView setRegion:viewregion];
    [self.mapView addAnnotation:annotation];
   }

- (IBAction)done:(id)sender {
    //Pushed
    PFQuery *query = [PFUser query];
    __block CLLocation *location = nil;
    [query whereKey:@"username" equalTo:self.user.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            for (PFObject *object in objects) {
                //double lat;
                //double longi;
               // NSLog(@"location %@",object[@"location"]);
                
                //Converting the data fetched from the PFObject and converting it to the object of latitude and longitude
                PFGeoPoint *local = object[@"location"];
               // NSLog(@"%@ is local",local);
                lat= local.latitude;
                longi= local.longitude;
                CLGeocoder *geocoder = [[CLGeocoder alloc] init];
                NSLog(@"location from cllocation in done %f", location.coordinate.latitude);
                location = [[CLLocation alloc] initWithLatitude:lat longitude:longi];
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
                    [self handleRoutePressed:location];
                }];
               // NSLog(@"location is %@", object[@"location"]);
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

- (void)handleRoutePressed:(CLLocation *)location {
    
    
    NSLog(@"location from cllocation %f", location.coordinate.latitude);
    // We're working
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    self.routeButton.enabled = NO;
    self.routeDetailsButton.enabled = NO;
    
    // Make a directions request
    MKDirectionsRequest *directionsRequest = [MKDirectionsRequest new];
    // Start at our current location
    
    
    //////
    CLLocationCoordinate2D sourceCoords = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    
    
    
    MKPlacemark *sourcePlacemark = [[MKPlacemark alloc] initWithCoordinate:sourceCoords addressDictionary:nil];
    
    
    /////
    
    
    MKMapItem *source = [[MKMapItem alloc] initWithPlacemark:sourcePlacemark];
    [directionsRequest setSource:source];
    // Make the destination
    CLLocationCoordinate2D destinationCoords = CLLocationCoordinate2DMake(32.882694, -96.971638);
    
    
    
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoords addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    [directionsRequest setDestination:destination];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        // We're done
        self.activityIndicator.hidden = YES;
        [self.activityIndicator stopAnimating];
        self.routeButton.enabled = YES;
        
        // Now handle the result
        if (error) {
            NSLog(@"There was an error getting your directions");
            return;
        }
        
        // So there wasn't an error - let's plot those routes
        self.routeDetailsButton.enabled = YES;
        self.routeDetailsButton.hidden = NO;
        _currentRoute = [response.routes firstObject];
        [self plotRouteOnMap:_currentRoute];
    }];
}

#pragma mark - Utility Methods
- (void)plotRouteOnMap:(MKRoute *)route
{
    if(_routeOverlay) {
        [self.mapView removeOverlay:_routeOverlay];
    }
    
    // Update the ivar
    _routeOverlay = route.polyline;
    
    // Add it to the map
    [self.mapView addOverlay:_routeOverlay];
    
}

#pragma mark - MKMapViewDelegate methods
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 4.0;
    return  renderer;
}

@end
