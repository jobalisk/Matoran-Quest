//
//  MapController.h
//  Matoran Quest
//
//  Created by Job Dyer on 12/11/23.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "GameViewController.h"
#import "MenuController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MapController : UIViewController

@property (nonatomic, weak) IBOutlet MKMapView *theMap; //the players name feild setter
@property (nonatomic, weak) IBOutlet UILabel *theLabel; //long and lat label
@property (nonatomic, weak) IBOutlet UILabel *theHP; //HP label
@property (nonatomic, weak) IBOutlet UIView *blackOutView; //allows for fading to black
@property (nonatomic, assign) int rahiFightFlag4;
@property (nonatomic, assign) float screenFade; //a float to hold the blackout value of the screen. this needs to be reset from a different controller
@property (nonatomic, assign) NSString *rahiType3; //holds the rahi we have just been fighting
-(IBAction) returnToSender: (id) sender; //the return button


@end

NS_ASSUME_NONNULL_END
