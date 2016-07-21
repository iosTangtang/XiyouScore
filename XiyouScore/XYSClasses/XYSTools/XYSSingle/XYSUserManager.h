//
//  XYSUserManager.h
//  XiyouScore
//
//  Created by Tangtang on 16/7/21.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYSUserManager : NSObject<NSCopying>

@property (nonatomic, copy) NSString    *userID;
@property (nonatomic, copy) NSString    *password;
@property (nonatomic, copy) NSString    *session;


/**
 *  创建user单例的方法
 *
 *  @return 返回user单例
 */
+ (instancetype)shareInstance;

@end
