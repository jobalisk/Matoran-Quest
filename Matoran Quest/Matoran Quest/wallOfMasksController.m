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

- (void)viewDidLoad {
    [super viewDidLoad];
    maskArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMasks"]; //get the players masks from the user defaults and make an array of them
    _maskGrid.delegate = self;
    _maskGrid.dataSource = self;
    //NSLog(@"%@", maskArray);
    [_maskCount setText:[NSString stringWithFormat:@"Kanohi found: %d", (int)maskArray.count]]; // how many masks do we have?
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //NSLog(@"Got this far");
    CollectionViewCell *cell3 = [_maskGrid dequeueReusableCellWithReuseIdentifier:@"cell3" forIndexPath:indexPath];
    //[cell1.customLabel setText:itemArray[indexPath.row]];
    //make a label
    //UILabel *itemName = [[UILabel alloc]initWithFrame:CGRectMake(91, 15, 0, 0)];
    //

    UILabel *maskName=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];//Set frame of label in your view
    //[itemName setBackgroundColor:[UIColor lightGrayColor]];//Set background color of label.
    NSArray *maskInterior = [maskArray objectAtIndex:indexPath.row]; //get the mask list to get out the name of the mask
    //NSLog(@"%@", maskInterior);
    @try {
        [maskName setText: [NSString stringWithFormat: @"%@",maskInterior[0]]];
    }
    @catch (NSException *exception) {
        [maskName setText: @""];
    }
    @finally {
      //Display Alternative
    }
    //NSLog(@"here: %@", maskArray);
    
    //[maskName setText: @"mask"];
    [maskName setAdjustsFontSizeToFitWidth:true];
    [maskName setFont:[UIFont fontWithName:@"Goudy Trajan Regular" size:10]];
    [maskName setTextColor:[UIColor whiteColor]];//Set text color in label.
    [maskName setTextAlignment:NSTextAlignmentCenter];//Set text alignment in label.
    [maskName setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];//Set line adjustment.
    [maskName setLineBreakMode:NSLineBreakByCharWrapping];//Set linebreaking mode..
    [maskName setNumberOfLines:3];//Set number of lines in label.
    //[itemName.layer setCornerRadius:40.0];//Set corner radius of label to change the shape.
    //[itemName.layer setBorderWidth:1.0f];//Set border width of label.
    [maskName setClipsToBounds:YES];//Set its to YES for Corner radius to work.
    [maskName.layer setBorderColor:[UIColor blackColor].CGColor];//Set Border color.
    [cell3 addSubview:maskName];//Add it to the view of your choice.

    
    
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
    [self performSegueWithIdentifier:@"selectedMask" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender { //assign the mask we want to view to the next controller
    if([segue.identifier isEqualToString:@"selectedMask"]){
        individualMaskController *controller = (individualMaskController *)segue.destinationViewController;
        controller.maskDetailsArray = selectedMaskArray;
        
    }
}


@end
