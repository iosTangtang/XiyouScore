//
//  ViewController.m
//  XiyouScore
//
//  Created by Tangtang on 16/7/21.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "ViewController.h"
#import "XYSHTTPRequestSession.h"
#import "XYSHTTPRequestManager.h"

#define MAX_REQUEST 3

@interface ViewController ()

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *passWord;
@property (nonatomic, copy) NSDictionary *diction1;
@property (nonatomic, copy) NSDictionary *diction2;
@property (nonatomic, copy) NSData  *data;
@property (nonatomic, assign) NSInteger count;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 0;
    
    self.userName = @"03151274";
    self.passWord = @"FRANfulan520";
    NSString *str = @"唐年";
    
    NSData *nsdata = [@"610151152105913"
                      dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];

    NSData *data1 = [[self getDateStr] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *baseStr = [data1 base64EncodedStringWithOptions:0];
    
    NSString *url = [NSString stringWithFormat:@"http://139.129.210.109/xuptqueryscore/servlet/CetServlet"];
    XYSHTTPRequestManager *requestManager = [XYSHTTPRequestManager createInstance];
    [requestManager postDataWithUrl:url WithParams:@{@"Time" : baseStr, @"Ticket" : base64Encoded, @"Name" : [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]} success:^(id dic) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dic options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@", dict);
        
    } error:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

- (NSString *)getDateStr {
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSLog(@"%@", [formatter stringFromDate:nowDate]);
    return [formatter stringFromDate:nowDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webRequest:(NSString *)session {
    XYSHTTPRequestManager *request = [XYSHTTPRequestManager createInstance];
    
    __weak typeof(self) weakSelf = self;
    
    NSString *url1 = [NSString stringWithFormat:@"http://scoreapi.xiyoumobile.com/users/info"];
    [request postDataWithUrl:url1 WithParams:@{@"username" : weakSelf.userName, @"password" : weakSelf.passWord, @"session" : session} success:^(id dic) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dic options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"11111111----%@", dict);
        weakSelf.diction1 = dict;
        [weakSelf endRequest];
    } error:^(NSError *error) {
        NSLog(@"11111111----%@", error);
    }];
    
    NSString *url2 = [NSString stringWithFormat:@"http://scoreapi.xiyoumobile.com/score/all"];
    [request postDataWithUrl:url2 WithParams:@{@"username" : weakSelf.userName, @"session" : session} success:^(id dic) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dic options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"22222222----%@", dict);
        weakSelf.diction2 = dict;
        [weakSelf endRequest];
    } error:^(NSError *error) {
        NSLog(@"22222222----%@", error);
    }];
    
    NSString *url = [NSString stringWithFormat:@"http://scoreapi.xiyoumobile.com/users/img"];
    [request postDataWithUrl:url WithParams:@{@"username" : weakSelf.userName, @"session" : session} success:^(id dic) {
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dic options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"33333333----%@", dic);
        weakSelf.data = dic;
        [weakSelf endRequest];
    } error:^(NSError *error) {
        NSLog(@"33333333----%@", error);
    }];
}

- (void)endRequest {
    self.count++;
    if (self.count == MAX_REQUEST) {
        NSLog(@"end");
        NSLog(@"%@", self.diction1);
        NSLog(@"%@", self.diction2);
        NSLog(@"%ld", [self.data length]);
    }
}

@end
