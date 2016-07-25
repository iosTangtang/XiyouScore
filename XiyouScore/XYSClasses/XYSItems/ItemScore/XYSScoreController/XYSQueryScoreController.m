//
//  XYSQueryScoreController.m
//  XiyouScore
//
//  Created by Tangtang on 16/7/21.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYSQueryScoreController.h"
#import "XYSQueryScoreCell.h"
#import "XYSExitCell.h"
#import "XYSTermHeaderView.h"
#import "XYSTermModel.h"
#import "XYSScoreModel.h"
#import <MJRefresh/MJRefresh.h>

#define KHEADWIDTH 60

static NSString * const kQueryScoreCell = @"kQueryScoreCell";
static NSString * const kRankCell = @"kRankCell";

@interface XYSQueryScoreController ()<UITableViewDelegate, UITableViewDataSource> {
    NSMutableDictionary *_showDic;
}

@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) XYSTermModel  *termModel;

@end

@implementation XYSQueryScoreController

//模拟数据
- (XYSTermModel *)termModel {
    if (_termModel == nil) {
        _termModel = [[XYSTermModel alloc] init];
        _termModel.year = @"2013-2014";
        _termModel.scoresTermOne = [NSMutableArray arrayWithObjects:@"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3",nil];
        _termModel.scoresTermTwo = [NSMutableArray arrayWithObjects:@"4", @"5", @"1", @"2", @"3", @"1", @"2", @"3",nil];
    }
    return _termModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeYearItem:) name:XYSCHANGEYEARNOTIFI object:nil];
    
    [self p_setupTableView];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - setupTableView
- (void)p_setupTableView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.bottom).offset(-44);
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XYSQueryScoreCell class]) bundle:nil] forCellReuseIdentifier:kQueryScoreCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XYSExitCell class]) bundle:nil] forCellReuseIdentifier:kRankCell];
    
    //去掉底部线条
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(p_loadHeadData)];
    [self.tableView.header beginRefreshing];
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
        if ([_showDic objectForKey:[NSString stringWithFormat:@"%ld",section]]) {
            return self.termModel.scoresTermOne.count;
        }
        return 0;
    } else {
        if ([_showDic objectForKey:[NSString stringWithFormat:@"%ld",section]]) {
            return self.termModel.scoresTermTwo.count;
        }
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XYSQueryScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:kQueryScoreCell];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    if (indexPath.section == 0) {
        cell.courseName.text = self.termModel.scoresTermOne[indexPath.row];
    } else {
        cell.courseName.text = self.termModel.scoresTermTwo[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backView.layer.cornerRadius = 5.f;
    cell.backView.layer.masksToBounds = YES;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_showDic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.section]]) {
        return 120;
    }
    return 0;
}

//section头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return KHEADWIDTH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *headTitle = nil;
    if (section == 0) {
        headTitle = @"第一学期";
    } else {
        headTitle = @"第二学期";
    }
    
    XYSTermHeaderView *header = [[XYSTermHeaderView alloc] initWithTitle:headTitle WithRank:@"6"];
    
    header.frame = CGRectMake(0, 0, self.view.frame.size.width, KHEADWIDTH);
    header.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    // 单击的 Recognizer ,收缩分组cell
    header.tag = section;
    
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer.numberOfTapsRequired = 1;
    [singleRecognizer setNumberOfTouchesRequired:1];
    [header addGestureRecognizer:singleRecognizer];
    
    return header;
}

#pragma mark - 下拉刷新事件
- (void)p_loadHeadData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        
        [self.tableView.header endRefreshing];
    });
}

#pragma mark - 展开收缩section中cell 手势监听
-(void)SingleTap:(UITapGestureRecognizer*)recognizer{
    NSInteger didSection = recognizer.view.tag;
    
    if (!_showDic) {
        _showDic = [[NSMutableDictionary alloc]init];
    }
    
    NSString *key = [NSString stringWithFormat:@"%ld",didSection];
    if (![_showDic objectForKey:key]) {
        [_showDic setObject:@"1" forKey:key];
        
    }else{
        [_showDic removeObjectForKey:key];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:didSection] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - 改变学年的监听事件
- (void)changeYearItem:(id)sender {
    NSLog(@"%@", [sender userInfo]);
    [self.tableView.header beginRefreshing];
}

@end
