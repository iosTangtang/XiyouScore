//
//  XYSHTTPRequestManager.m
//  XiyouScore
//
//  Created by Tangtang on 16/7/21.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYSHTTPRequestManager.h"
#import "XYSHTTPRequestSession.h"
#import "NSString+Hash.h"

#define  XYSCachePath [NSTemporaryDirectory() stringByAppendingString:@"cache"]
#define  XYSBaseURLPath @""

static XYSHTTPRequestManager *httpManager = nil;

@interface XYSHTTPRequestManager ()

@property (nonatomic, strong) XYSHTTPRequestSession     *requesSession;             //请求
@property (nonatomic, strong) NSMutableDictionary       *cachePool;                 //缓存池
@property (nonatomic, copy)   NSString                  *taskName;                  //缓存的请求地址
@property (nonatomic, assign) BOOL                      isCanceled;                 //是否取消请求

@end

@implementation XYSHTTPRequestManager

- (NSMutableDictionary *)cachePool {
    if (_cachePool == nil) {
        _cachePool = [NSMutableDictionary dictionary];
    }
    return _cachePool;
}

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
                 error:(XYSErrorBlock)errorBlock {
    
    urlStr = [self preperForRequestWithUrl:urlStr];
    XYSHTTPRequestSession *session = [[XYSHTTPRequestSession alloc] init];
    [self.cachePool setObject:session forKey:urlStr];
    self.requesSession = session;
    [session getData:urlStr WithParams:params success:^(id dic) {
        [self successReturnWithSuccessBlock:success Url:urlStr data:dic];
    } error:^(NSError *error) {
        [self errorReturnWithError:error SuccessBlock:success errorBlock:errorBlock];
    }];
}

- (void)postDataWithUrl:(NSString *)urlStr
             WithParams:(id)params
                success:(XYSSucceedBlock)success
                  error:(XYSErrorBlock)errorBlock {
    
    urlStr = [self preperForRequestWithUrl:urlStr];
    XYSHTTPRequestSession *session = [[XYSHTTPRequestSession alloc] init];
    [self.cachePool setObject:session forKey:urlStr];
    self.requesSession = session;
    [session postData:urlStr WithParams:params success:^(id dic) {
        [self successReturnWithSuccessBlock:success Url:urlStr data:dic];
    } error:^(NSError *error) {
        [self errorReturnWithError:error SuccessBlock:success errorBlock:errorBlock];
    }];
}

- (void)uploadFileWithUrl:(NSString *)urlStr
               WithParams:(id)params
                 fileData:(NSData *)data
           fileSuffixName:(NSString *)suffixName
                 progress:(NSProgress **)kProgress
                  success:(XYSSucceedBlock)success
                    error:(XYSErrorBlock)errorBlock {
    
    urlStr = [self preperForRequestWithUrl:urlStr];
    XYSHTTPRequestSession *session = [[XYSHTTPRequestSession alloc] init];
    
    NSString *name = [[self getDateStr] md5String];
    NSString *fileName = [NSString stringWithFormat:@"%@.%@", name, suffixName];
    
    [session uploadFile:urlStr WithParams:params fileData:data name:name fileName:fileName progress:kProgress success:^(id dic) {
        if (success) {
            success(dic);
        }
    } error:^(NSError *error) {
        self.isCanceled = NO;
        if (errorBlock) {
            [self errorReturnWithError:error SuccessBlock:success errorBlock:errorBlock];
        }
    }];
    
    
}

- (void)downloadFileWithUrl:(NSString *)urlStr
                 WithParams:(id)params
                   progress:(NSProgress **)kProgress
                    success:(XYSSucceedBlock)success
                      error:(XYSErrorBlock)errorBlock {
    
    urlStr = [self preperForRequestWithUrl:urlStr];
    XYSHTTPRequestSession *session = [[XYSHTTPRequestSession alloc] init];
    [self.cachePool setObject:session forKey:urlStr];
    self.requesSession = session;
    
    NSString *hashPath = [self.taskName md5String];
    NSString *fullPath = [self getFilePath:hashPath];
    
    [session downLoadFile:urlStr WithParams:params fileDownPath:fullPath progress:kProgress success:^(id dic) {
        if (success) {
            success(dic);
        }
    } error:^(NSError *error) {
        self.isCanceled = NO;
        if (errorBlock) {
            [self errorReturnWithError:error SuccessBlock:success errorBlock:errorBlock];
        }
    }];
    
    
}

- (NSString *)preperForRequestWithUrl:(NSString *)urlStr {
    urlStr = [NSString stringWithFormat:@"%@%@", XYSBaseURLPath, urlStr];
    self.taskName = urlStr;
    if ([self.cachePool objectForKey:urlStr]) {
        NSLog(@"XYSHTTPRequestManager: 正在请求");
    }
    
    return urlStr;
}

- (void)successReturnWithSuccessBlock:(XYSSucceedBlock)success Url:(NSString *)url data:(id)dic {
    if ([self.cachePool objectForKey:self.taskName]) {
        [self.cachePool removeObjectForKey:self.taskName];
    }
    
    NSString *hashPath = [self.taskName md5String];
    NSString *fullPath = [self getFilePath:hashPath];
    
    NSData *data = [self dictionaryToData:dic];
    [data writeToFile:fullPath atomically:YES];
    
    if (success) {
        success(dic);
    }
    
    [self.cachePool removeObjectForKey:url];
}

- (void)errorReturnWithError:(NSError *)error SuccessBlock:(XYSSucceedBlock)success errorBlock:(XYSErrorBlock)errorBlock {
    
    if (self.isCanceled) {
        self.isCanceled = NO;
        if (errorBlock) {
            errorBlock(error);
        }
    } else {
        NSString *hashPath = [self.taskName md5String];
        NSString *fullPath = [self getFilePath:hashPath];
        
        NSDictionary *dic = [self dataToDictionaryFromDataPath:fullPath];
        
        if (dic) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
                if (success) {
                    success(dic);
                }
            }
        } else {
            if (errorBlock) {
                errorBlock(error);
            }
        }
    }
}

- (NSString *)getFilePath:(NSString *)field {
    NSString *realPath = nil;
    if (field && [field length]) {
        NSString *path = NSHomeDirectory();
        NSString *cacheDir = [path stringByAppendingString:@"Library/Caches/requestCache"];
        realPath = [cacheDir stringByAppendingString:field];
    } else {
        realPath = XYSCachePath;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:realPath]) {
        NSError *error = nil;
        if ([fileManager createDirectoryAtPath:realPath withIntermediateDirectories:YES attributes:nil error:&error]) {
            return [realPath stringByAppendingString:field];
        } else {
            [fileManager createDirectoryAtPath:realPath withIntermediateDirectories:YES attributes:nil error:&error];
            return [realPath stringByAppendingString:field];
        }
    }
    
    realPath = [realPath stringByAppendingString:field];
    
    return realPath;
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
    if (self.cachePool.count) {
        [self.cachePool removeAllObjects];
        [self.requesSession cancel];
        self.isCanceled = YES;
    }
}

- (NSString *)getCacheByte {
    return nil;
}

- (NSString *)getDateStr {
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSLog(@"%@", [formatter stringFromDate:nowDate]);
    return [formatter stringFromDate:nowDate];
}

@end
