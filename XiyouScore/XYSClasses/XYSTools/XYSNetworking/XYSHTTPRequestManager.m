//
//  XYSHTTPRequestManager.m
//  XiyouScore
//
//  Created by Tangtang on 16/7/21.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYSHTTPRequestManager.h"
#import "XYSHTTPRequestSession.h"

static XYSHTTPRequestManager *httpManager = nil;

@interface XYSHTTPRequestManager ()

@property (nonatomic, strong) XYSHTTPRequestSession     *requesSession;             //请求
@property (nonatomic, strong) NSCache                   *cachePool;                 //缓存池
@property (nonatomic, copy)   NSString                  *taskName;                  //缓存的请求地址
@property (nonatomic, assign) BOOL                      isCanceled;                 //是否取消请求

@end

@implementation XYSHTTPRequestManager

#pragma mark - 单例实现
+ (instancetype)createInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpManager = [[super allocWithZone:NULL] init];
    });
    return httpManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self createInstance];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return self;
}

- (void)getDataWithUrl:(NSString *)urlStr
            WithParams:(id)params
               success:(XYSSucceedBlock)success
                 error:(XYSErrorBlock)error {

}

- (void)postDataWithUrl:(NSString *)urlStr
             WithParams:(id)params
                success:(XYSSucceedBlock)success
                  error:(XYSErrorBlock)error {

}

- (void)uploadFileWithUrl:(NSString *)urlStr
               WithParams:(id)params
                 fileData:(NSData *)data
           fileSuffixName:(NSString *)suffixName
                  success:(XYSSucceedBlock)success
                    error:(XYSErrorBlock)error {

}

- (void)downloadFileWithUrl:(NSString *)urlStr
                 WithParams:(id)params
                    success:(XYSSucceedBlock)success
                      error:(XYSErrorBlock)error {

}

- (NSString *)preperForRequestWithUrl:(NSString *)urlStr {
    return nil;
}

- (void)successReturnWithSuccessBlock:(XYSSucceedBlock)success Url:(NSString *)url data:(id)dic {
    
}

- (void)errorReturnWithError:(NSError *)error SuccessBlock:(XYSSucceedBlock)success errorBlock:(XYSErrorBlock)errorBlock {

}

- (NSData *)dictionaryToData:(NSDictionary *)dic {
    
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dic forKey:@"XYSData"];
    [archiver finishEncoding];
    
    return data;
}

- (NSDictionary *)dataToDictionary:(NSData *)data {
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary *dic = [unarchiver decodeObjectForKey:@"XYSData"];
    [unarchiver finishDecoding];
    
    return dic;
}

- (NSDictionary *)dataToDictionaryFromDataPath:(NSString *)dataPath {
    
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:dataPath];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary *dic = [unarchiver decodeObjectForKey:@"XYSData"];
    [unarchiver finishDecoding];
    
    return dic;
}

- (void)cancel {

}

- (NSString *)getCacheByte {
    return nil;
}

@end
