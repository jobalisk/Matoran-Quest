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


- (void)viewDidLoad {
    [super viewDidLoad];
    @try {
        //try to get a new player sprite working
        [_playerNameLabel setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerName"]]; //set up the player name and image
        UIImage *playerSprite;
        //try to load the sprite kind, if it doesnt exist, substitute a temp sprite
        playerSprite = [UIImage imageNamed:[NSString stringWithFormat:@"%@0",[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"]]];
        NSString *checkString = [NSString stringWithFormat:@"%@0",[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerMask"]]; //check this is a valid name
        if([checkString rangeOfString:@"matoran"].location == NSNotFound){
            playerSprite = [UIImage imageNamed:@"unmaskedmatoran0.png"];
        }
        
        //convert colour back to uicolour
        UIColor *color1 = [UIColor colorWithRed:[[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerRed"] green:[[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerGreen"] blue:[[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerBlue"] alpha:[[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerAlpha"]];
        
        playerSprite = [self colorizeImage:playerSprite color:color1];
        [_playerPortrait setImage:playerSprite];
        [_playerPortrait setContentScaleFactor: UIViewContentModeScaleAspectFit];
    }
    @catch (NSException *exception) {
        [_playerNameLabel setText:@"Player Name"];
    }
    @finally {
      //Display Alternative
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    //[[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait]forKey:@"orientation"];//set the controller to be portrait
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
