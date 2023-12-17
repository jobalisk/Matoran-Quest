//
//  BattleInventoryViewController.h
//  Matoran Quest
//
//  Created by Job Dyer on 14/12/23.
//

#import <UIKit/UIKit.h>
#import "GameScene.h"

NS_ASSUME_NONNULL_BEGIN

@interface BattleInventoryViewController : UIViewController
//outlets
@property (nonatomic, weak) IBOutlet UILabel *titleEnglish; //the screen title
@property (nonatomic, weak) IBOutlet UIButton *returnButton; //return to the battle
@property (nonatomic, weak) IBOutlet UIButton *fruitButton; //item
@property (nonatomic, weak) IBOutlet UIButton *protodermisButton; //item
@property (nonatomic, weak) IBOutlet UIButton *superButton; //item
@property (nonatomic, weak) IBOutlet UIButton *fireButton; //item
@property (nonatomic, weak) IBOutlet UIButton *waterButton; //item
@property (nonatomic, weak) IBOutlet UIButton *iceButton; //item
@property (nonatomic, weak) IBOutlet UIButton *airButton; //item
@property (nonatomic, weak) IBOutlet UIButton *stoneButton; //item
@property (nonatomic, weak) IBOutlet UIButton *earthButton; //item
@property (nonatomic, weak) IBOutlet UIButton *rockButton; //item
//@property (nonatomic, weak) IBOutlet UILabel *titleMatroran; //the amount of items
//@property (nonatomic, weak) IBOutlet UIStackView *backPackDisplay; //the amount of items

//actions

-(IBAction) returnButtonP: (id) sender; //return to the battle
-(IBAction) fruitButtonP: (id) sender; //the getter for the players name text feild
-(IBAction) protodermisButtonP: (id) sender; //the getter for the players name text feild
-(IBAction) superButtonP: (id) sender; //the getter for the players name text feild
-(IBAction) fireButtonP: (id) sender; //the getter for the players name text feild
-(IBAction) waterButtonP: (id) sender; //the getter for the players name text feild
-(IBAction) iceButtonP: (id) sender; //the getter for the players name text feild
-(IBAction) airButtonP: (id) sender; //the getter for the players name text feild
-(IBAction) stoneButtonP: (id) sender; //the getter for the players name text feild
-(IBAction) earthButtonP: (id) sender; //the getter for the players name text feild
-(IBAction) rockButtonP: (id) sender; //the getter for the players name text feild


//variables
@property (nonatomic) int itemUsed2; //the item we are using

@end

NS_ASSUME_NONNULL_END
