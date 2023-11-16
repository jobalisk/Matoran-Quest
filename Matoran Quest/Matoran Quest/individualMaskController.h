//
//  individualMaskController.h
//  Matoran Quest
//
//  Created by Job Dyer on 12/11/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface individualMaskController : UIViewController

@property (nonatomic, assign) NSArray *maskDetailsArray;
@property (nonatomic, weak) IBOutlet UILabel *maskName;
@property (nonatomic, weak) IBOutlet UILabel *maskCatcher;
@property (nonatomic, weak) IBOutlet UILabel *maskLong;
@property (nonatomic, weak) IBOutlet UILabel *maskLat;
@property (nonatomic, weak) IBOutlet UIImageView *maskPortrait;

@end

NS_ASSUME_NONNULL_END
