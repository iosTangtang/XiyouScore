//
//  XYSSetHeader.m
//  XiyouScore
//
//  Created by Tangtang on 16/7/25.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYSSetHeader.h"

@implementation XYSSetHeader

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self p_setupHeadView];
    }
    return self;
}

- (void)p_setupHeadView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"XiyouScoreIcon"];
    imageView.layer.cornerRadius = 10;
    imageView.layer.masksToBounds = YES;
    [self addSubview:imageView];
    
    UILabel *creatorLabel = [[UILabel alloc] init];
    creatorLabel.text = @"西邮成绩";
    creatorLabel.textColor = [UIColor darkGrayColor];
    creatorLabel.font = [UIFont fontWithName:@"PingFang SC" size:15.f];
    creatorLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:creatorLabel];
    
    UILabel *updateLabel = [[UILabel alloc] init];
    updateLabel.text = @"Version 1.0";
    updateLabel.textColor = [UIColor darkGrayColor];
    updateLabel.font = [UIFont fontWithName:@"PingFang SC" size:15.f];
    updateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:updateLabel];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(0);
        make.centerX.equalTo(self.centerX);
        make.width.height.equalTo(80);
    }];
    
    [creatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.bottom).offset(10);
        make.centerX.equalTo(imageView.centerX);
        make.height.equalTo(20);
    }];
    
    [updateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(creatorLabel.bottom).offset(2);
        make.centerX.equalTo(imageView.centerX);
        make.height.equalTo(20);
    }];
    
    
}

@end
