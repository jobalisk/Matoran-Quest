//
//  GameViewController.h
//  Matoran Quest
//
//  Created by Job Dyer on 12/11/23.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"
#import <GameplayKit/GameplayKit.h>
#import <AVFoundation/AVCaptureSession.h>
#import <AVFoundation/AVCapturePhotoOutput.h>
#import <AVFoundation/AVCaptureVideoPreviewLayer.h> //these are needed to run the sprite kit app and also have a live video feed in the background.


@interface GameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *cameraView1;
@property (weak, nonatomic) IBOutlet SKView *gamePresentationView;
@property (nonatomic, assign) NSString *rahiName2;

@end
