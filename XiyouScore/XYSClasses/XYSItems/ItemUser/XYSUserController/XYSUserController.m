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
#import "XYSOutWardController.h"
#import "XYSUserModel.h"
#import "XYSUserCell.h"
#import "XYSHTTPRequestManager.h"
#import "SVProgressHUD.h"
#import "SFHFKeychainUtils.h"

static NSString * const kUserHeadCell = @"kUserHeadCell";
static NSString * const kUserCell     = @"kUserCell";

@interface XYSUserController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, copy)   NSArray       *titleArray;
@property (nonatomic, copy)   NSArray       *imageArray;
@property (nonatomic, strong) XYSUserModel  *userModel;
@property (nonatomic, assign) BOOL          isSucceed;

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

- (XYSUserModel *)userModel {
    if (_userModel == nil) {
        _userModel = [[XYSUserModel alloc] init];
    }
    return _userModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupModel:) name:XYS_USER_DATA object:nil];
    
    self.isSucceed = NO;
    [self p_setupTableView];
    [self p_startRequest];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void)p_startRequest {
    NSError *passError;
    
    XYSHTTPRequestManager *request = [XYSHTTPRequestManager createInstance];
    
    NSString *session = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionKey"];
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    NSString *password = [SFHFKeychainUtils getPasswordForUsername:username andServiceName:SAVE_NAME error:&passError];
    __weak typeof(self) weakSelf = self;
    
    NSString *url1 = [NSString stringWithFormat:@"%@%@", XYS_IP, @"/users/info"];
    [request postDataWithUrl:url1 WithParams:@{@"username" : username, @"password" : password, @"session" : session} success:^(id dic) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dic options:NSJSONReadingMutableLeaves error:nil];
        NSString *error = [dict objectForKey:@"error"];
        if ([error boolValue] == 0) {
            NSDictionary *userInfo = dict[@"result"];
            weakSelf.userModel.className = userInfo[@"class"];
            weakSelf.userModel.academy = userInfo[@"college"];
            weakSelf.userModel.name = userInfo[@"name"];
            weakSelf.userModel.studentID = userInfo[@"username"];
        }
        
        //加载头像
        NSString *url = [NSString stringWithFormat:@"%@%@", XYS_IP, @"/users/img"];
        [request postDataWithUrl:url WithParams:@{@"username" : username, @"session" : session} success:^(id dic) {
            weakSelf.userModel.headImageData = dic;
            [weakSelf.tableView reloadData];
            weakSelf.isSucceed = YES;
        } error:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
        }];
        
    } error:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
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
        if (self.userModel.headImageData == nil) {
            cell.headImage.image = [UIImage imageNamed:@"image"];
        } else {
            cell.headImage.image = [UIImage imageWithData:self.userModel.headImageData];
        }

        cell.userName.text = self.userModel.name == nil ? @"SomeBody" : self.userModel.name;
        cell.userID.text = self.userModel.studentID == nil ? @"SomeThing" : self.userModel.studentID;
        cell.academy.text = self.userModel.academy == nil ? @"SomeWhere" : self.userModel.academy;
        cell.className.text = self.userModel.className == nil ? @"SomeWhere" : self.userModel.className;
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
    if (indexPath.section == 0) {
        if (self.isSucceed == NO) {
            [self p_startRequest];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            XYSLoginViewController *loginVC = [[XYSLoginViewController alloc] init];
            loginVC.title = @"四六级查询";
            loginVC.userPlace = @"请输入准考证号";
            loginVC.keyPlace = @"请输入姓名";
            loginVC.buttonPlace = @"查询";
            loginVC.isCET = YES;
            loginVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
        } else if (indexPath.row == 1) {
            XYSOutWardController *outwardVC = [[XYSOutWardController alloc] init];
            outwardVC.hidesBottomBarWhenPushed = YES;
            outwardVC.title = @"素质拓展查询";
            [self.navigationController pushViewController:outwardVC animated:YES];
        } else if (indexPath.row == 2) {
            XYSRecommendController *recommendVC = [[XYSRecommendController alloc] init];
            recommendVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:recommendVC animated:YES];
        }
    }
}

- (void)setupModel:(id)sender {
    self.isSucceed = NO;
    [self p_startRequest];
}


@end
