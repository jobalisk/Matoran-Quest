//
//  OptionsViewController.h
//  Matoran Quest
//
//  Created by Job Dyer on 16/11/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OptionsViewController : UIViewController

-(IBAction) resetButtonPressed: (id) sender; //the delete button
-(IBAction) vibrationSwitchSwitched: (id) sender; //the vibration switch
-(IBAction) MaskSwitchSwitched: (id) sender; //the mask display switch
-(IBAction) cameraSwitchSwitched: (id) sender; //the camera switch
-(IBAction) eyeHolesSwitchSwitched: (id) sender; //the eye holes display switch
@property (nonatomic, weak) IBOutlet UISegmentedControl *vibrationSwitch; //is the vibration setting enabled?
@property (nonatomic, weak) IBOutlet UISegmentedControl *maskDisplaySwitch; //do we show all masks or just 1 of each kind found
@property (nonatomic, weak) IBOutlet UISegmentedControl *cameraSwitch; //Do we use the devices camera for backgrounds during rahi battles?
@property (nonatomic, weak) IBOutlet UISegmentedControl *eyeHolesSwitch; //do we show Rahi battles from the perspective of looking through the Matoran's mask


@end

NS_ASSUME_NONNULL_END
