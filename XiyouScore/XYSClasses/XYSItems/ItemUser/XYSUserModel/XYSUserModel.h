//
//  XYSUserModel.h
//  XiyouScore
//
//  Created by Tangtang on 16/7/21.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYSUserModel : NSObject

@property (nonatomic, copy) NSString    *name;                                  //名字
@property (nonatomic, copy) NSString    *studentID;                             //学号
@property (nonatomic, copy) NSString    *headImageUrl;                          //头像图片的url
@property (nonatomic, copy) NSString    *academy;                               //所属学院

@end
