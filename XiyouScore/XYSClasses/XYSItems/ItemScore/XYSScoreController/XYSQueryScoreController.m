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
#import "XYSScoreModel.h"
#import "XYSHTTPRequestManager.h"
#import "SVProgressHUD.h"
#import "SFHFKeychainUtils.h"
#import <MJRefresh/MJRefresh.h>

#define KHEADWIDTH 60

static NSString * const kQueryScoreCell = @"kQueryScoreCell";

@interface XYSQueryScoreController ()<UITableViewDelegate, UITableViewDataSource> {
    
}

@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) XYSTermModel      *termModel;
@property (nonatomic, copy) NSMutableDictionary *showDic;

@end

@implementation XYSQueryScoreController

//模拟数据
- (XYSTermModel *)termModel {
    if (_termModel == nil) {
        _termModel = [[XYSTermModel alloc] init];
        
    }
    return _termModel;
}

- (NSMutableArray *)yearArray {
    if (_yearArray == nil) {
        _yearArray = [NSMutableArray array];
    }
    return _yearArray;
}

- (NSMutableDictionary *)showDic {
    if (_showDic == nil) {
        _showDic = [NSMutableDictionary dictionary];
    }
    return _showDic;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.termModel = nil;
    [self entityDataSource:self.title];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeYearItem:) name:XYSCHANGEYEARNOTIFI object:nil];
    
    [self p_setupTableView];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XYSCHANGEYEARNOTIFI object:nil];
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
        make.bottom.equalTo(self.view.bottom).offset(-49);
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XYSQueryScoreCell class]) bundle:nil] forCellReuseIdentifier:kQueryScoreCell];
    
    //去掉底部线条
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    MJRefreshNormalHeader *head = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(p_loadHeadData)];
    head.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.header = head;
    
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
        if ([self.showDic objectForKey:[NSString stringWithFormat:@"%ld",section]]) {
            return self.termModel.scoresTermOne.count;
        }
        return 0;
    } else {
        if ([self.showDic objectForKey:[NSString stringWithFormat:@"%ld",section]]) {
            return self.termModel.scoresTermTwo.count;
        }
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XYSQueryScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:kQueryScoreCell];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    NSArray *array = nil;
    if (indexPath.section == 0) {
        array = self.termModel.scoresTermOne;
    } else {
        array = self.termModel.scoresTermTwo;
    }
    XYSScoreModel *score = array[indexPath.row];
    cell.courseName.text = score.course;
    cell.academy.text = score.academy;
    cell.courseType.text = score.courseQuality;
    cell.jmScore.text = score.volumeGrade;
    cell.psScore.text = score.regularGrade;
    cell.sumScore.text = score.score;
    cell.credit.text = score.credit;
    cell.makeupScore.text = score.makeupScore;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backView.layer.cornerRadius = 5.f;
    cell.backView.layer.masksToBounds = YES;
    
    if ([score.exam isEqualToString:@"补考未通过"]) {
        cell.backView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
    } else {
        cell.backView.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.showDic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.section]]) {
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
    NSInteger sum;
    if (section == 0) {
        headTitle = @"第一学期";
        sum = self.termModel.scoresTermOne.count;
    } else {
        headTitle = @"第二学期";
        sum = self.termModel.scoresTermTwo.count;
    }
    
    XYSTermHeaderView *header = [[XYSTermHeaderView alloc] initWithTitle:headTitle WithRank:[NSString stringWithFormat:@"%ld", sum]];
    
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
    if (![self.yearStr isEqualToString:@""] && self.yearStr) {
        NSError *passError;
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
        NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionKey"];
        NSString *passWord = [SFHFKeychainUtils getPasswordForUsername:userName andServiceName:SAVE_NAME error:&passError];
        
        __weak typeof(self) weakSelf = self;
        
        NSString *url = [NSString stringWithFormat:@"http://scoreapi.xiyoumobile.com/score/year"];
        XYSHTTPRequestManager *requestManager = [XYSHTTPRequestManager createInstance];
        [requestManager postDataWithUrl:url WithParams:@{@"username" : userName, @"password" : passWord, @"session" : session,@"year" : self.yearStr, @"update" : @"update"} success:^(id dic) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dic options:NSJSONReadingMutableLeaves error:nil];
            NSString *errorStr = dict[@"error"];
            if (![errorStr boolValue]) {
                XYSTermModel *tempModel = weakSelf.termModel;
                NSDictionary *result = dict[@"result"];
                NSArray *score = result[@"score"];
                tempModel.scoresTermOne = [weakSelf getTermMessage:score[0]];
                tempModel.scoresTermTwo = [weakSelf getTermMessage:score[1]];
                weakSelf.termModel = tempModel;
                [self.tableView reloadData];
            } else {
                [SVProgressHUD showErrorWithStatus:@"加载失败"];
            }
            [self.tableView.header endRefreshing];
            
        } error:^(NSError *error) {
            NSLog(@"%@", error);
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
            [self.tableView.header endRefreshing];
        }];
    } else {
        [SVProgressHUD showErrorWithStatus:@"请选择学年"];
        [self.tableView.header endRefreshing];
    }
    
}

#pragma mark - 展开收缩section中cell 手势监听
-(void)SingleTap:(UITapGestureRecognizer*)recognizer{
    NSInteger didSection = recognizer.view.tag;
    
    if (!self.showDic) {
        self.showDic = [[NSMutableDictionary alloc]init];
    }
    
    NSString *key = [NSString stringWithFormat:@"%ld",didSection];
    if (![self.showDic objectForKey:key]) {
        [self.showDic setObject:@"1" forKey:key];
        
    }else{
        [self.showDic removeObjectForKey:key];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:didSection] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - 改变学年的监听事件
- (void)changeYearItem:(id)sender {
    [self.showDic removeAllObjects];
    NSString *year = [[sender userInfo] objectForKey:@"title"];
    self.yearStr = year;
    [self entityDataSource:self.title];
}

#pragma mark - 筛选成绩信息
- (void)entityDataSource:(NSString *)value {
    if (self.yearArray && self.yearStr) {
        for (XYSTermModel *term in self.yearArray) {
            XYSTermModel *tempModel = [[XYSTermModel alloc] init];
            tempModel.year = term.year;
            tempModel.scoresTermOne = term.scoresTermOne;
            tempModel.scoresTermTwo = term.scoresTermTwo;
            if ([term.year isEqualToString:self.yearStr]) {
                if([self.title isEqualToString:@"已通过"]) {
                    NSMutableArray *array1 = [NSMutableArray array];
                    NSMutableArray *array2 = [NSMutableArray array];
                    for (XYSScoreModel *score in term.scoresTermOne) {
                        if (![score.exam isEqualToString:@"补考未通过"]) {
                            [array1 addObject:score];
                        }
                    }
                    for (XYSScoreModel *score in term.scoresTermTwo) {
                        if (![score.exam isEqualToString:@"补考未通过"]) {
                            [array2 addObject:score];
                        }
                    }
                    tempModel.scoresTermOne = array1;
                    tempModel.scoresTermTwo = array2;
                } else if ([self.title isEqualToString:@"未通过"]) {
                    NSMutableArray *array1 = [NSMutableArray array];
                    NSMutableArray *array2 = [NSMutableArray array];
                    for (XYSScoreModel *score in term.scoresTermOne) {
                        if ([score.exam isEqualToString:@"补考未通过"]) {
                            [array1 addObject:score];
                        }
                    }
                    for (XYSScoreModel *score in term.scoresTermTwo) {
                        if ([score.exam isEqualToString:@"补考未通过"]) {
                            [array2 addObject:score];
                        }
                    }
                    tempModel.scoresTermOne = array1;
                    tempModel.scoresTermTwo = array2;
                }
                
                self.termModel = tempModel;
                [self.tableView reloadData];
            }
        }
    }
}

#pragma mark - 下拉刷新解析数据方法
- (NSMutableArray *)getTermMessage:(NSDictionary *)dic {
    NSArray *scores = dic[@"Scores"];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *scoreDic in scores) {
        XYSScoreModel *scoreModel = [[XYSScoreModel alloc] init];
        scoreModel.score = scoreDic[@"EndScore"];
        scoreModel.credit = scoreDic[@"Credit"];
        scoreModel.regularGrade = scoreDic[@"UsualScore"];
        scoreModel.volumeGrade = scoreDic[@"RealScore"];
        scoreModel.academy = scoreDic[@"School"];
        scoreModel.course = scoreDic[@"Title"];
        scoreModel.courseQuality = scoreDic[@"Type"];
        scoreModel.makeupScore = scoreDic[@"ReScore"];
        scoreModel.exam = scoreDic[@"Exam"];
        [array addObject:scoreModel];
    }
    return array;
}

@end
