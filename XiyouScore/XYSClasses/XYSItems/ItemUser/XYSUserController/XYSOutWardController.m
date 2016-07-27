//
//  XYSOutWardController.m
//  XiyouScore
//
//  Created by Tangtang on 16/7/25.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYSOutWardController.h"
#import "SVProgressHUD.h"

#define URLSTR @"http://222.24.19.201/default4.aspx"

@interface XYSOutWardController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView         *webView;
@property (nonatomic, strong) UIButton          *goBack;
@property (nonatomic, strong) UIButton          *goForward;
@property (nonatomic, strong) UIButton          *reload;
@property (nonatomic, strong) UIButton          *gotoSafari;

@end

@implementation XYSOutWardController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.webView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self p_setupWebView];
    [self p_setupToolBar];
}

#pragma mark - setupWebView
- (void)p_setupWebView {
    
    self.webView = [[UIWebView alloc] init];
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view.bottom).offset(-44);
    }];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:URLSTR]];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    
    [self.webView loadRequest:request];
}

- (void)p_setupToolBar {
    UIView *toolView = [[UIView alloc] init];
    toolView.backgroundColor = [UIColor colorWithRed:61 / 255.0 green:118 / 255.0 blue:203 / 255.0 alpha:1];
    [self.view addSubview:toolView];
    
    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(44);
    }];
    
    self.goBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.goBack setBackgroundImage:[UIImage imageNamed:@"goBack"] forState:UIControlStateNormal];
    [self.goBack addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.goBack];
    
    [self.goBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(15);
        make.height.equalTo(25);
        make.centerY.equalTo(toolView.centerY);
        make.left.equalTo(30);
    
    }];
    
    if (self.webView.canGoBack == NO) {
        self.goBack.enabled = NO;
    }
    
    self.goForward = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.goForward setBackgroundImage:[UIImage imageNamed:@"goForward"] forState:UIControlStateNormal];
    [self.goForward addTarget:self action:@selector(goForwardAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.goForward];
    
    [self.goForward mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(15);
        make.height.equalTo(25);
        make.centerY.equalTo(toolView.centerY);
        make.left.equalTo(self.goBack.right).offset(50);
        
    }];
    
    if (self.webView.canGoForward == NO) {
        self.goForward.enabled = NO;
    }
    
    self.reload = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.reload setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [self.reload addTarget:self action:@selector(reloadAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.reload];
    
    [self.reload mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(26);
        make.height.equalTo(26);
        make.centerY.equalTo(toolView.centerY);
        make.right.equalTo(toolView.right).offset(-30);
    }];
    
    self.gotoSafari = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.gotoSafari setBackgroundImage:[UIImage imageNamed:@"safari"] forState:UIControlStateNormal];
    [self.gotoSafari addTarget:self action:@selector(gotoSafariAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.gotoSafari];
    
    [self.gotoSafari mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(28);
        make.height.equalTo(28);
        make.centerY.equalTo(toolView.centerY);
        make.right.equalTo(self.reload.left).offset(-40);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"start");
    [self.reload setBackgroundImage:[UIImage imageNamed:@"unLoad"] forState:UIControlStateNormal];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"end");
    
    if (self.webView.canGoBack == NO) {
        self.goBack.enabled = NO;
    } else {
        self.goBack.enabled = YES;
    }
    
    if (self.webView.canGoForward == NO) {
        self.goForward.enabled = NO;
    } else {
        self.goForward.enabled = YES;
    }
    
    [self.reload setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    NSLog(@"%@", error);
    [self.reload setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
}

#pragma mark - ButtonAction
- (void)goBackAction:(UIButton *)sender {
    [self.webView goBack];
}

- (void)goForwardAction:(UIButton *)sender {
    [self.webView goForward];
}

- (void)reloadAction:(UIButton *)sender {
    NSLog(@"%d", self.webView.isLoading);
    if (self.webView.isLoading == YES) {
        [self.webView stopLoading];
        [sender setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    } else {
        [self.webView reload];
        [sender setBackgroundImage:[UIImage imageNamed:@"unLoad"] forState:UIControlStateNormal];
    }
}

- (void)gotoSafariAction:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLSTR]];
}

@end
