//
//  PlayerDetailsController.m
//  Matoran Quest
//
//  Created by Job Dyer on 12/11/23.
//

#import "PlayerDetailsController.h"

@interface PlayerDetailsController ()

@end

@implementation PlayerDetailsController

NSUserDefaults *playerDetails;



- (void)viewDidLoad {
    [super viewDidLoad];
    playerDetails = [NSUserDefaults standardUserDefaults];
    _playerNameField.delegate = self;
    _playerNameField.returnKeyType = UIReturnKeyDone;
    // Do any additional setup after loading the view.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



-(IBAction) playerNameFieldCatcher: (id) sender
{
    [playerDetails setObject: _playerNameField.text forKey:@"PlayerName"];
    //NSLog([[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerName"]);
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
