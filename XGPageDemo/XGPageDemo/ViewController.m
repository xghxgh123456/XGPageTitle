//
//  ViewController.m
//  XGPageDemo
//
//  Created by 雷振华 on 2018/11/16.
//  Copyright © 2018年 xgh. All rights reserved.
//

#import "ViewController.h"
#import "XGPageTitleView.h"
#import "XGPageView.h"
@interface ViewController ()<UIScrollViewDelegate,XGPageTitleViewDelegate,XGPageViewDelegate>
@property (strong, nonatomic) UIButton *currentButton;
@property (strong, nonatomic) UIScrollView *scrollBackView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) XGPageView *pageV;
@property (strong, nonatomic) XGPageTitleView *titleV;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    XGPageTitleView *titleView = [[XGPageTitleView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 50)];
   [self.view addSubview:titleView];
    [titleView titlePageViewResetConfig:^(XGPageTitleConfig * _Nonnull config) {
        config.titleBackColor = [UIColor redColor];
        config.titleNormalColor = [UIColor whiteColor];
        config.tileFont = [UIFont systemFontOfSize:25];
        config.minTitleMargin = 50;
    }];
    titleView.titles = @[@"电影",@"电视剧",@"综艺",@"漫画",@"笑话",@"短视频"];
    titleView.delegate = self;
    self.titleV = titleView;
    XGPageView *pageView = [[XGPageView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100)];
    NSMutableArray *views = @[].mutableCopy;
    for (int i = 0; i<6; i++) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor yellowColor];
        [views addObject:view];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 30)];
        label.text = [NSString stringWithFormat:@"当前页面%d",i];
        [view addSubview:label];
    }
    pageView.pageContents = views;
    [self.view addSubview:pageView];
//    pageView.selectView = 4;
    self.pageV = pageView;
    self.pageV.delegate = self;
    titleView.selectIndex = 4;
}
#pragma mark - 点击标题栏
-(void)titlePageView:(XGPageTitleView *)pageView select:(NSInteger)index{
    NSLog(@"点击了----%ld",index);
    self.pageV.selectView = index;
}
#pragma mark - 滑动视图
-(void)pageViewDidScroll:(XGPageView *)pageView selectIndex:(NSInteger)selectIndex{
    if (self.titleV.selectIndex == selectIndex) {
        return;
    }
    self.titleV.selectIndex = selectIndex;
}
- (void)buttonPressed:(UIButton *)sender{
    self.currentButton = sender;
    [self.scrollBackView setContentOffset:CGPointMake((sender.tag-100)*CGRectGetWidth(self.scrollBackView.frame), 0) animated:YES];
    [self titleDidClick:sender];
}
- (void)titleDidClick:(UIButton *)sender{
    // 获取当前标题按钮的中心 x 轴
    CGFloat btnCenterX = sender.center.x;
    CGPoint offset = self.scrollView.contentOffset;
    // 求将该选中的标题按钮滚动到中间的偏移量
    offset.x = btnCenterX - self.scrollView.frame.size.width * 0.5;
    // 左边超出处理
    if (offset.x < 0) offset.x = 0;
    // 右边超出处理
    CGFloat maxTitleOffsetX = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
    if (offset.x > maxTitleOffsetX ) offset.x = maxTitleOffsetX;
    [self.scrollView setContentOffset:offset animated:YES];
}

-(void)setCurrentButton:(UIButton *)currentButton{
    if (currentButton==_currentButton) {
        return;
    }
    currentButton.backgroundColor = [UIColor grayColor];
    _currentButton.backgroundColor = [UIColor clearColor];
    _currentButton = currentButton;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat currentIndex = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
    UIButton *button = [self.scrollView viewWithTag:100+currentIndex];
    self.currentButton = button;
    [self titleDidClick:button];
}

@end
