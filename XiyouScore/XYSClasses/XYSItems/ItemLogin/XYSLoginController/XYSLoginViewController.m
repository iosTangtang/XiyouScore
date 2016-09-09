//
//  XYSLoginViewController.m
//  XiyouScore
//
//  该界面和四级共用一个界面
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
#import "SFHFKeychainUtils.h"
#import "AFHTTPSessionManager.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "XPathQuery.h"

#define MAX_REQUEST 3

@interface XYSLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) XYSTextField   *userName;
@property (nonatomic, strong) XYSTextField   *password;
@property (nonatomic, strong) XYSTextField   *codeText;
@property (nonatomic, strong) UIImageView    *codeImage;
@property (nonatomic, strong) UIButton       *loginButton;
@property (nonatomic, copy)   NSDictionary   *scoreDict;

@end

@implementation XYSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self p_setupTextField];
    
    if (_isCET == NO) {
        [self p_addCreator];
        [self p_getCodeImage];
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
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.loginButton.backgroundColor = [UIColor colorWithRed:61 / 255.0 green:118 / 255.0 blue:203 / 255.0 alpha:0.7];
    [self.loginButton setTitle:self.buttonPlace forState:UIControlStateNormal];
    [self.loginButton setTintColor:[UIColor whiteColor]];
    self.loginButton.layer.cornerRadius = 5;
    [self.loginButton addTarget:self action:@selector(p_loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    self.loginButton.enabled = NO;
    
    if (_isCET == NO) {
        self.codeText = [[XYSTextField alloc] init];
        self.codeText.placeholder = @"验证码";
        self.codeText.textAlignment = NSTextAlignmentCenter;
        self.codeText.clearButtonMode = YES;
        self.codeText.delegate = self;
        self.codeText.returnKeyType = UIReturnKeyDone;
        self.codeText.font = [UIFont fontWithName:@"PingFang SC" size:15.0];
        [self.view addSubview:self.codeText];
        
        self.codeImage = [[UIImageView alloc] init];
        self.codeImage.backgroundColor = [UIColor lightGrayColor];
        self.codeImage.userInteractionEnabled = YES;
        [self.view addSubview:self.codeImage];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_getCodeImage)];
        [self.codeImage addGestureRecognizer:tapGesture];
    }
    
    //添加布局
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
    
    if (_isCET == NO) {
        [self.codeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.password.bottom).offset(10);
            make.right.equalTo(self.password.right);
            make.height.equalTo(self.userName.height);
            make.width.equalTo(120);
        }];
        
        [self.codeText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.password.bottom).offset(10);
            make.left.equalTo(self.password.left);
            make.height.equalTo(self.userName.height);
            make.right.equalTo(self.codeImage.left).offset(10);
        }];
        
        [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.codeText.bottom).offset(20);
            make.left.right.equalTo(self.userName);
            make.height.equalTo(self.userName);
        }];
    } else {
        [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.password.bottom).offset(20);
            make.left.right.equalTo(self.userName);
            make.height.equalTo(self.userName);
        }];
    }
    
    
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
    
    NSError *passError = nil;
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    NSString *password = [SFHFKeychainUtils getPasswordForUsername:username andServiceName:SAVE_NAME error:&passError];
    if (username) {
        self.userName.text = username;
    }
    if (password) {
        self.password.text = password;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getCodeImage
- (void)p_getCodeImage {
    NSString *url = [NSString stringWithFormat:@"%@%@", XYS_IP, @"/users/verCode"];
    XYSHTTPRequestManager *requestManager = [XYSHTTPRequestManager createInstance];
    [requestManager postDataWithUrl:url WithParams:nil success:^(id dic) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dic options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *result = dict[@"result"];
        if (result) {
            [[NSUserDefaults standardUserDefaults] setObject:result[@"session"] forKey:@"sessionKey"];
            NSString *string = result[@"verCode" ];
            NSArray *strArray = [string componentsSeparatedByString:@","];
            if (strArray.count) {
                NSData *imageData = [[NSData alloc] initWithBase64EncodedString:strArray[1] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.codeImage.image = [UIImage imageWithData:imageData];
                });
            }
        }
        
    } error:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求验证码出错!"];
    }];
}

#pragma mark - buttonAction
- (void)p_loginAction {
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    
    if (_isCET == NO) {
        [SVProgressHUD showWithStatus:@"登录中"];
        
        __weak typeof(self) weakSelf = self;
        
        NSString *url = [NSString stringWithFormat:@"%@%@", XYS_IP, @"/users/login"];
        NSString *sessionStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionKey"];
        XYSHTTPRequestManager *requestManager = [XYSHTTPRequestManager createInstance];
        [requestManager postDataWithUrl:url WithParams:@{@"username" : self.userName.text, @"password" : self.password.text, @"session" : sessionStr, @"verCode" : self.codeText.text} success:^(id dic) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dic options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@", dict);
            NSString *isError = dict[@"error"];
            if ([isError boolValue] == 0) {
                NSDictionary *sessionDic = dict[@"result"];
                NSString *session = sessionDic[@"session"];
                [weakSelf webRequest:session];
                [[NSUserDefaults standardUserDefaults] setObject:self.userName.text forKey:@"userName"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSError *saveError;
                BOOL succee = [SFHFKeychainUtils storeUsername:self.userName.text
                                                    andPassword:self.password.text
                                                 forServiceName:SAVE_NAME
                                                 updateExisting:YES
                                                          error:&saveError];
                if (!succee) {
                    NSLog(@"保存密码出错");
                }

            } else {
                NSString *result = dict[@"result"];
                if ([result isEqualToString:@"Please check your password or vercode"]) {
                    [SVProgressHUD showErrorWithStatus:@"验证码错误"];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"用户名或密码错误"];
                }
                
                [self p_getCodeImage];
            }
            
        } error:^(NSError *error) {
            if ([[NSString stringWithFormat:@"%ld", error.code] isEqualToString:@"-1001"]) {
                [SVProgressHUD showErrorWithStatus:@"服务器异常"];
            } else {
                [SVProgressHUD showErrorWithStatus:@"网络异常"];
            }
            
        }];
        
    } else {
        [SVProgressHUD showWithStatus:@"查询中"];
        [self cetQuery];
    } 

}

#pragma mark - 网络请求
- (void)webRequest:(NSString *)session {
    XYSHTTPRequestManager *request = [XYSHTTPRequestManager createInstance];
    
    __weak typeof(self) weakSelf = self;
    
    if (session != nil) {
        NSString *url2 = [NSString stringWithFormat:@"%@%@", XYS_IP, @"/score/all"];
        [request postDataWithUrl:url2 WithParams:@{@"username" : self.userName.text, @"session" : session} success:^(id dic) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dic options:NSJSONReadingMutableLeaves error:nil];
            weakSelf.scoreDict = dict;
            [weakSelf endRequest];
        } error:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
        }];
    } else {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }

}

#pragma mark - 四六级查询请求
- (void)cetQuery {
    
    NSString *url = [NSString stringWithFormat:@"http://www.chsi.com.cn/cet/query?zkzh=%@&xm=%@", self.userName.text, self.password.text];
    NSString *urlSTR = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    XYSHTTPRequestManager *requestManager = [XYSHTTPRequestManager createInstance];
    [requestManager getDataWithUrl:urlSTR WithParams:nil success:^(id dic) {
        NSArray *cookies   = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:urlSTR]];
        if (cookies.count > 0) {
            NSHTTPCookie *test = cookies[0];
            NSString *cookie   = [NSString stringWithFormat:@"%@=%@",test.name,test.value];
            
            AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] init];
            sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/xml", nil];
            sessionManager.requestSerializer  = [AFHTTPRequestSerializer serializer];
            sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [sessionManager.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
            [sessionManager.requestSerializer setValue:@"http://www.chsi.com.cn/cet/" forHTTPHeaderField:@"Referer"];
            
            [sessionManager GET:urlSTR parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                
                NSMutableArray *result = [NSMutableArray array];
                NSMutableArray *messArray = [NSMutableArray array];
                NSMutableArray *scoreArray = [NSMutableArray array];
                TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:responseObject];
                NSArray *elements  = [xpathParser searchWithXPathQuery:@"//td"];
                for (TFHppleElement *obj2 in elements) {
                    if ([obj2.attributes[@"class"] isEqualToString:@"fontBold"]) {
                        for (TFHppleElement *obj3 in obj2.children) {
                            NSString *objStr = [obj3.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                            if (![objStr isEqualToString:@"听力："] &&
                                ![objStr isEqualToString:@"阅读："] &&
                                ![objStr isEqualToString:@"写作与翻译："] &&
                                ![objStr isEqualToString:@""]) {
                                [scoreArray addObject:objStr];
                            }
                        }
                    } else {
                        NSString *objStr = [obj2.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        if (![objStr isEqualToString:@""]) {
                            [messArray addObject:objStr];
                        }
                    }
                }
                if (messArray.count <= 0 || scoreArray.count <= 0) {
                    [SVProgressHUD showInfoWithStatus:@"查询失败！请检查网络及输入的信息"];
                } else {
                    [result addObject:messArray];
                    [result addObject:scoreArray];
                    [SVProgressHUD dismiss];
                    XYSCETController *cetVC = [[XYSCETController alloc] init];
                    cetVC.cetScores = result;
                    cetVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:cetVC animated:YES];
                }
                
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [SVProgressHUD showInfoWithStatus:@"查询失败！请检查网络及输入的信息"];
                NSLog(@"%@", error);
            }];
        } else {
           [SVProgressHUD showInfoWithStatus:@"服务器出错!"];
        }
        
    } error:^(NSError *error) {
        NSLog(@"%@", error);
        [SVProgressHUD showInfoWithStatus:@"查询失败！请检查网络及输入的信息"];
    }];
}

#pragma mark - 网络请求结束  分发数据
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
