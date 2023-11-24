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
    
    //add detail text to mask names
    NSString *finalNameString;
    if ([_maskDetailsArray[0] containsString:@"infected hau"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"This Kanohi has been\ncorrupted by the Makuta"];
    }
    else if ([_maskDetailsArray[0] containsString:@"hau"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Great Kanohi of Shielding"];
    }
    else if ([_maskDetailsArray[0] containsString:@"miru"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Great Kanohi of Levitation"];
    }
    else if ([_maskDetailsArray[0] containsString:@"kaukau"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Great Kanohi of Water Breathing"];
    }
    else if ([_maskDetailsArray[0] containsString:@"kakama"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Great Kanohi of Speed"];
    }
    else if ([_maskDetailsArray[0] containsString:@"akaku"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Great Kanohi of X-Ray Vision"];
    }
    else if ([_maskDetailsArray[0] containsString:@"pakari"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Great Kanohi of Strength"];
    }
    else if ([_maskDetailsArray[0] containsString:@"huna"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Noble Kanohi of Concealment"];
    }
    else if ([_maskDetailsArray[0] containsString:@"rau"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Noble Kanohi of Translation"];
    }
    else if ([_maskDetailsArray[0] containsString:@"ruru"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Noble Kanohi of Night Vision"];
    }
    else if ([_maskDetailsArray[0] containsString:@"mahiki"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Noble Kanohi of Illusion"];
    }
    else if ([_maskDetailsArray[0] containsString:@"matatu"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Noble Kanohi of Telekinesis"];
    }
    else if ([_maskDetailsArray[0] containsString:@"komau"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Noble Kanohi of Mind Control"];
    }
    else if ([_maskDetailsArray[0] containsString:@"vahi"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Legendary Mask of Time"];
    }
    else if ([_maskDetailsArray[0] containsString:@"avohkii"]) {
        finalNameString = [NSString stringWithFormat:@"%@\n\n%@",_maskDetailsArray[0], @"Great Kanohi of Light"];
    }
    else{
        finalNameString = _maskDetailsArray[0];
    }

    
    
    [_maskName setText:[NSString stringWithFormat:@"%@", finalNameString]];
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
