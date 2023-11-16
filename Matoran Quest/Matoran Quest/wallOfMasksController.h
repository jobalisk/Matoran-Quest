//
//  wallOfMasksController.h
//  Matoran Quest
//
//  Created by Job Dyer on 12/11/23.
//

#import <UIKit/UIKit.h>
#import "individualMaskController.h"

NS_ASSUME_NONNULL_BEGIN

@interface wallOfMasksController : UIViewController
@property (nonatomic, weak) IBOutlet UICollectionView *maskGrid; //the mask inventory view
@property (nonatomic, weak) IBOutlet UILabel *maskCount; //the amount of kanohi found so far
@end

NS_ASSUME_NONNULL_END
