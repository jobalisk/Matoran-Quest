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
    [_maskName setText:[NSString stringWithFormat:@"%@", _maskDetailsArray[0]]];
    [_maskCatcher setText:[NSString stringWithFormat:@"%@", _maskDetailsArray[1]]];
    [_maskLat setText:[NSString stringWithFormat:@"%@", _maskDetailsArray[2]]];
    [_maskLong setText:[NSString stringWithFormat:@"%@", _maskDetailsArray[3]]];
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
