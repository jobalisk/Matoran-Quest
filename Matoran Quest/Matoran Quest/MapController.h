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

NS_ASSUME_NONNULL_BEGIN

@interface MapController : UIViewController

@property (nonatomic, weak) IBOutlet MKMapView *theMap; //the players name feild setter
@property (nonatomic, weak) IBOutlet UILabel *theLabel; //long and lat label
@property (nonatomic, weak) IBOutlet UILabel *theHP; //HP label
@property (nonatomic, weak) IBOutlet UIView *blackOutView; //allows for fading to black
@property (nonatomic, assign) int rahiFightFlag;

@end

NS_ASSUME_NONNULL_END
