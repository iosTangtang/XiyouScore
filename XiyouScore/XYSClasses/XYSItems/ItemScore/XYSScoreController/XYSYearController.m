//
//  XYSYearController.m
//  XiyouScore
//
//  Created by Tangtang on 16/7/26.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYSYearController.h"

static NSString * const kYearsCell = @"kYearsCell";

@interface XYSYearController ()

@end

@implementation XYSYearController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kYearsCell];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.years.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYearsCell forIndexPath:indexPath];
    
    cell.textLabel.text = self.years[indexPath.row];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont fontWithName:@"PingFang SC" size:17.f];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = @{@"title" : [NSString stringWithFormat:@"%@", self.years[indexPath.row]]};
    [[NSNotificationCenter defaultCenter] postNotificationName:XYSCHANGEYEARNOTIFI object:nil userInfo:dic];
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
