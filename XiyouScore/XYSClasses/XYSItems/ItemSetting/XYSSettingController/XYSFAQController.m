//
//  XYSFAQController.m
//  XiyouScore
//
//  Created by Tangtang on 16/7/21.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYSFAQController.h"
#import "XYSFAQCell.h"

static NSString * const kFAQCell = @"kFAQCell";

@interface XYSFAQController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, copy)   NSArray       *messArray;

@end

@implementation XYSFAQController

- (NSArray *)messArray {
    if (_messArray == nil) {
        _messArray = @[@{@"question" : @"Q1:为什么查到的成绩是空白的?", @"answer" : @"请先选择对应的学年，再根据学期选择。\n如果按照此操作查询无成绩，请先确定是否已经评价过老师。\n若还是没有，那就是服务器正在忙，请稍后再查询。"},
                       @{@"question" : @"Q2:何时可以查询补考成绩?", @"answer" : @"补考成绩下来之后就可以查了。"},
                       @{@"question" : @"Q3:如果在使用过程中发现问题怎么办?", @"answer" : @"进入意见反馈给我们发邮件反馈问题哦。欢迎给我们提意见哈！"},
                       @{@"question" : @"Q4:为什么个人信息那块会是空白的？", @"answer" : @"因为你还未评价老师哦，还未评价老师我们的数据抓不下来。体谅一下啦~"}];
    }
    return _messArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self p_setupTableView];
}

#pragma mark - setupTableView
- (void)p_setupTableView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionFooterHeight = 5.f;
    self.tableView.estimatedRowHeight = 66;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XYSFAQCell class]) bundle:nil] forCellReuseIdentifier:kFAQCell];
    
    //去掉底部线条
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYSFAQCell *cell = [tableView dequeueReusableCellWithIdentifier:kFAQCell];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    cell.backView.layer.shadowOffset = CGSizeMake(1, 1);
    cell.backView.layer.shadowOpacity = 0.3;
    cell.backView.layer.shadowColor = [UIColor grayColor].CGColor;
    cell.backView.layer.cornerRadius = 5;
    cell.backView.layer.masksToBounds = YES;
    
    cell.questionLabel.text = [self.messArray[indexPath.row] objectForKey:@"question"];
    cell.answerLabel.text = [self.messArray[indexPath.row] objectForKey:@"answer"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end
