//
//  GameScene.h
//  Matoran Quest
//
//  Created by Job Dyer on 12/11/23.
//

#import <SpriteKit/SpriteKit.h>
#import <UIKit/UIKit.h>

@interface GameScene : SKScene

@property (nonatomic) UIViewController *presenterController;
@property (nonatomic, assign) NSString *rahiType;
@property (nonatomic, assign) int winLoss; //how did the match go, 0 is neutral, 3 is win, 4 is loss

@end
