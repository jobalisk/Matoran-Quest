//
//  MapController.m
//  Matoran Quest
//
//  Created by Job Dyer on 12/11/23.
//

#import "MapController.h"
#import "PlayerDetailsController.h"


@interface MapController () <MKMapViewDelegate, CLLocationManagerDelegate>

@end

@implementation MapController

CLLocationManager *locationManager;
CGPoint userLocation;
int playerWalkingSprite = 0; //the sprite number we're on
float playerOldLong = 0.0; //keep these two to know where we've been for working out how far we recently moved
float playerOldLat = 0.0;
int playerUpdateTimer = 0; //use this to check for player movement at regular intervals
int playerUpdateTimerMax = 60;//the player timer updates roughly every half a second, this max timer means that the minimum time before we potentually get a new item will be 30 seconds
int walkingTimer = 0; //this is for working out walking intervals

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
        userannotationView.draggable = YES;
        userannotationView.canShowCallout = YES;
        userannotationView.image = [UIImage imageNamed:@"item.png"];
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
    //MKAnnotationView *playerSprite;
    //[playerSprite setImage:[UIImage imageNamed:@"MatoranStandingStill.png"]];
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
    //first, work out timer
    if(playerUpdateTimer != playerUpdateTimerMax){
        playerUpdateTimer += 1;
    }
    else{
        //reset the timer every 30 seconds or so and update the new long and lat at current pos. before storing new long and lat, compare current with old old to see if the player has moved sufficently.
        float compLat = _theMap.userLocation.location.coordinate.latitude - playerOldLat;
        float compLong = _theMap.userLocation.location.coordinate.longitude - playerOldLong;
        //if we've moved more than around 5 meters...
        if(compLat > 0.000005){
            if(compLong > 0.000005){
                [self add1Annotation];
            }
        }
         
        playerUpdateTimer = 0;
        playerOldLat = _theMap.userLocation.location.coordinate.latitude;
        playerOldLong = _theMap.userLocation.location.coordinate.longitude;
        
    }
    NSLog(@"Timer: %d", playerUpdateTimer);
    
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.0008; //zoom level (the smaller the number the bigger the zoom
    span.longitudeDelta = 0.0008;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    //NSLog(@"Lat: %f", aUserLocation.coordinate.latitude);
    //NSLog(@"Long: %f", aUserLocation.coordinate.longitude );
    region.span = span;
    region.center = location;
    [aMapView setRegion:region animated:NO];
    
    [_theMap userLocation];
    
    if(walkingTimer == 0){
        _theMap.showsUserLocation = false;
        walkingTimer = 1;
        
    }
    else{
        walkingTimer = 0;
        [_theTimer setText: [NSString stringWithFormat:@"T: %d", playerUpdateTimer]];
        if ([_theLabel.text rangeOfString:@"Long"].location == NSNotFound) {
            [_theLabel setText:[NSString stringWithFormat:@"Long: %f", aUserLocation.coordinate.longitude]];
        }
        else{
            [_theLabel setText:[NSString stringWithFormat:@"Lat: %f", aUserLocation.coordinate.latitude]];
        }
        
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



-(void)add1Annotation{ //create 1 annotation
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate: CLLocationCoordinate2DMake(_theMap.userLocation.location.coordinate.latitude, _theMap.userLocation.location.coordinate.longitude)];
    [annotation setCoordinate: CLLocationCoordinate2DMake(_theMap.userLocation.location.coordinate.latitude, _theMap.userLocation.location.coordinate.longitude)];
    [annotation setTitle:@"What could it be?"];
    [annotation setSubtitle:@"Its a mystery..."];
    [_theMap addAnnotation:annotation];
    NSLog(@"added!");
    //[self zoomInOnLocation: CLLocationCoordinate2DMake(-45.861659, 170.627214)];
}


//work out player animations and colour the player with the user defined colour
-(void)playerWalker: (MKAnnotationView *) theView{
    UIImage *playerSprite;
    UIColor *color1 = [UIColor colorWithRed:[[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerRed"] green:[[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerGreen"] blue:[[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerBlue"] alpha:[[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerAlpha"]];
    if(playerWalkingSprite == 0){
        playerSprite = [UIImage imageNamed:@"matoran0.png"];
        playerSprite = [self colorizeImage:playerSprite color:color1];
        theView.image = playerSprite;
        playerWalkingSprite = 1;
    }
    else if(playerWalkingSprite == 1){
        playerSprite = [UIImage imageNamed:@"matoran1.png"];
        playerSprite = [self colorizeImage:playerSprite color:color1];
        theView.image = playerSprite;
        playerWalkingSprite = 2;
    }
    else if(playerWalkingSprite == 2){
        playerSprite = [UIImage imageNamed:@"matoran2.png"];
        playerSprite = [self colorizeImage:playerSprite color:color1];
        theView.image = playerSprite;
        playerWalkingSprite = 3;
    }
    else if(playerWalkingSprite == 3){
        playerSprite = [UIImage imageNamed:@"matoran3.png"];
        playerSprite = [self colorizeImage:playerSprite color:color1];
        theView.image = playerSprite;
        playerWalkingSprite = 0;
    }
    else{
        playerSprite = [UIImage imageNamed:@"matoran0.png"];
        playerSprite = [self colorizeImage:playerSprite color:color1];
        theView.image = playerSprite;
        playerWalkingSprite = 0;
    }
    
}

-(void)zoomInOnLocation:(CLLocationCoordinate2D)location //go to where a pin has been dropped
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 200, 200);
    [_theMap setRegion:[_theMap regionThatFits:region] animated:YES];
}


//change the colour of the input image
-(UIImage *)colorizeImage:(UIImage *)baseImage color:(UIColor *)theColor {
    UIGraphicsBeginImageContext(baseImage.size);

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);

    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, baseImage.CGImage);
    [theColor set];
    CGContextFillRect(ctx, area);
    CGContextRestoreGState(ctx);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextDrawImage(ctx, area, baseImage.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
