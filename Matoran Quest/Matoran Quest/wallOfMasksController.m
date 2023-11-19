//
//  wallOfMasksController.m
//  Matoran Quest
//
//  Created by Job Dyer on 12/11/23.
//

#import "wallOfMasksController.h"
#import "UICollectionViewCell+CollectionViewCell.h"

@interface wallOfMasksController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation wallOfMasksController

NSArray *maskArray; //our mask array
NSArray *selectedMaskArray; //the mask we want to know more about
UIImage *maskImage2; //the colourized mask image
UIImage *outPutMask; //the mask we take to the individual mask viewer
NSMutableArray *imagesInCollection; //an array of all the images
NSMutableArray *collectedMasks2; //a list of the kinds of masks the player has collected. 1 entry for each unique kind of mask (colour as well as type)

- (void)viewDidLoad {
    [super viewDidLoad];
    maskArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMasks"]; //get the players masks from the user defaults and make an array of them
    //NSLog(@"monkey: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMasks"]);
    _maskGrid.delegate = self;
    _maskGrid.dataSource = self;
    //NSLog(@"%@", maskArray);
    [_maskCount setText:[NSString stringWithFormat:@"Kanohi found: %d", (int)maskArray.count]]; // how many masks do we have?
    imagesInCollection = [[NSMutableArray alloc] init];
    
    collectedMasks2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMaskCollectionList"];
    if(collectedMasks2 == NULL){ //if there is no player masks collection key yet
        collectedMasks2 = [[NSMutableArray alloc] init];
        //NSLog(@"refreshing2");
        [[NSUserDefaults standardUserDefaults] setObject:collectedMasks2 forKey:@"PlayerMaskCollectionList"]; //set it if it doesnt exist
        
    }
    [_collectionCount setText:[NSString stringWithFormat: @"Collection: %d/183", (int)collectedMasks2.count]];
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //NSLog(@"Got this far");
    CollectionViewCell *cell3 = [_maskGrid dequeueReusableCellWithReuseIdentifier:@"cell3" forIndexPath:indexPath];
    //[cell1.customLabel setText:itemArray[indexPath.row]];
    //make a label
    //UILabel *itemName = [[UILabel alloc]initWithFrame:CGRectMake(91, 15, 0, 0)];
    //
    
    NSArray *maskInterior = [maskArray objectAtIndex:indexPath.row]; //get the mask list to get out the name of the mask
    //NSLog(@"%@", maskInterior)
    NSString *maskNameAndColour = maskInterior[0];
    NSArray *maskColourAndName; //array of seperated name and colour
    NSString *maskName;
    int noColourFlag = 0; //check if mask is special and skip colourizing
    if([maskNameAndColour isEqualToString: @"vahi"]){ //seperate things out if needed
        maskName = @"vahi";
        noColourFlag = 1;
    }
    else if([maskNameAndColour isEqualToString: @"avohkii"]){
        maskName = @"avohkii";
        noColourFlag = 1;
    }
    else if([maskNameAndColour isEqualToString: @"infected hau"]){
        maskName = @"infected hau";
        noColourFlag = 1;
    }

    else{
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
    
    UIImageView *maskImage=[[UIImageView alloc]initWithFrame:CGRectMake(18, 18, 64, 64)];
    if(noColourFlag == 0){ //if its not a special flag, then colourize it
        UIColor *tempColor = [self colourCaser: maskColourAndName[0]]; //colour the image
        maskImage2 = [UIImage imageNamed:[NSString stringWithFormat: @"%@", maskName]];
        //[maskImage2 imageWithTintColor:tempColor];
        maskImage2 = [self colorizeImage:maskImage2 color:tempColor];
        [maskImage setImage:maskImage2]; //set an image with a colour
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
        [maskImage setImage:[UIImage imageNamed:[NSString stringWithFormat: @"%@", maskName]]]; //get the image named the name of the mask without the colour
    }

    [cell3 addSubview:maskImage];//Add it to the view of your choice.
    
    UILabel *maskNameLabel =[[UILabel alloc]initWithFrame:CGRectMake(25, 70, 50, 50)];//Set frame of label in your view
    //[itemName setBackgroundColor:[UIColor lightGrayColor]];//Set background color of label.

    @try {
        [maskNameLabel setText: [NSString stringWithFormat: @"%@",maskNameAndColour]];
    }
    @catch (NSException *exception) {
        [maskNameLabel setText: @""];
    }
    @finally {
      //Display Alternative
    }
    //NSLog(@"here: %@", maskArray);
    
    //[maskName setText: @"mask"];
    [maskNameLabel setAdjustsFontSizeToFitWidth:true];
    [maskNameLabel setFont:[UIFont fontWithName:@"Goudy Trajan Regular" size:10]];
    [maskNameLabel setTextColor:[UIColor whiteColor]];//Set text color in label.
    [maskNameLabel setTextAlignment:NSTextAlignmentCenter];//Set text alignment in label.
    [maskNameLabel setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];//Set line adjustment.
    [maskNameLabel setLineBreakMode:NSLineBreakByCharWrapping];//Set linebreaking mode..
    [maskNameLabel setNumberOfLines:1];//Set number of lines in label.
    //[itemName.layer setCornerRadius:40.0];//Set corner radius of label to change the shape.
    //[itemName.layer setBorderWidth:1.0f];//Set border width of label.
    [maskNameLabel setClipsToBounds:YES];//Set its to YES for Corner radius to work.
    [maskNameLabel.layer setBorderColor:[UIColor blackColor].CGColor];//Set Border color.
    [cell3 addSubview:maskNameLabel];//Add it to the view of your choice.
     
    
    
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
        greenColour = 255.0;
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
    else if ([theColor isEqualToString:@"light-green"]){
        //r221 g255 b103
        redColour = 221.0;
        greenColour = 255.0;
        blueColour = 103.0;
    }
    else if ([theColor isEqualToString:@"yellow"]){
        //r255 g255 b144
        redColour = 255.0;
        greenColour = 255.0;
        blueColour = 144.0;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender { //assign the mask we want to view to the next controller
    if([segue.identifier isEqualToString:@"selectedMask"]){
        individualMaskController *controller = (individualMaskController *)segue.destinationViewController;
        controller.maskDetailsArray = selectedMaskArray;
        //NSLog(@"%@", maskArray);
        controller.maskImage = outPutMask;
        
    }
}


@end
