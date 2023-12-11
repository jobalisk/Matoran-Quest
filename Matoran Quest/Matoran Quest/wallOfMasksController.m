//
//  wallOfMasksController.m
//  Matoran Quest
//
//  Created by Job Dyer on 12/11/23.
//

#import "wallOfMasksController.h"
#import "Celler1.h"

@interface wallOfMasksController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>

@end

@implementation wallOfMasksController

int totalMasksInGame = 231; //the total findable mask variations in the game
NSMutableArray *maskArray; //our mask array
NSArray *selectedMaskArray; //the mask we want to know more about
UIImage *maskImage2; //the colourized mask image
UIImage *outPutMask; //the mask we take to the individual mask viewer
NSMutableArray *imagesInCollection; //an array of all the images
NSMutableArray *collectedMasks2; //a list of the kinds of masks the player has collected. 1 entry for each unique kind of mask (colour as well as type)
NSMutableArray *backUpMasksList; //for refering to while using the search bar
NSMutableArray *noDuplicateMasksList; //for only showing one of each type found
int maskDisplayingCheck2 = 1;

- (void)viewDidLoad {
    [super viewDidLoad];
    maskArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMasks"]; //get the players masks from the user defaults and make an array of them
    maskArray = [maskArray mutableCopy];
    backUpMasksList = [[NSMutableArray alloc] init]; //make a duplicate mask array
    backUpMasksList = maskArray;
    noDuplicateMasksList = [[NSMutableArray alloc] init]; //initialize this one too
    noDuplicateMasksList = maskArray;
    maskDisplayingCheck2 = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"showKanohiCollectionSetting"];
    //NSLog(@"monkey: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMasks"]);
    _maskGrid.delegate = self;
    _maskGrid.dataSource = self;
    //NSLog(@"%@", maskArray);
    [_maskCount setText:[NSString stringWithFormat:@"Kanohi found: %d", (int)maskArray.count]]; // how many masks do we have?
    imagesInCollection = [[NSMutableArray alloc] init];
    
    collectedMasks2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMaskCollectionList"];
    collectedMasks2 = [collectedMasks2 mutableCopy];
    if(collectedMasks2 == NULL){ //if there is no player masks collection key yet
        collectedMasks2 = [[NSMutableArray alloc] init];
        //NSLog(@"refreshing2");
        [[NSUserDefaults standardUserDefaults] setObject:collectedMasks2 forKey:@"PlayerMaskCollectionList"]; //set it if it doesnt exist
        
    }
 
    
    
    //set up search bar
    _searchBar1.showsCancelButton=TRUE;
    _searchBar1.delegate = self;
    
    
    //check through collected masks and remove any that are no longer present in the masks array due to trading
    int findersFlag = 0; //check to make sure we still have a mask of this type in our inventory
    NSString *testMaskNameAndColour;
    for (int i = 0; i <= (collectedMasks2.count -1); i++)
    {
        findersFlag = 0;
        testMaskNameAndColour = collectedMasks2[i];
        //NSLog(@"mask: %@", testMaskNameAndColour);
        for (int j = 0; j <= (maskArray.count -1); j++)
        {
            NSArray *testMask2 = maskArray[j];
            //NSLog(@"mask2: %@", testMask2[0]);
            if([testMaskNameAndColour isEqualToString:testMask2[0]]){ //do we have the same name and colour
                findersFlag = 1;
                //NSLog(@"match!: %@", testMaskNameAndColour);
            }
        }
        if(findersFlag == 0){
            //NSLog(@"%@ is not present", testMaskNameAndColour);
            
            [collectedMasks2 removeObjectAtIndex:i];
            [[NSUserDefaults standardUserDefaults] setObject: collectedMasks2 forKey:@"PlayerMaskCollectionList"]; //resave the array
             
        }
    }
    [_collectionCount setText:[NSString stringWithFormat: @"Collection: %d/%d", (int)collectedMasks2.count, totalMasksInGame]];

}


- (nonnull __kindof Celler1 *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //NSLog(@"Got this far");
    Celler1 *cell3 = [_maskGrid dequeueReusableCellWithReuseIdentifier:@"Celler1" forIndexPath:indexPath];
    //[cell1.customLabel setText:itemArray[indexPath.row]];
    //make a label
    //UILabel *itemName = [[UILabel alloc]initWithFrame:CGRectMake(91, 15, 0, 0)];
    //
    
    NSMutableArray *maskInterior = [maskArray objectAtIndex:indexPath.row]; //get the mask list to get out the name of the mask
    //NSLog(@"%@", maskInterior)
    maskInterior = [maskInterior mutableCopy];
    NSString *maskNameAndColour = maskInterior[0];
    NSArray *maskColourAndName; //array of seperated name and colour
    NSString *maskName;
    int noColourFlag = 0; //check if mask is special and skip colourizing
    
    //fix colour name issues by replacing old colour names with new ones:
    /*
    maskColourAndName = [maskNameAndColour componentsSeparatedByString:@" "];
    NSMutableArray *maskColourAndName2 = [maskColourAndName mutableCopy];
    
    if([maskColourAndName2[0] isEqualToString: @"yellow"]){
        maskInterior[0] = [NSString stringWithFormat: @"tan %@", maskColourAndName[1]];
        NSLog(@"%@", maskInterior);
        maskArray[indexPath.row] = maskInterior;
        
        for (int i = 0; i <= (collectedMasks2.count -1); i++)
        {
            if([collectedMasks2[i] isEqualToString: @"yellow"]){
                collectedMasks2[i] = @"tan";
                [[NSUserDefaults standardUserDefaults] setObject:collectedMasks2 forKey:@"PlayerMaskCollectionList"];
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:maskArray forKey:@"PlayerMasks"];
    }
    
    if([maskColourAndName2[0] isEqualToString: @"bright-yellow"]){
        maskInterior[0] = [NSString stringWithFormat: @"yellow %@", maskColourAndName[1]];
        NSLog(@"%@", maskInterior);
        maskArray[indexPath.row] = maskInterior;
        
        for (int i = 0; i <= (collectedMasks2.count -1); i++)
        {
            if([collectedMasks2[i] isEqualToString: @"bright-yellow"]){
                collectedMasks2[i] = @"yellow";
                [[NSUserDefaults standardUserDefaults] setObject:collectedMasks2 forKey:@"PlayerMasks"];
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:maskArray forKey:@"PlayerMaskCollectionList"];
        
    }

    //NSLog(@"masks: %@", collectedMasks2);
      */
    
    //continue on with the regularly scheduled program
        
    if([maskNameAndColour isEqualToString: @"vahi"]){ //seperate things out if needed
        //NSLog(@"check");
        maskName = @"vahi";
        noColourFlag = 1;
    }
    else if([maskNameAndColour isEqualToString: @"avohkii"]){
        //NSLog(@"check");
        maskName = @"avohkii";
        noColourFlag = 1;
    }
    else if([maskNameAndColour isEqualToString: @"infected hau"]){
        //NSLog(@"check");
        maskName = @"infected hau";
        noColourFlag = 1;
    }

    else{
        //NSLog(@"then do");
        maskColourAndName = [maskNameAndColour componentsSeparatedByString:@" "];
        maskName = maskColourAndName[1];
    }
    /*
    //check and replace problem names (legacy). this will cause the app to crash if the string does not have a hyphen added
    if([maskNameAndColour containsString:@"light green"]){
        [maskInterior replaceObjectAtIndex:0 withObject:@"light green"];
        [maskArray replaceObjectAtIndex:indexPath.row withObject:maskInterior];
    }
    */
    
    
    if(noColourFlag == 0){ //if its not a special flag, then colourize it
        UIColor *tempColor = [self colourCaser: maskColourAndName[0]]; //colour the image
        maskImage2 = [UIImage imageNamed:[NSString stringWithFormat: @"%@", maskName]];
        //[maskImage2 imageWithTintColor:tempColor];
        maskImage2 = [self colorizeImage:maskImage2 color:tempColor];
        [cell3.maskImage5 setImage:maskImage2]; //set an image with a colour
        [maskImage2 setAccessibilityIdentifier: maskNameAndColour];
        if(maskImage2 != nil){
            [imagesInCollection addObject: maskImage2];
        }
        else{
            NSLog(@"adding to collection error");
        }
        //NSLog(@"%@", imagesInCollection);
    }
    else{
        [cell3.maskImage5 setImage:[UIImage imageNamed:[NSString stringWithFormat: @"%@", maskName]]]; //get the image named the name of the mask without the colour
    }

    //[cell3 addSubview:cell3.maskImage];//Add it to the view of your choice.
    
   //cell3.maskName5 =[[UILabel alloc]initWithFrame:CGRectMake(25, 70, 50, 50)];//Set frame of label in your view
    //[itemName setBackgroundColor:[UIColor lightGrayColor]];//Set background color of label.

    @try {
        [cell3.maskName5  setText: [NSString stringWithFormat: @"%@",maskNameAndColour]];
    }
    @catch (NSException *exception) {
        [cell3.maskName5  setText: @""];
    }
    @finally {
      //Display Alternative
    }
    //NSLog(@"here: %@", maskArray);
    
    //[maskName setText: @"mask"];

     
    
    
    return cell3;
    
}



- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return maskArray.count;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:   (UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100, 100);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{ //tap brings up delete dialog
    //NSLog(@"Tapped %d", (int)indexPath.row);
    selectedMaskArray = maskArray[indexPath.row]; //assign the new mask to a temporary holding cell
    for (int i = 0; i <= (imagesInCollection.count -1); i++)
    {
        UIImage *tempImage = imagesInCollection[i]; //some technical wizardry to get the correct mask and colour displaying in the individual mask display screen
        //NSLog(@"A: %@", maskName);
        //NSLog(@"B: %@", tempImage.accessibilityIdentifier);
        if([tempImage.accessibilityIdentifier isEqualToString: selectedMaskArray[0]] ){
            outPutMask = tempImage;
        }
        if([selectedMaskArray[0]containsString:@"infected hau"]){
            outPutMask = [UIImage imageNamed:@"infected hau"];
        }
        else if([selectedMaskArray[0]containsString:@"avohkii"]){
            outPutMask = [UIImage imageNamed:@"avohkii"];
        }
        else if([selectedMaskArray[0]containsString:@"vahi"]){
            outPutMask = [UIImage imageNamed:@"vahi"];
        }
        
    }
    
    [self performSegueWithIdentifier:@"selectedMask" sender:self];
}

//colourizing methods

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

-(UIColor *)colourCaser:(NSString *)theColor { //takes a mask and works out what shade to colour it using colourizeimage
    float redColour = 0.0;
    float blueColour = 0.0;
    float greenColour = 0.0;
    float alphaColour = 1.0;
    if ([theColor isEqualToString:@"bronze"]){
        //r175 g112 b38
        redColour = 175.0;
        greenColour = 112.0;
        blueColour = 38.0;
    }
    else if ([theColor isEqualToString:@"silver"]){
        //r197 g205 b211
        redColour = 197.0;
        blueColour = 211.0;
        greenColour = 205.0;
        
    }
    else if ([theColor isEqualToString:@"gold"]){
        //r206 g180 b59
        redColour = 206.0;
        blueColour = 59.0;
        greenColour = 180.0;
    }
    else if ([theColor isEqualToString:@"red"]){
        //r255 g0 b0
        redColour = 255.0;
        blueColour = 0.0;
        greenColour = 0.0;
    }
    else if ([theColor isEqualToString:@"green"]){
        //r0 g129 b0
        redColour = 0.0;
        blueColour = 0.0;
        greenColour = 122.0;
    }
    else if ([theColor isEqualToString:@"blue"]){
        //r0 g0 b255
        redColour = 0.0;
        blueColour = 255.0;
        greenColour = 0.0;
    }
    else if ([theColor isEqualToString:@"white"]){
        //all 255
        redColour = 255.0;
        blueColour = 255.0;
        greenColour = 255.0;
    }
    else if ([theColor isEqualToString:@"brown"]){
        //r128 g84 b0
        redColour = 128.0;
        greenColour = 84.0;
        blueColour = 0.0;
    }
    else if ([theColor isEqualToString:@"purple"]){
        //r140 g51 b182
        redColour = 140.0;
        greenColour = 51.0;
        blueColour = 182.0;
    }
    else if ([theColor isEqualToString:@"black"]){
        //all 0
        //do nothing
    }
    else if ([theColor isEqualToString:@"orange"]){
        //r255 g165 b81
        redColour = 255.0;
        greenColour = 112.0;
        blueColour = 38.0;
    }
    else if ([theColor isEqualToString:@"grey"]){
        //all 218
        redColour = 218.0;
        blueColour = 218.0;
        greenColour = 218.0;
        
    }
    else if ([theColor isEqualToString:@"dark-grey"]){
        //all 112
        redColour = 112.0;
        blueColour = 112.0;
        greenColour = 112.0;
        
    }
    else if ([theColor isEqualToString:@"light-green"]){
        //r221 g255 b103
        redColour = 171.0;
        greenColour = 193.0;
        blueColour = 106.0;
    }
    else if ([theColor isEqualToString:@"cyan"]){
        //r107 g184 b178
        redColour = 107.0;
        greenColour = 184.0;
        blueColour = 178.0;
    }
    else if ([theColor isEqualToString:@"tan"]){
        //r250 g229 b175
        redColour = 250.0;
        greenColour = 229.0;
        blueColour = 175.0;
    }
    else if ([theColor isEqualToString:@"yellow"]){ //formerly bright-yellow
        //r255 g245 b0
        redColour = 255.0;
        greenColour = 245.0;
        blueColour = 0.0;
    }
    else if ([theColor isEqualToString:@"light-blue"]){
        //r186 g222 b255
        redColour = 186.0;
        greenColour = 222.0;
        blueColour = 255.0;
    }
    else if ([theColor isEqualToString:@"dark-brown"]){
        //r81 g59 b15
        redColour = 81.0;
        greenColour = 59.0;
        blueColour = 15.0;
    }
    else{
        //just do white, all 225
        redColour = 255.0;
        blueColour = 255.0;
        greenColour = 255.0;
    }
    redColour = redColour / 255.0; //set proper colour portrayals in apple colour out of 1.0
    greenColour = greenColour / 255.0;
    blueColour = blueColour / 255.0;
    
    UIColor *colourzingColour = [UIColor colorWithRed:redColour green:greenColour blue:blueColour alpha:alphaColour];
    
    return colourzingColour;
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    if(maskDisplayingCheck2 == 0){
        maskArray = noDuplicateMasksList;
    }
    else{
        maskArray = backUpMasksList;
    }
    [_maskGrid reloadData]; //refresh all the data back to origonal
    [_searchBar1 resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if(maskDisplayingCheck2 == 0){
        maskArray = noDuplicateMasksList;
    }
    else{
        maskArray = backUpMasksList;
    }
    
    NSMutableArray *searchArray = [[NSMutableArray alloc] init];
    
    [_maskGrid reloadData]; //refresh all the data back to origonal
    //then compile a new mask array based on the search terms.
    NSString *searchString1 = searchBar.text;
    searchString1 = [searchString1 lowercaseString];
    //NSLog(@"Text: %@", searchString1);
    NSArray *tempMaskItems = [[NSArray alloc] init];
    for (int i = 0; i <= (maskArray.count -1); i++) //check each mask in the array
    {
        tempMaskItems = maskArray[i];
        //NSLog(@"check: %@",tempMaskItems[0]);
        if([tempMaskItems[0] containsString:searchString1]){
            [searchArray addObject:maskArray[i]];
            //[_maskGrid reloadData]; //refresh the data with the new search results
            //NSLog(@"Good: %@",tempMaskItems[0]);
        }
        else{
            
            //[_maskGrid reloadData]; //refresh the data with the new search results
        }
    }
    //NSLog(@"array: %@", maskArray);
    maskArray = searchArray;
    [_maskGrid reloadData]; //refresh the data with the new search results
    [_searchBar1 resignFirstResponder];
}
    
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{ //for when the clear text button is pressed
    if(maskDisplayingCheck2 == 0){
        maskArray = noDuplicateMasksList;
        [_maskGrid reloadData]; //refresh all the data back to origonal
    }
    else{
        maskArray = backUpMasksList;
        [_maskGrid reloadData]; //refresh all the data back to origonal
    }

}

-(void)viewDidAppear:(BOOL)animated{
    if(collectedMasks2.count == totalMasksInGame){
        UIAlertController *completionAlert = [UIAlertController alertControllerWithTitle:@"Congratulations!"
                                                                                 message:[NSString stringWithFormat: @"You have collected all %d kanohi masks and completed the game!\nYou can now return to your village and retire in peace.", totalMasksInGame]
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [completionAlert addAction:defaultAction];
        [self presentViewController:completionAlert animated:YES completion:nil]; //show the completion alert if you have collected all masks.
        //this alert will be presented later, once the view has fully loaded
    }
    
    //if show all masks is switched off...
    if(maskDisplayingCheck2 == 0){
        int maskAlreadyThere = 0; //flag for if the mask has already been found in the list
        for (int j = 0; j <= (collectedMasks2.count -1); j++) //go through each mask in the collected masks array
        {
            maskAlreadyThere = 0; //reset the flag to 0
            for (int i = 0; i <= (noDuplicateMasksList.count -1); i++) //check it against each mask in the full mask list (this could take a while)
            {
                NSArray *checkingArray2 = noDuplicateMasksList[i];
                //NSLog(@"Mask Found: %d", maskAlreadyThere);
                //NSLog(@"Currently searching for: %@", collectedMasks2[j]);
                if([checkingArray2[0] isEqualToString: collectedMasks2[j]]){
                    if(maskAlreadyThere == 0){ //if this is the first mask of its kind, keep it
                        //NSLog(@"Found 1: %@", collectedMasks2[j]);
                        maskAlreadyThere = 1;
                    }
                    else{
                        //NSLog(@"Found more than 1: %@", collectedMasks2[j]);
                        //NSLog(@"Mask Found status: %d", maskAlreadyThere);
                        
                        [noDuplicateMasksList removeObjectAtIndex:i]; //otherwise, get rid of it.
                    }
                }
            }
        }
        maskArray = noDuplicateMasksList; //update the mask array
        //NSLog(@"Slimmer grid: %@", noDuplicateMasksList);
        [_maskGrid reloadData];
    }
    
}
    

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender { //assign the mask we want to view to the next controller
    if([segue.identifier isEqualToString:@"selectedMask"]){
        //NSLog(@"%@", selectedMaskArray);
        individualMaskController *controller = (individualMaskController *)segue.destinationViewController;
        controller.maskDetailsArray = selectedMaskArray;
        //NSLog(@"%@", maskArray);
        controller.maskImage = outPutMask;

    }
}


@end
