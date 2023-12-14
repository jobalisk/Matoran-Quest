//
//  individualMaskController.m
//  Matoran Quest
//
//  Created by Job Dyer on 12/11/23.
//

#import "individualMaskController.h"

@interface individualMaskController ()

@end

@implementation individualMaskController

NSString *theCode; //holds the mask trading code
int theMaskCode; //holds an int value for the mask
NSMutableArray *maskArray9;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //NSLog(@"%@", _maskDetailsArray);
    
    //add detail text to mask names
    maskArray9 = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMasks"];
    NSString *finalNameString;
    [_tradeButton setHidden:false];
    if(maskArray9.count < 2){ //if there is only one mask availible to trade
        //hide the option to trade until there are at least 2 masks
        [_tradeButton setHidden:true];
    }
    
    if ([_maskDetailsArray[0] containsString:@"infected hau"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"This Kanohi has been\ncorrupted by the Makuta"];
        theMaskCode = 0;
    }
    else if ([_maskDetailsArray[0] containsString:@"hau"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Great Kanohi of Shielding"];
        theMaskCode = 1;
    }
    else if ([_maskDetailsArray[0] containsString:@"miru"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Great Kanohi of Levitation"];
        theMaskCode = 2;
    }
    else if ([_maskDetailsArray[0] containsString:@"kaukau"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Great Kanohi of Water Breathing"];
        theMaskCode = 3;
    }
    else if ([_maskDetailsArray[0] containsString:@"kakama"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Great Kanohi of Speed"];
        theMaskCode = 4;
    }
    else if ([_maskDetailsArray[0] containsString:@"akaku"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Great Kanohi of X-Ray Vision"];
        theMaskCode = 5;
    }
    else if ([_maskDetailsArray[0] containsString:@"pakari"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Great Kanohi of Strength"];
        theMaskCode = 6;
    }
    else if ([_maskDetailsArray[0] containsString:@"huna"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Noble Kanohi of Concealment"];
        theMaskCode = 7;
    }
    else if ([_maskDetailsArray[0] containsString:@"rau"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Noble Kanohi of Translation"];
        theMaskCode = 8;
    }
    else if ([_maskDetailsArray[0] containsString:@"ruru"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Noble Kanohi of Night Vision"];
        theMaskCode = 9;
    }
    else if ([_maskDetailsArray[0] containsString:@"mahiki"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Noble Kanohi of Illusion"];
        theMaskCode = 10;
    }
    else if ([_maskDetailsArray[0] containsString:@"matatu"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Noble Kanohi of Telekinesis"];
        theMaskCode = 11;
    }
    else if ([_maskDetailsArray[0] containsString:@"komau"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Noble Kanohi of Mind Control"];
        theMaskCode = 12;
    }
    else if ([_maskDetailsArray[0] containsString:@"vahi"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Legendary Mask of Time"];
        theMaskCode = 13;
    }
    else if ([_maskDetailsArray[0] containsString:@"avohkii"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Great Kanohi of Light"];
        theMaskCode = 14;
    }
    else{
        finalNameString = _maskDetailsArray[0];
    }

    
    
    [_maskName setText:[NSString stringWithFormat:@"%@", finalNameString]];
    [_maskCatcher setText:[NSString stringWithFormat:@"%@", _maskDetailsArray[1]]];
    [_maskLat setText:[NSString stringWithFormat:@"%@", _maskDetailsArray[2]]];
    [_maskLong setText:[NSString stringWithFormat:@"%@", _maskDetailsArray[3]]];
    
    
    [_maskPortrait setImage: _maskImage];
}

-(void)viewDidAppear:(BOOL)animated{
    //[[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait]forKey:@"orientation"];//set the controller to be portrait
}

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

- (void)tradeButtonPressed:(nonnull id)sender __attribute__((ibaction)) {
    //when pressed, this will attept to initiate a blu-tooth connection
    
    UIAlertController *tradeAlert = [UIAlertController alertControllerWithTitle:@"Are you sure?"
                   message:@"Press yes to trade this mask with a nearby friend over via a code.\nThe kanohi mask will be removed from your inventory.\nIt might be difficult to get this mask back again afterwards."
                   preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * action) {
        //do the trade
        [self CodeMaker]; //make the code
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard]; //copy the code to the clipboard
        pasteboard.string = theCode;
        
        //remove the item from the masks list and minus 1 off of the collected masks list
        NSMutableArray *maskArray8 = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMasks"];
        maskArray8 = [maskArray8 mutableCopy];
        for (int i = 0; i <= (maskArray9.count -1); i++) //sift through the list to find the mask we just traded...
        {
            NSArray *testMask = maskArray8[i];
            if([testMask[0] isEqualToString:self.maskDetailsArray[0]]){ //do we have the same name and colour
                if([testMask[1] isEqualToString:self.maskDetailsArray[1]]){ //do we have the same catcher name
                    
                    [maskArray8 removeObjectAtIndex:i];
                    [[NSUserDefaults standardUserDefaults] setObject: maskArray8 forKey:@"PlayerMasks"]; //resave the array
                    break; //stop the loop here!
                }
            }
        }
         
        //present another alert once the first alert has finished
        UIAlertController *completionAlert = [UIAlertController alertControllerWithTitle:@"Your Code:"
                       message:[NSString stringWithFormat:@"Here is your code: %@\nIt has been copied to your clipboard.", theCode]
                       preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* defaultAction2 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
            
            //final alert, this one is for recieveing a kanohi mask from a friend.
            
            UIAlertController *recieveTradeAlert = [UIAlertController alertControllerWithTitle:@"Receive a Kanohi Mask:"
                           message:@"If you have received a code in return, enter it here:/nIf not, or after entering the code/npress OK to end the trade."
                           preferredStyle:UIAlertControllerStyleAlert];
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectZero];
            textView.translatesAutoresizingMaskIntoConstraints = NO;

            NSLayoutConstraint *leadConstraint = [NSLayoutConstraint constraintWithItem:recieveTradeAlert.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:textView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-8.0];
            NSLayoutConstraint *trailConstraint = [NSLayoutConstraint constraintWithItem:recieveTradeAlert.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:textView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:8.0];

            NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:recieveTradeAlert.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:textView attribute:NSLayoutAttributeTop multiplier:1.0 constant:-64.0];
            NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:recieveTradeAlert.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:textView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:64.0];
            [recieveTradeAlert.view addSubview:textView];
            [NSLayoutConstraint activateConstraints:@[leadConstraint, trailConstraint, topConstraint, bottomConstraint]];

            [recieveTradeAlert addAction: [UIAlertAction actionWithTitle:@"OK"style:UIAlertActionStyleDefault handler:^(UIAlertAction*action) {
                //handle what we need to do with the text
                if (textView.text && textView.text.length > 0)
                {
                    [self CodeBreaker: textView.text];
                }
                else
                {
                   //the text field is empty so just return to the masks view
                    [self performSegueWithIdentifier:@"BackToWallOfMasks" sender:self];
                }
            }]];

            [self presentViewController:recieveTradeAlert animated:YES completion:nil]; //run the alert
            
            
            
        }];
        [completionAlert addAction:defaultAction2];
        [self presentViewController:completionAlert animated:YES completion:nil]; //run the alert

    }];
    [tradeAlert addAction:defaultAction];

    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel
    handler:^(UIAlertAction * action) {}];

    [tradeAlert addAction:cancelAction];

    [self presentViewController:tradeAlert animated:YES completion:nil]; //run the alert
        
}

-(void)CodeMaker{
    //create a code for the specific kanohi mask
    theCode = @"";
    NSString *theName = _maskDetailsArray[1]; //save the name
    float theLong = [_maskDetailsArray[3] floatValue]; //save the longitude divided in 2
    theLong = theLong /2;
    float theLat = [_maskDetailsArray[2] floatValue];//save the latitude divided in 2
    theLat = theLat / 2;
    NSString *theColour = @"";
    theMaskCode = theMaskCode * 3; //multiply the code by 3
    //assign letters to colours
    if ([_maskDetailsArray[0] containsString:@"black"]) {
        theColour = @"a";
    }
    else if ([_maskDetailsArray[0] containsString:@"red"]) {
        theColour = @"b";
    }
    else if ([_maskDetailsArray[0] containsString:@"brown"]) {
        theColour = @"c";
    }
    else if ([_maskDetailsArray[0] containsString:@"white"]) {
        theColour = @"d";
    }
    else if ([_maskDetailsArray[0] containsString:@"green"]) {
        theColour = @"e";
    }
    else if ([_maskDetailsArray[0] containsString:@"orange"]) {
        theColour = @"f";
    }
    else if ([_maskDetailsArray[0] containsString:@"light-green"]) {
        theColour = @"g";
    }
    else if ([_maskDetailsArray[0] containsString:@"grey"]) {
        theColour = @"h";
    }
    else if ([_maskDetailsArray[0] containsString:@"dark-brown"]) {
        theColour = @"i";
    }
    else if ([_maskDetailsArray[0] containsString:@"light-blue"]) {
        theColour = @"j";
    }
    else if ([_maskDetailsArray[0] containsString:@"tan"]) {
        theColour = @"k";
    }
    else if ([_maskDetailsArray[0] containsString:@"yellow"]) {
        theColour = @"l";
    }
    else if ([_maskDetailsArray[0] containsString:@"purple"]) {
        theColour = @"m";
    }
    else if ([_maskDetailsArray[0] containsString:@"dark-grey"]) {
        theColour = @"n";
    }
    else if ([_maskDetailsArray[0] containsString:@"cyan"]) {
        theColour = @"o";
    }
    else if ([_maskDetailsArray[0] containsString:@"silver"]) {
        theColour = @"p";
    }
    else if ([_maskDetailsArray[0] containsString:@"gold"]) {
        theColour = @"q";
    }
    else if ([_maskDetailsArray[0] containsString:@"blue"]) {
        theColour = @"r";
    }
    else if ([_maskDetailsArray[0] containsString:@"bronze"]) {
        theColour = @"t";
    }
    else{
        theColour = @"s"; //special masks

    }

    //sort out the unique identifier of the phone:
    int uniqueIdentifier2 = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"UniquePhoneIdentifier"];
    if(uniqueIdentifier2 == 0){ //if this hasn't been set properly (or if it just randomly ended up as 0...)
        uniqueIdentifier2 = arc4random_uniform(100000); //generate a new number
        [[NSUserDefaults standardUserDefaults] setInteger:uniqueIdentifier2 forKey:@"UniquePhoneIdentifier"];
    }
    
    //get the time since 1970 as an interger
    NSTimeInterval timeSince19700 = [[NSDate date] timeIntervalSince1970];
    int timeSince19701 = (int)timeSince19700;
    
    
    theCode = [NSString stringWithFormat:@"%@#%.2fQ%.2fZ%dJ%@!%d?%d&13", theName, theLong, theLat, theMaskCode, theColour, uniqueIdentifier2, timeSince19701];
    //NSLog(@"Code: %@", theCode);
    
}

-(void)CodeBreaker: (NSString *)theCodeToBreak{
    //first up, check if the code has been recieved before:
    NSMutableArray *collectedCodes = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerCollectedKanohiCodes"];
    collectedCodes = [collectedCodes mutableCopy];
    if(collectedCodes == NULL){ //if there is no player masks collection key yet
        collectedCodes = [[NSMutableArray alloc] init];
        //NSLog(@"refreshing2");
        [[NSUserDefaults standardUserDefaults] setObject:collectedCodes forKey:@"PlayerCollectedKanohiCodes"]; //set it if it doesnt exist
        
    }
    if([collectedCodes indexOfObject:theCodeToBreak]==NSNotFound){
        [collectedCodes addObject:theCodeToBreak];
        [[NSUserDefaults standardUserDefaults] setObject:collectedCodes forKey:@"PlayerCollectedKanohiCodes"]; 
        
        bool errorFlag = false; //this flag will be raised if we detect a invalid code later in the code(not the initial check)
        NSString *theCodeToBreak2 = @""; //a temp store for the code as its broken down
        //break a code and generate a kanohi mask with details
        NSArray *SplitCode; //for sorting through the code peice by peice
        //the various components of the code
        NSString *catcherDeets = @"";
        float longDeets = 0.00;
        float latDeets = 0.00;
        int maskNameDeets1 = 0;
        int theDate1 = 0;
        int theDate2 = (int)[[NSDate date] timeIntervalSince1970]; //comparing against now
        NSString *maskNameDeets2 = @"";
        NSString *maskColourDeets = @"";
        int uniqueIdentifierDeets = 0;
        int uniqueIdentifier3 = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"UniquePhoneIdentifier"];
        //NSLog(@"The Code: %@", theCodeToBreak);
        if([theCodeToBreak containsString: [NSString stringWithFormat:@"%d", uniqueIdentifier3]]){
            UIAlertController *heyYouCheaterAlert = [UIAlertController alertControllerWithTitle:@"Error: 1"
                                                                                        message:@"You cannot trade masks with yourself!"
                                                                                 preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction4 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action) {
                [self performSegueWithIdentifier:@"BackToWallOfMasks" sender:self];
            }];
            [heyYouCheaterAlert addAction:defaultAction4];
            
            [self presentViewController:heyYouCheaterAlert animated:YES completion:nil]; //run the alert
            
        }
        else{
            @try {
                
                //try to spit the code up. If it fails somehow then the catcher will show this up as an invalid code
                theCodeToBreak2 = theCodeToBreak;
                SplitCode = [theCodeToBreak2 componentsSeparatedByString:@"#"]; //break off the name of the catcher
                catcherDeets = SplitCode[0]; //catcher name
                theCodeToBreak2 = SplitCode[1]; //rest of code
                SplitCode = [theCodeToBreak2 componentsSeparatedByString:@"Q"]; //break off the long
                longDeets = [SplitCode[0] floatValue]; //long
                longDeets = longDeets * 2; //multiply it back again
                theCodeToBreak2 = SplitCode[1]; //the rest of the code
                SplitCode = [theCodeToBreak2 componentsSeparatedByString:@"Z"]; //break off the lat
                latDeets = [SplitCode[0] floatValue]; //lat
                latDeets = latDeets * 2; //multiply back to origonal value
                theCodeToBreak2 = SplitCode[1]; //rest of code
                SplitCode = [theCodeToBreak2 componentsSeparatedByString:@"J"]; //break off the mask name
                maskNameDeets1 = [SplitCode[0] intValue]; //mask name
                maskNameDeets1 = maskNameDeets1 / 3; //divide the name code back to its origonal value
                theCodeToBreak2 = SplitCode[1]; //rest of code
                SplitCode = [theCodeToBreak2 componentsSeparatedByString:@"!"]; //break off the mask name
                maskColourDeets =  SplitCode[0]; //mask colour code
                theCodeToBreak2 = SplitCode[1]; //rest of code
                SplitCode = [theCodeToBreak2 componentsSeparatedByString:@"?"]; //break off the mask name
                uniqueIdentifierDeets = [SplitCode[0] intValue]; //mask colour code
                theCodeToBreak2 = SplitCode[1]; //rest of code
                SplitCode = [theCodeToBreak2 componentsSeparatedByString:@"&"]; //break off the time stamp
                theDate1 = [SplitCode[0] intValue]; //time stamp
                
                
                
                //start working out the meaning of the mask codes
                //mask colour
                if ([maskColourDeets containsString:@"a"]) {
                    maskColourDeets = @"black";
                }
                else if ([maskColourDeets containsString:@"b"]) {
                    maskColourDeets = @"red";
                }
                else if ([maskColourDeets containsString:@"c"]) {
                    maskColourDeets = @"brown";
                }
                else if ([maskColourDeets containsString:@"d"]) {
                    maskColourDeets = @"white";
                }
                else if ([maskColourDeets containsString:@"e"]) {
                    maskColourDeets = @"green";
                }
                else if ([maskColourDeets containsString:@"f"]) {
                    maskColourDeets = @"orange";
                }
                else if ([maskColourDeets containsString:@"g"]) {
                    maskColourDeets = @"light-green";
                }
                else if ([maskColourDeets containsString:@"h"]) {
                    maskColourDeets = @"grey";
                }
                else if ([maskColourDeets containsString:@"i"]) {
                    maskColourDeets = @"dark-brown";
                }
                else if ([maskColourDeets containsString:@"j"]) {
                    maskColourDeets = @"light-blue";
                }
                else if ([maskColourDeets containsString:@"k"]) {
                    maskColourDeets = @"tan";
                }
                else if ([maskColourDeets containsString:@"l"]) {
                    maskColourDeets = @"yellow";
                }
                else if ([maskColourDeets containsString:@"m"]) {
                    maskColourDeets = @"purple";
                }
                else if ([maskColourDeets containsString:@"n"]) {
                    maskColourDeets = @"dark-grey";
                }
                else if ([maskColourDeets containsString:@"o"]) {
                    maskColourDeets = @"cyan";
                }
                else if ([maskColourDeets containsString:@"p"]) {
                    maskColourDeets = @"silver";
                }
                else if ([maskColourDeets containsString:@"q"]) {
                    maskColourDeets = @"gold";
                }
                else if ([maskColourDeets containsString:@"r"]) {
                    maskColourDeets = @"blue";
                }
                else if ([maskColourDeets containsString:@"s"]) {
                    maskColourDeets = @"";
                }
                else if ([maskColourDeets containsString:@"t"]) {
                    maskColourDeets = @"bronze";
                }
                else{
                    errorFlag = true; //error found
                }
                if(errorFlag == false){
                    //mask name (these numbers are found at the top of this file
                    if (maskNameDeets1 == 0) {
                        maskNameDeets2 = @"infected hau";
                    }
                    else if (maskNameDeets1 == 1) {
                        maskNameDeets2 = @"hau";
                    }
                    else if (maskNameDeets1 == 2) {
                        maskNameDeets2 = @"miru";
                    }
                    else if (maskNameDeets1 == 3) {
                        maskNameDeets2 = @"kaukau";
                    }
                    else if (maskNameDeets1 == 4) {
                        maskNameDeets2 = @"kakama";
                    }
                    else if (maskNameDeets1 == 5) {
                        maskNameDeets2 = @"akaku";
                    }
                    else if (maskNameDeets1 == 6) {
                        maskNameDeets2 = @"pakari";
                    }
                    else if (maskNameDeets1 == 7) {
                        maskNameDeets2 = @"huna";
                    }
                    else if (maskNameDeets1 == 8) {
                        maskNameDeets2 = @"rau";
                    }
                    else if (maskNameDeets1 == 9) {
                        maskNameDeets2 = @"ruru";
                    }
                    else if (maskNameDeets1 == 10) {
                        maskNameDeets2 = @"mahiki";
                    }
                    else if (maskNameDeets1 == 11) {
                        maskNameDeets2 = @"matatu";
                    }
                    else if (maskNameDeets1 == 12) {
                        maskNameDeets2 = @"komau";
                    }
                    else if (maskNameDeets1 == 13) {
                        maskNameDeets2 = @"vahi";
                    }
                    else if (maskNameDeets1 == 14) {
                        maskNameDeets2 = @"avohkii";
                    }
                    else{
                        errorFlag = true; //error found
                    }
                    if(errorFlag == false){
                        int checkerNumber = theDate2 - theDate1; //work out the difference in seconds between when the code was generated and when the code was redeemed.
                        if(checkerNumber > 86400 || checkerNumber < 0){
                            //if its been more than 24 hours or less than the current time...
                            UIAlertController *heyYouCheaterAlert = [UIAlertController alertControllerWithTitle:@"Error: 3"
                                                                                                        message:@"Your code is no longer valid.\nYou must redeem your code with 24 hours."
                                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                            
                            UIAlertAction* defaultAction4 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                   handler:^(UIAlertAction * action) {
                                [self performSegueWithIdentifier:@"BackToWallOfMasks" sender:self];
                            }];
                            [heyYouCheaterAlert addAction:defaultAction4];
                            
                            [self presentViewController:heyYouCheaterAlert animated:YES completion:nil]; //run the alert
                        }
                    }
                    if(errorFlag == false){
                        
                        //now we have the name, colour, catcher and all other details, we can construct the mask
                        NSMutableArray * newMaskFreshFromTheForge = [[NSMutableArray alloc] init]; //make the new mask from a fresh disk
                        NSString *maskNameAndColourSetting;
                        if([maskColourDeets isEqualToString: @""]){ //check for special masks
                            maskNameAndColourSetting = maskNameDeets2;
                        }
                        else{
                            maskNameAndColourSetting = [NSString stringWithFormat: @"%@ %@", maskColourDeets, maskNameDeets2];
                        }
                        [newMaskFreshFromTheForge addObject:maskNameAndColourSetting]; //add a name and colour
                        [newMaskFreshFromTheForge addObject:catcherDeets]; //add a catcher
                        [newMaskFreshFromTheForge addObject:[NSString stringWithFormat:@"%f", latDeets]]; //add a latitude
                        [newMaskFreshFromTheForge addObject:[NSString stringWithFormat:@"%f", longDeets]]; //add a longitude
                        
                        //now add it to the relevent arrays
                        
                        NSMutableArray *collectedMasks4 = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMaskCollectionList"]; //get a list of collected mask types
                        collectedMasks4 = [collectedMasks4 mutableCopy];
                        if([collectedMasks4 indexOfObject:maskNameAndColourSetting]==NSNotFound){ //if the mask is not in the list of collected masks, add it!
                            [collectedMasks4 addObject:maskNameAndColourSetting];
                            NSLog(@"Mask Not in collection");
                            [[NSUserDefaults standardUserDefaults] setObject:collectedMasks4 forKey:@"PlayerMaskCollectionList"]; //add the mask to the collection
                        }
                        NSMutableArray *maskArray7 = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMasks"];
                        maskArray7 = [maskArray7 mutableCopy];

                        [maskArray7 addObject:newMaskFreshFromTheForge];
                        [[NSUserDefaults standardUserDefaults] setObject: maskArray7 forKey:@"PlayerMasks"]; //save the new mask array back to user defaults
                        UIAlertController *maskAddedAlert = [UIAlertController alertControllerWithTitle:@"New Kanohi Mask Received!"
                                                                                                message:[NSString stringWithFormat: @"You have just received a %@", maskNameAndColourSetting]
                                                                                         preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* defaultAction6 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                               handler:^(UIAlertAction * action) {
                            [self performSegueWithIdentifier:@"BackToWallOfMasks" sender:self];
                        }];
                        [maskAddedAlert addAction:defaultAction6];
                        
                        [self presentViewController:maskAddedAlert animated:YES completion:nil]; //run the alert
                    }
                    
                }
                if(errorFlag == true){ //handle errors in the given code
                    [self error2Message];
                }
                
            }
            @catch (NSException *exception) {
                [self error2Message];
            }
            @finally {
                //Display Alternative
            }
        }
    }
    else{ //if the user is trying to re-redeem a code...
        UIAlertController *heyYouCheaterAlert4 = [UIAlertController alertControllerWithTitle:@"Error: 4"
                                                                                message:@"You cannot redeem a Kanohi Mask Code more than once!"
                                                                         preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction7 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
            [self performSegueWithIdentifier:@"BackToWallOfMasks" sender:self];
        }];
        [heyYouCheaterAlert4 addAction:defaultAction7];
        
        [self presentViewController:heyYouCheaterAlert4 animated:YES completion:nil]; //run the alert
    }
}


-(void)error2Message{ //if you have typed an invalid responce
    UIAlertController *heyYouCheaterAlert2 = [UIAlertController alertControllerWithTitle:@"Error: 2"
                   message:@"You code is invalid!"
                   preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction5 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
        UIAlertController *recieveTradeAlert = [UIAlertController alertControllerWithTitle:@"Receive a Kanohi Mask:"
                       message:@"If you have received a code in return, enter it here:/nIf not, or after entering the code/npress OK to end the trade."
                       preferredStyle:UIAlertControllerStyleAlert];
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectZero];
        textView.translatesAutoresizingMaskIntoConstraints = NO;

        NSLayoutConstraint *leadConstraint = [NSLayoutConstraint constraintWithItem:recieveTradeAlert.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:textView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-8.0];
        NSLayoutConstraint *trailConstraint = [NSLayoutConstraint constraintWithItem:recieveTradeAlert.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:textView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:8.0];

        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:recieveTradeAlert.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:textView attribute:NSLayoutAttributeTop multiplier:1.0 constant:-64.0];
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:recieveTradeAlert.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:textView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:64.0];
        [recieveTradeAlert.view addSubview:textView];
        [NSLayoutConstraint activateConstraints:@[leadConstraint, trailConstraint, topConstraint, bottomConstraint]];

        [recieveTradeAlert addAction: [UIAlertAction actionWithTitle:@"OK"style:UIAlertActionStyleDefault handler:^(UIAlertAction*action) {
            //handle what we need to do with the text
            if (textView.text && textView.text.length > 0)
            {
                [self CodeBreaker: textView.text];
            }
            else
            {
               //the text field is empty so do nothing
            }
        }]];

        [self presentViewController:recieveTradeAlert animated:YES completion:nil]; //run the alert
    }];
    [heyYouCheaterAlert2 addAction:defaultAction5];

    [self presentViewController:heyYouCheaterAlert2 animated:YES completion:nil]; //run the alert
}

@end
