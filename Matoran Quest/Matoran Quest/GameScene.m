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
    SKNode *bagButton;
    SKNode *fightButton;
    SKNode *runButton;
    SKNode *bagLabel;
    SKNode *fightLabel;
    SKNode *runLabel;
    
    
    //int winLoss; //0 undecided, 1 win, 2 loss
    //SKNode *cameraARNode;
    int doubleTapp;
    int isRunningAnimation; //flag for have we started animating yet
    NSString*rahiActualName; //name of rahi formatted correctly

    
    //arrays and atlas's for animations
    //player
    SKTextureAtlas *armThrowAtlas;
    SKTextureAtlas *diskThrowAtlas;
    SKTextureAtlas *maskEyeHoleAtlas;
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
    maskEyeHoleAtlas = [SKTextureAtlas atlasNamed:@"maskLenses.atlas"];
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
    bagButton = (SKSpriteNode *)[self childNodeWithName:@"//bagButton"];
    runButton = (SKSpriteNode *)[self childNodeWithName:@"//runButton"];
    fightButton = (SKSpriteNode *)[self childNodeWithName:@"//fightButton"];
    bagLabel = (SKSpriteNode *)[self childNodeWithName:@"//bagLabel"];
    runLabel = (SKSpriteNode *)[self childNodeWithName:@"//runLabel"];
    fightLabel = (SKSpriteNode *)[self childNodeWithName:@"//fightLabel"];
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
    [bagButton setHidden:FALSE];
    [runButton setHidden:FALSE];
    [fightButton setHidden:FALSE];
    
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
    
    //colourize player sprite
    UIColor *playerColour = [UIColor colorWithRed:[[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerRed"] green:[[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerGreen"] blue:[[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerBlue"] alpha:[[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerAlpha"]];

    [playerArm runAction:[SKAction colorizeWithColor:playerColour colorBlendFactor:1.0 duration:0.0]];
    
    //set up buttons
    
    //fightButton = [SKShapeNode shapeNodeWithRect:CGRectMake(fightButton.position.x, fightButton.position.x, fightButton.frame.size.width, fightButton.frame.size.height) cornerRadius:0.25];
    //[fightLabel setYScale:(fightLabel.yScale *2)];
    [fightLabel setUserInteractionEnabled:FALSE];
    [runLabel setUserInteractionEnabled:FALSE];
    [bagLabel setUserInteractionEnabled:FALSE];
    //[runLabel setYScale:(runLabel.yScale *2)];
    //[bagLabel setYScale:(bagLabel.yScale *2)];
    
    //set up rahi
    if([rahiActualName isEqualToString:@"hoi"]){ //this sprite is a little large and needs resizing constantly.
        [rahiSprite setXScale:(rahiSprite.xScale * 0.75)];
        [rahiSprite setYScale:(rahiSprite.yScale * 0.75)];
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
    //NSLog(@"touched something!");
    UITouch *somethingTouched = [touches anyObject]; //whenever a sprite is touched...
    CGPoint posTouched = [somethingTouched locationInNode:self];
    SKNode *touchedNode = [self nodeAtPoint:posTouched]; //get the node at the point touched
    //begin tests
    if([touchedNode.name isEqualToString:@"runButton"]){
        //NSLog(@"run selected");
        [runButton setHidden:true];
    }
    else if([touchedNode.name isEqualToString:@"fightButton"]){
        //NSLog(@"fight selected");
        [fightButton setHidden:true];
    }
    else if([touchedNode.name isEqualToString:@"bagButton"]){
        //NSLog(@"bag selected");
        [bagButton setHidden:true];
    }
    else if([touchedNode.name isEqualToString:@"rahi1"]){
        //NSLog(@"rahi touched");
        [rahiSprite setHidden:true];
    }
    else if([touchedNode.name isEqualToString:@"sliderBarSlider1"]){
        //NSLog(@"slider touched");
    }
    
    
    
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
        [rahiSprite runAction: [SKAction repeatActionForever:[SKAction animateWithTextures:rahiIdleArray timePerFrame:0.15]]];
        //[playerArm runAction:armThrowAction];
        
        //work out mask lenses
        NSString *playersMask1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"]; //round eyeholes
        playersMask1 = [playersMask1 lowercaseString];
        //NSLog(@"%@",playersMask1);
        if([playersMask1 containsString:@"akaku"] || [playersMask1 containsString:@"hau"] || [playersMask1 containsString:@"rau"]){
            [kanohiMaskEyeHoles runAction:[SKAction setTexture:[maskEyeHoleAtlas textureNamed:@"KanohiMaskEyeHolesRound"]]];
        }
        else if([playersMask1 containsString:@"vahi"]){ //vahi has no eye holes
            [kanohiMaskEyeHoles setHidden:TRUE];
        }
        else{
            [kanohiMaskEyeHoles runAction:[SKAction setTexture:[maskEyeHoleAtlas textureNamed:@"KanohiMaskEyeHolesTrapzoid"]]];
        }
        if([playersMask1 containsString:@"akaku"]){
            [self setBackgroundColor: [UIColor colorWithRed:1.0 green:0.5 blue:0.5 alpha:0.2]]; //give the akaku view a red tint
            
        }
        
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
