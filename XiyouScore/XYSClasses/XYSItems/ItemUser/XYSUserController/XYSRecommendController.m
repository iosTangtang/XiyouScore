//
//  XYSRecommendController.m
//  XiyouScore
//
//  Created by Tangtang on 16/7/21.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYSRecommendController.h"
#import "XYSRecommendCell.h"

static NSString * const kRecomCell = @"kRecomCell";

@interface XYSRecommendController ()<UITableViewDelegate, UITableViewDataSource, XYSButtonActionDelegate>

@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, copy)   NSArray       *messArray;

@end

@implementation XYSRecommendController

- (NSArray *)messArray {
    if (_messArray == nil) {
        _messArray = @[@{@"headImage" : [UIImage imageNamed:@"liblogo"], @"titleName" : @"西邮图书馆-iOS版",
                         @"moreLabel" : @" 一款高效的移动图书管理App。\n 随时随地续借图书，快来下载吧~"},
                       @{@"headImage" : [UIImage imageNamed:@"liblogo"], @"titleName" : @"西邮图书馆-iOS版",
                         @"moreLabel" : @" 一款高效的移动图书管理App。\n 随时随地续借图书，快来下载吧~"}
                       ];
    }
    return _messArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"向我推荐";
    
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
    self.tableView.estimatedRowHeight = 145;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XYSRecommendCell class]) bundle:nil] forCellReuseIdentifier:kRecomCell];
    
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYSRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecomCell];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    cell.delegate = self;
    NSDictionary *dic = self.messArray[indexPath.section];
    cell.titleImage = [dic objectForKey:@"headImage"];
    cell.titleLabel.text = [dic objectForKey:@"titleName"];
    cell.moreLabel.text = [dic objectForKey:@"moreLabel"];
    
    cell.backView.layer.shadowOffset = CGSizeMake(1, 1);
    cell.backView.layer.shadowOpacity = 0.3;
    cell.backView.layer.shadowColor = [UIColor grayColor].CGColor;
    cell.backView.layer.cornerRadius = 5;
    cell.backView.layer.masksToBounds = YES;
    
    return cell;
}

#pragma mark - XYSButtonActionDelegate
- (void)recomButtonAction:(UIButton *)sender {
    NSLog(@"downLoad");
}

@end
