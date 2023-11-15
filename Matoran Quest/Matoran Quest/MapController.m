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
int playerUpdateTimerMax = 30;//the player timer updates roughly every half a second, this max timer means that the minimum time before we potentually get a new item will be 30 seconds (normally 60 or 30) (test 4)
int walkingTimer = 0; //this is for working out walking intervals
int randomThing; //a random number for item placement purposes
NSArray *kanohiList2;
NSArray *itemList;
NSArray *rahiList;
float spawnDistance = 0.00025; //how far away objects spawn from the player (0.00025 seems good) (test 0.0002)
float spawnWalkDistance = 0.00015; //how far you need to walk to trigger a spawn chance (normally 0.00015) (test 0.000005)
bool initialZoom = false; //this is so that when we first zoom in on the player it doesnt animate


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
        float Lo = _theMap.userLocation.location.coordinate.longitude; //these two are required for getting a item drop spot
        float La = _theMap.userLocation.location.coordinate.latitude;
        //if we've moved more than around 5 meters...
        if(compLat > spawnWalkDistance || compLong > spawnWalkDistance){
            randomThing = arc4random_uniform(4); //generate a random number for spawn rate
            [_theLabel setText: [NSString stringWithFormat: @"%d", randomThing]];
            if(randomThing != 3){ //1 chance in 3 that the item does not spawn
                randomThing = arc4random_uniform(8); //generate a random number for spawn location
                if (randomThing == 0){ //I tried this with cases but it didn't work
                    Lo += spawnDistance;
                    [self add1AnnotationWithLong:Lo andLat:La];
                }
                else if (randomThing == 1){
                    Lo -= spawnDistance;
                    [self add1AnnotationWithLong:Lo andLat:La];
                }
                else if (randomThing == 2){
                    La += spawnDistance;
                    [self add1AnnotationWithLong:Lo andLat:La];
                }
                else if (randomThing == 3){
                    La -= spawnDistance;
                    [self add1AnnotationWithLong:Lo andLat:La];
                }
                else if (randomThing == 4){
                    Lo += spawnDistance;
                    La -= spawnDistance;
                    [self add1AnnotationWithLong:Lo andLat:La];
                }
                else if (randomThing == 5){
                    Lo += spawnDistance;
                    La += spawnDistance;
                    [self add1AnnotationWithLong:Lo andLat:La];
                }
                else if (randomThing == 6){
                    Lo -= spawnDistance;
                    La += spawnDistance;
                    [self add1AnnotationWithLong:Lo andLat:La];
                }
                else if (randomThing == 7){
                    Lo -= spawnDistance;
                    La += spawnDistance;
                    [self add1AnnotationWithLong:Lo andLat:La];
                }
                else if (randomThing == 8){
                    Lo += spawnDistance;
                    [self add1AnnotationWithLong:Lo andLat:La];//the item is NEVER placed directly under the player
                }
                else{
                    Lo += spawnDistance;
                    [self add1AnnotationWithLong:Lo andLat:La];
                }
                
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
    location.latitude = aUserLocation.coordinate.latitude; //go to player location and center on it
    location.longitude = aUserLocation.coordinate.longitude;
    //NSLog(@"Lat: %f", aUserLocation.coordinate.latitude);
    //NSLog(@"Long: %f", aUserLocation.coordinate.longitude );
    region.span = span;
    region.center = location;
    if(initialZoom != true){
        initialZoom = true;
        [aMapView setRegion:region animated:NO];
    }
    else{
        [aMapView setRegion:region animated:YES];
    }
    
    
    [_theMap userLocation];
    //walking timer is used for animations
    if(walkingTimer == 0){
        _theMap.showsUserLocation = false; //turning this on and off again gets the players sprite to redraw and animate
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
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        //do nothing
    }
    else{
        //[_theTimer setHidden:true];
        NSString *MysteryAlertMessage = @""; //this will hold the message for the alert or view.
        //generate a random number to determine what we have just picked up:
        int randomItem = arc4random_uniform(4);
        if(randomItem == 0){
            randomItem = arc4random_uniform((int)rahiList.count);
            //randomItem -= 1;
            MysteryAlertMessage = [NSString stringWithFormat:@"You encountered a %@ Rahi!", rahiList[randomItem]];
        }
        else if(randomItem == 1){
            randomItem = arc4random_uniform((int)kanohiList2.count);
            //randomItem -= 1;
            MysteryAlertMessage = [NSString stringWithFormat:@"You found a %@ Kanohi mask!", kanohiList2[randomItem]];
        }
        else if(randomItem == 2){
            randomItem = arc4random_uniform((int)itemList.count);
            //randomItem -= 1;
            
            MysteryAlertMessage = [NSString stringWithFormat:@"You found a %@!", itemList[randomItem]];
        }
        else if(randomItem == 3){
            MysteryAlertMessage = @"You found some slightly interesting scenery!";
        }
        
        else if(randomItem == 4){
            randomItem = arc4random_uniform((int)rahiList.count);
            //randomItem -= 1;
            MysteryAlertMessage = [NSString stringWithFormat:@"You encountered a %@ Rahi!", rahiList[randomItem]];
        }
        else{
            randomItem = arc4random_uniform((int)rahiList.count);
            //randomItem -= 1;
            MysteryAlertMessage = [NSString stringWithFormat:@"You encountered a %@ Rahi!", rahiList[randomItem]];
        }
        
        //create an alert (temporary, later we will shift to a different view controller
        UIAlertController *MysteryAlert = [UIAlertController alertControllerWithTitle:@"Mysterious Object"
                                       message:MysteryAlertMessage
                                       preferredStyle:UIAlertControllerStyleAlert];
         
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
           handler:^(UIAlertAction * action) {}];
         
        [MysteryAlert addAction:defaultAction];
        
        [self presentViewController:MysteryAlert animated:YES completion:nil]; //show the alert
        
        [_theMap removeAnnotation:annotation]; //remove the annotation if clicked on
    }
    
    
    
}

//update player location when player location has moved



-(void)add1AnnotationWithLong: (float)longitude andLat:(float)latitude{ //create 1 annotation with given long and lat values
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate: CLLocationCoordinate2DMake(latitude, longitude)];
    [annotation setCoordinate: CLLocationCoordinate2DMake(latitude, longitude)];
    [annotation setTitle:@"What could it be?"];
    [annotation setSubtitle:@"Its a mystery..."];
    [_theMap addAnnotation:annotation];
    NSLog(@"added!");
    //[self zoomInOnLocation: CLLocationCoordinate2DMake(-45.861659, 170.627214)];
}


//work out player animations and colour the player with the user defined colour
-(void)playerWalker: (MKAnnotationView *) theView{
    //NSString *tempPlayerImageName; //for holding the name of the player sprite
    UIImage *playerSprite;
    UIColor *color1 = [UIColor colorWithRed:[[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerRed"] green:[[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerGreen"] blue:[[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerBlue"] alpha:[[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerAlpha"]];
    if(playerOldLong != _theMap.userLocation.location.coordinate.longitude){ //only animate if the player has moved
        if(playerWalkingSprite == 1){
            //try to load the sprite kind, if it doesnt exist, substitute a temp sprite
            playerSprite = [UIImage imageNamed:[NSString stringWithFormat:@"%@0",[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"]]];
            NSString *checkString = [NSString stringWithFormat:@"%@0",[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"]]; //check this is a valid name
            if([checkString rangeOfString:@"matoran"].location == NSNotFound){
                playerSprite = [UIImage imageNamed:@"unmaskedmatoran0.png"];
            }
            playerSprite = [self colorizeImage:playerSprite color:color1];
            
            playerWalkingSprite = 2;
        }
        else if(playerWalkingSprite == 2){
            //try to load the sprite kind, if it doesnt exist, substitute a temp sprite
            playerSprite = [UIImage imageNamed:[NSString stringWithFormat:@"%@1",[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"]]];
            NSString *checkString = [NSString stringWithFormat:@"%@1",[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"]]; //check this is a valid name
            if([checkString rangeOfString:@"matoran"].location == NSNotFound){
                playerSprite = [UIImage imageNamed:@"unmaskedmatoran1.png"];
            }
            playerSprite = [self colorizeImage:playerSprite color:color1];
            
            playerWalkingSprite = 3;
        }
        else if(playerWalkingSprite == 3){
            //try to load the sprite kind, if it doesnt exist, substitute a temp sprite
            playerSprite = [UIImage imageNamed:[NSString stringWithFormat:@"%@2",[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"]]];
            NSString *checkString = [NSString stringWithFormat:@"%@2",[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"]]; //check this is a valid name
            if([checkString rangeOfString:@"matoran"].location == NSNotFound){
                playerSprite = [UIImage imageNamed:@"unmaskedmatoran2.png"];
            }
            playerSprite = [self colorizeImage:playerSprite color:color1];
            
            playerWalkingSprite = 0;
        }
        else if(playerWalkingSprite == 0){
            //try to load the sprite kind, if it doesnt exist, substitute a temp sprite
            playerSprite = [UIImage imageNamed:[NSString stringWithFormat:@"%@3",[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"]]];
            NSString *checkString = [NSString stringWithFormat:@"%@3",[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"]]; //check this is a valid name
            if([checkString rangeOfString:@"matoran"].location == NSNotFound){
                playerSprite = [UIImage imageNamed:@"unmaskedmatoran3.png"];
            }
            playerSprite = [self colorizeImage:playerSprite color:color1];
            
            playerWalkingSprite = 1;
        }
        else{
            //try to load the sprite kind, if it doesnt exist, substitute a temp sprite
            playerSprite = [UIImage imageNamed:[NSString stringWithFormat:@"%@0",[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"]]];
            NSString *checkString = [NSString stringWithFormat:@"%@0",[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"]]; //check this is a valid name
            if([checkString rangeOfString:@"matoran"].location == NSNotFound){
                playerSprite = [UIImage imageNamed:@"unmaskedmatoran0.png"];
            }
            playerSprite = [self colorizeImage:playerSprite color:color1];
            
            playerWalkingSprite = 0;
        }
        
    }
    else{ //do this if the player isn't moving
        //try to load the sprite kind, if it doesnt exist, substitute a temp sprite
        playerSprite = [UIImage imageNamed:[NSString stringWithFormat:@"%@0",[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"]]];
        NSString *checkString = [NSString stringWithFormat:@"%@0",[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"]]; //check this is a valid name
        if([checkString rangeOfString:@"matoran"].location == NSNotFound){
            playerSprite = [UIImage imageNamed:@"unmaskedmatoran0.png"];
        }
        playerSprite = [self colorizeImage:playerSprite color:color1];
        
        playerWalkingSprite = 0;
    }
    theView.image = playerSprite; //set the image
    
}

//generate randoms







-(NSString*)randomMaskMaker{
    //kanohiList2 = [NSArray arrayWithObjects: @"unmasked", @"hau", @"miru", @"kakama", @"akaku", @"huna", @"rau", @"matatu", @"pakari", @"ruru", @"kaukau", @"mahiki", @"komau", @"vahi" , @"avohkii", nil]; //load up masks the player can find
    int randomItem = arc4random_uniform(101);
    NSString *colorString; //holds the found colour
    if(randomItem == 1){ //rare mask
        int randomItem = arc4random_uniform(5);
        if (randomItem == 1){
            return @"vahi"; //Mask of Time (ultra rare)
        }
        else if (randomItem == 2){
            return @"infected hau"; // Infected Mask of Shielding (ultra rare)
        }
        else{
            return @"avohkii"; //Mask of Light (rare)
        }
    }
    else if(randomItem <= 51){ //Noble Masks
        int randomItem = arc4random_uniform(12);
        if (randomItem == 1){
            int randomItem = arc4random_uniform(14); //work out colour
            if (randomItem == 1 || randomItem == 2){ //black
                
            }
            else if (randomItem == 3 || randomItem == 4){ //red
                
            }
            else if (randomItem == 6 || randomItem == 5){ //brown
                
            }
            else if (randomItem == 8 || randomItem == 7){ //white
                
            }
            else if (randomItem == 10 || randomItem == 9){ //green
                
            }
            else if (randomItem == 11){ //silver
                
            }
            else if (randomItem == 12){ //gold
                
            }
            else{ //blue (slightly more common for this one
                
            }
            return [NSString stringWithFormat:@"%@ kaukau", colorString]; //Mask of Water Breathing (common)
        }
        else if (randomItem == 2){
            return [NSString stringWithFormat:@"%@ hau", colorString]; // Mask of Shielding (common)
        }
        else if (randomItem == 2){
            return [NSString stringWithFormat:@"%@ pakari", colorString]; // Mask of Strength (common)
        }
        else if (randomItem == 2){
            return [NSString stringWithFormat:@"%@ kakama", colorString]; // Mask of Speed (common)
        }
        else if (randomItem == 2){
            return [NSString stringWithFormat:@"%@ miru", colorString]; // Mask of Levitation (common)
        }
        else{
            return [NSString stringWithFormat:@"%@ akaku", colorString]; //Mask of X-Ray Vision (common)
        }
    }
    else if (randomItem > 51){ //Great Masks
        int randomItem = arc4random_uniform(12);
        if (randomItem == 1){
            return [NSString stringWithFormat:@"%@ matatu", colorString]; //Mask of Telekinesis (common)
        }
        else if (randomItem == 2){
            return [NSString stringWithFormat:@"%@ rau", colorString]; // Infected Mask of Translation (common)
        }
        else if (randomItem == 2){
            return [NSString stringWithFormat:@"%@ mahiki", colorString]; // Infected Mask of Illusion (common)
        }
        else if (randomItem == 2){
            return [NSString stringWithFormat:@"%@ huna", colorString]; // Infected Mask of Concealment (common)
        }
        else if (randomItem == 2){
            return [NSString stringWithFormat:@"%@ ruru", colorString]; // Infected Mask of Night Vision (common)
        }
        else{
            return [NSString stringWithFormat:@"%@ komau", colorString]; //Mask of Mind Control (common)
        }
    }
    else{ //otherwise
        return @"brown rau"; //you get my favourite
    }
}

-(NSString*)randomItemMaker{
    //itemList = [NSArray arrayWithObjects: @"Energised Protodermis", @"Vuata Maca fruit", @"Super Disk", @"Charged Fire Disk", @"Charged Water Disk", @"Charged Earth Disk", @"Charged Rock Disk", @"Charged Air Disk", @"Charged Ice Disk", nil]; //load up a list of items the player can find
    int randomItem = arc4random_uniform(20);
    if(randomItem < 13){ //healing items
        itemList = [NSArray arrayWithObjects: @"Vuata Maca fruit", @"Vuata Maca fruit", @"Energised Protodermis", @"Vuata Maca fruit",nil]; //load up a list of healing items (multipul of 1 to increase likelyhood of getting it, its a dumb way to do it but it works so bite me
        randomItem = arc4random_uniform((int)rahiList.count);
        return itemList[randomItem]; //return a random greater rahi
    }
    else if (randomItem < 18){ //power disks
        itemList = [NSArray arrayWithObjects: @"Super Disk", @"Charged Fire Disk", @"Charged Water Disk", @"Charged Earth Disk", @"Charged Rock Disk", @"Charged Air Disk", @"Charged Ice Disk",nil]; //load up a list of rahi the player can encounter
        randomItem = arc4random_uniform((int)rahiList.count);
        return itemList[randomItem]; //return a random greater rahi
    }
    else{ //rare item
        int randomItem = arc4random_uniform(2);
        if (randomItem == 1){
            return @"Cool looking rock"; //useless, but cool!
        }
        else{
            return @"Mystery Item"; //not sure what this will become yet
        }
    }
}

-(NSString*)randomRahiMaker{
    //rahiList = [NSArray arrayWithObjects: @"Nui Rama", @"Nui Kopen", @"Nui Jaga", @"Kuma Nui", @"Tarakava", @"Manas", @"Mana Ko", @"Tarakava Nui", @"Muaka", @"Kane Ra", @"Fikou Nui",nil]; //load up a list of rahi the player can encounter
    int randomItem = arc4random_uniform(20);
    if(randomItem < 13){ //lesser rahi
        rahiList = [NSArray arrayWithObjects: @"Nui Rama", @"Nui Jaga", @"Tarakava",nil]; //load up a list of rahi the player can encounter
        randomItem = arc4random_uniform((int)rahiList.count);
        return rahiList[randomItem]; //return a random greater rahi
    }
    else if (randomItem < 18){ //greater rahi
        rahiList = [NSArray arrayWithObjects: @"Nui Kopen", @"Kuma Nui", @"Tarakava Nui", @"Muaka", @"Kane Ra", @"Fikou Nui",nil]; //load up a list of rahi the player can encounter
        randomItem = arc4random_uniform((int)rahiList.count);
        return rahiList[randomItem]; //return a random greater rahi
    }
    else{ //rare rahi
        int randomItem = arc4random_uniform(2);
        if (randomItem == 1){
            return @"Manas";
        }
        else{
            return @"Manas Ko";
        }
    }
}


//3rd party utlities

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
