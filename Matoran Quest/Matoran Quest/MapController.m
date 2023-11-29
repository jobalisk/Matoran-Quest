//
//  MapController.m
//  Matoran Quest
//
//  Created by Job Dyer on 12/11/23.
//

#import "MapController.h"
#import "PlayerDetailsController.h"
#import <AudioToolbox/AudioServices.h>


@interface MapController () <MKMapViewDelegate, CLLocationManagerDelegate>

@end

@implementation MapController

CLLocationManager *locationManager;
CGPoint userLocation;
int playerWalkingSprite = 0; //the sprite number we're on
float playerOldLong = 0.0; //keep these two to know where we've been for working out how far we recently moved
float playerOldLat = 0.0;
int playerUpdateTimer = 0; //use this to check for player movement at regular intervals
int playerUpdateTimerMax = 24;//the player timer updates roughly every half a second, this max timer means that the minimum time before we potentually get a new item will be 20 seconds (for tests use 4), 24 is a good time
int walkingTimer = 0; //this is for working out walking intervals
int randomThing; //a random number for item placement purposes
NSArray *kanohiList2;
NSArray *itemList;
NSArray *rahiList;
int rareMaskIdentifyier = 0; //this is here so that I can raise a flag when a rare mask has been found to stop crashes in the player edit controller
float spawnDistance = 0.0002; //how far away objects spawn from the player (0.0002 seems good)
float spawnWalkDistance = 0.00005; //how far you need to walk to trigger a spawn chance (normally  0.000005) (test 0.0000005)
int spawnRate = 3; //the rate at which masks spawn, 1 in whatever this number is is the rate at which they don't spawn
bool initialZoom = false; //this is so that when we first zoom in on the player it doesnt animate
NSString *maskColorString; //holds the found masks's colour
int playerHP = 0; //this will later be loaded from the userdefaults and shared with the gameviewcontroller
int widgetCount = 0;
int rahiFightFlag = 0; //are you encountering a rahi (in a fight)
NSMutableArray *collectedMasks; //a list of the kinds of masks the player has collected. 1 entry for each unique kind of mask (colour as well as type)

- (void)viewDidLoad {
    [super viewDidLoad];
    playerWalkingSprite = 0;
    // Do any additional setup after loading the view.
    
    playerHP = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerHP"]; //load player HP
    if(playerHP == 0){ //if there is no playerHP key yet
        playerHP = 10;
        [[NSUserDefaults standardUserDefaults] setInteger: playerHP forKey:@"PlayerHP"]; //set it if it doesnt exist
        
    }
    
    collectedMasks = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMaskCollectionList"]; //load player list of collected masks
    if(collectedMasks == NULL){ //if there is no player masks collection key yet
        //NSLog(@"refreshing1");
        NSMutableArray *collectedMasks = [[NSMutableArray alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:collectedMasks forKey:@"PlayerMaskCollectionList"]; //set it if it doesnt exist
        
    }
    else{
        collectedMasks = [collectedMasks mutableCopy]; //make sure we can add to it!
    }
    
    
    rahiFightFlag = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerFighting"]; //load player fighting flag
    if(rahiFightFlag == 0){ //if there is no playerHP key yet
        rahiFightFlag = 0;
        [[NSUserDefaults standardUserDefaults] setInteger: rahiFightFlag forKey:@"PlayerFighting"]; //set it if it doesnt exist
        
    }
    
    widgetCount = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerWidgets"]; //load player Widgets
    if(widgetCount == 0){ //if there is no playerHP key yet
        widgetCount = 0;
        [[NSUserDefaults standardUserDefaults] setInteger: widgetCount forKey:@"PlayerWidgets"]; //set it if it doesnt exist
        
    }
    
    rareMaskIdentifyier = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerRares"]; //load player Widgets
    if(rareMaskIdentifyier == 0){ //if there are no rare masks in the players posession
        rareMaskIdentifyier = 0;
        [[NSUserDefaults standardUserDefaults] setInteger: rareMaskIdentifyier forKey:@"PlayerRares"]; //set it if it doesnt exist
        
    }
    NSString *testName = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerName"];
    if(testName == NULL || [testName isEqualToString:@""]){
        [[NSUserDefaults standardUserDefaults] setObject: @"Rīwai" forKey:@""]; //set a default name to avoid a really weird bug
    }

    [self setModalInPresentation:true]; //make it so you can's swipe it away (stops cheating)
    
    [_theLabel setText:@"Updated!"];
    [self GetLocation];
    
    /*
     //random item checker
    itemList = [NSArray arrayWithObjects: @"Super Disk", @"Charged Fire Disk", @"Charged Water Disk", @"Charged Earth Disk", @"Charged Rock Disk", @"Charged Air Disk", @"Charged Ice Disk",nil]; //load up a list of rahi the player can encounter
    int randomItem = arc4random_uniform((int)itemList.count);
    NSLog(@"%@", itemList[randomItem]);
    */
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
    //[locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
    
    //next, set up the map view
    _theMap.delegate = self;
    [_theMap setMapType: MKMapTypeStandard];
    [_theMap setZoomEnabled:false];
    [_theMap setScrollEnabled:false];
    userLocation = CGPointMake(_theMap.userLocation.location.coordinate.longitude, _theMap.userLocation.location.coordinate.latitude);
    _theMap.showsUserLocation = true;
    [_theMap.userLocation setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerName"]];
    //[_theMap.userLocation.enabled]

    
    
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views //make clicking on the user impossible
{
    MKAnnotationView *ulv = [mapView viewForAnnotation:mapView.userLocation];
    ulv.enabled = NO;
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
    /*
    float x = -45.884126;
    float y = -45.884055;
    float z = y - x;
    z = 0.000007 * -1;
    NSLog(@"%f", z);
    */
     
}


//update player location
- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    //first, work out timer
    if(playerUpdateTimer != playerUpdateTimerMax){
        playerUpdateTimer += 1;
    }
    else{
        //recover HP
        if(playerHP != 10){
            playerHP += 1;
            [[NSUserDefaults standardUserDefaults] setInteger: playerHP forKey:@"PlayerHP"];
        }

        //reset the timer every 30 seconds or so and update the new long and lat at current pos. before storing new long and lat, compare current with old old to see if the player has moved sufficently.
        //get the difference by adding or subtracing to a value and then comparing to the origonal value. for walking south which means the number decreases, we add a number to it
        float compLat = _theMap.userLocation.location.coordinate.latitude - spawnWalkDistance;
        float compLong = _theMap.userLocation.location.coordinate.longitude - spawnWalkDistance;
        float compLatNeg = _theMap.userLocation.location.coordinate.latitude + spawnWalkDistance;
        float compLongNeg = _theMap.userLocation.location.coordinate.longitude + spawnWalkDistance;
        float Lo = _theMap.userLocation.location.coordinate.longitude; //these two are required for getting a item drop spot
        float La = _theMap.userLocation.location.coordinate.latitude;
        //if we've moved more than around 5 meters...
        if(compLat > playerOldLat || compLong > playerOldLong || compLatNeg < playerOldLat || compLongNeg < playerOldLong){ //check to see if we have moved north or south, east or west, further than the required amount
            //NSLog(@"compLong: %f", compLong);
            //NSLog(@"compLat: %f", compLat);
            //NSLog(@"spawnWalkDistance: %f", spawnWalkDistance);
            //NSLog(@"spawnWalkDistance: %f", (spawnWalkDistance * -1));
            
            
            //[_theTester setText: [NSString stringWithFormat: @"%f , %f", compLat, compLong]];
            randomThing = arc4random_uniform(spawnRate); //generate a random number for spawn rate
            [_theLabel setText: [NSString stringWithFormat: @"%d", randomThing]];
            if(randomThing != 1){ //1 chance in 3 that the item does not spawn
                if([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerVibrate"] == 1){ //only do this if enabled in the options menu
                    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate); //vibrate the phone (or beep on unsupported devices)
                }
                
                int randomThing2 = arc4random_uniform(2); //generate a random number for chance to spawn 2
                randomThing2 += 1; //choose between spawning 1 or 2 objects
                if(randomThing2 == 2){
                    int randomThing1 = arc4random_uniform(2); //make it more unlikely
                    if(randomThing1 == 1){
                        randomThing2 = 1; //so now its a 1 in 4 chance roughly of getting 2 to spawn at once
                    }
                }
                int i = 0;
                while (i != randomThing2){ //do this once or twice
                    i += 1;
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
        }
         
        playerUpdateTimer = 0;
        playerOldLat = _theMap.userLocation.location.coordinate.latitude;
        playerOldLong = _theMap.userLocation.location.coordinate.longitude;
        
    }
    //NSLog(@"Timer: %d", playerUpdateTimer);
    
    
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
        //[_theTimer setText: [NSString stringWithFormat:@"T: %d", playerUpdateTimer]];
        if ([_theLabel.text rangeOfString:@"Long"].location == NSNotFound) {
            [_theLabel setText:[NSString stringWithFormat:@"Long: %f", aUserLocation.coordinate.longitude]];
        }
        else{
            [_theLabel setText:[NSString stringWithFormat:@"Lat: %f", aUserLocation.coordinate.latitude]];
        }

    }
    //set HP label:
    [_theHP setText:[NSString stringWithFormat:@"HP: %d", playerHP]];
    
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
        int randomItem = arc4random_uniform(8);
        if(randomItem == 0){
            //randomItem = arc4random_uniform((int)rahiList.count);
            //randomItem -= 1;
            MysteryAlertMessage = [NSString stringWithFormat:@"You encountered a %@ Rahi!", [self randomRahiMaker]];
        }
        else if(randomItem == 1 || randomItem == 4){
            //randomItem = arc4random_uniform((int)kanohiList2.count);
            //randomItem -= 1;
            NSArray *maskDetails; //the holding container for the mask and its info
            NSMutableArray *maskArray2;
            NSString *theMask = [self randomMaskMaker];
            NSArray *maskArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMasks"];
            
            //reduce down the accuracy of the lat and long by removing the decimal point
            float long3 = (float)_theMap.userLocation.location.coordinate.longitude;
            float lat3 = (float)_theMap.userLocation.location.coordinate.latitude;
            int long2 = (int)long3;
            int lat2 = (int)lat3;
            NSString *long1 = [NSString stringWithFormat:@"%d",long2];
            NSString *lat1  = [NSString stringWithFormat:@"%d", lat2];
            //bit messy but need to first convert to float to convert to int as just straight int conversion causes a crash
            
            //sort out mask details
            maskDetails = [NSArray arrayWithObjects: theMask, [[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerName"], lat1, long1, nil]; //give player name, location and mask details
            //NSLog(@"name: %@", theMask);
            //NSLog(@"player: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerName"]);
            //NSLog(@"lat: %@", lat1);
            //NSLog(@"long: %@", long1);
            //NSLog(@"MList0: %@", maskDetails);
            if(maskArray != NULL){ //check to see if the list exists first
                
                maskArray2 = [maskArray mutableCopy];
                [maskArray2 addObject: maskDetails]; //add it to the array
                [[NSUserDefaults standardUserDefaults] setObject: maskArray2 forKey:@"PlayerMasks"];
                //NSLog(@"MList2: %@", maskArray2);
            }
            else{ //make a new array
                maskArray = [NSArray arrayWithObjects: maskDetails, nil];
                [[NSUserDefaults standardUserDefaults] setObject: maskArray forKey:@"PlayerMasks"]; //save the new mask array back to user defaults
                //NSLog(@"MList1: %@", maskArray);
            }
            if([collectedMasks indexOfObject:theMask]==NSNotFound){ //if the mask is not in the list of collected masks, add it!
                NSLog(@"adding: %@", theMask);
                [collectedMasks addObject:theMask];
                NSLog(@"list1: %@", collectedMasks);
                [[NSUserDefaults standardUserDefaults] setObject:collectedMasks forKey:@"PlayerMaskCollectionList"]; //add the mask to the collection
            }
            else{
                NSLog(@"not adding: %@", theMask);
                NSLog(@"list2: %@", collectedMasks);
            }
            MysteryAlertMessage = [NSString stringWithFormat:@"You found a %@ Kanohi mask!",theMask];
        }
        else if(randomItem == 2 || randomItem == 5){
            //randomItem = arc4random_uniform((int)itemList.count);
            //randomItem -= 1;
            NSMutableArray *itemArray2;
            NSString *theItem = [self randomItemMaker];
            NSArray *itemArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerItems"];
            NSString *extraText = @"";//extra text for if you run out of bag space.
            if(itemArray != NULL){
                
                itemArray2 = [itemArray mutableCopy];
                if(itemArray2.count == 14){ //max inventory space is 20
                    if([theItem isEqualToString: @"Widget"]){ //if the item is a widget just addi it to the stack
                        widgetCount +=1;
                        [[NSUserDefaults standardUserDefaults] setInteger: widgetCount forKey:@"PlayerWidgets"]; //set it if it doesnt
					}
					else{ //otherwise display a warning message
                        extraText = @"\nYour back pack is now full!"; //give a warning message
						[itemArray2 addObject: theItem]; //add it to the array
						[[NSUserDefaults standardUserDefaults] setObject: itemArray2 forKey:@"PlayerItems"];
					}
                }
                else if(itemArray2.count < 15){ //max inventory space is 20
                    if([theItem isEqualToString: @"Widget"]){ //if the item is a widget just addi it to the stack
                        widgetCount +=1;
                        [[NSUserDefaults standardUserDefaults] setInteger: widgetCount forKey:@"PlayerWidgets"]; //set it if it doesnt
                    }
					else{
						[itemArray2 addObject: theItem]; //add it to the array
						[[NSUserDefaults standardUserDefaults] setObject: itemArray2 forKey:@"PlayerItems"];
					}
                }
                else{
                    if([theItem isEqualToString: @"Widget"]){ //if the item is a widget just addi it to the stack
                        widgetCount +=1;
                        [[NSUserDefaults standardUserDefaults] setInteger: widgetCount forKey:@"PlayerWidgets"]; //set it if it doesnt
                    }
                    else{
                        extraText = @"\nThere's no room left in your back pack for that item!";
                    }
                }
                 

            }
            else{
                itemArray = [NSArray arrayWithObjects: theItem , nil];
                [[NSUserDefaults standardUserDefaults] setObject: itemArray forKey:@"PlayerItems"]; //save the array to player defaults
            }
             
            MysteryAlertMessage = [NSString stringWithFormat:@"You found a %@!%@", theItem, extraText];
        }
        else if(randomItem == 3 || randomItem == 6 || randomItem == 7){
            randomItem = arc4random_uniform(2);
            if(randomItem == 0){
                MysteryAlertMessage = @"You found some slightly interesting scenery!";
            }
            else{
                MysteryAlertMessage = @"You thought you saw something, must have been mistaken.";
            }
            
            
        }

        
        else if(randomItem == 8){
            randomItem = arc4random_uniform((int)rahiList.count);
            //randomItem -= 1;
            
            MysteryAlertMessage = [NSString stringWithFormat:@"You encountered a %@ Rahi!", [self randomRahiMaker]];
        }
        else{
            randomItem = arc4random_uniform((int)rahiList.count);
            //randomItem -= 1;
            MysteryAlertMessage = [NSString stringWithFormat:@"You encountered a %@ Rahi!", [self randomRahiMaker]];
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
    //NSLog(@"added!");
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
    int randomItem;
    randomItem = arc4random_uniform(15);
    if(randomItem != 3){ //start of with regional mask randomizer, 1 in 15 chance of finding a bronze region mask if in the correct region
        randomItem = arc4random_uniform(101);
        if(randomItem == 1){ //rare mask
            int randomItem = arc4random_uniform(5);
            if (randomItem == 1){
                [[NSUserDefaults standardUserDefaults] setInteger: 1 forKey:@"PlayerRares"];
                return @"vahi"; //Mask of Time (ultra rare)
                
            }
            else if (randomItem == 2){
                return @"infected hau"; // Infected Mask of Shielding (ultra rare)
            }
            else{
                [[NSUserDefaults standardUserDefaults] setInteger: 1 forKey:@"PlayerRares"];
                return @"avohkii"; //Mask of Light (rare)
            }
        }
        else if(randomItem <= 51){ //Noble Masks
            int randomItem = arc4random_uniform(6);
            if (randomItem == 1){
                [self randomColourPicker]; //choose a mask colour
                return [NSString stringWithFormat:@"%@ kaukau", maskColorString]; //Mask of Water Breathing (common)
            }
            else if (randomItem == 2){
                [self randomColourPicker]; //choose a mask colour
                return [NSString stringWithFormat:@"%@ hau", maskColorString]; // Mask of Shielding (common)
            }
            else if (randomItem == 3){
                [self randomColourPicker]; //choose a mask colour
                return [NSString stringWithFormat:@"%@ pakari", maskColorString]; // Mask of Strength (common)
            }
            else if (randomItem == 4){
                [self randomColourPicker]; //choose a mask colour
                return [NSString stringWithFormat:@"%@ kakama", maskColorString]; // Mask of Speed (common)
            }
            else if (randomItem == 5){
                [self randomColourPicker]; //choose a mask colour
                return [NSString stringWithFormat:@"%@ miru", maskColorString]; // Mask of Levitation (common)
            }
            else{
                [self randomColourPicker]; //choose a mask colour
                return [NSString stringWithFormat:@"%@ akaku", maskColorString]; //Mask of X-Ray Vision (common)
            }
        }
        else if (randomItem > 51){ //Great Masks
            int randomItem = arc4random_uniform(6);
            if (randomItem == 1){
                [self randomColourPicker]; //choose a mask colour
                return [NSString stringWithFormat:@"%@ matatu", maskColorString]; //Mask of Telekinesis (common)
            }
            else if (randomItem == 2){
                [self randomColourPicker]; //choose a mask colour
                return [NSString stringWithFormat:@"%@ rau", maskColorString]; // Infected Mask of Translation (common)
            }
            else if (randomItem == 3){
                [self randomColourPicker]; //choose a mask colour
                return [NSString stringWithFormat:@"%@ mahiki", maskColorString]; // Infected Mask of Illusion (common)
            }
            else if (randomItem == 4){
                [self randomColourPicker]; //choose a mask colour
                return [NSString stringWithFormat:@"%@ huna", maskColorString]; // Infected Mask of Concealment (common)
            }
            else if (randomItem == 5){
                [self randomColourPicker]; //choose a mask colour
                return [NSString stringWithFormat:@"%@ ruru", maskColorString]; // Infected Mask of Night Vision (common)
            }
            else{
                [self randomColourPicker]; //choose a mask colour
                return [NSString stringWithFormat:@"%@ komau", maskColorString]; //Mask of Mind Control (common)
            }
        }
        else{ //otherwise
            return @"brown rau"; //you get my favourite
        }
    }
    else{ //region locked bronze masks (uncommon, region specific)
        
        /*
         LATITUDE AND LONGITUDES (2 masks for each area, antarctica and other places get 1 as an extra):
        
        Oceania between lat 21 and lat -54 long 109 and long 180
        Africa between lat 37 and lat -37 long -20 and long 51
        Asia between lat 82 and lat -10.5 long 40 and long 180
        Europe between lat 82 and lat 33 long -13 and long 45 (only gets 1)
        North America between lat 84 and lat 13 long -180 and long -53
        South America between lat 12 and lat -58 long -27 and long -90
        */
        if(_theMap.userLocation.location.coordinate.latitude < 21.0 && _theMap.userLocation.location.coordinate.latitude > -54.0){
            if(_theMap.userLocation.location.coordinate.longitude < 180.0 && _theMap.userLocation.location.coordinate.longitude > 109.0){
                //these 2 met means we're in Oceania
                int randomItem = arc4random_uniform(2);
                if (randomItem == 1){
                    return @"bronze rau";
                }
                else{
                    return @"bronze kaukau";
                }
            }
            
        } //using ifs not if else because more than 1 may apply
        if(_theMap.userLocation.location.coordinate.latitude < 37.0 && _theMap.userLocation.location.coordinate.latitude > -37.0){
            if(_theMap.userLocation.location.coordinate.longitude < 51.0 && _theMap.userLocation.location.coordinate.longitude > -20.0){
                //these 2 met means we're in Africa
                int randomItem = arc4random_uniform(2);
                if (randomItem == 1){
                    return @"bronze hau";
                }
                else{
                    return @"bronze huna";
                }
            }
            
        }
        if(_theMap.userLocation.location.coordinate.latitude < 82.0 && _theMap.userLocation.location.coordinate.latitude > -10.5){
            if(_theMap.userLocation.location.coordinate.longitude < 180.0 && _theMap.userLocation.location.coordinate.longitude > 40.0){
                //these 2 met means we're in Asia
                int randomItem = arc4random_uniform(2);
                if (randomItem == 1){
                    return @"bronze kakama";
                }
                else{
                    return @"bronze komau";
                }
            }
            
        }
        if(_theMap.userLocation.location.coordinate.latitude < 82.0 && _theMap.userLocation.location.coordinate.latitude > 33.0){
            if(_theMap.userLocation.location.coordinate.longitude < 45.0 && _theMap.userLocation.location.coordinate.longitude > -13.0){
                //these 2 met means we're in Europe
                return @"bronze akaku";
            }
            
        }
        if(_theMap.userLocation.location.coordinate.latitude < 84.0 && _theMap.userLocation.location.coordinate.latitude > 13.0){
            if(_theMap.userLocation.location.coordinate.longitude < -53.0 && _theMap.userLocation.location.coordinate.longitude > -180.0){
                //these 2 met means we're in North America
                int randomItem = arc4random_uniform(2);
                if (randomItem == 1){
                    return @"bronze pakari";
                }
                else{
                    return @"bronze ruru";
                }
            }
            
        }
        if(_theMap.userLocation.location.coordinate.latitude < 12.0 && _theMap.userLocation.location.coordinate.latitude > -58.0){
            if(_theMap.userLocation.location.coordinate.longitude < -27.0 && _theMap.userLocation.location.coordinate.longitude > -90.0){
                //these 2 met means we're in South America
                int randomItem = arc4random_uniform(2);
                if (randomItem == 1){
                    return @"bronze miru";
                }
                else{
                    return @"bronze mahiki";
                }
            }
            
        }
        else{ //other random bits that got left out like Antarctica and maybe bits of the Pacific or Middle East...
            return @"bronze matatu";
        }
        

    }
    //return @"brown rau"; //you get my favourite
    return @"bronze matatu";//other random bits that got left out like Antarctica and maybe bits of the Pacific or Middle East...
    //don't know why I need this here but apparently theres some kind of trippy extra condition that this meets
    
}

-(NSString*)randomItemMaker{
    //itemList = [NSArray arrayWithObjects: @"Energised Protodermis", @"Vuata Maca fruit", @"Super Disk", @"Charged Fire Disk", @"Charged Water Disk", @"Charged Earth Disk", @"Charged Rock Disk", @"Charged Air Disk", @"Charged Ice Disk", nil]; //load up a list of items the player can find
    int randomItem = arc4random_uniform(20);
    if(randomItem < 13){ //healing items
        itemList = [NSArray arrayWithObjects: @"Vuata Maca fruit", @"Vuata Maca fruit", @"Energised Protodermis", @"Vuata Maca fruit",nil]; //load up a list of healing items (multipul of 1 to increase likelyhood of getting it, its a dumb way to do it but it works so bite me
        randomItem = arc4random_uniform((int)itemList.count);
        return itemList[randomItem]; //return a random greater rahi
    }
    else if (randomItem < 18){ //power disks
        itemList = [NSArray arrayWithObjects: @"Super Disk", @"Charged Fire Disk", @"Charged Water Disk", @"Charged Earth Disk", @"Charged Rock Disk", @"Charged Air Disk", @"Charged Ice Disk",nil]; //load up a list of rahi the player can encounter
        randomItem = arc4random_uniform((int)itemList.count);
        return itemList[randomItem]; //return a random greater rahi
    }
    else{ //rare item
        int randomItem = arc4random_uniform(2);
        if (randomItem == 1){
            return @"Cool looking rock"; //useless, but cool!
        }
        else{
            return @"Widget"; //Money for no reason at all.
        }
    }
}

-(NSString*)randomRahiMaker{
    //rahiList = [NSArray arrayWithObjects: @"Nui Rama", @"Nui Kopen", @"Nui Jaga", @"Kuma Nui", @"Tarakava", @"Manas", @"Mana Ko", @"Tarakava Nui", @"Muaka", @"Kane Ra", @"Fikou Nui",nil]; //load up a list of rahi the player can encounter
    int randomItem = arc4random_uniform(3);
    if(randomItem == 1){ //1 in three chance of getting a big rahi...
        randomItem = arc4random_uniform(20);
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
    else{ //otherwise, a small one
        randomItem = arc4random_uniform(5);
        if(randomItem == 1){
            return @"Fikou"; //spider
        }
        else if (randomItem == 2){
            return @"Jaga"; //scorpian
        }
        else if (randomItem == 3){
            return @"Hoi"; //turtle
        }
        else if (randomItem == 4){
            return @"Ngarere"; //bug
        }
        else{
            return @"Pekapeka"; //bat
        }
        
    }
}

-(void)randomColourPicker{ //chooses the colour of the mask
    
    int randomItem = arc4random_uniform(37); //work out colour
    
    //great mask colours
    if (randomItem == 1 || randomItem == 2  || randomItem == 19){ //black (common)
        maskColorString = @"black";
    }
    else if (randomItem == 3 || randomItem == 13 || randomItem == 20){ //red (common)
        maskColorString = @"red";
    }
    else if (randomItem == 6 || randomItem == 14 || randomItem == 21){ //brown (common)
        maskColorString = @"brown";
    }
    else if (randomItem == 8 || randomItem == 15 || randomItem == 22){ //white (common)
        maskColorString = @"white";
    }
    else if (randomItem == 10 || randomItem == 16 || randomItem == 23){ //green (common)
        maskColorString = @"green";
    }
    //noble colours
    else if (randomItem == 4 || randomItem == 24){ //orange (uncommon)
        maskColorString = @"orange";
    }
    else if (randomItem == 5 || randomItem == 25){ //light green (uncommon)
        maskColorString = @"light-green";
    }
    else if (randomItem == 7 || randomItem == 26){ //grey (uncommon)
        maskColorString = @"grey";
    }
    else if (randomItem == 9 || randomItem == 27){ //dark brown (uncommon)
        maskColorString = @"dark-brown";
    }
    else if (randomItem == 17 || randomItem == 28){ //light blue (uncommon)
        maskColorString = @"light-blue";
    }
    else if (randomItem == 18 || randomItem == 29){ //yellow (uncommon)
        maskColorString = @"tan";
    }
    else if (randomItem == 30){ //bright yellow (lesser rare)
        maskColorString = @"yellow";
    }
    else if (randomItem == 31){ //purple (lesser rare)
        maskColorString = @"purple";
    }
    else if (randomItem == 32){ //bright yellow (lesser rare)
        maskColorString = @"dark-grey";
    }
    else if (randomItem == 33){ //cyan (lesser rare)
        maskColorString = @"cyan";
    }
    //metalics
    
    else if (randomItem == 11){ //silver (lesser rare)
        maskColorString = @"silver";
    }
    else if (randomItem == 12){ //gold (lesser rare)
        maskColorString = @"gold";
    }
    
    //great mask blue
    else{ //blue
        maskColorString = @"blue";// (common)
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





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //[self removeFromParentViewController];
    //[self dealloc];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}




@end
