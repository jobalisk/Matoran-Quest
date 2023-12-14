//
//  BattleInventoryViewController.m
//  Matoran Quest
//
//  Created by Job Dyer on 14/12/23.
//

#import "BattleInventoryViewController.h"

@interface BattleInventoryViewController ()

@end

@implementation BattleInventoryViewController

float rotationCostant1 = 90.0;
float rotationCostant2 = 180.0;


- (void)viewDidLoad {
    [super viewDidLoad];
    //rotate all buttons correctly
    self.titleEnglish.transform = CGAffineTransformMakeRotation( ( rotationCostant1 * M_PI ) / rotationCostant2 );
    self.earthButton.transform = CGAffineTransformMakeRotation( ( rotationCostant1 * M_PI ) / rotationCostant2 );
    self.stoneButton.transform = CGAffineTransformMakeRotation( ( rotationCostant1 * M_PI ) / rotationCostant2 );
    self.rockButton.transform = CGAffineTransformMakeRotation( ( rotationCostant1 * M_PI ) / rotationCostant2 );
    self.airButton.transform = CGAffineTransformMakeRotation( ( rotationCostant1 * M_PI ) / rotationCostant2 );
    self.waterButton.transform = CGAffineTransformMakeRotation( ( rotationCostant1 * M_PI ) / rotationCostant2 );
    self.fireButton.transform = CGAffineTransformMakeRotation( ( rotationCostant1 * M_PI ) / rotationCostant2 );
    self.iceButton.transform = CGAffineTransformMakeRotation( ( rotationCostant1 * M_PI ) / rotationCostant2 );
    self.fruitButton.transform = CGAffineTransformMakeRotation( ( rotationCostant1 * M_PI ) / rotationCostant2 );
    self.protodermisButton.transform = CGAffineTransformMakeRotation( ( rotationCostant1 * M_PI ) / rotationCostant2 );
    self.superButton.transform = CGAffineTransformMakeRotation( ( rotationCostant1 * M_PI ) / rotationCostant2 );
}

-(void)viewDidAppear:(BOOL)animated{

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)airButtonP:(nonnull id)sender __attribute__((ibaction)) {
    [self returnToBattle];
}

- (void)earthButtonP:(nonnull id)sender __attribute__((ibaction)) {
    [self returnToBattle];
}

- (void)fireButtonP:(nonnull id)sender __attribute__((ibaction)) {
    [self returnToBattle];
}

- (void)fruitButtonP:(nonnull id)sender __attribute__((ibaction)) {
    [self returnToBattle];
}

- (void)iceButtonP:(nonnull id)sender __attribute__((ibaction)) {
    [self returnToBattle];
}

- (void)protodermisButtonP:(nonnull id)sender __attribute__((ibaction)) {
    [self returnToBattle];
}

- (void)rockButtonP:(nonnull id)sender __attribute__((ibaction)) {
    [self returnToBattle];
}

- (void)stoneButtonP:(nonnull id)sender __attribute__((ibaction)) {
    [self returnToBattle];
}

- (void)superButtonP:(nonnull id)sender __attribute__((ibaction)) {
    [self returnToBattle];
}

- (void)waterButtonP:(nonnull id)sender __attribute__((ibaction)) {
    [self returnToBattle];
}

-(void)returnToBattle{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
