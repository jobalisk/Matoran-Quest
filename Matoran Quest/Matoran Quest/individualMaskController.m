//
//  individualMaskController.m
//  Matoran Quest
//
//  Created by Job Dyer on 12/11/23.
//

#import "individualMaskController.h"

@interface individualMaskController ()

@end

@implementation individualMaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //NSLog(@"%@", _maskDetailsArray);
    [_maskName setText:[NSString stringWithFormat:@"%@", _maskDetailsArray[0]]];
    [_maskCatcher setText:[NSString stringWithFormat:@"%@", _maskDetailsArray[1]]];
    [_maskLat setText:[NSString stringWithFormat:@"%@", _maskDetailsArray[2]]];
    [_maskLong setText:[NSString stringWithFormat:@"%@", _maskDetailsArray[3]]];
    
    [_maskPortrait setImage: _maskImage];
    
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
