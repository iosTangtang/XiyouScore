//
//  XYSLoginViewController.m
//  XiyouScore
//
//  Created by Tangtang on 16/7/23.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYSLoginViewController.h"
#import "XYSTabBarViewController.h"
#import "XYSCETController.h"
#import "XYSTextField.h"
#import "SVProgressHUD.h"
#import "XYSHTTPRequestManager.h"

#define MAX_REQUEST 3

@interface XYSLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) XYSTextField   *userName;
@property (nonatomic, strong) XYSTextField   *password;
@property (nonatomic, strong) UIButton       *loginButton;
//@property (nonatomic, copy)   NSDictionary   *userDict;
@property (nonatomic, copy)   NSDictionary   *scoreDict;
//@property (nonatomic, copy)   NSData         *imageData;
//@property (nonatomic, assign) NSInteger      count;

@end

@implementation XYSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self p_setupTextField];
//    self.count = 0;
    
    if (_isCET == NO) {
        [self p_addCreator];
    }
    
}

#pragma mark - setupTextField
- (void)p_setupTextField {
    //初始化提示框
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    
    self.userName = [[XYSTextField alloc] init];
    self.userName.placeholder = self.userPlace;
    UIImageView *accountView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"name"]];
    accountView.frame = CGRectMake(0, 0, 35, 35);
    accountView.contentMode = UIViewContentModeCenter;
    self.userName.leftView = accountView;
    self.userName.leftViewMode = UITextFieldViewModeAlways;
    self.userName.clearButtonMode = YES;
    self.userName.delegate = self;
    self.userName.returnKeyType = UIReturnKeyDone;
    self.userName.font = [UIFont fontWithName:@"PingFang SC" size:15.0];
    [self.view addSubview:self.userName];
    
    self.password = [[XYSTextField alloc] init];
    self.password.placeholder = self.keyPlace;
    self.password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UIImageView *lock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"key"]];
    lock.frame = CGRectMake(0, 0, 35, 35);
    lock.contentMode = UIViewContentModeCenter;
    self.password.leftView = lock;
    self.password.leftViewMode = UITextFieldViewModeAlways;
    if (self.isCET == NO) {
        self.password.secureTextEntry = YES;
    }
    self.password.clearButtonMode = YES;
    self.password.delegate = self;
    self.password.returnKeyType = UIReturnKeyDone;
    self.password.font = [UIFont fontWithName:@"PingFang SC" size:15.0];
    [self.view addSubview:self.password];
    
    if (self.isCET == NO) {
        self.userName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
        self.password.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"passWord"];
    }
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.loginButton.backgroundColor = [UIColor colorWithRed:61 / 255.0 green:118 / 255.0 blue:203 / 255.0 alpha:0.7];
    [self.loginButton setTitle:self.buttonPlace forState:UIControlStateNormal];
    [self.loginButton setTintColor:[UIColor whiteColor]];
    self.loginButton.layer.cornerRadius = 5;
    [self.loginButton addTarget:self action:@selector(p_loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    self.loginButton.enabled = NO;
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(40);
        make.left.equalTo(self.view.left).offset(30);
        make.right.equalTo(self.view.right).offset(-30);
        make.height.equalTo(40);
    }];
    
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userName.bottom).offset(10);
        make.left.right.equalTo(self.userName);
        make.height.equalTo(self.userName.height);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.password.bottom).offset(20);
        make.left.right.equalTo(self.userName);
        make.height.equalTo(self.userName);
    }];
    
}

#pragma mark - addCreator
- (void)p_addCreator {
    UILabel *creatorLabel = [[UILabel alloc] init];
    creatorLabel.text = @"© 西安邮电大学移动应用开发实验室";
    creatorLabel.textAlignment = NSTextAlignmentCenter;
    creatorLabel.font = [UIFont fontWithName:@"PingFang SC" size:12.0];
    creatorLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:creatorLabel];
    
    [creatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(20);
        make.bottom.equalTo(self.view).offset(-30);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - buttonAction
- (void)p_loginAction {
    if (_isCET == NO) {
        [self.userName resignFirstResponder];
        [self.password resignFirstResponder];
        
        [SVProgressHUD showWithStatus:@"登陆中"];
        
        __weak typeof(self) weakSelf = self;
        
        NSString *url = [NSString stringWithFormat:@"%@%@", XYS_IP, @"/users/login"];
        XYSHTTPRequestManager *requestManager = [XYSHTTPRequestManager createInstance];
        [requestManager postDataWithUrl:url WithParams:@{@"username" : self.userName.text, @"password" : self.password.text} success:^(id dic) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dic options:NSJSONReadingMutableLeaves error:nil];
            NSString *isError = dict[@"error"];
            if ([isError boolValue] == 0) {
                NSDictionary *sessionDic = dict[@"result"];
                NSString *session = sessionDic[@"session"];
                [weakSelf webRequest:session];
                [[NSUserDefaults standardUserDefaults] setObject:session forKey:@"sessionKey"];
                [[NSUserDefaults standardUserDefaults] setObject:self.userName.text forKey:@"userName"];
                [[NSUserDefaults standardUserDefaults] setObject:self.password.text forKey:@"passWord"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } else {
                [SVProgressHUD showErrorWithStatus:@"用户名或密码错误"];
            }
            
        } error:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
        }];
        
    } else {
        [SVProgressHUD showWithStatus:@"查询中"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            XYSCETController *cetVC = [[XYSCETController alloc] init];
            cetVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cetVC animated:YES];
        });
        
    }

}

- (void)webRequest:(NSString *)session {
    XYSHTTPRequestManager *request = [XYSHTTPRequestManager createInstance];
    
    __weak typeof(self) weakSelf = self;
    NSLog(@"%@", session);
    
    NSString *url2 = [NSString stringWithFormat:@"%@%@", XYS_IP, @"/score/all"];
    [request postDataWithUrl:url2 WithParams:@{@"username" : self.userName.text, @"session" : session} success:^(id dic) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dic options:NSJSONReadingMutableLeaves error:nil];
        weakSelf.scoreDict = dict;
        [weakSelf endRequest];
    } error:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
    

}

- (void)endRequest {

    [SVProgressHUD dismiss];
    [self dismissViewControllerAnimated:NO completion:nil];
    
    //这块儿 使用通知分发数据
    //XYSContainerController
    [[NSNotificationCenter defaultCenter] postNotificationName:XYS_SCORE_DATA object:nil userInfo:self.scoreDict];
    //XYSUerController
    [[NSNotificationCenter defaultCenter] postNotificationName:XYS_USER_DATA object:nil];
    //XYSQueryScoreController
    [[NSNotificationCenter defaultCenter] postNotificationName:XYS_CHANGE_SCORE object:nil userInfo:self.scoreDict];
}

#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![self.userName.text isEqualToString:@""] && ![self.password.text isEqualToString:@""]) {
        self.loginButton.enabled = YES;
    } else {
        self.loginButton.enabled = NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (![self.userName.text isEqualToString:@""] && ![self.password.text isEqualToString:@""]) {
        self.loginButton.enabled = YES;
    } else {
        self.loginButton.enabled = NO;
    }
    
    return YES;
}

#pragma mark - 点击背景去键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
}

@end
