//
//  XYSSettingController.m
//  XiyouScore
//
//  Created by Tangtang on 16/7/21.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYSSettingController.h"
#import "XYSFeedBackController.h"
#import "XYSFAQController.h"
#import "XYSAboutUSController.h"
#import "XYSExitCell.h"
#import "XYSSetHeader.h"

static NSString * const kSetCell = @"kSetCell";
static NSString * const kExitCell = @"kExitCell";

@interface XYSSettingController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, copy)   NSArray       *messArray;

@end

@implementation XYSSettingController

- (NSArray *)messArray {
    if (_messArray == nil) {
        _messArray = @[@{@"icon" : [UIImage imageNamed:@"advice"], @"title" : @"意见反馈"},
                       @{@"icon" : [UIImage imageNamed:@"help"], @"title" : @"常见问题"},
                       @{@"icon" : [UIImage imageNamed:@"delete"], @"title" : @"清楚缓存"},
                       @{@"icon" : [UIImage imageNamed:@"night"], @"title" : @"夜间模式"},
                       @{@"icon" : [UIImage imageNamed:@"image"], @"title" : @"关于我们"}];
    }
    return _messArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self p_setupTableView];
    [self p_setupHeader];
}

#pragma mark - setupTableView
- (void)p_setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionFooterHeight = 5.f;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSetCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XYSExitCell class]) bundle:nil] forCellReuseIdentifier:kExitCell];
    
    //去掉底部线条
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)p_setupHeader {
    XYSSetHeader *header = [[XYSSetHeader alloc] init];
    self.tableView.tableHeaderView = header;
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
        return self.messArray.count;;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSetCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 3) {
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            switchView.onTintColor = [UIColor colorWithRed:61 / 255.0 green:118 / 255.0 blue:203 / 255.0 alpha:0.8];
            [switchView addTarget:self action:@selector(p_switchValue:) forControlEvents:UIControlEventValueChanged];
        }
        
        cell.imageView.image = [self.messArray[indexPath.row] objectForKey:@"icon"];
        cell.textLabel.text = [self.messArray[indexPath.row] objectForKey:@"title"];
        return cell;
    } else {
        XYSExitCell *exitCell = [tableView dequeueReusableCellWithIdentifier:kExitCell];
        return exitCell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            XYSFeedBackController *feedVC = [[XYSFeedBackController alloc] init];
            feedVC.hidesBottomBarWhenPushed = YES;
            feedVC.title = [self.messArray[indexPath.row] objectForKey:@"title"];
            [self.navigationController pushViewController:feedVC animated:YES];
        } else if (indexPath.row == 1) {
            XYSFAQController *faqVC = [[XYSFAQController alloc] init];
            faqVC.hidesBottomBarWhenPushed = YES;
            faqVC.title = [self.messArray[indexPath.row] objectForKey:@"title"];;
            [self.navigationController pushViewController:faqVC animated:YES];
        } else if (indexPath.row == 4) {
            XYSAboutUSController *aboutUsVC = [[XYSAboutUSController alloc] init];
            aboutUsVC.hidesBottomBarWhenPushed = YES;
            aboutUsVC.title = [self.messArray[indexPath.row] objectForKey:@"title"];
            [self.navigationController pushViewController:aboutUsVC animated:YES];
        }
    } else {
        NSLog(@"退出登陆");
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 150.f;
    }
    return 10.f;
}

#pragma mark - SwitchAction
- (void)p_switchValue:(UISwitch *)sender {
    NSLog(@"%d", sender.isOn);
}

@end
