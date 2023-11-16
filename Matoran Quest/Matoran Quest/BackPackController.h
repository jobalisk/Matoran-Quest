//
//  BackPackController.h
//  Matoran Quest
//
//  Created by Job Dyer on 15/11/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BackPackController : UIViewController

@property (nonatomic, weak) IBOutlet UICollectionView *itemGrid; //the back pack inventory view
@property (nonatomic, weak) IBOutlet UILabel *widgetCount; //the back pack inventory view

@end

NS_ASSUME_NONNULL_END
