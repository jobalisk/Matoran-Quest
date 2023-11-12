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
int playerWalkingSprite = 0; //the sprite number we're on

- (void)viewDidLoad {
    [super viewDidLoad];
    playerWalkingSprite = 0;
    // Do any additional setup after loading the view.

    [_theLabel setText:@"Updated!"];
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
    locationManager.distanceFilter = 2; // meters

    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
    
    //next, set up the map view
    _theMap.delegate = self;
    [_theMap setMapType: MKMapTypeStandard];
    [_theMap setZoomEnabled:false];
    [_theMap setScrollEnabled:false];
    userLocation = CGPointMake(_theMap.userLocation.location.coordinate.longitude, _theMap.userLocation.location.coordinate.latitude);
    _theMap.showsUserLocation = true;
    [_theMap.userLocation setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerName"]];

    
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation {

    if ([annotation isKindOfClass:[MKUserLocation class]]) {

 MKAnnotationView  *userannotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        //get the players sprite to "walk"
        [self playerWalker: userannotationView];

        userannotationView.draggable = YES;
        userannotationView.canShowCallout = YES;


         return userannotationView;
    }else {
        // your code to return annotationView or pinAnnotationView
        MKAnnotationView  *userannotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        return userannotationView;
    }
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
    
    //NSLog(@"X: %f",userLocation.x);
    //NSLog(@"Y: %f",userLocation.x);
//    MKCoordinateSpan span = MKCoordinateSpanMake(0.001, 0.001);
//    MKCoordinateRegion region = MKCoordinateRegionMake(_theMap.userLocation.location.coordinate, span);
//    [_theMap setRegion:region animated: false];
    
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


//update player location
- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.0008; //zoom level (the smaller the number the bigger the zoom
    span.longitudeDelta = 0.0008;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [aMapView setRegion:region animated:NO];
    
    [_theMap userLocation];
    [self addAnnotation];
    if([_theLabel.text isEqualToString: @"Updated2"]){
        _theMap.showsUserLocation = false;
        [_theLabel setText:@"Updated3"];
    }
    else{
        [_theLabel setText:@"Updated2"];
    }
    
    _theMap.showsUserLocation = true;
    //NSLog(@"Updated!");
    
    
    
}

//if something is clicked on...
-(void)mapView:(MKMapView *)aMapView didSelectAnnotation:(nonnull id<MKAnnotation>)annotation{
    //playerWalkingSprite = 3;
    _theMap.showsUserLocation = true;
}

//update player location when player location has moved

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{


}

-(void)addAnnotation{
    MKPointAnnotation *playerLocation;
    [playerLocation setCoordinate:_theMap.userLocation.location.coordinate];
    [playerLocation setCoordinate:_theMap.userLocation.location.coordinate];
    [playerLocation setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerName"]];
    [playerLocation setSubtitle:@"Current Location"];
    [_theMap addAnnotation:playerLocation];
}

-(void)playerWalker: (MKAnnotationView *) theView{
    if(playerWalkingSprite == 0){
        theView.image = [UIImage imageNamed:@"matoran0.png"];
        playerWalkingSprite = 1;
    }
    else if(playerWalkingSprite == 1){
        theView.image = [UIImage imageNamed:@"matoran1.png"];
        playerWalkingSprite = 2;
    }
    else if(playerWalkingSprite == 2){
        theView.image = [UIImage imageNamed:@"matoran2.png"];
        playerWalkingSprite = 3;
    }
    else if(playerWalkingSprite == 3){
        theView.image = [UIImage imageNamed:@"matoran3.png"];
        playerWalkingSprite = 0;
    }
    else{
        theView.image = [UIImage imageNamed:@"matoran0.png"];
        playerWalkingSprite = 0;
    }
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
