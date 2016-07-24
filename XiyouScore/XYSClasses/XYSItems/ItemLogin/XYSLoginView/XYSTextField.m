//
//  XYSTextField.m
//  XiyouScore
//
//  Created by Tangtang on 16/7/24.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYSTextField.h"

@implementation XYSTextField

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5));
}

@end
