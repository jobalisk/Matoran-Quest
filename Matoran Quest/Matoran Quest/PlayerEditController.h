//
//  PlayerEditController.h
//  Matoran Quest
//
//  Created by Job Dyer on 12/11/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayerEditController : UIViewController



-(IBAction) playerNameFieldCatcher: (id) sender; //the getter for the players name text feild

-(IBAction) colourButtonPressed: (id) sender; //the getter for the players name text feild

@property (nonatomic, weak) IBOutlet UITextField *playerNameField; //the players name feild setter
@property (nonatomic, weak) IBOutlet UIColorWell *playerColourPicker; //the players name feild setter
@property (nonatomic, weak) IBOutlet UIPickerView *playerMaskChooser; //the players name feild setter

@property (nonatomic, weak) IBOutlet UIImageView *playerPortrait; //the players picture



@end

NS_ASSUME_NONNULL_END
