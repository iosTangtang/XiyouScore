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
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_changeSkin) name:NIGHT_KEY object:nil];
    
    //关闭高斯模糊
    [UINavigationBar appearance].translucent = NO;
    //去除导航栏上返回按钮的文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:61 / 255.0 green:118 / 255.0 blue:203 / 255.0 alpha:1]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    NSDictionary *dic = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:dic];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
//    [self p_changeSkin];
    
}

//-(void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - changeSkin
//- (void)p_changeSkin {
//    NSString *isON = [[NSUserDefaults standardUserDefaults] objectForKey:NIGHT_KEY];
//    if ([isON boolValue]) {
//        [[UINavigationBar appearance] setBarTintColor:[UIColor darkGrayColor]];
//        [[UINavigationBar appearance] setTintColor:[UIColor lightGrayColor]];
//        
//        NSDictionary *dic = @{NSForegroundColorAttributeName : [UIColor lightGrayColor]};
//        [[UINavigationBar appearance] setTitleTextAttributes:dic];
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//        
//    } else {
//        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:61 / 255.0 green:118 / 255.0 blue:203 / 255.0 alpha:1]];
//        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//        
//        NSDictionary *dic = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
//        [[UINavigationBar appearance] setTitleTextAttributes:dic];
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    }
//}



@end
