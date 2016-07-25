//
//  XYSUserController.m
//  XiyouScore
//
//  Created by Tangtang on 16/7/21.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYSUserController.h"
#import "XYSLoginViewController.h"
#import "XYSRecommendController.h"
#import "XYSUserCell.h"

static NSString * const kUserHeadCell = @"kUserHeadCell";
static NSString * const kUserCell     = @"kUserCell";

@interface XYSUserController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, copy)   NSArray       *titleArray;
@property (nonatomic, copy)   NSArray       *imageArray;

@end

@implementation XYSUserController

#pragma mark - lazy
- (NSArray *)titleArray {
    if (_titleArray == nil) {
        _titleArray = @[@"四六级查询", @"素质拓展学分", @"向我推荐"];
    }
    return _titleArray;
}

- (NSArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = @[[UIImage imageNamed:@"cet46"], [UIImage imageNamed:@"grade"], [UIImage imageNamed:@"recommend"]];
    }
    return _imageArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self p_setupTableView];
    
}

#pragma mark - setupTableView
- (void)p_setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.sectionFooterHeight = 5.f;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XYSUserCell class]) bundle:nil] forCellReuseIdentifier:kUserHeadCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kUserCell];
    
    //去掉底部线条
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        XYSUserCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserHeadCell];
        cell.headImage.image = [UIImage imageNamed:@"touxian"];
        cell.userName.text = @"唐年";
        cell.userID.text = @"04143031";
        cell.academy.text = @"计算机学院";
        cell.className.text = @"软件1401";
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = self.titleArray[indexPath.row];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont fontWithName:@"PingFang SC" size:15.f];
        cell.imageView.image = self.imageArray[indexPath.row];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 81.f;
    } else {
        return 44.f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            XYSLoginViewController *loginVC = [[XYSLoginViewController alloc] init];
            loginVC.title = @"四六级查询";
            loginVC.userPlace = @"请输入准考证号";
            loginVC.keyPlace = @"请输入姓名";
            loginVC.buttonPlace = @"查询";
            loginVC.isCET = YES;
            loginVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
        } else if (indexPath.row == 2) {
            XYSRecommendController *recommendVC = [[XYSRecommendController alloc] init];
            recommendVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:recommendVC animated:YES];
        }
    }
}


@end
