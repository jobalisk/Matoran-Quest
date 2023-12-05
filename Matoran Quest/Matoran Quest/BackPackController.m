//
//  BackPackController.m
//  Matoran Quest
//
//  Created by Job Dyer on 15/11/23.
//

#import "BackPackController.h"
#import "UICollectionViewCell+CollectionViewCell.h"

@interface BackPackController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation BackPackController

NSMutableArray *itemArray; //our item array
//UICollectionView * itemGrid;

- (void)viewDidLoad {
    [super viewDidLoad];
    itemArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerItems"]; //get the players items from the user defaults and make an array of them
    _itemGrid.delegate = self;
    _itemGrid.dataSource = self;
    //[_itemGrid setDataSource:self];
    //[_itemGrid registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell1"];

    //[_itemGrid registerNib: [UINib nibWithNibName:@"cell2" bundle:nil] forCellWithReuseIdentifier:@"cell1"];

    //sort out widgets
    int widgetCount1 = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerWidgets"]; //load player Widgets
    //NSLog(@"Widgets: %d", widgetCount1);
    if(widgetCount1 == 0){ //if there is no playerHP key yet
        //NSLog(@"we have no widgets");
        widgetCount1 = 0;
        [[NSUserDefaults standardUserDefaults] setInteger: widgetCount1 forKey:@"PlayerWidgets"]; //set it if it doesnt exist
        
    }
    [_widgetCount setText:[NSString stringWithFormat:@"Widgets: %d", widgetCount1]];
    [_itemCount setText:[NSString stringWithFormat:@"items: %d", (int)itemArray.count]];
    
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //NSLog(@"Got this far");
    UICollectionViewCell *cell1 = [_itemGrid dequeueReusableCellWithReuseIdentifier:@"cell1" forIndexPath:indexPath];
    //[cell1.customLabel setText:itemArray[indexPath.row]];
    //make a label
    //UILabel *itemName = [[UILabel alloc]initWithFrame:CGRectMake(91, 15, 0, 0)];
    NSString *itemString2 = [itemArray[indexPath.row] uppercaseString]; //convert the items name to all upper case

    
    //cause string to work as a paragraph
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.hyphenationFactor = 1;
    paragraphStyle.allowsDefaultTighteningForTruncation = true;
    //paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineBreakMode = 0.1f;
    paragraphStyle.firstLineHeadIndent = 5.0f;
    paragraphStyle.headIndent = 5.0f;
    paragraphStyle.tailIndent = -5.0f;
    //paragraphStyle.alignment = NSTextAlignmentJustified;
    //paragraphStyle.lineSpacing = 8.0f;
    //paragraphStyle.usesDefaultHyphenation = true;
        
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:itemString2 attributes:@{ NSParagraphStyleAttributeName : paragraphStyle }];
    
    UILabel *itemName=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];//Set frame of label in your view
    [itemName setBackgroundColor:[UIColor lightGrayColor]];//Set background color of label.
    //[itemName setText: itemString2];
    [itemName setAttributedText: attributedString];
    [itemName setAdjustsFontSizeToFitWidth:true];
    [itemName setFont:[UIFont fontWithName:@"Times New Roman" size:10]];
    [itemName setTextColor:[UIColor blackColor]];//Set text color in label.
    //[itemName setTextAlignment:NSTextAlignmentCenter];//Set text alignment in label.
    [itemName setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];//Set line adjustment.
    [itemName setLineBreakMode:NSLineBreakByCharWrapping];//Set linebreaking mode..
    [itemName setNumberOfLines:3];//Set number of lines in label.
    [itemName.layer setCornerRadius:40.0];//Set corner radius of label to change the shape.
    [itemName.layer setBorderWidth:1.5f];//Set border width of label.
    //[itemName.layoutMargins];
    [itemName setClipsToBounds:YES];//Set its to YES for Corner radius to work.
    [itemName.layer setBorderColor:[UIColor blackColor].CGColor];//Set Border color.
    [cell1 addSubview:itemName];//Add it to the view of your choice.
    
    
    
    return cell1;
    
}



- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section { 
    return itemArray.count;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:   (UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100, 100);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{ //tap brings up delete dialog
    //NSLog(@"Tapped %d", (int)indexPath.row);
    NSString *itemString1 = [itemArray[indexPath.row] lowercaseString]; //convert the items name to all lower case
    //2 different alerts for if the item is a heal item or not...
    if([itemString1 isEqualToString:@"vuata maca fruit"] || [itemString1 isEqualToString:@"energised protodermis"]){
        
        UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Throw away or use %@?", itemString1]
                                                                             message:@"Doing one of these two options will remove this from your backpack!"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Remove" style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction * action) {
            itemArray = [itemArray mutableCopy];
            [itemArray removeObjectAtIndex: indexPath.row]; //delete the item
            [self.itemCount setText:[NSString stringWithFormat:@"items: %d", (int)itemArray.count]]; //update the number of items display
            [[NSUserDefaults standardUserDefaults] setObject: itemArray forKey:@"PlayerItems"];
            [self.itemGrid reloadData];//refresh the view
            //NSIndexPath *cellForDeletionIndexPath; //a holder for the index path
            //NSLog(@"DELETED");
            
            
        }];
        [deleteAlert addAction:defaultAction];
        
        UIAlertAction* useAction = [UIAlertAction actionWithTitle:@"Use" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
            itemArray = [itemArray mutableCopy];
            
            [self.itemCount setText:[NSString stringWithFormat:@"items: %d", (int)itemArray.count]]; //update the number of items display

            if([itemString1 isEqualToString:@"vuata maca fruit"]){ //heal player health
                int playerHP2 = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerHP"];
                if(playerHP2 < 5){
                    playerHP2 += 5; //5 for a vuata maca fruit
                }
                else{
                    playerHP2 = 10;
                    [[NSUserDefaults standardUserDefaults] setInteger: playerHP2 forKey:@"PlayerHP"];
                }
            }
            if([itemString1 isEqualToString:@"energised protodermis"]){
                int playerHP2 = 10; //full health for energised protodermis
                [[NSUserDefaults standardUserDefaults] setInteger: playerHP2 forKey:@"PlayerHP"];
            }
            [itemArray removeObjectAtIndex: indexPath.row]; //delete the item
            [[NSUserDefaults standardUserDefaults] setObject: itemArray forKey:@"PlayerItems"];
            [self.itemGrid reloadData];//refresh the view
            //NSIndexPath *cellForDeletionIndexPath; //a holder for the index path
            
        }];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {}];
        
        [deleteAlert addAction:useAction];
        
        
        [deleteAlert addAction:cancelAction];
        
        [self presentViewController:deleteAlert animated:YES completion:nil]; //run the alert
    }
    else{
       
        UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Throw away  %@?", itemString1]
                                       message:[NSString stringWithFormat:@"Are you sure you want to throw away %@?", itemArray[indexPath.row]]
                                       preferredStyle:UIAlertControllerStyleAlert];
         
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDestructive
           handler:^(UIAlertAction * action) {
            itemArray = [itemArray mutableCopy];
            [itemArray removeObjectAtIndex: indexPath.row]; //delete the item
            [self.itemCount setText:[NSString stringWithFormat:@"items: %d", (int)itemArray.count]]; //update the number of items display
            [[NSUserDefaults standardUserDefaults] setObject: itemArray forKey:@"PlayerItems"];
            [self.itemGrid reloadData];//refresh the view
            //NSIndexPath *cellForDeletionIndexPath; //a holder for the index path
            //NSLog(@"DELETED");
            

        }];
        [deleteAlert addAction:defaultAction];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel
           handler:^(UIAlertAction * action) {}];
         
        [deleteAlert addAction:cancelAction];
        
        [self presentViewController:deleteAlert animated:YES completion:nil]; //run the alert
        
    }


    
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    //[collectionView deleteItemsAtIndexPaths:@[indexPath]]; //remove the cell
    [self.itemGrid reloadData];//refresh the view
    //[collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

/*
- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    <#code#>
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection { 
    <#code#>
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container { 
    <#code#>
}

- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize { 
    
    <#code#>
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container { 
    <#code#>
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator { 
    <#code#>
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator { 
    <#code#>
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator { 
    <#code#>
}

- (void)setNeedsFocusUpdate { 
    <#code#>
}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context { 
    return NO;
}

- (void)updateFocusIfNeeded { 
    <#code#>
}


- (void)collectionView:(nonnull UICollectionView *)collectionView prefetchItemsAtIndexPaths:(nonnull NSArray<NSIndexPath *> *)indexPaths {
    <#code#>
}
 
*/

@end
