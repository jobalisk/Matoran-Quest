//
//  MenuController.h
//  Matoran Quest
//
//  Created by Job Dyer on 12/11/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MenuController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *title2;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

-(IBAction) helpButton: (id) sender; //the getter for the players name text feild
-(IBAction) aboutButton: (id) sender; //the getter for the players name text feild

@end

NS_ASSUME_NONNULL_END
