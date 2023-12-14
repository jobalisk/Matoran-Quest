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
    int isRunningAnimation; //flag for have we started animating yet
    NSString*rahiActualName; //name of rahi formatted correctly

    
    //arrays and atlas's for animations
    //player
    SKTextureAtlas *armThrowAtlas;
    SKTextureAtlas *diskThrowAtlas;
    NSArray *armThrowArray;
    NSArray *diskThrowArray;
    SKAction *armThrowAction; //throw a disk
    SKTextureAtlas *rahiAtlas;
    NSArray *rahiIdleArray;
    SKAction *rahiIdleAnimation; //just standing around animation
    
    
    
}

- (void)didMoveToView:(SKView *)view {
    
    //set up player
    armThrowAtlas = [SKTextureAtlas atlasNamed: @"throwingArm.atlas"];
    diskThrowAtlas = [SKTextureAtlas atlasNamed: @"kanohiDisk.atlas"];
    armThrowArray = @[[armThrowAtlas textureNamed:@"throwing_arm00"], [armThrowAtlas textureNamed:@"throwing_arm01"], [armThrowAtlas textureNamed:@"throwing_arm02"], [armThrowAtlas textureNamed:@"throwing_arm03"], [armThrowAtlas textureNamed:@"throwing_arm04"], [armThrowAtlas textureNamed:@"throwing_arm05"], [armThrowAtlas textureNamed:@"throwing_arm06"], [armThrowAtlas textureNamed:@"throwing_arm07"], [armThrowAtlas textureNamed:@"throwing_arm08"], [armThrowAtlas textureNamed:@"throwing_arm09"]];
    
    diskThrowArray = @[[armThrowAtlas textureNamed:@"kanohiDisk0"], [armThrowAtlas textureNamed:@"kanohiDisk1"]];
    
    [playerArm runAction:[SKAction setTexture:armThrowArray[0]]];
    kanohiDisk = [SKSpriteNode spriteNodeWithTexture:diskThrowArray[0]size:CGSizeMake(128, 128)];
    armThrowAction = [SKAction animateWithTextures:armThrowArray timePerFrame:0.1];
    
    
    
    //set up rahi

    [self chooseRahiImage];
    


    
    
}

-(void)sceneDidLoad{
    // attach nodes to code
    backGroundBox1 = (SKSpriteNode *)[self childNodeWithName:@"//backgroundBar1"];
    //backGroundBox1 = [self childNodeWithName:@"backgroundBar1"];
    //kanohiMaskEyeHoles = [self childNodeWithName:@"KanohiMaskEyeHoles"];
    kanohiMaskEyeHoles = (SKSpriteNode *)[self childNodeWithName:@"//KanohiMaskEyeHoles"];
    //escapeSliderBar = [self childNodeWithName:@"escapeBar"];
    escapeSliderBar = (SKSpriteNode *)[self childNodeWithName:@"//escapeBar"];
    //aimSliderBar = [self childNodeWithName:@"aimBar"];
    aimSliderBar = (SKSpriteNode *)[self childNodeWithName:@"//aimBar"];
    //slideBarSlider = [self childNodeWithName:@"sliderBarSlider1"];
    slideBarSlider = (SKSpriteNode *)[self childNodeWithName:@"//sliderBarSlider1"];
    //playerArm = [self childNodeWithName:@"throwingArm"];
    playerArm = (SKSpriteNode *)[self childNodeWithName:@"//throwingArm"];
    //kanohiDisk = [self childNodeWithName:@"kanohiDisk"];
    kanohiDisk = (SKSpriteNode *)[self childNodeWithName:@"//kanohiDisk"];
    //rahiSprite = [self childNodeWithName:@"rahi1"];
    rahiSprite = (SKSpriteNode *)[self childNodeWithName:@"//rahi1"];
    _winLoss = 0; //start of neutral
    _gotoBackPack = 0; //we don't need to go to the back pack yet...
    //cameraARNode = [self childNodeWithName:@"camera4AR"];
    //hide things that should always be hidden at the start...
    
    isRunningAnimation = 0;
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

    //set up rahi


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
    if(isRunningAnimation == 0){ //start animating
        isRunningAnimation = 1;
        [rahiSprite runAction: [SKAction repeatActionForever:[SKAction animateWithTextures:rahiIdleArray timePerFrame:0.2]]];
        //[playerArm runAction:armThrowAction];
    }
}

-(void)chooseRahiImage{ //sort out getting the correct rahi images
    if(_rahiType == NULL){ //give a more pleasent name for rahi if the type is null.
        _rahiType = @"unnamed";
    }
    rahiActualName = [_rahiType lowercaseString];
    if([rahiActualName isEqualToString:@"pekapeka"] || [rahiActualName isEqualToString:@"ngarara"] || [rahiActualName isEqualToString:@"fikou"] || [rahiActualName isEqualToString:@"jaga"] || [rahiActualName isEqualToString:@"hoi"]){
        //small rahi...
        
        
        
    }
    else{ //back up texures for rahi that have not had textures made for them yet or other such things
        NSArray *randomSmallRahiArray = @[@"ngarara", @"pekapeka",@"jaga",@"hoi",@"fikou"];
        int i = arc4random_uniform(5);
        rahiActualName = randomSmallRahiArray[i];

    }
    //assign names to a array of idle sprites to create an animation
    rahiAtlas = [SKTextureAtlas atlasNamed: [NSString stringWithFormat: @"%@.atlas", rahiActualName]];
    rahiIdleArray = @[[rahiAtlas textureNamed:[NSString stringWithFormat:@"%@0", rahiActualName]], [rahiAtlas textureNamed:[NSString stringWithFormat:@"%@1", rahiActualName]], [rahiAtlas textureNamed:[NSString stringWithFormat:@"%@2", rahiActualName]], [rahiAtlas textureNamed:[NSString stringWithFormat:@"%@1", rahiActualName]]];
    
    //assign a starting sprite
    //NSLog(@"Rahi idle Array: %@", rahiIdleArray);
    
    

}

-(void)atlasSetup{
    //set up sprites for rahi, ect
    
}

@end
