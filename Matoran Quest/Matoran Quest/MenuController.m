//
//  MenuController.m
//  Matoran Quest
//
//  Created by Job Dyer on 12/11/23.
//

#import "MenuController.h"

@interface MenuController ()

@end

@implementation MenuController

UIAlertController* helpAlert; //the help dialog
UIAlertController* aboutAlert; //the about dialog
UIAlertController* startAlert; //the about dialog
int maskChosenFlag2; //have we chosen a mask and player name, ect yet?

- (void)viewDidLoad {
    [super viewDidLoad];
    [_title1 setFont:[UIFont fontWithName:@"Mata Nui" size:15]];
    [_title2 setFont:[UIFont fontWithName:@"GoudyTrajan-Regular" size:16]];

    [_playButton setEnabled:false];
    maskChosenFlag2 = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"maskChosen"]; //get whether or not the player has picked their character yet
    if(maskChosenFlag2 == 1){
        [_playButton setHidden:false];
        [_playButton setEnabled:true]; //you can only press play once the character has been set up.
    }
    else{ //if the player hasn't set up their matoran yet, display this message.
        [_playButton setEnabled:false];
        [_playButton setHidden:true];
        startAlert = [UIAlertController alertControllerWithTitle:@"Starting Out"
                                       message:@"Greetings Nameless One!\nI hear you are interested in setting out from our dear village to start a Kanohi mask gathering quest.\nBefore departing, would you mind going to Manage Player and telling us a little more about yourself?"
                                       preferredStyle:UIAlertControllerStyleAlert];
         
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
           handler:^(UIAlertAction * action) {}];
         
        [startAlert addAction:defaultAction];
        //this alert will be presented later, once the view has fully loaded
        
    }
    
    helpAlert = [UIAlertController alertControllerWithTitle:@"Help"
                                   message:@"Island life tends to be a bit boring without a hobby. Yours is collecting masks. Your fellow Matoran might think your a little crazy wandering around at all times of the day and night tapping on things on your map, or viewing your inventory and kanohi from the manage player screen off the main menu, but you know better. One day, you're gonna find 'em all!"
                                   preferredStyle:UIAlertControllerStyleAlert];
     
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {}];
     
    [helpAlert addAction:defaultAction];
    
    
    /*
    aboutAlert = [UIAlertController alertControllerWithTitle:@"About"
                                   message:@"This game was made by Job Dyer with assets borrowed from the LEGO Group's Bionicle range. The origonal idea came from Ezra Haren (though who knows how many others also had it.)"
                                   preferredStyle:UIAlertControllerStyleAlert];

    [aboutAlert addAction:defaultAction];
    */
    
    
    
}

-(IBAction) helpButton: (id) sender
{
    [self presentViewController:helpAlert animated:YES completion:nil];
}

-(IBAction) aboutButton: (id) sender
{
    //[self presentViewController:aboutAlert animated:YES completion:nil];
}


-(void)viewDidAppear:(BOOL)animated{
    if(maskChosenFlag2 == 0){
        [self presentViewController:startAlert animated:YES completion:nil]; //show the start up alert
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
