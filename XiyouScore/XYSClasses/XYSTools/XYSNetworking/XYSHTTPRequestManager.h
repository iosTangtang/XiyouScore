//
//  XYSHTTPRequestManager.h
//  XiyouScore
//
//  Created by Tangtang on 16/7/21.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XYSRequestSerializerType) {
    XYSRequestSerializerTypeDefault = 0,            //default
    XYSRequestSerializerTypeJson
};

typedef NS_ENUM(NSInteger, XYSResponseSerializerType) {
    XYSResponseSerializerTypeDefault = 0,            //default
    XYSResponseSerializerTypeJson
};

typedef void(^XYSSucceedBlock)(id dic);
typedef void(^XYSErrorBlock)(NSError *error);
//typedef void(^XYSCompleted)(double count);


@interface XYSHTTPRequestManager : NSObject

@property (nonatomic, assign) XYSRequestSerializerType  requestType;                                //请求时设定的数据请求格式
@property (nonatomic, assign) XYSResponseSerializerType responseType;                               //数据返回时的数据格式
@property (nonatomic, assign) double                    timeoutInterval;                            //超时时间

/**
 *  单例方法
 *
 *  @return 返回该类的单例对象
 */
+ (instancetype)createInstance;

/**
 *  GET请求方法
 *
 *  @param urlStr  请求接口
 *  @param params  请求参数
 *  @param success 请求成功回调的block
 *  @param error   请求失败回调的block
 */
- (void)getDataWithUrl:(NSString *)urlStr
            WithParams:(id)params
               success:(XYSSucceedBlock)success
                 error:(XYSErrorBlock)errorBlock;

/**
 *  POST请求方法
 *
 *  @param urlStr  请求接口
 *  @param params  请求参数
 *  @param success 请求成功回调的block
 *  @param error   请求失败回调的block
 */
- (void)postDataWithUrl:(NSString *)urlStr
            WithParams:(id)params
               success:(XYSSucceedBlock)success
                 error:(XYSErrorBlock)errorBlock;

/**
 *  上传文件方法
 *
 *  @param urlStr     请求接口
 *  @param params     请求参数
 *  @param data       所要上传的文件的数据(data)
 *  @param suffixName 所要上传的文件的后缀名
 *  @param kProgress  获取下载进度的类
 *  @param success    请求成功回调的block
 *  @param error      请求失败回调的block
 */
- (void)uploadFileWithUrl:(NSString *)urlStr
               WithParams:(id)params
                 fileData:(NSData *)data
           fileSuffixName:(NSString *)suffixName
                 progress:(NSProgress **)kProgress
                  success:(XYSSucceedBlock)success
                    error:(XYSErrorBlock)errorBlock;

/**
 *  下载文件方法
 *
 *  @param urlStr    请求接口
 *  @param params    请求参数
 *  @param kProgress  获取下载进度的类
 *  @param success   下载成功回调的block
 *  @param error     下载失败回调的block
 */
- (void)downloadFileWithUrl:(NSString *)urlStr
                 WithParams:(id)params
                   progress:(NSProgress **)kProgress
                    success:(XYSSucceedBlock)success
                      error:(XYSErrorBlock)errorBlock;

/**
 *  取消请求的方法
 */
- (void)cancel;

/**
 *  获取缓存的数据的大小
 *
 *  @return 数据大小的字符串形式
 */
- (NSString *)getCacheByte;

@end
