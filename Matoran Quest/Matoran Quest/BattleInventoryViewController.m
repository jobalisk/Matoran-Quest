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

float rotationCostant1 = 90.0; //what values are we rotating the buttons by
float rotationCostant2 = 180.0;
NSMutableArray *itemsArray; //holds all items in the players inventory


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
    
    //get inventory
    itemsArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerItems"];
    itemsArray = [itemsArray mutableCopy];
    [self enableOrDissableButtons]; //work out what we have
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

-(void)enableOrDissableButtons{ //work out which buttons are enabled depending on whats in the players inventory
    NSLog(@"items: %@", itemsArray);
    if([itemsArray indexOfObject:@"Vuata Maca fruit"]==NSNotFound){ //check if the inventory contains this item
        //NSLog(@"fruit not here");
        [_fruitButton setEnabled:FALSE]; //if it does not, dissable the button
    }
    if([itemsArray indexOfObject:@"Energised Protodermis"]==NSNotFound){ //check if the inventory contains this item
        //NSLog(@"protodermis not here");
        [_protodermisButton setEnabled:FALSE]; //if it does not, dissable the button
    }
    if([itemsArray indexOfObject:@"Super Disk"]==NSNotFound){ //check if the inventory contains this item
        [_superButton setEnabled:FALSE]; //if it does not, dissable the button
    }
    if([itemsArray indexOfObject:@"Charged Fire Disk"]==NSNotFound){ //check if the inventory contains this item
        [_fireButton setEnabled:FALSE]; //if it does not, dissable the button
    }
    if([itemsArray indexOfObject:@"Charged Water Disk"]==NSNotFound){ //check if the inventory contains this item
        [_waterButton setEnabled:FALSE]; //if it does not, dissable the button
    }
    if([itemsArray indexOfObject:@"Charged Earth Disk"]==NSNotFound){ //check if the inventory contains this item
        [_earthButton setEnabled:FALSE]; //if it does not, dissable the button
    }
    if([itemsArray indexOfObject:@"Charged Stone Disk"]==NSNotFound || [itemsArray indexOfObject:@"Charged Rock Disk"]==NSNotFound){ //check if the inventory contains this item
        [_stoneButton setEnabled:FALSE]; //if it does not, dissable the button
    }
    if([itemsArray indexOfObject:@"Charged Air Disk"]==NSNotFound){ //check if the inventory contains this item
        [_airButton setEnabled:FALSE]; //if it does not, dissable the button
    }
    if([itemsArray indexOfObject:@"Charged Ice Disk"]==NSNotFound){ //check if the inventory contains this item
        [_iceButton setEnabled:FALSE]; //if it does not, dissable the button
    }
    if([itemsArray indexOfObject:@"Cool looking rock"]==NSNotFound){ //check if the inventory contains this item
        [_rockButton setEnabled:FALSE]; //if it does not, dissable the button
    }
}

@end
