//
//  XYSTabBarViewController.m
//  XiyouScore
//
//  Created by Tangtang on 16/7/23.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYSTabBarViewController.h"
#import "XYSNavigationViewController.h"
#import "XYSContainerController.h"
#import "XYSUserController.h"
#import "XYSSettingController.h"
#import "XYSLoginViewController.h"
#import "SVProgressHUD.h"

@interface XYSTabBarViewController ()

@property (nonatomic, assign) BOOL isOnline;

@end

@implementation XYSTabBarViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.isOnline == NO) {
        XYSLoginViewController *loginVC = [[XYSLoginViewController alloc] init];
        loginVC.title = @"用户登陆";
        loginVC.userPlace = @"请输入学号";
        loginVC.keyPlace = @"请输入密码";
        loginVC.buttonPlace = @"登陆";
        loginVC.isCET = NO;
        XYSNavigationViewController *navc = [[XYSNavigationViewController alloc] initWithRootViewController:loginVC];
        [self presentViewController:navc animated:NO completion:nil];
        
        self.isOnline = YES;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unLogin) name:@"XYSUNLOGIN" object:nil];
    self.isOnline = NO;
    
    [self p_setTabbar];
    
}

- (void)p_setTabbar {
    
    XYSContainerController *containerVC = [[XYSContainerController alloc] init];
    [self p_addChildViewController:containerVC normalImage:[UIImage imageNamed:@"score1"] selectImage:[UIImage imageNamed:@"score2"] title:@"成绩"];
    
    XYSUserController *userVC = [[XYSUserController alloc] init];
    [self p_addChildViewController:userVC normalImage:[UIImage imageNamed:@"home1"] selectImage:[UIImage imageNamed:@"home2"] title:@"个人"];
    
    XYSSettingController *setVC = [[XYSSettingController alloc] init];
    [self p_addChildViewController:setVC normalImage:[UIImage imageNamed:@"setting1"] selectImage:[UIImage imageNamed:@"setting2"] title:@"设置"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)p_addChildViewController:(UIViewController *)childController
                   normalImage:(UIImage*) image
                   selectImage:(UIImage*) seleceImage
                         title:(NSString *) title{
    XYSNavigationViewController * nav = [[XYSNavigationViewController alloc]
                                         initWithRootViewController:childController];
    nav.tabBarItem.image = image;
    nav.tabBarItem.selectedImage = seleceImage;
    nav.tabBarItem.title = title;
    childController.title =title;
    
    self.tabBar.tintColor = [UIColor colorWithRed:61 / 255.0 green:118 / 255.0 blue:203 / 255.0 alpha:1];
    
    
    [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:61 / 255.0 green:118 / 255.0 blue:203 / 255.0 alpha:1],
                                             NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:1.0]} forState:UIControlStateSelected];
    
    
    [self addChildViewController: nav];
}

- (void)unLogin {
    self.selectedIndex = 0;
    
    XYSLoginViewController *loginVC = [[XYSLoginViewController alloc] init];
    loginVC.title = @"用户登陆";
    loginVC.userPlace = @"请输入学号";
    loginVC.keyPlace = @"请输入密码";
    loginVC.buttonPlace = @"登陆";
    loginVC.isCET = NO;
    XYSNavigationViewController *navc = [[XYSNavigationViewController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navc animated:NO completion:nil];
}


@end
