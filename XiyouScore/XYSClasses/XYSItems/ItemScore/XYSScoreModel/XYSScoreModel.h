//
//  XYSScoreModel.h
//  XiyouScore
//
//  Created by Tangtang on 16/7/21.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYSScoreModel : NSObject

@property (nonatomic, copy) NSString    *term;                                      //学期
@property (nonatomic, copy) NSString    *score;                                     //总分
@property (nonatomic, copy) NSString    *credit;                                    //课程学分
@property (nonatomic, copy) NSString    *regularGrade;                              //平时成绩
@property (nonatomic, copy) NSString    *volumeGrade;                               //卷面成绩
@property (nonatomic, copy) NSString    *academy;                                   //开课学院
@property (nonatomic, copy) NSString    *course;                                    //课程名称
@property (nonatomic, copy) NSString    *courseQuality;                             //课程性质(必修/选修)
@property (nonatomic, copy) NSString    *rank;                                      //排名

@end
