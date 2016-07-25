//
//  XYSQueryScoreCell.h
//  XiyouScore
//
//  Created by Tangtang on 16/7/21.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYSQueryScoreCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *courseName;
@property (weak, nonatomic) IBOutlet UILabel *courseType;
@property (weak, nonatomic) IBOutlet UILabel *academy;
@property (weak, nonatomic) IBOutlet UILabel *jmScore;
@property (weak, nonatomic) IBOutlet UILabel *psScore;
@property (weak, nonatomic) IBOutlet UILabel *sumScore;
@property (weak, nonatomic) IBOutlet UILabel *makeupScore;
@property (weak, nonatomic) IBOutlet UILabel *credit;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
