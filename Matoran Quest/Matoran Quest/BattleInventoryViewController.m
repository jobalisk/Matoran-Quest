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
    self.returnButton.transform = CGAffineTransformMakeRotation( ( rotationCostant1 * M_PI ) / rotationCostant2 );
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
    
    //sort out what items we will be using variable
    self.itemUsed2 = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"BackPackItemUsed"];
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
    [self removeItemFromBag:@"Charged Air Disk"];
    self.itemUsed2 = 1; //1 is air disk
    [self returnToBattle];
}

- (void)earthButtonP:(nonnull id)sender __attribute__((ibaction)) {
    self.itemUsed2 = 2; //2 is earth disk
    [self removeItemFromBag:@"Charged Earth Disk"];
    [self returnToBattle];
}

- (void)fireButtonP:(nonnull id)sender __attribute__((ibaction)) {
    self.itemUsed2 = 3; //3 is fire disk
    [self removeItemFromBag:@"Charged Fire Disk"];
    [self returnToBattle];
}

- (void)fruitButtonP:(nonnull id)sender __attribute__((ibaction)) {
    self.itemUsed2 = 9; //9 is vuata maka fruit
    [self removeItemFromBag:@"Vuata Maca fruit"];
    int playerHPFight23 = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerHP"]; //load player HP
    if(playerHPFight23 > 6){ //heal the player 3 (or full health if they're on 7 or more.)
        [[NSUserDefaults standardUserDefaults] setInteger: 10 forKey:@"PlayerHP"];
    }
    else{
        playerHPFight23 += 3;
        [[NSUserDefaults standardUserDefaults] setInteger: playerHPFight23 forKey:@"PlayerHP"];
    }
    [self returnToBattle];
}

- (void)iceButtonP:(nonnull id)sender __attribute__((ibaction)) {
    self.itemUsed2 = 4; //4 is ice disk
    [self removeItemFromBag:@"Charged Ice Disk"];
    [self returnToBattle];
}

- (void)protodermisButtonP:(nonnull id)sender __attribute__((ibaction)) {
    self.itemUsed2 = 10; //10 is energized protodermis
    [[NSUserDefaults standardUserDefaults] setInteger: 10 forKey:@"PlayerHP"]; //full heal the player
    [self removeItemFromBag:@"Energised Protodermis"];
    [self returnToBattle];
}

- (void)rockButtonP:(nonnull id)sender __attribute__((ibaction)) {
    self.itemUsed2 = 8; //8 is interesting rock
    [self removeItemFromBag:@"Cool looking rock"];
    [self returnToBattle];
}

- (void)stoneButtonP:(nonnull id)sender __attribute__((ibaction)) {
    self.itemUsed2 = 5; //5 is stone disk
    [self removeItemFromBag:@"Charged Stone Disk"];
    [self returnToBattle];
}

- (void)superButtonP:(nonnull id)sender __attribute__((ibaction)) {
    self.itemUsed2 = 7; //7 is super disk
    [self removeItemFromBag:@"Super Disk"];
    [self returnToBattle];
}

- (void)waterButtonP:(nonnull id)sender __attribute__((ibaction)) {
    self.itemUsed2 = 6; //6 is water disk
    [self removeItemFromBag:@"Charged Water Disk"];
    [self returnToBattle];
}

-(void)returnToBattle{
    [[NSUserDefaults standardUserDefaults] setInteger: self.itemUsed2 forKey:@"BackPackItemUsed"]; //had to do it this way cause the nice way didn't work
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)enableOrDissableButtons{ //work out which buttons are enabled depending on whats in the players inventory
    //NSLog(@"items: %@", itemsArray);
    
    //first check health of player
    int playerHPFight23 = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerHP"]; //load player HP
    if(playerHPFight23 > 9){ //heal the player 3 (or full health if they're on 7 or more.)
        [_fruitButton setEnabled:FALSE];
        [_protodermisButton setEnabled:FALSE]; //these buttons are not availible if the player is at full health
    }
    
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

- (void)returnButtonP:(nonnull id)sender __attribute__((ibaction)) {
    self.itemUsed2 = 0; //0 is nothing
    NSLog(@"Return Pressed");
    [self returnToBattle];
}

-(void)removeItemFromBag:(NSString *)item1{ //remove the selected item from the inventory
    for (int i = 0; i <= (itemsArray.count -1); i++)
    {
        if([itemsArray[i]isEqualToString:item1]){
            [itemsArray removeObjectAtIndex:i];
            [[NSUserDefaults standardUserDefaults] setObject: itemsArray forKey:@"PlayerItems"];
            break; //stop the loop here
        }
    }
}

@end
