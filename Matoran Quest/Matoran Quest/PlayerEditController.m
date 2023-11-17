//
//  PlayerEditController.m
//  Matoran Quest
//
//  Created by Job Dyer on 12/11/23.
//

#import "PlayerEditController.h"

@interface PlayerEditController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation PlayerEditController

NSUserDefaults *playerDetails;
NSMutableArray *kanohiList;
NSNotificationCenter *colorCenter;
UIImage *playerSprite; //the image in the player portrait


- (void)viewDidLoad {
    [super viewDidLoad];
    
    kanohiList = [NSMutableArray arrayWithObjects: @"unmasked", @"hau", @"miru", @"kakama", @"akaku", @"huna", @"rau", @"matatu", @"pakari", @"ruru", @"kaukau", @"mahiki", @"komau", nil]; //load up masks availible to player
    NSArray *maskArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMasks"]; //get the players masks from the user defaults and make an array of them
    //NSLog(@"%@", maskArray);
    NSArray *testMaskArray; //for checking masks
    NSString *testString;
    //try catch because this will cause the app to crash if you have no masks atam
    if((int)[[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerRares"] == 1){
        for (int i = 0; i <= (maskArray.count -1); i++)
        {
            
            
            NSLog(@"trying to do masks %d", (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerRares"]);
            testMaskArray = [maskArray objectAtIndex:i]; //go through each mask, if the player has a vahi or avohkii, add those to the array of availible masks
            
            testString = [testMaskArray objectAtIndex:0];
            if([testString isEqualToString: @"avohkii"]){
                //NSLog(@"contains A");
                [kanohiList addObject:@"avohkii"];
            }
            if([testString isEqualToString: @"vahi"]){
                [kanohiList addObject:@"vahi"];
                //NSLog(@"contains V");
            }
        }
    }
    //NSLog(@"got here");
    
    playerDetails = [NSUserDefaults standardUserDefaults];
    _playerNameField.delegate = self;
    _playerNameField.returnKeyType = UIReturnKeyDone;
    _playerMaskChooser.delegate = self;
    _playerMaskChooser.dataSource = self;
    
    //try to set a player name
    //get the player portrait up and running
    @try {
        [_playerNameField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerName"]];
    }
    @catch (NSException *exception) {
        [_playerNameField setText:@"Player Name"];
    }
    @finally {
      //Display Alternative
    }
    //NSLog(@"got here");
    
    //try to load the sprite kind, if it doesnt exist, substitute a temp sprite
    playerSprite = [UIImage imageNamed:[NSString stringWithFormat:@"%@0",[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"]]];
    NSString *checkString = [NSString stringWithFormat:@"%@0",[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"]]; //check this is a valid name
    if([checkString rangeOfString:@"matoran"].location == NSNotFound){
        playerSprite = [UIImage imageNamed:@"unmaskedmatoran0.png"];
        
        

        
    }

    
    
    //playerSprite = [UIImage imageNamed:@"matoran0.png"];
    
    //convert colour text back to uicolour

    UIColor *color1 = [UIColor colorWithRed:[[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerRed"] green:[[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerGreen"] blue:[[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerBlue"] alpha:[[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerAlpha"]];
    
    playerSprite = [self colorizeImage:playerSprite color:color1];
    [_playerPortrait setImage:playerSprite];
    //[_playerPortrait setContentScaleFactor: UIViewContentModeScaleAspectFit];
    [_playerColourPicker setSelectedColor: color1]; //set up the colourwell's colour
    [_playerPortrait setContentScaleFactor: UIViewContentModeCenter]; //make sure the image isn't being stretched
    
    // set up the picker view
    [_playerMaskChooser setDataSource: self];

  
}

-(void)viewDidAppear:(BOOL)animated{
    [_playerMaskChooser selectRow:[[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerMaskNumber"] inComponent:0 animated:true]; //go to the players selected mask on load up
    //NSLog(@"row: %ld", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerMaskNumber"]);
}

-(void)colourWellPressed:(UIImage*)playerSprite1{ //change the colour of the given sprite then save those colours to user defaults
    //NSLog(@"colour changed ");
    if(_playerColourPicker.selectedColor != NULL){
        playerSprite1 = [self colorizeImage:playerSprite color:_playerColourPicker.selectedColor];
        [_playerPortrait setImage:playerSprite1];
        //save the player colour
        
        //convert player colours to text for saving
        
        CGFloat red1;
        CGFloat blue1;
        CGFloat green1;
        CGFloat alpha1;
        [_playerColourPicker.selectedColor getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
        [[NSUserDefaults standardUserDefaults] setFloat: red1 forKey:@"PlayerRed"];
        [[NSUserDefaults standardUserDefaults] setFloat: blue1 forKey:@"PlayerBlue"];
        [[NSUserDefaults standardUserDefaults] setFloat: green1 forKey:@"PlayerGreen"];
        [[NSUserDefaults standardUserDefaults] setFloat: alpha1 forKey:@"PlayerAlpha"];
        //NSLog(@"1R: %f", [[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerRed"]);
        //NSLog(@"1G: %f", [[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerGreen"]);
        //NSLog(@"1B: %f", [[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerBlue"]);
        //NSLog(@"1A: %f", [[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerAlpha"]);

    }
}






- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction) colourButtonPressed: (id) sender
{
    playerSprite = [UIImage imageNamed:[NSString stringWithFormat:@"%@0",[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"]]];
    [_playerPortrait setImage:playerSprite];
    [self colourWellPressed: playerSprite];

    
    //sort out mask
    
    
}


-(IBAction) playerNameFieldCatcher: (id) sender
{
    [playerDetails setObject: _playerNameField.text forKey:@"PlayerName"];
    //NSLog([[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerName"]);
}

-(UIImage *)colorizeImage:(UIImage *)baseImage color:(UIColor *)theColor {
    UIGraphicsBeginImageContext(baseImage.size);

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);

    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, baseImage.CGImage);
    [theColor set];
    CGContextFillRect(ctx, area);
    CGContextRestoreGState(ctx);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextDrawImage(ctx, area, baseImage.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


//picker view functions

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *playerMask = [NSString stringWithFormat:@"%@matoran", kanohiList[row]];
    //NSLog(@"Mask name: %@",playerMask);
    [playerDetails setObject: playerMask forKey:@"PlayerMask"]; //save the player mask choice
    [playerDetails setInteger: row forKey:@"PlayerMaskNumber"]; //save where that is in the list for later
}

- (NSInteger)selectedRowInComponent:(NSInteger)component{
    return kanohiList.count;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView
numberOfRowsInComponent:(NSInteger)component {
    return kanohiList.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
     return 1;  // 1 item in it (as it, collumns)
}

- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat: @"%@", kanohiList[row]];//Or, your suitable title; like Choice-a, etc.
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
