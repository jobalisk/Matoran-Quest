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
    SKNode *fightLabel2;
    SKNode *armSliderArea; //this is an area placed over the lense that is invisible but allows one to basically drag the arm back to shoot.
    SKLabelNode *RHPLabel;
    SKLabelNode *PHPLabel;
    SKLabelNode *timerLabel;
    SKLabelNode *resultLabel;
    
    //actions
    SKAction *rahiIdleAction;
    SKAction *rahiAttackAction;
    SKAction *rahiEnlarge;
    SKAction *rahiShrink;
    SKAction *rahiKOAction;
    
    
    //int winLoss; //0 undecided, 1 win, 2 loss
    //SKNode *cameraARNode;
    int doubleTapp;
    int timerCounter; //a counter that holds approximatly 1 sec worth of time in an interger format
    int timerCounterDefault; //whatever 1 second is to reset it
    int actionTimer; //a count down for how long you have to aim or dodge.
    int isRunningAnimation; //flag for have we started animating yet
    NSString*rahiActualName; //name of rahi formatted correctly
    int playerHPFight; //how much health the player has (default is 1, so alive and not well.)
    int rahiHPFight; //rahi HP, it will change depending on the rahi.
    int rahiDifficulty; //this number will change depending on the kind of rahi. By default the value is 2, meaning there is a 50/50 chance you will get to attack or dodge first.
    int randomRahiAI; //holds the precious difficulty randomizer
    bool rahiAttackFlag; //are we attacking the rahi?
    bool rahiDodgeFlag; //are we dodging the rahi?
    CGPoint defaultSliderPos; //where the slider starts (different on different devices?)
    bool whichWay1; //for determining the direction of the slider
    int sliderSpeed; //how fast the slider moves
    bool playerRecentlyLostHealth; //to make sure we only lose a bit of health at a time
    int fightProgressCounter; //counts how far through a fight cycle we are. 0 is just started, 1 is finished one part, 2 is finished it all
    float playerDefaultArmRotation;
    //bool rahiRunningAnimation; //is the rahi currently animating?
    float growShrinkTimeInterval; //how long it takes the rahi to grow and shrink
    bool playerAttacked; //has the player just attacked?
    int playerResistance1; //resistance modifiers for damage mitigation
    int rahiResistance1;
    float diskTravelSpeed; //how fast the disk shoots
    CGPoint diskOrigin; //where the disk starts so that we can return it
    bool onlyDoThisOnce; //a variable to make sure we remove only 1 item from the players collection if they lose
    bool rahiAttackCalledFlag; //a similar variable to above, to stop the rahi attack method being called several times at once
    
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
    SKTextureAtlas *fightLabelsAtlas; //for the count down labels
    NSArray *fightLabelsArray;
    
    //atlases and arrays for rahi
    
    //small rahi
    //idle arrays and atlas's are generated later

    NSArray *fikouAttackArray;
    NSArray *fikouKOArray;
    

    NSArray *hoiAttackArray;
    NSArray *hoiKOArray;
    

    NSArray *jagaAttackArray;
    NSArray *jagaKOArray;
    

    NSArray *ngararaAttackArray;
    NSArray *ngararaKOArray;
    

    NSArray *pekapekaAttackArray;
    NSArray *pekapekaKOArray;
    
}

- (void)didMoveToView:(SKView *)view {
    //set up variables
    self.bagAccessed = FALSE;
    self.runTapped = FALSE;
    rahiAttackFlag = false;
    rahiDodgeFlag = false;
    isRunningAnimation = 0;
    doubleTapp = 0;
    //rahiDifficulty = 2;
    actionTimer = 3;
    timerCounterDefault = 60; //60 to 1 second
    timerCounter = timerCounterDefault;
    //rahiHPFight = 1;
    whichWay1 = arc4random_uniform(2); //for the slider. 0 for right, 1 for left
    sliderSpeed = 15;
    playerRecentlyLostHealth = false;
    fightProgressCounter = 0;
    playerDefaultArmRotation = -1.570796;
    //rahiRunningAnimation = false;
    growShrinkTimeInterval = 0.4;
    playerAttacked = false;
    onlyDoThisOnce = false;
    rahiAttackCalledFlag = false;
    
    
    [[NSUserDefaults standardUserDefaults] setInteger: 0 forKey:@"BackPackItemUsed"]; //set it to 0 by default
    self.itemUsed = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"BackPackItemUsed"];
    
    playerHPFight = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerHP"]; //load player HP
    //NSLog(@"HP: %d", playerHPFight);
    if(playerHPFight == 0){
        playerHPFight = 1; //make sure we're at least somewhat alive regardless of what happens
    }
    
    //set up player
    armThrowAtlas = [SKTextureAtlas atlasNamed: @"throwingArm.atlas"];
    diskThrowAtlas = [SKTextureAtlas atlasNamed: @"kanohiDisk.atlas"];
    maskEyeHoleAtlas = [SKTextureAtlas atlasNamed:@"maskLenses.atlas"];
    fightLabelsAtlas = [SKTextureAtlas atlasNamed:@"fightingNumbers.atlas"];
    armThrowArray = @[[armThrowAtlas textureNamed:@"throwing_arm00"], [armThrowAtlas textureNamed:@"throwing_arm01"], [armThrowAtlas textureNamed:@"throwing_arm02"], [armThrowAtlas textureNamed:@"throwing_arm03"], [armThrowAtlas textureNamed:@"throwing_arm04"], [armThrowAtlas textureNamed:@"throwing_arm05"], [armThrowAtlas textureNamed:@"throwing_arm06"], [armThrowAtlas textureNamed:@"throwing_arm07"], [armThrowAtlas textureNamed:@"throwing_arm08"], [armThrowAtlas textureNamed:@"throwing_arm09"]];
    
    diskThrowArray = @[[diskThrowAtlas textureNamed:@"kanohiDisk0"], [diskThrowAtlas textureNamed:@"kanohiDisk1"]];
    
    fightLabelsArray = @[[fightLabelsAtlas textureNamed:@"toru"], [fightLabelsAtlas textureNamed:@"rua"], [fightLabelsAtlas textureNamed:@"tahi"], [fightLabelsAtlas textureNamed:@"fight"]]; //in the order of counting down
    
    [playerArm runAction:[SKAction setTexture:armThrowArray[0]]];
    //kanohiDisk = [SKSpriteNode spriteNodeWithTexture:diskThrowArray[0]size:CGSizeMake(128, 128)];
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
    kanohiDisk = (SKSpriteNode *)[self childNodeWithName:@"//kanohiDisk1"];
    //rahiSprite = [self childNodeWithName:@"rahi1"];
    rahiSprite = (SKSpriteNode *)[self childNodeWithName:@"//rahi1"];
    bagButton = (SKSpriteNode *)[self childNodeWithName:@"//bagButton"];
    runButton = (SKSpriteNode *)[self childNodeWithName:@"//runButton"];
    fightButton = (SKSpriteNode *)[self childNodeWithName:@"//fightButton"];
    bagLabel = (SKSpriteNode *)[self childNodeWithName:@"//bagLabel"];
    runLabel = (SKSpriteNode *)[self childNodeWithName:@"//runLabel"];
    fightLabel = (SKSpriteNode *)[self childNodeWithName:@"//fightLabel"];
    fightLabel2 = (SKSpriteNode *)[self childNodeWithName:@"//fightLabel2"];
    armSliderArea = (SKSpriteNode *)[self childNodeWithName:@"//armSliderArea"];
    RHPLabel = (SKLabelNode *)[self childNodeWithName:@"//RHPLabel"];
    PHPLabel = (SKLabelNode *)[self childNodeWithName:@"//PHPLabel"];
    timerLabel = (SKLabelNode *)[self childNodeWithName:@"//timerLabel"];
    resultLabel = (SKLabelNode *)[self childNodeWithName:@"//resultLabel"];
    
    //set variables
    _winLoss = 0; //start of neutral
    _gotoBackPack = 0; //we don't need to go to the back pack yet...
    defaultSliderPos = slideBarSlider.position; //set default position of slider based on screen size
    //rahiDifficulty = 2;
    //rahiHPFight = rahiDifficulty;
    diskOrigin = kanohiDisk.position;
    
    //hide things that should always be hidden at the start...
    
    [fightLabel2 setHidden:true];
    [PHPLabel setHidden:false];
    [RHPLabel setHidden:false];
    [timerLabel setHidden:true];
    [backGroundBox1 setHidden:FALSE];
    [escapeSliderBar setHidden:TRUE];
    [aimSliderBar setHidden:TRUE];
    [slideBarSlider setHidden:TRUE];
    [bagButton setHidden:FALSE];
    [runButton setHidden:FALSE];
    [fightButton setHidden:FALSE];
    [kanohiDisk setHidden:true];
    [resultLabel setHidden:TRUE];
    
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
    
    [kanohiDisk runAction:[SKAction colorizeWithColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0] colorBlendFactor:1.0 duration:0.0]]; //dye the kanohi disk a generic grey
    [playerArm runAction:[SKAction colorizeWithColor:playerColour colorBlendFactor:1.0 duration:0.0]];
    
    //set up buttons
    
    //fightButton = [SKShapeNode shapeNodeWithRect:CGRectMake(fightButton.position.x, fightButton.position.x, fightButton.frame.size.width, fightButton.frame.size.height) cornerRadius:0.25];
    //[fightLabel setYScale:(fightLabel.yScale *2)];
    //[fightLabel setUserInteractionEnabled:FALSE];
    //[runLabel setUserInteractionEnabled:FALSE];
    //[bagLabel setUserInteractionEnabled:FALSE];
    //[runLabel setYScale:(runLabel.yScale *2)];
    //[bagLabel setYScale:(bagLabel.yScale *2)];
    
    //set up HP
    [PHPLabel setText:[NSString stringWithFormat:@"HP: %d", playerHPFight]];
    [RHPLabel setText:[NSString stringWithFormat:@"Rahi: %d", rahiHPFight]]; //make sure the rahi has at least 1 health
    
    //set up rahi
    if([rahiActualName isEqualToString:@"hoi"]){ //this sprite is a little large and needs resizing constantly.
        [rahiSprite setXScale:(rahiSprite.xScale * 0.75)];
        [rahiSprite setYScale:(rahiSprite.yScale * 0.75)];
    }

}


- (void)touchDownAtPoint:(CGPoint)pos {

}

- (void)touchMovedToPoint:(CGPoint)pos {

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
    if([touchedNode.name isEqualToString:@"runButton"] || [touchedNode.name isEqualToString:@"runLabel"]){ //if we select run
        //NSLog(@"run selected");
        [runButton setHidden:true];
        self.runTapped = TRUE;
        randomRahiAI = arc4random_uniform(self->rahiDifficulty); //oh no, the Rahi has got AI!
        if(randomRahiAI == 0){ //the chance of escape shrinks depending on the type of rahi fought
            self.winLoss = 5;
            [resultLabel setText:@"You escape Successfully!"]; //display a good message
            [resultLabel setHidden:FALSE];
        }
        else{
            [resultLabel setText:@"There is, no escape!"]; //otherwise display a bad message
            [resultLabel setHidden:FALSE];
        }
        
    }
    else if([touchedNode.name isEqualToString:@"fightButton"] || [touchedNode.name isEqualToString:@"fightLabel"]){ //if we select fight
        //NSLog(@"fight selected");
        rahiDodgeFlag = false;
        //NSLog(@"tapped");
        rahiAttackFlag = false; //reset these before the fight starts
        fightProgressCounter = 0;
        playerAttacked = false;
        
        //work out disk colour:
        if(_bagAccessed == true){
            if(_itemUsed == 1){ //air
                [kanohiDisk runAction:[SKAction colorizeWithColor:[UIColor greenColor] colorBlendFactor:1.0 duration:0.0]];
                if([_rahiType isEqualToString:@"pekapeka"]){
                    //rahiResistance1 -= 1;
                }
                else if([_rahiType isEqualToString:@"ngarara"]){
                    rahiResistance1 += 3;
                }
                else if([_rahiType isEqualToString:@"hoi"]){
                    rahiResistance1 += 1;
                }
            }
            else if(_itemUsed == 5){ //stone
                [kanohiDisk runAction:[SKAction colorizeWithColor:[UIColor brownColor] colorBlendFactor:1.0 duration:0.0]];
                if([_rahiType isEqualToString:@"ngarara"]){
                    //rahiResistance1 -= 1;
                }
                else if([_rahiType isEqualToString:@"jaga"]){
                    rahiResistance1 -= 1;
                }
                else if([_rahiType isEqualToString:@"pekapeka"]){
                    rahiResistance1 += 3;
                }
                
            }
            if(_itemUsed == 3){ //fire
                [kanohiDisk runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0 duration:0.0]];
                if([_rahiType isEqualToString:@"jaga"]){
                    //rahiResistance1 -= 1;
                }
                else if([_rahiType isEqualToString:@"hoi"]){
                    //rahiResistance1 -= 1;
                }
                else if([_rahiType isEqualToString:@"ngarara"]){
                    rahiResistance1 += 3;
                }
                else if([_rahiType isEqualToString:@"fikou"]){
                    rahiResistance1 += 2;
                }

            }
            if(_itemUsed == 4){ //ice
                [kanohiDisk runAction:[SKAction colorizeWithColor:[UIColor whiteColor] colorBlendFactor:1.0 duration:0.0]];
                if([_rahiType isEqualToString:@"fikou"]){
                    //rahiResistance1 -= 1;
                }
                else if([_rahiType isEqualToString:@"hoi"]){
                    //rahiResistance1 -= 1;
                }
                if([_rahiType isEqualToString:@"ngarara"]){
                    rahiResistance1 += 3;
                }

            }
            if(_itemUsed == 2){ //earth
                [kanohiDisk runAction:[SKAction colorizeWithColor:[UIColor blackColor] colorBlendFactor:1.0 duration:0.0]];
                if([_rahiType isEqualToString:@"ngarara"]){
                    //rahiResistance1 -= 1;
                }
                else if([_rahiType isEqualToString:@"pekapeka"]){
                    rahiResistance1 += 3;
                }
                else if([_rahiType isEqualToString:@"hoi"]){
                    rahiResistance1 += 3;
                }
            }
            if(_itemUsed == 6){ //water
                [kanohiDisk runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0 duration:0.0]];
                if([_rahiType isEqualToString:@"jaga"]){
                    rahiResistance1 += 3;
                }
                else if([_rahiType isEqualToString:@"hoi"]){
                    //rahiResistance1 -= 1;
                }
                
            }
            if(_itemUsed == 7){ //super disk
                [kanohiDisk runAction:[SKAction colorizeWithColor:[UIColor colorWithRed:0.8 green:0.7 blue:0.0 alpha:1.0] colorBlendFactor:1.0 duration:0.0]]; //goldish
                rahiResistance1 += 3;

            }
        }
        
        
        [fightButton setHidden:true]; //hide the menu
        [bagButton setHidden:true];
        [runButton setHidden:true];
        [kanohiDisk setPosition:diskOrigin]; //do kanohi disk reset
        [kanohiDisk setScale:0.50];
        [kanohiDisk setHidden:true];
        [fightLabel2 setHidden: false]; //show the count down
        [fightLabel2 runAction:[SKAction animateWithTextures:fightLabelsArray timePerFrame:1.0] completion:^(void){ //run the countdown
            [self->fightLabel2 setHidden: true]; //hide the count down upon completion and show the HP trackers
            [self->PHPLabel setHidden: false];
            [self->RHPLabel setHidden: false];
            self->randomRahiAI = arc4random_uniform(self->rahiDifficulty); //oh no, the Rahi has got AI!
            //NSLog(@"Difficulty: %d", self->rahiDifficulty);
            if(self->randomRahiAI == 0){
                //NSLog(@"called 3");
                if(self->rahiAttackCalledFlag == false){
                    [self rahiAttack];
                }
                
            }
            else{
                [self rahiDodge];
            }
            
        }];
    }
    else if([touchedNode.name isEqualToString:@"bagButton"] || [touchedNode.name isEqualToString:@"bagLabel"]){ //if we select bag
        //NSLog(@"bag selected");
        self.bagAccessed = TRUE;
        [bagButton setHidden:true]; //hide these once the bag has been accessed so that you have to fight when you get back
        [runButton setHidden:true];
        self.gotoBackPack = 1;
    }
    else if([touchedNode.name isEqualToString:@"rahi1"]){
        //NSLog(@"rahi touched");
        [rahiSprite setHidden:true];
    }
    else if([touchedNode.name isEqualToString:@"sliderBarSlider1"]){
        //NSLog(@"slider touched");
        if(rahiDodgeFlag == true){ //if we touched the bar while trying to dodge, we have success (if it was within the correct area)
            if(slideBarSlider.position.y < -183 || slideBarSlider.position.y > 183){
                [playerArm runAction:[SKAction moveToY:-996 duration:0.3] completion:^(void){ //hide the arm briefly to simulate dodging
                    self->rahiDodgeFlag = false;
                    [self->resultLabel setText:@"You dodged the Rahi!"];
                    [self->resultLabel setHidden: false];
                    [self->slideBarSlider setHidden:true];
                    [self->escapeSliderBar setHidden:true];
                    [self->playerArm runAction:[SKAction moveToY:-283 duration:0.3] completion:^(void){

                    }];
                }];

            }
            else{
                rahiDodgeFlag = false;
                [resultLabel setText:@"You were hit by the Rahi!"];
                [slideBarSlider setHidden:true];
                [escapeSliderBar setHidden:true];
                [resultLabel setHidden:false];
                [self playerLostHealth];
                
            }
            fightProgressCounter += 1;
            timerCounter = 240;
        }
        else if(rahiAttackFlag == true){ //if we touched the bar while trying to attack...
            if(playerAttacked == false){ //only do this once per fight phase!
                playerAttacked = true;
                diskTravelSpeed = 0.5;
                //NSLog(@"POS: %f", slideBarSlider.position.y);
                if(slideBarSlider.position.y > -153 && slideBarSlider.position.y < 153){ //if we are in the green area we hit...
                    [playerArm removeAllActions];
                    [playerArm runAction:[SKAction moveToY:-500 duration:0.25] completion:^(void){ //if we still have the disk, withdraw the arm briefly and hide it
                        //make the disk "appear"
                        //self->rahiRunningAnimation = true;
                        //[self->rahiSprite runAction:self->rahiIdleAction withKey:@"idleAction"];
                        [self->kanohiDisk setHidden:false];
                        //NSLog(@"part 1: %d", self->rahiAttackFlag);
                        //NSLog(@"hit");
                        [self->playerArm runAction:[SKAction moveToY:-283 duration:0.25] completion:^(void){
                            [self->kanohiDisk runAction:[SKAction moveTo: CGPointMake(-95, 2.3) duration:self->diskTravelSpeed]];
                            [self->kanohiDisk runAction:[SKAction scaleTo:0.0 duration:self->diskTravelSpeed]completion:^(void){
                                self->rahiHPFight -= (1 + self->rahiResistance1);
                                //NSLog(@"resistance: %d", self->rahiResistance1);
                                self->rahiAttackFlag = false;
                                [self->resultLabel setText:@"You hit it!"];
                                
                                //[self->rahiSprite removeAllActions];
                                //NSLog(@"RHP: %d", self->rahiHPFight);
                                if(self->rahiHPFight > 0){
                                    //NSLog(@"health: %d", self->rahiHPFight);
                                    if([self->rahiSprite actionForKey:@"hitRahi"] == nil){
                                        [self->rahiSprite removeAllActions];
                                        //NSLog(@"hit1");
                                        [self->rahiSprite runAction:[SKAction setTexture:[self->rahiAtlas textureNamed:[NSString stringWithFormat:@"%@3", self->rahiActualName]]]]; //give the rahi a dammaged pose texture
                                        [self->rahiSprite runAction: [SKAction waitForDuration:0.3] withKey: @"hitRahi"]; //give the program time to read it
                                    }

                                }
                                else{
                                    //NSLog(@"KOed");
                                    if([self->rahiSprite actionForKey:@"rahiKO"] == nil){
                                        //NSLog(@"KOed2");
                                        [self->rahiSprite removeAllActions];
                                        [self->rahiSprite runAction: self->rahiKOAction withKey:@"rahiKO"];
                                    }
                                }

                                [self->slideBarSlider setHidden:true];
                                [self->aimSliderBar setHidden:true];
                                [self->resultLabel setHidden:false];
                                [self->kanohiDisk setHidden:true];
                                self->fightProgressCounter += 1;
                                self->timerCounter = 240;
                                
                            }];
                        }];
                    }];
                }
                else{
                    //...otherwise we miss
                    [playerArm removeAllActions];
                    //NSLog(@"miss");
                    [playerArm runAction:[SKAction moveToY:-500 duration:0.25] completion:^(void){ //if we still have the disk, withdraw the arm briefly and hide it
                        //make the disk "appear"
                        //self->rahiRunningAnimation = true;
                        //[self->rahiSprite runAction:self->rahiIdleAction withKey:@"idleAction"];
                        [self->kanohiDisk setHidden:false];
                        //NSLog(@"part 1: %d", self->rahiAttackFlag);
                        [self->playerArm runAction:[SKAction moveToY:-283 duration:0.25] completion:^(void){
                            [self->kanohiDisk runAction:[SKAction moveTo: CGPointMake(-214.213, 24) duration:self->diskTravelSpeed]];
                            [self->kanohiDisk runAction:[SKAction scaleTo:0.0 duration:self->diskTravelSpeed]completion:^(void){
                                //NSLog(@"called");
                                self->rahiAttackFlag = false;
                                [self->resultLabel setText:@"You missed!"];
                                [self->slideBarSlider setHidden:true];
                                [self->aimSliderBar setHidden:true];
                                [self->resultLabel setHidden:false];
                                [self->kanohiDisk setHidden:true];
                                self->fightProgressCounter += 1;
                                self->timerCounter = 240;
                                
                            }];

                        }];
                    }];

                }
                
            }

        }
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
    //NSLog(@"dodge: %d", rahiDodgeFlag);
    //NSLog(@"RHP: %d", rahiHPFight);
    //NSLog(@"attack: %d", rahiAttackFlag);
    //NSLog(@"FPC: %d", fightProgressCounter);
    if(playerHPFight < 1){ //if we run out of life we lose!
        [playerArm setZRotation: -1.22173048]; //70 degrees
        
        //remove an item at random from the players inventory or mask stash
        if(onlyDoThisOnce != true){ //make sure this only happens once!
            onlyDoThisOnce = true;
            NSMutableArray *itemArrayRemoval = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerItems"];
            itemArrayRemoval = [itemArrayRemoval mutableCopy];
            NSMutableArray *KanohiArrayRemoval = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMasks"];
            KanohiArrayRemoval = [itemArrayRemoval mutableCopy];
            int q = arc4random_uniform(3); //select between items and masks
            if(q == 0){
                if(itemArrayRemoval.count != 0){ //if there are items in the array
                    int randomSelection = (int)itemArrayRemoval.count - 1;
                    q = arc4random_uniform(randomSelection); //remove one at random
                    [itemArrayRemoval removeObjectAtIndex:q];
                    [[NSUserDefaults standardUserDefaults] setObject: itemArrayRemoval forKey:@"PlayerItems"];
                }
            }
            else{
                if(KanohiArrayRemoval.count != 0){
                    int randomSelection = (int)KanohiArrayRemoval.count - 1;
                    q = arc4random_uniform(randomSelection);
                    [KanohiArrayRemoval removeObjectAtIndex:q];
                    [[NSUserDefaults standardUserDefaults] setObject: KanohiArrayRemoval forKey:@"PlayerMasks"];
                }
            }

            
            [kanohiDisk runAction:[SKAction waitForDuration:1.0]completion:^(void){
                self.winLoss = 4;
            }];
        }

        
    }
    if(rahiHPFight < 1){ //if the rahi runs out of life we win!
        rahiAttackFlag = false;
        //[resultLabel setText:@"You hit it!"];
        [slideBarSlider setHidden:true];
        [escapeSliderBar setHidden:true];
        //[resultLabel setHidden:true];
        //[rahiSprite removeAllActions];
        [kanohiDisk runAction:[SKAction waitForDuration:1.1]completion:^(void){
            self.winLoss = 3;
        }];
    }
    
    if(rahiDodgeFlag == true){
        if([rahiSprite actionForKey:@"attackAction"] == nil && [rahiSprite actionForKey:@"rahiKO"] == nil){
            //work out rahi animations
            [rahiSprite removeAllActions];

            [rahiSprite runAction:[SKAction repeatActionForever:rahiAttackAction] withKey:@"attackAction"];
            //NSLog(@"enlarging");
            [rahiSprite runAction: rahiEnlarge withKey:@"enlargeAction"];
        }

    }
    if(rahiAttackFlag == true){
        //work out rahi animations
        if([rahiSprite actionForKey:@"idleAction"] == nil && [rahiSprite actionForKey:@"rahiKO"] == nil){
            [rahiSprite removeAllActions];
            [rahiSprite runAction: rahiShrink withKey:@"shrinkAction"];
            [rahiSprite runAction:[SKAction repeatActionForever:rahiIdleAction] withKey:@"idleAction"];
        }
    }
    
    //NSLog(@"WW: %d", whichWay1);
    if(fightProgressCounter == 2){ //if we have finished this fight round...
        if(rahiHPFight > 0){
            if(timerCounter > 0){ //give 2 secs to read any messages
                timerCounter -=1;
                if(timerCounter > 61){ //make sure to only do this one for 60 sec
                    timerCounter = 60;
                }
            }
            else{
                //work out arm position
                [playerArm setZRotation:playerDefaultArmRotation];
                //work out rahi animations
                
                //[rahiSprite runAction:rahiShrink];
                
                //[rahiSprite runAction: [SKAction repeatActionForever: rahiIdleAnimation]];
                //[rahiSprite runAction:[SKAction stop]];
                if([rahiSprite actionForKey:@"idleAction"] == nil && [rahiSprite actionForKey:@"rahiKO"] == nil){
                    if([rahiSprite actionForKey:@"hitRahi"]){
                        [rahiSprite runAction:[SKAction waitForDuration:0.3] completion:^(void){
                            [self->rahiSprite removeAllActions];
                            [self->rahiSprite runAction:self->rahiShrink withKey:@"shrinkAction"];
                            [self->rahiSprite runAction:[SKAction repeatActionForever:self->rahiIdleAction] withKey:@"idleAction"];
                        }];
                    }
                    else{
                        [rahiSprite removeAllActions];
                        [rahiSprite runAction:rahiShrink withKey:@"shrinkAction"];
                        [rahiSprite runAction:[SKAction repeatActionForever:rahiIdleAction] withKey:@"idleAction"];
                    }
                    
                    
                }
                fightProgressCounter = 0;
                [resultLabel setHidden: true];
                [timerLabel setHidden: true];
                //leave HP labels showing
                //[RHPLabel setHidden: false];
                //[PHPLabel setHidden: false];
                [fightButton setHidden: false];
                [runButton setHidden: false];
                [bagButton setHidden: false];
                _runTapped = false; //reset previous actions
                _itemUsed = 0;
            }
        }

    }
    if(fightProgressCounter == 1){ //the half way checker
        if(rahiDodgeFlag == false && rahiAttackFlag == false){ //only do this once basically
            //work out arm position
            [playerArm setZRotation:playerDefaultArmRotation];
            //work out rahi animations
            //[rahiSprite runAction:[SKAction stop]];

            //NSLog(@"here 2");
            if([rahiSprite actionForKey:@"idleAction"] == nil && [rahiSprite actionForKey:@"rahiKO"] == nil){
                if([rahiSprite actionForKey:@"hitRahi"]){
                    [rahiSprite runAction:[SKAction waitForDuration:0.3] completion:^(void){
                        [self->rahiSprite removeAllActions];
                        [self->rahiSprite runAction:self->rahiShrink withKey:@"shrinkAction"];
                        [self->rahiSprite runAction:[SKAction repeatActionForever:self->rahiIdleAction] withKey:@"idleAction"];
                    }];
                }
                else{
                    [rahiSprite removeAllActions];
                    [rahiSprite runAction:rahiShrink withKey:@"shrinkAction"];
                    [rahiSprite runAction:[SKAction repeatActionForever:rahiIdleAction] withKey:@"idleAction"];
                }
            }
            if(timerCounter > 0){ //give 2 secs to read any messages
                timerCounter -=1;
                if(timerCounter < 121){ //make sure to only do this one for 60 sec
                    if(randomRahiAI == 0){ //prepare messages
                        [resultLabel setText:[NSString stringWithFormat:@"The Rahi is about to attack!"]];
                    }
                    else{
                        //NSLog(@"timer: %d", timerCounter);
                        [resultLabel setText:[NSString stringWithFormat:@"Quick, strike! Before it recovers!"]];
                    }
                }
            }
            else{
                if(randomRahiAI == 0){ //if we attacked first, we need to now dodge
                    [rahiSprite removeAllActions];
                    [self rahiDodge];
                    
                }
                /*
                if(randomRahiAI == 1){ //if we dodged first, we need to now attack
                    [rahiSprite removeAllActions];
                    [self rahiAttack];
                    
                }
                 */
                else{ //for more difficult ai, we're almost certainly going to have to dodge first... then we get to attack.
                    //NSLog(@"ai: %d", randomRahiAI);
                    //NSLog(@"called 2");
                    if(rahiAttackCalledFlag == false){
                        [self rahiAttack];
                    }
                }
            }
        }
    }

    
    self.itemUsed = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"BackPackItemUsed"];
    //NSLog(@"Item used: %d", self.itemUsed);
    if(isRunningAnimation == 0){ //start animating
        isRunningAnimation = 1;
        //NSLog(@"here 5");
        if([rahiSprite actionForKey:@"idleAction"] == nil && [rahiSprite actionForKey:@"rahiKO"] == nil){
            [rahiSprite runAction:[SKAction repeatActionForever:rahiIdleAction] withKey:@"idleAction"];
        }
        
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
            [self setBackgroundColor: [UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:0.2]]; //give the akaku view a red tint
            
        }
        
    }
    
    //update HP
    [PHPLabel setText:[NSString stringWithFormat:@"HP: %d", playerHPFight]];
    [RHPLabel setText:[NSString stringWithFormat:@"Rahi: %d", rahiHPFight]]; //make sure the rahi has at least 1 health

    //check to see if we used an interesting rock...
    if(self.itemUsed == 8){
        self.winLoss = 5; //announce that we have gotten away safely!
    }
    
    
    //work out movement of slider
    //left: -448.36
    //right: 448.36
    //these are on the 7 axis, not x
    if(rahiDodgeFlag == true || rahiAttackFlag == true){ //if we are in an active fight...
        if(actionTimer > 0){ //as long as we have time to do it...
            //first work out the timer
            [timerLabel setText:[NSString stringWithFormat:@"%d", actionTimer]]; //set the timer label
            timerCounter -= 1;
            //NSLog(@"Timer: %d", timerCounter);
            //NSLog(@"Y Pos: %f", slideBarSlider.position.y);
            //NSLog(@"X Pos: %f", slideBarSlider.position.x);
            
            if(timerCounter < 0){
                actionTimer -= 1;
                timerCounter = timerCounterDefault;
            }

            //add scaling

            
            //work out slider movement
            if(rahiDodgeFlag == true){
                if(whichWay1 == 0){
                    if(slideBarSlider.position.y < 448.36){ //if we're not already on the far right (-448.36) (448.36)
                        [slideBarSlider setPosition:CGPointMake(slideBarSlider.position.x, (slideBarSlider.position.y + sliderSpeed))];
                        
                    }
                    else{
                        whichWay1 = 1;
                    }
                }
                else{
                    if(slideBarSlider.position.y > -448.36){ //if we're not already on the far left
                        [slideBarSlider setPosition:CGPointMake(slideBarSlider.position.x, (slideBarSlider.position.y - sliderSpeed))];
                    }
                    else{
                        whichWay1 = 0;
                    }
                }
                
                
            } //these 2 move in opposite directions
            else if (rahiAttackFlag == true){
                if(whichWay1 == 0){
                    if(slideBarSlider.position.y < 447.639){ //if we're not already on the far right (-448.36) (447.639)
                        [slideBarSlider setPosition:CGPointMake(slideBarSlider.position.x, (slideBarSlider.position.y + sliderSpeed))];
                        
                    }
                    else{
                        whichWay1 = 1;
                    }
                }
                else{
                    if(slideBarSlider.position.y > -448.36){ //if we're not already on the far left
                        [slideBarSlider setPosition:CGPointMake(slideBarSlider.position.x, (slideBarSlider.position.y - sliderSpeed))];
                    }
                    else{
                        whichWay1 = 0;
                    }
                }
            }
            
        }
        else{ //otherwise reset the slider and hide it
            [timerLabel setText:[NSString stringWithFormat:@"%d", actionTimer]]; //set the timer label
            [resultLabel setText:[NSString stringWithFormat:@"Too slow!"]]; //set the timer label
            [resultLabel setHidden:false];
            fightProgressCounter += 1;
            [slideBarSlider setHidden:true];
            [escapeSliderBar setHidden:true];
            [aimSliderBar setHidden:true];
            [slideBarSlider setPosition:defaultSliderPos]; //put the slider back where it belongs in the middle
            [playerArm runAction:[SKAction moveToY:-996 duration:0.5] completion:^(void){ //if we still have the disk, withdraw the arm briefly and hide it
                //make the disk "appear"
                //self->rahiRunningAnimation = true;
                //[self->rahiSprite runAction:self->rahiIdleAction withKey:@"idleAction"];
                [self->kanohiDisk setHidden:true];
                //NSLog(@"part 1: %d", self->rahiAttackFlag);
                [self->playerArm runAction:[SKAction moveToY:-283 duration:0.5] completion:^(void){
                }];
            }];
            if(rahiDodgeFlag == true){
                [self playerLostHealth];
                
            }
            rahiDodgeFlag = false;
            rahiAttackFlag = false; //reset these back to false at the end of this
            timerCounter = 240;
            
        }
        
    }
    
    //work out player attacking animations
    
    
    
}

-(void)chooseRahiImage{ //sort out getting the correct rahi images
    if(_rahiType == NULL){ //give a more pleasent name for rahi if the type is null.
        _rahiType = @"unnamed";
    }
    rahiActualName = [_rahiType lowercaseString];


    
    //work out temporary sprites for larger rahi...
    if([rahiActualName isEqualToString:@"pekapeka"] || [rahiActualName isEqualToString:@"ngarara"] || [rahiActualName isEqualToString:@"fikou"] || [rahiActualName isEqualToString:@"jaga"] || [rahiActualName isEqualToString:@"hoi"]){
        rahiDifficulty = 3;
    }
        
    else{//temporary until big rahi are properly added
        NSArray *randomSmallRahiArray = @[@"ngarara", @"pekapeka",@"jaga",@"hoi",@"fikou"];
        int i = arc4random_uniform(5);
        rahiActualName = randomSmallRahiArray[i];
        //assign names to a array of idle sprites to create an animation
        
    }
    rahiHPFight = rahiDifficulty;
    rahiAtlas = [SKTextureAtlas atlasNamed: [NSString stringWithFormat: @"%@.atlas", rahiActualName]];
    //NSLog(@"atlas: %@", rahiAtlas);
    //NSLog(@"atlas name: %@", [NSString stringWithFormat: @"%@.atlas", rahiActualName]);
    
    //assign names to a array of idle sprites to create an animation
    rahiIdleArray = @[[rahiAtlas textureNamed:[NSString stringWithFormat:@"%@0", rahiActualName]], [rahiAtlas textureNamed:[NSString stringWithFormat:@"%@1", rahiActualName]], [rahiAtlas textureNamed:[NSString stringWithFormat:@"%@2", rahiActualName]], [rahiAtlas textureNamed:[NSString stringWithFormat:@"%@1", rahiActualName]]];
    
    rahiIdleAction = [SKAction animateWithTextures:rahiIdleArray timePerFrame:0.15];
    rahiAttackAction = [SKAction animateWithTextures:rahiIdleArray timePerFrame:0.15];
    //generate other arrays and the actions for them
    
    //small rahi
    if([rahiActualName isEqualToString:@"pekapeka"]){
        //pekapeka
        pekapekaKOArray = @[[rahiAtlas textureNamed:[NSString stringWithFormat:@"%@5", rahiActualName]], [rahiAtlas textureNamed:[NSString stringWithFormat:@"%@6", rahiActualName]], [rahiAtlas textureNamed:[NSString stringWithFormat:@"%@7", rahiActualName]],[rahiAtlas textureNamed:[NSString stringWithFormat:@"%@8", rahiActualName]],[rahiAtlas textureNamed:[NSString stringWithFormat:@"%@9", rahiActualName]],[rahiAtlas textureNamed:[NSString stringWithFormat:@"%@9", rahiActualName]],[rahiAtlas textureNamed:[NSString stringWithFormat:@"%@9", rahiActualName]]];
        pekapekaAttackArray = rahiIdleArray;
        //NSLog(@"pekapeka");
        rahiAttackAction = [SKAction animateWithTextures:pekapekaAttackArray timePerFrame:0.15];
        rahiKOAction = [SKAction animateWithTextures:pekapekaKOArray timePerFrame:0.25];
    }
    
    else if([rahiActualName isEqualToString:@"ngarara"]){
        //ngarara
        ngararaKOArray = @[[rahiAtlas textureNamed:[NSString stringWithFormat:@"%@0", rahiActualName]], [rahiAtlas textureNamed:[NSString stringWithFormat:@"%@4", rahiActualName]], [rahiAtlas textureNamed:[NSString stringWithFormat:@"%@5", rahiActualName]], [rahiAtlas textureNamed:[NSString stringWithFormat:@"%@5", rahiActualName]], [rahiAtlas textureNamed:[NSString stringWithFormat:@"%@5", rahiActualName]]];
        ngararaAttackArray = rahiIdleArray;
        //NSLog(@"ngarara");
        rahiAttackAction = [SKAction animateWithTextures:ngararaAttackArray timePerFrame:0.15];
        rahiKOAction = [SKAction animateWithTextures:ngararaKOArray timePerFrame:0.25];
    }
    
    else if([rahiActualName isEqualToString:@"fikou"]){
        //fikou
        fikouKOArray = @[[rahiAtlas textureNamed:[NSString stringWithFormat:@"%@4", rahiActualName]], [rahiAtlas textureNamed:[NSString stringWithFormat:@"%@5", rahiActualName]], [rahiAtlas textureNamed:[NSString stringWithFormat:@"%@6", rahiActualName]], [rahiAtlas textureNamed:[NSString stringWithFormat:@"%@7", rahiActualName]], [rahiAtlas textureNamed:[NSString stringWithFormat:@"%@7", rahiActualName]], [rahiAtlas textureNamed:[NSString stringWithFormat:@"%@7", rahiActualName]]];
        fikouAttackArray = rahiIdleArray;
        //NSLog(@"fikou");
        rahiAttackAction = [SKAction animateWithTextures:fikouAttackArray timePerFrame:0.15];
        rahiKOAction = [SKAction animateWithTextures:fikouKOArray timePerFrame:0.25];
    }
    
    else if([rahiActualName isEqualToString:@"jaga"]){
        //jaga
        
        jagaKOArray = @[[rahiAtlas textureNamed:[NSString stringWithFormat:@"%@5", rahiActualName]], [rahiAtlas textureNamed:[NSString stringWithFormat:@"%@6", rahiActualName]], [rahiAtlas textureNamed:[NSString stringWithFormat:@"%@7", rahiActualName]],[rahiAtlas textureNamed:[NSString stringWithFormat:@"%@8", rahiActualName]],[rahiAtlas textureNamed:[NSString stringWithFormat:@"%@9", rahiActualName]],[rahiAtlas textureNamed:[NSString stringWithFormat:@"%@9", rahiActualName]],[rahiAtlas textureNamed:[NSString stringWithFormat:@"%@9", rahiActualName]]];
        jagaAttackArray = rahiIdleArray;
        //NSLog(@"jaga");
        rahiAttackAction = [SKAction animateWithTextures:jagaAttackArray timePerFrame:0.15];
        rahiKOAction = [SKAction animateWithTextures:jagaKOArray timePerFrame:0.25];
    }
    
    else if([rahiActualName isEqualToString:@"hoi"]){
        //hoi
        hoiAttackArray = @[[rahiAtlas textureNamed:[NSString stringWithFormat:@"%@4", rahiActualName]], [rahiAtlas textureNamed:[NSString stringWithFormat:@"%@5", rahiActualName]], [rahiAtlas textureNamed:[NSString stringWithFormat:@"%@6", rahiActualName]], [rahiAtlas textureNamed:[NSString stringWithFormat:@"%@5", rahiActualName]],[rahiAtlas textureNamed:[NSString stringWithFormat:@"%@4", rahiActualName]]];
        hoiKOArray = @[[rahiAtlas textureNamed:[NSString stringWithFormat:@"%@7", rahiActualName]], [rahiAtlas textureNamed:[NSString stringWithFormat:@"%@8", rahiActualName]], [rahiAtlas textureNamed:[NSString stringWithFormat:@"%@9", rahiActualName]], [rahiAtlas textureNamed:[NSString stringWithFormat:@"%@9", rahiActualName]], [rahiAtlas textureNamed:[NSString stringWithFormat:@"%@9", rahiActualName]]];
        //NSLog(@"hoi");
        rahiAttackAction = [SKAction animateWithTextures:hoiAttackArray timePerFrame:0.15];
        rahiKOAction = [SKAction animateWithTextures:hoiKOArray timePerFrame:0.25];
    }
    rahiEnlarge = [SKAction scaleTo:2.0 duration:growShrinkTimeInterval];
    rahiShrink = [SKAction scaleTo:1.0 duration:growShrinkTimeInterval];

    
    
    
    //assign a starting sprite
    //NSLog(@"Rahi actual name: %@", rahiActualName);
    //NSLog(@"Rahi idle array: %@", rahiIdleArray);
    
    

}

-(void)rahiAttack{ //what to do if its your turn to attack the rahi
    rahiAttackCalledFlag = true; //to stop this being called more than once at a time
    actionTimer = 3;
    [timerLabel setHidden:false];
    [resultLabel setHidden:true];
    
    [playerArm setZRotation:playerDefaultArmRotation];
    //run action to make the players disk appear
    [rahiSprite removeAllActions];
    //NSLog(@"called1");
    [rahiSprite runAction: [SKAction repeatActionForever:rahiIdleAction]];
    [playerArm runAction:[SKAction moveToY:-996 duration:0.7] completion:^(void){
         //make the disk "appear"
        [self->kanohiDisk setHidden:false];
        //[self->rahiSprite runAction:self->rahiIdleAction withKey:@"idleAction"];
        //NSLog(@"part 1: %d", self->rahiAttackFlag);
        [self->playerArm runAction:[SKAction moveToY:-283 duration:0.5] completion:^(void){
            self->rahiAttackFlag = true;
            self->rahiDodgeFlag = false;
            self->timerCounter = self->timerCounterDefault;
            
            //NSLog(@"part 2: %d", self->rahiAttackFlag);
            [self->slideBarSlider setPosition:CGPointMake(self->slideBarSlider.position.x, -448.36)]; //start on the left side and work towards the middle
            self->playerRecentlyLostHealth = false;
            [self->aimSliderBar setHidden:false];
            [self->slideBarSlider setHidden:false];
            self->rahiAttackCalledFlag = false;
        }];

    }];
    


    
}

-(void)rahiDodge{ //what to do if its the rahi's turn to attack you!
    [playerArm setZRotation:playerDefaultArmRotation];
    [escapeSliderBar setHidden:false];
    [slideBarSlider setHidden:false];
    actionTimer = 3; //3 seconds
    [timerLabel setHidden:false];
    [resultLabel setHidden:true];
    rahiDodgeFlag = true;
    rahiAttackFlag = false;
    timerCounter = timerCounterDefault; //10000 microseconds, or 1 second
    
    [kanohiDisk setHidden:true];
    [slideBarSlider setPosition:defaultSliderPos]; //start in the middle and work towards the sides
    playerRecentlyLostHealth = false;
}

-(void)setUpAttack{

}

-(void)playerLostHealth{
    [playerArm setZRotation: -1.22173048]; //70 degrees
    timerCounter = 240; //set this so that we can display messages for 1 second
    //work out player resistances
    playerResistance1 = 0;
    rahiResistance1 = 0;
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"] containsString:@"rau"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"] containsString:@"kaukau"]){
        if([_rahiType isEqualToString:@"hoi"]){
            playerResistance1 += 2;
        }
        else if([_rahiType isEqualToString:@"ngarara"]){
            playerResistance1 += 1;
        }
        else if([_rahiType isEqualToString:@"pekapeka"]){
            playerResistance1 -= 2;
        }
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"] containsString:@"akaku"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"] containsString:@"matatu"]){
        if([_rahiType isEqualToString:@"ngarara"]){
            playerResistance1 += 2;
        }
        else if([_rahiType isEqualToString:@"hoi"]){
            playerResistance1 += 1;
        }
        else if([_rahiType isEqualToString:@"fikou"]){
            playerResistance1 -= 2;
        }
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"] containsString:@"hau"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"] containsString:@"huna"]){
        if([_rahiType isEqualToString:@"ngarara"]){
            playerResistance1 += 1;
        }
        else if([_rahiType isEqualToString:@"hoi"]){
            playerResistance1 -= 2;
        }
        else if([_rahiType isEqualToString:@"fikou"]){
            playerResistance1 += 2;
        }
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"] containsString:@"miru"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"] containsString:@"mahiki"]){
        if([_rahiType isEqualToString:@"ngarara"]){
            playerResistance1 += 2;
        }
        else if([_rahiType isEqualToString:@"jaga"]){
            playerResistance1 -= 2;
        }
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"] containsString:@"kakama"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"] containsString:@"komau"]){
        if([_rahiType isEqualToString:@"jaga"]){
            playerResistance1 += 2;
        }
        else if([_rahiType isEqualToString:@"hoi"]){
            playerResistance1 -= 2;
        }
        else if([_rahiType isEqualToString:@"pekapeka"]){
            playerResistance1 += 1;
        }
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"] containsString:@"ruru"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"] containsString:@"pakari"]){
        if([_rahiType isEqualToString:@"pekapeka"]){
            playerResistance1 += 2;
        }
        else if([_rahiType isEqualToString:@"ngarara"]){
            playerResistance1 -= 1;
        }
        else if([_rahiType isEqualToString:@"jaga"]){
            playerResistance1 += 1;
        }
        else if([_rahiType isEqualToString:@"fikou"]){
            playerResistance1 -= 1;
        }
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"] containsString:@"avohkii"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"] containsString:@"vahi"]){
        //no gain or loss in resistance, sort of a bonus?
        
    }
    
    
    if(playerRecentlyLostHealth != true){
        playerHPFight -= rahiDifficulty;
        playerHPFight += playerResistance1; //remove player health minus or added to any bonuses or penalties from resistances
        //playerHPFight + rahiResistance1;
        playerRecentlyLostHealth = true;
        [[NSUserDefaults standardUserDefaults] setInteger: playerHPFight forKey:@"PlayerHP"];
    }
}

@end
