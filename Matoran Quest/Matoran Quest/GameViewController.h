//
//  GameViewController.h
//  Matoran Quest
//
//  Created by Job Dyer on 12/11/23.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"
#import "MapController.h"
#import "BattleInventoryViewController.h"
#import <GameplayKit/GameplayKit.h>
#import <AVFoundation/AVCaptureSession.h>
#import <AVFoundation/AVCapturePhotoOutput.h>
#import <AVFoundation/AVCaptureInput.h>
#import <AVFoundation/AVCaptureVideoPreviewLayer.h> //these are needed to run the sprite kit app and also have a live video feed in the background.


@interface GameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *cameraView1;
@property (weak, nonatomic) IBOutlet SKView *gamePresentationView;
@property (nonatomic, assign) NSString *rahiName2; //the type of rahi we are fighting
//@property (nonatomic, assign) int rahiFightFlag3; //holds the outcome of the fight against the rahi above
@property (nonatomic) AVCaptureSession *captureSession; //set up the camera variables
@property (nonatomic) AVCapturePhotoOutput *stillImageOutput;
@property (nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
//@property (nonatomic) GameScene *scene; //the game scene used in this controller

@end
