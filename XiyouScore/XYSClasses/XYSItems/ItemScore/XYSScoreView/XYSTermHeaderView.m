//
//  XYSTermHeaderView.m
//  XiyouScore
//
//  Created by Tangtang on 16/7/21.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYSTermHeaderView.h"

@interface XYSTermHeaderView ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *rank;

@end

@implementation XYSTermHeaderView

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _title = title;
        
        [self p_setupHead];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title WithRank:(NSString *)rank{
    self = [super init];
    if (self) {
        _title = title;
        _rank = rank;
        
        [self p_setupHead];
    }
    return self;
}

- (void)p_setupHead{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.shadowOffset = CGSizeMake(1, 1);
    backView.layer.shadowOpacity = 0.3;
    backView.layer.shadowColor = [UIColor grayColor].CGColor;
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(10);
        make.left.equalTo(self.left).offset(10);
        make.right.equalTo(self.right).offset(-10);
        make.bottom.equalTo(self.bottom).offset(0);
    }];
    
    UILabel *myLabel = [[UILabel alloc]init];
    myLabel.text = self.title;
    myLabel.textColor = [UIColor grayColor];
    myLabel.font = [UIFont fontWithName:@"PingFang SC" size:17.f];
    [backView addSubview:myLabel];
    
    [myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.centerY);
        make.left.equalTo(backView.left).offset(20);
    }];
    
    UILabel *rankLabel = [[UILabel alloc]init];
    rankLabel.text = [NSString stringWithFormat:@"学科数: %@", self.rank];
    rankLabel.textColor = [UIColor grayColor];
    rankLabel.font = [UIFont fontWithName:@"PingFang SC" size:15.f];
    [backView addSubview:rankLabel];
    
    [rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.centerY);
        make.right.equalTo(backView.right).offset(-20);
    }];
}

@end
