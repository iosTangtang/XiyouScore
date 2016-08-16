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
#import "AFHTTPSessionManager.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "XPathQuery.h"

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
//    self.count = 0;
//    
//    self.userName = @"03151274";
//    self.passWord = @"FRANfulan520";
//    NSString *str = @"唐年";
//    
//    NSData *nsdata = [@"610151152105913"
//                      dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
//
//    NSData *data1 = [[self getDateStr] dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *baseStr = [data1 base64EncodedStringWithOptions:0];
    
    NSString *url = [NSString stringWithFormat:@"http://www.chsi.com.cn/cet/query?zkzh=610151152105913&xm=唐年"];
    NSString *urlSTR = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    XYSHTTPRequestManager *requestManager = [XYSHTTPRequestManager createInstance];
    [requestManager getDataWithUrl:urlSTR WithParams:@{@"zkzh" : @"610151152105913", @"xm" : @"唐年"} success:^(id dic) {
        NSArray *cookies   = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:urlSTR]];
        NSHTTPCookie *test = cookies[0];
        NSString *cookie   = [NSString stringWithFormat:@"%@=%@",test.name,test.value];
        
        AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] init];
        sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/xml", nil];
        sessionManager.requestSerializer  = [AFHTTPRequestSerializer serializer];
        sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [sessionManager.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
        [sessionManager.requestSerializer setValue:@"http://www.chsi.com.cn/cet/" forHTTPHeaderField:@"Referer"];
        
        [sessionManager GET:urlSTR parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {

            TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:responseObject];
            NSArray *elements  = [xpathParser searchWithXPathQuery:@"//td"];
            for (TFHppleElement *obj2 in elements) {
                if ([obj2.attributes[@"class"] isEqualToString:@"fontBold"]) {
                    for (TFHppleElement *obj3 in obj2.children) {
                        NSLog(@"%@", [obj3.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
                    }
                } else {
                    NSLog(@"%@", [obj2.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
                }
            }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
        
    } error:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
