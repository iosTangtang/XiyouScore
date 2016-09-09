//
//  XYSHTTPRequestSession.m
//  XiyouScore
//
//  Created by Tangtang on 16/7/21.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYSHTTPRequestSession.h"
#import "XYSHTTPRequestManager.h"
#define BaseUrl [NSURL URLWithString:@""]

@implementation XYSHTTPRequestSession

#pragma mark - 懒加载 初始化AFHTTPSessionManager
- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:BaseUrl];
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain" ,@"application/json", @"text/json", @"text/javascript",@"text/html",@"image/png",@"image/jpeg",@"application/rtf",@"image/gif",@"application/zip",@"audio/x-wav",@"image/tiff",@" 	application/x-shockwave-flash",@"application/vnd.ms-powerpoint",@"video/mpeg",@"video/quicktime",@"application/x-javascript",@"application/x-gzip",@"application/x-gtar",@"application/msword",@"text/css",@"video/x-msvideo",@"text/xml", nil];
        
        switch ([XYSHTTPRequestManager createInstance].requestType) {
            case XYSRequestSerializerTypeDefault:
                _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
                break;
            case XYSRequestSerializerTypeJson:
                _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
                break;
            default:
                _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
                break;
        }
        
        switch ([XYSHTTPRequestManager createInstance].responseType) {
            case XYSResponseSerializerTypeDefault:
                _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
                break;
            case XYSResponseSerializerTypeJson:
                _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
                break;
            default:
                _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
                break;
        }
        if ([XYSHTTPRequestManager createInstance].timeoutInterval != 0) {
            _sessionManager.requestSerializer.timeoutInterval = [XYSHTTPRequestManager createInstance].timeoutInterval;
        } else {
            _sessionManager.requestSerializer.timeoutInterval = 30.f;
        }
    }
    return _sessionManager;
}

#pragma mark - 请求方法的实现
- (void)getData:(NSString *)urlStr
     WithParams:(id)params
        success:(XYSSucceedBlock)success
          error:(XYSErrorBlock)errorBlock {
    [self.sessionManager GET:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if (error) {
            errorBlock(error);
        }
    }];
}

- (void)postData:(NSString *)urlStr
      WithParams:(id)params
         success:(XYSSucceedBlock)success
           error:(XYSErrorBlock)errorBlock {
    [self.sessionManager POST:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if (errorBlock) {
            errorBlock(error);
        }
    }];
}

- (void)uploadFile:(NSString *)urlStr
        WithParams:(id)params
          fileData:(NSData *)data
              name:(NSString *)name
          fileName:(NSString *)fileName
          progress:(NSProgress **)kProgress
           success:(XYSSucceedBlock)success
             error:(XYSErrorBlock)errorBlock {
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:@"application/octet-stream"];
    } error:nil];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [self.sessionManager uploadTaskWithStreamedRequest:request progress:kProgress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            if (success) {
                success(responseObject);
            }
        } else {
            if (errorBlock) {
                errorBlock(error);
            }
        }
    }];
    
    [uploadTask resume];

}

- (void)downLoadFile:(NSString *)urlStr
          WithParams:(id)params
        fileDownPath:(NSString *)fileDownPath
            progress:(NSProgress **)kProgress
             success:(XYSSucceedBlock)success
               error:(XYSErrorBlock)errorBlock {
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [self.sessionManager downloadTaskWithRequest:request
                                                                                 progress:kProgress
                                                                              destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documUrl = [NSURL fileURLWithPath:fileDownPath];
        return documUrl;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (!error) {
            if (success) {
                success(filePath);
            }
        } else {
            if (errorBlock) {
                errorBlock(error);
            }
        }
    }];
    
    [downloadTask resume];
   
}

- (void)cancel {
    [self.sessionManager.operationQueue cancelAllOperations];
}

@end
