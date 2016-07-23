//
//  XYSNavigationViewController.m
//  XiyouScore
//
//  Created by Tangtang on 16/7/23.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYSNavigationViewController.h"

@interface XYSNavigationViewController ()

@end

@implementation XYSNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:61 / 255.0 green:118 / 255.0 blue:203 / 255.0 alpha:1]];
    //关闭高斯模糊
    [UINavigationBar appearance].translucent = NO;
    //去除导航栏上返回按钮的文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    NSDictionary *dic = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:dic];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
