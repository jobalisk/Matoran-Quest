//
//  PlayerDetailsController.h
//  Matoran Quest
//
//  Created by Job Dyer on 12/11/23.
//

#import <UIKit/UIKit.h>
//#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayerDetailsController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *playerNameLabel; //the players name in a label
@property (nonatomic, weak) IBOutlet UIImageView *playerPortrait; //the players picture
-(IBAction) resetButtonPressed: (id) sender; //the delete button

@end

NS_ASSUME_NONNULL_END
