//
//  XYSAboutUSController.m
//  XiyouScore
//
//  Created by Tangtang on 16/7/21.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYSAboutUSController.h"

@interface XYSAboutUSController ()

@end

@implementation XYSAboutUSController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self p_createIcon];
}

- (void)p_createIcon {
    UIImageView *iconImage = [[UIImageView alloc] init];
    iconImage.image = [UIImage imageNamed:@"XiyouScoreIcon"];
    iconImage.layer.cornerRadius = 10;
    [self.view addSubview:iconImage];
    
    UILabel *updateLabel = [[UILabel alloc] init];
    updateLabel.textColor = [UIColor lightGrayColor];
    updateLabel.text = @"西邮成绩 v1.0.0";
    updateLabel.textAlignment = NSTextAlignmentCenter;
    updateLabel.font = [UIFont fontWithName:@"PingFang SC" size:15.f];
    [self.view addSubview:updateLabel];
    
    UILabel *ownerLabel = [[UILabel alloc] init];
    ownerLabel.textColor = [UIColor lightGrayColor];
    ownerLabel.text = @"Copyright ©  西邮移动应用开发实验室iOS组";
    ownerLabel.textAlignment = NSTextAlignmentCenter;
    ownerLabel.font = [UIFont fontWithName:@"PingFang SC" size:13.f];
    [self.view addSubview:ownerLabel];
    
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(35);
        make.centerX.equalTo(self.view.centerX);
        make.width.height.equalTo(80);
    }];
    
    [updateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImage.bottom).offset(10);
        make.centerX.equalTo(iconImage.centerX);
        make.height.equalTo(30);
    }];
    
    [ownerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.bottom.equalTo(self.view.bottom).offset(-20);
        make.height.equalTo(20);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
