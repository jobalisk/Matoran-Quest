//
//  GameViewController.m
//  Matoran Quest
//
//  Created by Job Dyer on 12/11/23.
//

#import "GameViewController.h"
#import "GameScene.h"


@implementation GameViewController

//int rahiFightProgress = 0; //this is the progress variable for the fight and cheif way to communicate between controller and scene
GameScene *scene;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setModalInPresentation:true]; //make it so you can's swipe it away (stops cheating)

    


    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // Load the SKScene from 'GameScene.sks'
    //NSLog(@"RahiName1: %@", _rahiName2);
    scene = (GameScene *)[SKScene nodeWithFileNamed:@"rahiScene"];
    scene.rahiType = self.rahiName2; //give the gamescene a copy of the rahi name to work out correct sprites, ect
    // Set the scale mode to scale to fit the window

    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    //SKView *skView = (SKView *)self.gamePresentationView;
    
    // Present the scene
    //[skView presentScene:scene];
    [self.gamePresentationView presentScene:scene];
    //
    //NSLog(@"RahiName2: %@", scene.rahiType);
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;

    //[[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationLandscapeLeft]forKey:@"orientation"];//set the controller to be portrait

    //[UINavigationController attemptRotationToDeviceOrientation];
    
    //set up rahi fighting flags
    //rahiFightProgress = 1;
    //[[NSUserDefaults standardUserDefaults] setInteger:rahiFightProgress forKey:@"rahiFightingFlags"]; //this is needed to communicate between the view controller and the scene
    
    
    //get the camera running in the background
    int cameraCheck = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ShowCameraBackgroundSetting"];
    if(cameraCheck == 0){
        //start setting up the camera
        self.captureSession = [AVCaptureSession new];
        self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
        //set up the back camera for work...
        AVCaptureDevice *backCamera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if (!backCamera) { //if there is no suitable back camera, give an error then turn the camera setting off.
            UIAlertController *cameraErrorAlert1 = [UIAlertController alertControllerWithTitle:@"Camera Error 1"
                                                                                    message:@"Your device does not have a suitable camera for augmented reality!\nThe camera option will now be turned off in options."
                                                                             preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction10 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action) {
                [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"ShowCameraBackgroundSetting"];
            }];
            [cameraErrorAlert1 addAction:defaultAction10];
            
            [self presentViewController:cameraErrorAlert1 animated:YES completion:nil]; //run the alert
            [self setBlandBackground];
            return;
        }
        
        NSError *error;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera
                                                                            error:&error];
        if (!error) {
            self.stillImageOutput = [AVCapturePhotoOutput new];
            self.stillImageOutput = [AVCapturePhotoOutput new];

            if ([self.captureSession canAddInput:input] && [self.captureSession canAddOutput:self.stillImageOutput]) {
                
                [self.captureSession addInput:input];
                [self.captureSession addOutput:self.stillImageOutput];
                [self setupLivePreview];
            }
        }
        else {
            UIAlertController *cameraErrorAlert1 = [UIAlertController alertControllerWithTitle:@"Camera Error 2"
                                                                                    message:@"The camera on your device failed to work correctly!\nThe camera option will now be turned off in options."
                                                                             preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction10 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action) {
                [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"ShowCameraBackgroundSetting"];
            }];
            [cameraErrorAlert1 addAction:defaultAction10];
            
            [self presentViewController:cameraErrorAlert1 animated:YES completion:nil]; //run the alert
            [self setBlandBackground];
        }
        //once checks have been made...
        
    }
    else{ //if we don't want a camera it will just show a generic background
        [self setBlandBackground];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while(scene.winLoss == 0){
            //check for inventory opening here
            if(scene.gotoBackPack == 1){
                scene.gotoBackPack = 0;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSegueWithIdentifier:@"GoToBackPackBattle1" sender:self];
                });
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            MapController *parentVC = (MapController *)self.presentingViewController; //get a handle on our parent map controller
            parentVC.rahiFightFlag4 = scene.winLoss;
            parentVC.rahiType3 = self.rahiName2;
            parentVC.screenFade = 0.0; //reset this back to visable.
            [parentVC.blackOutView setAlpha:0.0]; //reset this back to visable.
            [self dismissViewControllerAnimated:YES completion:nil];
        });

        
    });

    
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

- (void)setupLivePreview { //configure live preview
    
    self.videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    if (self.videoPreviewLayer) {
        
        self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        self.videoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        [self.cameraView1.layer addSublayer:self.videoPreviewLayer];
        
        dispatch_queue_t globalQueue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(globalQueue, ^{
            [self.captureSession startRunning];
            dispatch_async(dispatch_get_main_queue(), ^{ //put the live feed into the image view
                CGRect screenRect = [[UIScreen mainScreen] bounds];
                //CGFloat screenWidth = screenRect.size.width;
                //CGFloat screenHeight = screenRect.size.height; //get the height of the iphones screen and divide it by 27% in order to correctly place the video feed on the screen
                self.videoPreviewLayer.frame = CGRectMake(self.cameraView1.bounds.origin.x, (self.cameraView1.bounds.origin.x - ((screenRect.size.height * 0.27))), (self.cameraView1.bounds.size.width *1.5), (self.cameraView1.bounds.size.height *1.5)); //its a bit weird but it works
                //check to see if the fight is over...


            });
            
        });
    }
}


-(void)setBlandBackground{ //sets the background if the camera is off
    [_cameraView1 setImage:[UIImage imageNamed:@"genericBackdrop.png"]]; //put on a generic background
    [_cameraView1 setContentMode: UIViewContentModeScaleToFill];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //make sure to tie up any loose ends and properly close this controller so it doesn't use up extra RAM and CPU.

}

@end
