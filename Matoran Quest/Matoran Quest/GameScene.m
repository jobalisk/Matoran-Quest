//
//  GameScene.m
//  Matoran Quest
//
//  Created by Job Dyer on 12/11/23.
//

#import "GameScene.h"

@implementation GameScene {

    SKNode *backGroundBox1;
    SKNode *kanohiMaskEyeHoles;
    SKNode *escapeSliderBar;
    SKNode *aimSliderBar;
    SKNode *slideBarSlider;
    SKNode *playerArm;
    SKNode *kanohiDisk;
    SKNode *rahiSprite;
    
    //int winLoss; //0 undecided, 1 win, 2 loss
    //SKNode *cameraARNode;
    int doubleTapp;
    
    
}

- (void)didMoveToView:(SKView *)view {
    //NSLog(@"ran this");
 
}

-(void)sceneDidLoad{
    // attach nodes to code
    backGroundBox1 = [self childNodeWithName:@"backgroundBar1"];
    kanohiMaskEyeHoles = [self childNodeWithName:@"KanohiMaskEyeHoles"];
    escapeSliderBar = [self childNodeWithName:@"escapeBar"];
    aimSliderBar = [self childNodeWithName:@"aimBar"];
    slideBarSlider = [self childNodeWithName:@"sliderBarSlider1"];
    playerArm = [self childNodeWithName:@"throwingArm"];
    kanohiDisk = [self childNodeWithName:@"kanohiDisk"];
    rahiSprite = [self childNodeWithName:@"rahi1"];
    _winLoss = 0; //start of neutral
    _gotoBackPack = 0; //we don't need to go to the back pack yet...
    //cameraARNode = [self childNodeWithName:@"camera4AR"];
    //hide things that should always be hidden at the start...

    doubleTapp = 0;
    [backGroundBox1 setHidden:FALSE];
    [escapeSliderBar setHidden:TRUE];
    [aimSliderBar setHidden:TRUE];
    [slideBarSlider setHidden:TRUE];
    
    //sort out visuals based on user option settings
    int eyeHolesCheck = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ShowKanohiEyeHolesSetting"];
    //NSLog(@"eyeholes: %d", eyeHolesCheck);
    if(eyeHolesCheck == 1){
        [kanohiMaskEyeHoles setHidden:TRUE];
        //NSLog(@"eyeholes2: %d", kanohiMaskEyeHoles.hidden);
    }
    else{
        [kanohiMaskEyeHoles setHidden:FALSE];
        //NSLog(@"eyeholes2: %d", kanohiMaskEyeHoles.hidden);
    }

    //do some other quick set up stuff
    if(_rahiType == NULL){ //give a more pleasent name for rahi if the type is null.
        _rahiType = @"unnamed";
    }

}


- (void)touchDownAtPoint:(CGPoint)pos {
    doubleTapp += 1;
    if(doubleTapp == 2){
        self.winLoss = 3;
    }
}

- (void)touchMovedToPoint:(CGPoint)pos {
    if(self.winLoss == 0){
        self.gotoBackPack = 1;
    }
}

- (void)touchUpAtPoint:(CGPoint)pos {

    

    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"touching begins...");
    //[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"rahiFightingFlags"];
    //run an alert and prepare to close the controller
    
    for (UITouch *t in touches) {[self touchDownAtPoint:[t locationInNode:self]];}
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //NSLog(@"touching moved...");
    //[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"rahiFightingFlags"];
    for (UITouch *t in touches) {[self touchMovedToPoint:[t locationInNode:self]];}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"touching ended...");
    //[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"rahiFightingFlags"];
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"touching cancelled...");
    //[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"rahiFightingFlags"];
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}


-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
    //NSLog(@"updating");
}

@end
