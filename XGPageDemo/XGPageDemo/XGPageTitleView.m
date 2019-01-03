//
//  XGPageTitleView.m
//  XGPageDemo
//
//  Created by 雷振华 on 2018/11/20.
//  Copyright © 2018年 xgh. All rights reserved.
//

#import "XGPageTitleView.h"

@interface XGPageTitleView()
/**配置*/
@property (strong, nonatomic) XGPageTitleConfig *config;
@property (strong, nonatomic) UIScrollView *titleScrollView;
/**当前选中的button*/
@property (strong, nonatomic) UIButton *currentButton;

@end

@implementation XGPageTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = self.config.titleBackColor;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titles = titles;
    }
    return self;
}

#pragma mark - add button
- (void)addButton{
    CGFloat width = self.config.minTitleMargin;
    for (int i = 0; i<self.titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = self.titles[i];
        CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, CGRectGetHeight(self.frame)) options:0 attributes:@{NSFontAttributeName:self.config.tileFont} context:nil].size;
        [button setTitle:title forState:0];
        button.frame = CGRectMake(width, 0, size.width, CGRectGetHeight(self.frame));
        width += size.width+self.config.minTitleMargin;
        button.titleLabel.font = self.config.tileFont;
        [button setTitleColor:self.config.titleNormalColor forState:UIControlStateNormal];
        [button setTitleColor:self.config.titleSelectColor forState:UIControlStateSelected];
        [self.titleScrollView addSubview:button];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+i;
        if (i==self.selectIndex) {
            self.currentButton = button;
        }
    }
    self.titleScrollView.contentSize = CGSizeMake(width, 0);
}
#pragma mark - button pressed
- (void)buttonPressed:(UIButton *)sender{
    self.currentButton = sender;
    [self titleDidClick:sender];
    if ([self.delegate respondsToSelector:@selector(titlePageView:select:)]) {
        [self.delegate titlePageView:self select:sender.tag-100];
    }
}
#pragma mark - scrollView contentOffset
- (void)titleDidClick:(UIButton *)sender{
    //没有偏移量
    if (self.titleScrollView.contentSize.width<=self.frame.size.width) {
        return;
    }
    // 获取当前标题按钮的中心 x 轴
    CGFloat btnCenterX = sender.center.x;
    CGPoint offset = self.titleScrollView.contentOffset;
    // 求将该选中的标题按钮滚动到中间的偏移量
    offset.x = btnCenterX - self.titleScrollView.frame.size.width * 0.5;
    // 左边超出处理
    if (offset.x < 0) offset.x = 0;
    // 右边超出处理
    CGFloat maxTitleOffsetX = self.titleScrollView.contentSize.width - self.titleScrollView.frame.size.width;
    if (offset.x > maxTitleOffsetX ) offset.x = maxTitleOffsetX;
    [self.titleScrollView setContentOffset:offset animated:YES];
}
#pragma mark - set config
- (void)titlePageViewResetConfig:(void(^)(XGPageTitleConfig *_Nonnull config))configBlock{
    if (configBlock) {
        configBlock(self.config);
    }
    //重置
    self.backgroundColor = self.config.titleBackColor;
    CGFloat width = self.config.minTitleMargin;
    for (UIView *view in self.titleScrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            button.titleLabel.font = self.config.tileFont;
            [button setTitleColor:self.config.titleNormalColor forState:UIControlStateNormal];
            [button setTitleColor:self.config.titleSelectColor forState:UIControlStateSelected];
            NSString *title = button.titleLabel.text;
            CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, CGRectGetHeight(self.frame)) options:0 attributes:@{NSFontAttributeName:self.config.tileFont} context:nil].size;
            [button setTitle:title forState:0];
            
            button.frame = CGRectMake(width, 0, size.width, CGRectGetHeight(self.frame));
            width += size.width+self.config.minTitleMargin;
        }
    }
    self.titleScrollView.contentSize = CGSizeMake(width, 0);
}
#pragma mark - setter and getter
-(void)setTitles:(NSArray *)titles{
    _titles = titles;
    [self.titleScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self addButton];
}
-(void)setCurrentButton:(UIButton *)currentButton{
    if (currentButton==_currentButton) {
        return;
    }
    currentButton.selected = YES;
    _currentButton.selected = NO;
    _currentButton = currentButton;
}

-(UIScrollView *)titleScrollView{
    if (!_titleScrollView) {
        _titleScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _titleScrollView.pagingEnabled = YES;
        _titleScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_titleScrollView];
    }
    return _titleScrollView;
}

-(XGPageTitleConfig *)config{
    if (!_config) {
        _config = [XGPageTitleConfig defaultConfig];
    }
    return _config;
}
-(void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
    [self buttonPressed:(UIButton *)[self.titleScrollView viewWithTag:100+selectIndex]];
}
@end
