//
//  XYSCETModel.h
//  XiyouScore
//
//  Created by Tangtang on 16/7/21.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYSCETModel : NSObject

@property (nonatomic, copy) NSString    *testType;                          //考试类型
@property (nonatomic, copy) NSString    *listening;                         //听力成绩
@property (nonatomic, copy) NSString    *read;                              //阅读成绩
@property (nonatomic, copy) NSString    *write;                             //写作成绩
@property (nonatomic, copy) NSString    *score;                             //总成绩
@property (nonatomic, copy) NSString    *school;                            //所属学校
@property (nonatomic, copy) NSString    *name;                              //考试人名字

@end
