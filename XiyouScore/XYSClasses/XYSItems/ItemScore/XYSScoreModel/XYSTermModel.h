//
//  XYSTermModel.h
//  XiyouScore
//
//  Created by Tangtang on 16/7/21.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYSTermModel : NSObject

@property (nonatomic, copy)     NSString       *year;                                  //学年
@property (nonatomic, strong)   NSMutableArray *scoresTermOne;                         //存储该学年第一学期的成绩的数组
@property (nonatomic, strong)   NSMutableArray *scoresTermTwo;                         //存储该学年第二学期的成绩的数组

@end
