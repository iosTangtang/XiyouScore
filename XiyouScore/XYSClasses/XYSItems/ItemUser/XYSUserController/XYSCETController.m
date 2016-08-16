//
//  XYSCETController.m
//  XiyouScore
//
//  Created by Tangtang on 16/7/21.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYSCETController.h"
#import "XYSCETTableViewCell.h"

static NSString * const kCETCell = @"kCETCell";

@interface XYSCETController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, copy)   NSArray       *titleArray;

@end

@implementation XYSCETController

#pragma mark - lazy
- (NSArray *)titleArray {
    if (_titleArray == nil) {
        _titleArray = @[@[@"姓名", @"学校", @"考试类别", @"准考证号", @"考试时间"], @[@"总分", @"听力", @"阅读", @"写作与翻译"]];
    }
    return _titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"四六级成绩";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self p_setupTableView];
    
}

#pragma mark - setupTableView
- (void)p_setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionFooterHeight = 5.f;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XYSCETTableViewCell class]) bundle:nil] forCellReuseIdentifier:kCETCell];
    
    //去掉底部线条
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titleArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYSCETTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCETCell];
    cell.titleLabel.text = [[self.titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.cetScores[indexPath.section] count] <= 0) {
        cell.valueLabel.text = @"xxx";
    } else {
        cell.valueLabel.text = [self.cetScores[indexPath.section] objectAtIndex:indexPath.row];
    }
    
    return cell;
}

@end
