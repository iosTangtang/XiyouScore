//
//  XYSRecommendCell.h
//  XiyouScore
//
//  Created by Tangtang on 16/7/21.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XYSButtonActionDelegate <NSObject>

- (void)recomButtonAction:(UIButton *)sender;

@end

@interface XYSRecommendCell : UITableViewCell

@property (weak, nonatomic) id<XYSButtonActionDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moreLabel;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UIView *backView;


@end
