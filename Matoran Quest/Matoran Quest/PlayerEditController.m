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
NSArray *kanohiList;
NSNotificationCenter *colorCenter;
UIImage *playerSprite; //the image in the player portrait


- (void)viewDidLoad {
    [super viewDidLoad];
    
    kanohiList = [NSArray arrayWithObjects: @"Unmasked", @"Hau", @"Miru", @"Kakama", @"Akaku", @"Huna", @"Rau", @"Matatu", @"Pakari", @"Ruru", @"Kaukau", @"Mahiki", @"Komau", nil]; //load up masks availible to player
    playerDetails = [NSUserDefaults standardUserDefaults];
    _playerNameField.delegate = self;
    _playerNameField.returnKeyType = UIReturnKeyDone;
    _playerMaskChooser.delegate = self;
    _playerMaskChooser.dataSource = self;
    
    //try to set a player name

    @try {
        [_playerNameField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerName"]];
    }
    @catch (NSException *exception) {
        [_playerNameField setText:@"Player Name"];
    }
    @finally {
      //Display Alternative
    }

    //get the player portrait up and running
    
    playerSprite = [UIImage imageNamed:@"matoran0.png"];
    
    //convert colour text back to uicolour

    UIColor *color1 = [UIColor colorWithRed:[[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerRed"] green:[[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerGreen"] blue:[[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerBlue"] alpha:[[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerAlpha"]];
    
    playerSprite = [self colorizeImage:playerSprite color:color1];
    [_playerPortrait setImage:playerSprite];
    [_playerPortrait setContentScaleFactor: UIViewContentModeScaleAspectFit];
    
    
    // set up the picker view
    [_playerMaskChooser setDataSource: self];
    

    
}

-(void)colourWellPressed{
    //NSLog(@"colour changed ");
    if(_playerColourPicker.selectedColor != NULL){
        playerSprite = [UIImage imageNamed:@"matoran0.png"];
        playerSprite = [self colorizeImage:playerSprite color:_playerColourPicker.selectedColor];
        [_playerPortrait setImage:playerSprite];
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
    [self colourWellPressed];
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
