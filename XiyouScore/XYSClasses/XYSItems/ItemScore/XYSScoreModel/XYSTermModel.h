//
//  XYSTermModel.h
//  XiyouScore
//
//  Created by Tangtang on 16/7/21.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XYSScoreModel;
@interface XYSTermModel : NSObject

@property (nonatomic, copy)     NSString                        *year;                                  //学年
@property (nonatomic, strong)   NSMutableArray<XYSScoreModel *> *scores;                                //存储该学年的成绩的数组

@end
