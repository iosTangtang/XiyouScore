//
//  XYSTermModel.m
//  XiyouScore
//
//  Created by Tangtang on 16/7/21.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYSTermModel.h"

@implementation XYSTermModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _scoresTermOne = [NSMutableArray array];
        _scoresTermTwo = [NSMutableArray array];
    }
    return self;
}

@end
