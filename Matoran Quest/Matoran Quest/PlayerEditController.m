//
//  PlayerEditController.m
//  Matoran Quest
//
//  Created by Job Dyer on 12/11/23.
//

#import "PlayerEditController.h"

@interface PlayerEditController () <UITextFieldDelegate>

@end

@implementation PlayerEditController

NSUserDefaults *playerDetails;
NSMutableArray *kanohiList;

- (void)viewDidLoad {
    [super viewDidLoad];
    kanohiList = [[NSMutableArray alloc] init];
    playerDetails = [NSUserDefaults standardUserDefaults];
    _playerNameField.delegate = self;
    _playerNameField.returnKeyType = UIReturnKeyDone;
    
    @try {
        [_playerNameField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerName"]];
    }
    @catch (NSException *exception) {
        [_playerNameField setText:@"Player Name"];
    }
    @finally {
      //Display Alternative
    }
    
    
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
