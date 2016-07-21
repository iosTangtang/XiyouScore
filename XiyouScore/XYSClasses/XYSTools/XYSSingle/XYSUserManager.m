//
//  XYSUserManager.m
//  XiyouScore
//
//  Created by Tangtang on 16/7/21.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYSUserManager.h"

static XYSUserManager *userManager = nil;

@implementation XYSUserManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userManager = [[super allocWithZone:NULL] init];
    });
    return userManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self shareInstance];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return self;
}

@end
