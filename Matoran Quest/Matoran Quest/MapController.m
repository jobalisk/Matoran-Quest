//
//  MapController.m
//  Matoran Quest
//
//  Created by Job Dyer on 12/11/23.
//

#import "MapController.h"
#import "PlayerDetailsController.h"


@interface MapController ()

@end

@implementation MapController

CLLocationManager *locationManager;
CGPoint userLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    [self GetLocation];
}

-(void)GetLocation{
    
    //first set up the location manager
    locationManager.delegate = self;
    if (locationManager == nil) {
        locationManager = [[CLLocationManager alloc] init];
    }
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    locationManager.distanceFilter = 5; // meters

    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
    
    //next, set up the map view
    _theMap.delegate = self;
    [_theMap setMapType: MKMapTypeStandard];
    //[_theMap setZoomEnabled:false];
    //[_theMap setScrollEnabled:false];
    userLocation = CGPointMake(_theMap.userLocation.location.coordinate.longitude, _theMap.userLocation.location.coordinate.latitude);
    _theMap.showsUserLocation = true;
    [_theMap.userLocation setTitle:@"You"];

    
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation {

    if ([annotation isKindOfClass:[MKUserLocation class]]) {

 MKAnnotationView  *userannotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
            userannotationView.image = [UIImage imageNamed:@"matoran0.png"];
            userannotationView.draggable = YES;
            userannotationView.canShowCallout = YES;


         return userannotationView;
    }else {
        // your code to return annotationView or pinAnnotationView
        MKAnnotationView  *userannotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        return userannotationView;
    }
}


//update player location
- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [aMapView setRegion:region animated:YES];
    NSLog(@"Updated!");
    
}

-(void)viewDidAppear:(BOOL)animated{ //display this warning message once everything has properly loaded
    UIAlertController* warningAlert = [UIAlertController alertControllerWithTitle:@"Attention!"
                                   message:@"Please be mindful of your location at all times while playing this game! Watch out for cars, people and other hazards!"
                                   preferredStyle:UIAlertControllerStyleAlert];
     
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {}];
     
    [warningAlert addAction:defaultAction];
    
    [self presentViewController:warningAlert animated:YES completion:nil];
    
    //[_theMap setCenter: userLocation];
    
    userLocation = CGPointMake(_theMap.userLocation.location.coordinate.longitude, _theMap.userLocation.location.coordinate.latitude);
    
    NSLog(@"X: %f",userLocation.x);
    NSLog(@"Y: %f",userLocation.x);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.0005, 0.0005);
    MKCoordinateRegion region = MKCoordinateRegionMake(_theMap.userLocation.location.coordinate, span);
    [_theMap setRegion:region animated: false];
    
    //set user location image
    MKAnnotationView *playerSprite;
    [playerSprite setImage:[UIImage imageNamed:@"MatoranStandingStill.png"]];
    
    
    
    
    /*
    MKPointAnnotation *playerLocation;
    [playerLocation setCoordinate:_theMap.userLocation.location.coordinate];
    [playerLocation setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerName"]];
    [playerLocation setSubtitle:@"Current Location"];
    MKAnnotationView *playerSprite;
    [playerSprite setImage:[UIImage imageNamed:@"MatoranStandingStill.png"]];
    [playerSprite setAnnotation:playerLocation];
    [_theMap addAnnotation:playerLocation];
    */
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
