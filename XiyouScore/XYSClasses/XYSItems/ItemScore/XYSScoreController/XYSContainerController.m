//
//  XYSContainerController.m
//  XiyouScore
//
//  Created by Tangtang on 16/7/21.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "XYSContainerController.h"
#import "XYSQueryScoreController.h"
#import "XYSYearController.h"
#import "XYSTermModel.h"
#import "XYSScoreModel.h"

#define SVXButtonUnSelColor [UIColor grayColor]
#define SVXButtonSelColor   [UIColor colorWithRed:61 / 255.0 green:118 / 255.0 blue:203 / 255.0 alpha:1]
#define kButtonWidth        [UIScreen mainScreen].bounds.size.width / 3

static CGFloat const kSVXTitleH = 44;
static CGFloat const kMaxScale = 1.1;
static int const kLineWidth = 60;

@interface XYSContainerController ()<UIScrollViewDelegate, UIPopoverPresentationControllerDelegate> {
    UIView      *_preView;
    NSUInteger  _currentX;
}
//定义头部标题
@property (nonatomic, strong) UIScrollView  *titleScroller;
@property (nonatomic, strong) UIScrollView  *containScroller;

//当前选中的标题按钮
@property (nonatomic, strong) UIButton      *selectButton;

@property (nonatomic, strong) UIView        *bottomLine;

//添加的标题按钮集合
@property (nonatomic, strong) NSMutableArray <UIButton *> *titleButtons;

@property (nonatomic, strong) NSMutableDictionary         *lineWidthCache;

@property (nonatomic, strong) UIButton      *yearButton;
@property (nonatomic, strong) UIPopoverPresentationController   *popVC;
@property (nonatomic, copy)   NSMutableArray       *yearArray;
@property (nonatomic, copy)   NSMutableArray       *terms;

@end

@implementation XYSContainerController

- (NSMutableArray *)yearArray {
    if (_yearArray == nil) {
        _yearArray = [NSMutableArray array];
    }
    return _yearArray;
}

- (NSMutableArray *)terms {
    if (_terms == nil) {
        _terms = [NSMutableArray array];
    }
    return _terms;
}

- (NSMutableArray <UIButton *> *)titleButtons {
    if (_titleButtons == nil) {
        _titleButtons = [NSMutableArray array];
        
    }
    return _titleButtons;
}

- (NSMutableDictionary *)lineWidthCache {
    if (_lineWidthCache == nil) {
        _lineWidthCache = [NSMutableDictionary dictionary];
    }
    return _lineWidthCache;
}

- (UIView *)bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, kSVXTitleH - 2, kLineWidth, 2)];
        _bottomLine.backgroundColor = SVXButtonSelColor;
        
    }
    return _bottomLine;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeYearButton:) name:XYSCHANGEYEARNOTIFI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupModel:) name:XYS_SCORE_DATA object:nil];
    
    [self p_setupTitleScroller];
    [self p_setupContainScroller];
    [self p_setupChildViewController];
    [self p_setupTitle];
    
    [self p_setupNavigationItem];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillLayoutSubviews {
    //屏幕旋转修正containScroller的contentSize,修正到合适的大小
    self.containScroller.contentSize = CGSizeMake(self.view.frame.size.width * self.childViewControllers.count, 0);
    
    //同样是修正位置，将当前的contentOffset修正到合适的位置
    self.containScroller.contentOffset = CGPointMake(_currentX * self.view.frame.size.width, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupNavigation
- (void)p_setupNavigationItem {
    self.yearButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.yearButton.frame = CGRectMake(0, 0, 200, 44);
    [self.yearButton setTitle:@"选择学年" forState:UIControlStateNormal];
    [self.yearButton setTintColor:[UIColor whiteColor]];
    self.yearButton.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:17.f];
    
    [self.yearButton addTarget:self action:@selector(yearButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = self.yearButton;
}

#pragma mark - 设置头部标题栏
- (void)p_setupTitleScroller {
    self.titleScroller = [[UIScrollView alloc] init];
    self.titleScroller.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleScroller];
    
    [self.titleScroller addSubview:self.bottomLine];
    
    [self.titleScroller mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.offset(kSVXTitleH);
    }];
}

#pragma mark - 设置内容
- (void)p_setupContainScroller {
    
    self.containScroller = [[UIScrollView alloc] init];
    self.containScroller.backgroundColor = [UIColor whiteColor];
    self.containScroller.delegate = self;
    self.containScroller.pagingEnabled = YES;
    self.containScroller.showsHorizontalScrollIndicator = NO;
    self.containScroller.bounces = NO;
    [self.view addSubview:self.containScroller];
    
    [self.containScroller mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.top.equalTo(self.view.mas_top).offset(kSVXTitleH);
    }];
}

#pragma mark - 添加子控制器
- (void)p_setupChildViewController {
    XYSQueryScoreController *allScoreVC = [[XYSQueryScoreController alloc] init];
    allScoreVC.title = @"全部成绩";
    [self addChildViewController:allScoreVC];
    
    XYSQueryScoreController *passVC = [[XYSQueryScoreController alloc] init];
    passVC.title = @"已通过";
    [self addChildViewController:passVC];
    
    XYSQueryScoreController *noPassVC = [[XYSQueryScoreController alloc] init];
    noPassVC.title = @"未通过";
    [self addChildViewController:noPassVC];
    
    //添加4个占位View
    UIView *tempView = nil;
    for (int i = 0; i < self.childViewControllers.count; i++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [self.containScroller addSubview:view];
        
        if (i == 0) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self.containScroller);
                make.width.equalTo(self.view.mas_width);
                make.height.equalTo(self.containScroller.mas_height);
            }];
        } else if(i == 3){
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tempView.mas_right).offset(0);
                make.top.right.bottom.equalTo(self.containScroller);
                make.width.equalTo(self.view.mas_width);
                make.height.equalTo(self.containScroller.mas_height);
            }];
        } else {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tempView.mas_right).offset(0);
                make.top.bottom.equalTo(self.containScroller);
                make.width.equalTo(self.view.mas_width);
                make.height.equalTo(self.containScroller.mas_height);
            }];
        }
        tempView = view;
    }
    
}

#pragma mark - 添加标题
- (void)p_setupTitle {
    NSUInteger icount = self.childViewControllers.count;
    
    CGFloat currentX = 0;
    CGFloat width = kButtonWidth;
    CGFloat height = kSVXTitleH;
    
    for (int index = 0; index < icount; index++) {
        UIViewController *VC = self.childViewControllers[index];
        currentX = index * width;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(currentX, 0, width, height);
        button.tag = index;
        
        [button setTitle:VC.title forState:UIControlStateNormal];
        [button setTitleColor:SVXButtonUnSelColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.f];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleScroller addSubview:button];
        [self.titleButtons addObject:button];
        
        if (index == 0) {
            [self buttonAction:button];
        }
        
    }
    self.titleScroller.contentSize = CGSizeMake(icount * width, 0);
    self.titleScroller.showsHorizontalScrollIndicator = NO;
    
}

#pragma mark - 按钮点击事件
- (void)buttonAction:(UIButton *)sender {
    [self p_selectButton:sender];
    
    NSUInteger index = sender.tag;
    [self p_setupOneChildController:index];
    _currentX = index;
    
    self.containScroller.contentOffset = CGPointMake(index * self.view.frame.size.width, 0);
}

#pragma mark - 选中按钮进行的操作
- (void)p_selectButton:(UIButton *)button {
    [self.selectButton setTitleColor:SVXButtonUnSelColor forState:UIControlStateNormal];
    //将选中的button的transform重置
    self.selectButton.transform = CGAffineTransformIdentity;
    
    [button setTitleColor:SVXButtonSelColor forState:UIControlStateNormal];
    button.transform = CGAffineTransformMakeScale(kMaxScale, kMaxScale);
    
    NSString *lineSize = [self.lineWidthCache objectForKey:button.titleLabel.text];
    
    if (!lineSize) {
        UIFont *fontWithButton = [UIFont fontWithName:@"HelveticaNeue" size:17.0f];
        CGSize buttonTextSize = [button.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fontWithButton, NSFontAttributeName, nil]];
        
        lineSize = [NSString stringWithFormat:@"%f", buttonTextSize.width];
    }
    
    //添加按钮下面线的移动动画
    CGFloat x = button.center.x - [lineSize doubleValue] / 2.0;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bottomLine.frame = CGRectMake(x, self.bottomLine.frame.origin.y, [lineSize doubleValue], self.bottomLine.frame.size.height);
    } completion:nil];
    
    self.selectButton = button;
    [self p_setupButtonCenter:button];
}

#pragma mark - 将当前选中的按钮置于中心
- (void)p_setupButtonCenter:(UIButton *)button {
    CGFloat offSet = button.center.x - self.view.frame.size.width * 0.5;
    CGFloat maxOffSet = self.titleScroller.contentSize.width - self.view.frame.size.width;
    if (offSet > maxOffSet) {
        offSet = maxOffSet;
    }
    
    if (offSet < 0) {
        offSet = 0;
    }
    
    [self.titleScroller setContentOffset:CGPointMake(offSet, 0) animated:YES];
}

#pragma mark - 添加一个子视图方法
- (void)p_setupOneChildController:(NSUInteger)index {
    UIViewController *VC = self.childViewControllers[index];
    
    //判断是否已经加上
    if (VC.view.superview) {
        return;
    }
    
    [self.containScroller addSubview:VC.view];
    
    if (index == 0) {
        [VC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.containScroller);
            make.width.equalTo(self.view.mas_width);
            make.height.equalTo(self.containScroller.mas_height);
        }];
    } else if(index == 3){
        [VC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_preView.mas_right).offset(0);
            make.top.right.bottom.equalTo(self.containScroller);
            make.width.equalTo(self.view.mas_width);
            make.height.equalTo(self.containScroller.mas_height);
        }];
    } else {
        [VC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_preView.mas_right).offset(0);
            make.top.bottom.equalTo(self.containScroller);
            make.width.equalTo(self.view.mas_width);
            make.height.equalTo(self.containScroller.mas_height);
        }];
    }
    _preView = VC.view;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger i = self.containScroller.contentOffset.x / self.view.frame.size.width;
    [self p_selectButton:self.titleButtons[i]];
    [self p_setupOneChildController:i];
    _currentX = i;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    NSUInteger leftIndex = offset / self.view.frame.size.width;
    NSUInteger rightIndex = leftIndex + 1;
    
    UIButton *leftButton = self.titleButtons[leftIndex];
    UIButton *rightButton = nil;
    if (rightIndex < self.titleButtons.count) {
        rightButton = self.titleButtons[rightIndex];
    }
    
    CGFloat transScale = kMaxScale - 1;
    CGFloat rightScale = offset / self.view.frame.size.width - leftIndex;
    CGFloat leftScale = 1 - rightScale;
    
    leftButton.transform = CGAffineTransformMakeScale(leftScale * transScale + 1, leftScale * transScale + 1);
    rightButton.transform = CGAffineTransformMakeScale(rightScale * transScale + 1, rightScale * transScale + 1);
}

#pragma mark - yearButtonAction
- (void)yearButtonAction:(UIButton *)sender {
    XYSYearController *year = [[XYSYearController alloc] init];
    year.years = self.yearArray;
    year.preferredContentSize = CGSizeMake(120, self.yearArray.count * 44);
    year.modalPresentationStyle = UIModalPresentationPopover;
    
    self.popVC = year.popoverPresentationController;
    self.popVC.permittedArrowDirections = UIPopoverArrowDirectionUp;
    self.popVC.sourceView = self.view;
    self.popVC.backgroundColor = [UIColor whiteColor];
    self.popVC.delegate = self;
    self.popVC.sourceRect = CGRectMake(self.view.frame.size.width / 2.0, 0, 0, 0);
    
    [self presentViewController:year animated:YES completion:nil];
}

#pragma mark - yearButtonNSNotification
- (void)changeYearButton:(id)sender {
    [self.yearButton setTitle:[[sender userInfo] objectForKey:@"title"] forState:UIControlStateNormal];
    self.yearButton.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:17.f];
    
    for (XYSQueryScoreController *scoreVC in self.childViewControllers) {
        scoreVC.yearStr = [[sender userInfo] objectForKey:@"title"];
    }
    
}

#pragma mark - loginNSNotification
- (void)setupModel:(id)sender {
    //修正重新登录时标题的位置
    [self buttonAction:self.titleButtons[0]];
    //修正重新登录时选择学年的初始
    [self.yearButton setTitle:@"选择学年" forState:UIControlStateNormal];
    
    //解析数据
    NSDictionary *dic = [sender userInfo];
    NSDictionary *result = dic[@"result"];
    
    NSArray *score = result[@"score"];
    
    [self.yearArray removeAllObjects];
    for (NSDictionary *obj in score) {
        [self.yearArray addObject:[obj objectForKey:@"year"]];
        XYSTermModel *termModel = [[XYSTermModel alloc] init];
        termModel.year = obj[@"year"];
        NSArray *termArray = obj[@"Terms"];
        NSDictionary *termOne = termArray[0];
        NSDictionary *termTwo = termArray[1];
        termModel.scoresTermOne = [self getTermsScore:termOne];
        termModel.scoresTermTwo = [self getTermsScore:termTwo];
        [self.terms addObject:termModel];
    }
    
    for (XYSQueryScoreController *scoreVC in self.childViewControllers) {
        scoreVC.yearStr = @"";
        scoreVC.yearArray = self.terms;
    }
}

- (NSMutableArray *)getTermsScore:(NSDictionary *)dic {
    NSMutableArray *array = [NSMutableArray array];
    NSArray *scores = dic[@"Scores"];
    for (NSDictionary *scoreDic in scores) {
        XYSScoreModel *scoreModel = [[XYSScoreModel alloc] init];
        scoreModel.score = scoreDic[@"EndScore"];
        scoreModel.credit = scoreDic[@"Credit"];
        scoreModel.regularGrade = scoreDic[@"UsualScore"];
        scoreModel.volumeGrade = scoreDic[@"RealScore"];
        scoreModel.academy = scoreDic[@"School"];
        scoreModel.course = scoreDic[@"Title"];
        scoreModel.courseQuality = scoreDic[@"Type"];
        if ([scoreDic[@"ReScore"] isEqualToString:@""]) {
            scoreModel.makeupScore = @"0";
        } else {
            scoreModel.makeupScore = scoreDic[@"ReScore"];
        }
        scoreModel.exam = scoreDic[@"Exam"];
        [array addObject:scoreModel];
    }
    return array;
}


#pragma mark - UIPopoverPresentationControllerDelegate
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

@end
