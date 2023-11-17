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
@property (nonatomic, weak) IBOutlet UISegmentedControl *vibrationSwitch; //is the vibration setting enabled?

@end

NS_ASSUME_NONNULL_END
