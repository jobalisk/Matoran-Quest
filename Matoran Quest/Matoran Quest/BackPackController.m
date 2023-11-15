//
//  BackPackController.m
//  Matoran Quest
//
//  Created by Job Dyer on 15/11/23.
//

#import "BackPackController.h"
#import "UICollectionViewCell+CollectionViewCell.h"

@interface BackPackController () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation BackPackController

NSArray *itemArray; //our item array

- (void)viewDidLoad {
    [super viewDidLoad];
    itemArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerItems"]; //get the players items from the user defaults and make an array of them
    _itemGrid.delegate = self;
    _itemGrid.dataSource = self;
    //[_itemGrid setDataSource:self];
    //[_itemGrid registerClass:CollectionViewCell.self forCellWithReuseIdentifier:@"cell1"];

}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSLog(@"Got this far");
    CollectionViewCell *cell1 = [_itemGrid dequeueReusableCellWithReuseIdentifier:@"cell1" forIndexPath:indexPath];
    [cell1.customLabel setText:itemArray[indexPath.row]];
    return cell1;
    
}



- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section { 
    return itemArray.count;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:   (UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100, 100);
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
