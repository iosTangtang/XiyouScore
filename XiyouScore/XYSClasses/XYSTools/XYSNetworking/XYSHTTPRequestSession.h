//
//  XYSHTTPRequestSession.h
//  XiyouScore
//
//  Created by Tangtang on 16/7/21.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^XYSSucceedBlock)(id dic);
typedef void(^XYSErrorBlock)(NSError *error);
typedef void(^XYSProgress)(double count);

@interface XYSHTTPRequestSession : NSObject

@property (nonatomic, strong)AFHTTPSessionManager *sessionManager;

/**
 *  GET请求方法
 *
 *  @param urlStr  请求接口
 *  @param params  请求参数
 *  @param success 请求成功回调的block
 *  @param error   请求失败回调的block
 */
- (void)getData:(NSString *)urlStr
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
- (void)postData:(NSString *)urlStr
      WithParams:(id)params
         success:(XYSSucceedBlock)success
           error:(XYSErrorBlock)errorBlock;

/**
 *  上传文件方法
 *
 *  @param urlStr     请求接口
 *  @param params     请求参数
 *  @param data       要上传的文件数据
 *  @param name       文件名称(不加后缀)
 *  @param fileName   文件全名(加后缀)
 *  @param kProgress  获取下载进度的类
 *  @param success    请求成功回调的block
 *  @param errorBlock 请求失败回调的block
 */
- (void)uploadFile:(NSString *)urlStr
        WithParams:(id)params
          fileData:(NSData *)data
              name:(NSString *)name
          fileName:(NSString *)fileName
          progress:(NSProgress **)kProgress
           success:(XYSSucceedBlock)success
             error:(XYSErrorBlock)errorBlock
 fractionCompleted:(XYSProgress)progress;

/**
 *  下载文件方法
 *
 *  @param urlStr       请求接口
 *  @param params       请求参数
 *  @param fileDownPath 要保存的地址
 *  @param kProgress    获取下载进度的类
 *  @param success      请求成功回调的block
 *  @param errorBlock   请求失败回调的block
 */
- (void)downLoadFile:(NSString *)urlStr
          WithParams:(id)params
        fileDownPath:(NSString *)fileDownPath
            progress:(NSProgress **)kProgress
             success:(XYSSucceedBlock)success
               error:(XYSErrorBlock)errorBlock
   fractionCompleted:(XYSProgress)progress;

/**
 *  取消请求的方法
 */
- (void)cancel;

@end
