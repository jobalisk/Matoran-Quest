//
//  PlayerDetailsController.h
//  Matoran Quest
//
//  Created by Job Dyer on 12/11/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayerDetailsController : UIViewController

-(IBAction) playerNameFieldCatcher: (id) sender; //the getter for the players name text feild
@property (nonatomic, strong) IBOutlet UITextField *playerNameField; //the players name feild setter


@end

NS_ASSUME_NONNULL_END
