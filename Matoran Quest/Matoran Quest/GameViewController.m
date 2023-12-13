//
//  GameViewController.m
//  Matoran Quest
//
//  Created by Job Dyer on 12/11/23.
//

#import "GameViewController.h"
#import "GameScene.h"


@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setModalInPresentation:true]; //make it so you can's swipe it away (stops cheating)

    


    
    
}

-(void)viewDidAppear:(BOOL)animated{
    // Load the SKScene from 'GameScene.sks'
    GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"rahiScene"];
    
    // Set the scale mode to scale to fit the window
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    //SKView *skView = (SKView *)self.gamePresentationView;
    
    // Present the scene
    //[skView presentScene:scene];
    [self.gamePresentationView presentScene:scene];
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    //[[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeLeft) forKey:@"orientation"]; //set the controller to be landscape
    //[UINavigationController attemptRotationToDeviceOrientation];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
