//
//  OptionsViewController.m
//  Matoran Quest
//
//  Created by Job Dyer on 16/11/23.
//

#import "OptionsViewController.h"

@interface OptionsViewController ()

@end

@implementation OptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    int vibrationCheck = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerVibrate"];
    //NSLog(@"tt: %d", vibrationCheck);
    [_vibrationSwitch setSelectedSegmentIndex:vibrationCheck]; //set the on off for vibration
    
    int cameraCheck = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ShowCameraBackgroundSetting"];
    if(cameraCheck == 0){
        [_cameraSwitch setSelectedSegmentIndex:0];
    }
    else{
        [_cameraSwitch setSelectedSegmentIndex:1]; //set camera switch to user default
    }
    
    int eyeHolesCheck = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ShowKanohiEyeHolesSetting"];
    if(eyeHolesCheck == 0){
        [_eyeHolesSwitch setSelectedSegmentIndex:0];
    }
    else{
        [_eyeHolesSwitch setSelectedSegmentIndex:1]; //set eye holes switch to user default
    }
    
    
    
    int maskDisplayingCheck = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"showKanohiCollectionSetting"];
    if(maskDisplayingCheck == 0){
        [_maskDisplaySwitch setSelectedSegmentIndex:1]; //set the on off for mask displays (default is show all masks)
    }
    else{
        [_maskDisplaySwitch setSelectedSegmentIndex:0];
    }

}

-(void)viewDidAppear:(BOOL)animated{
    //[[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait]forKey:@"orientation"];//set the controller to be portrait
}

- (void)resetButtonPressed:(nonnull id)sender __attribute__((ibaction)) { //make a yes no confirm alert for deleting everything
    NSLog(@"Masks: %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMasks"]);
    NSLog(@"Items: %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerItems"]);
    NSLog(@"Widgets: %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerWidgets"]);
    NSLog(@"Collection: %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMaskCollectionList"]);
    UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:@"Are you sure?"
                                   message:@"Press YES to completely reset the game.\nYou will lose all progress and restart with an empty inventory and mask collection."
                                   preferredStyle:UIAlertControllerStyleAlert];
     
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {
        NSArray *defaultArray1 = [[NSMutableArray alloc] init]; 
        [[NSUserDefaults standardUserDefaults] setObject: defaultArray1 forKey:@"PlayerMasks"];
        defaultArray1 = [[NSMutableArray alloc] init]; //create 2 arrays, 1 array within an array for the first item, the masks, the second for the items
        [[NSUserDefaults standardUserDefaults] setObject: defaultArray1 forKey:@"PlayerItems"]; //set a variety of game variables back to 0.
        [[NSUserDefaults standardUserDefaults] setObject: defaultArray1 forKey:@"PlayerAvailibleToWearMasks"]; //set a variety of game variables back to 0.
        [[NSUserDefaults standardUserDefaults] setObject: defaultArray1 forKey:@"PlayerMaskCollectionList"]; //set the collection counter back to 0!
        [[NSUserDefaults standardUserDefaults] setObject: defaultArray1 forKey:@"PlayerCollectedKanohiCodes"]; //set the list of redeemed mask codes back to empty.
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"PlayerWidgets"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"PlayerFighting"];
        [[NSUserDefaults standardUserDefaults] setInteger: 0 forKey:@"PlayerRares"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"maskChosen"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"UniquePhoneIdentifier"];
        [[NSUserDefaults standardUserDefaults] setInteger: 0 forKey:@"BackPackItemUsed"];
        NSLog(@"DELETED");
        
        

        
    }];
    [deleteAlert addAction:defaultAction];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel
       handler:^(UIAlertAction * action) {}];
     
    [deleteAlert addAction:cancelAction];
    
    [self presentViewController:deleteAlert animated:YES completion:nil]; //run the alert
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)vibrationSwitchSwitched:(nonnull id)sender __attribute__((ibaction)) {
    if(_vibrationSwitch.selectedSegmentIndex == 0){
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"PlayerVibrate"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"PlayerVibrate"];
    }
    //NSLog(@"tt: %d", (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerVibrate"]);
}

- (void)MaskSwitchSwitched:(nonnull id)sender __attribute__((ibaction)) {
    if(_maskDisplaySwitch.selectedSegmentIndex == 0){
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"showKanohiCollectionSetting"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"showKanohiCollectionSetting"];
    }
    //NSLog(@"tt: %d", (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerVibrate"]);
}

- (void)eyeHolesSwitchSwitched:(nonnull id)sender __attribute__((ibaction)) {
    if(_eyeHolesSwitch.selectedSegmentIndex == 0){
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"ShowKanohiEyeHolesSetting"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"ShowKanohiEyeHolesSetting"];
    }
}

- (void)cameraSwitchSwitched:(nonnull id)sender __attribute__((ibaction)) {
    if(_cameraSwitch.selectedSegmentIndex == 0){
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"ShowCameraBackgroundSetting"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"ShowCameraBackgroundSetting"];
    }
}

@end
