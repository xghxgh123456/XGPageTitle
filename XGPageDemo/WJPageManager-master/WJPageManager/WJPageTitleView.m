//
//  WJPageTitleView.m
//  WJPageManager
//
//  Created by 陈威杰 on 2017/3/3.
//  Copyright © 2017年 ChenWeiJie. All rights reserved.
//

#import "WJPageTitleView.h"
#import "WJTitleButton.h"
#import "UIView+WJExtension.h"
#import "WJConst.h"

/** 标题最小间距 */
//#define kMinMargin 30

@interface WJPageTitleView ()<UIScrollViewDelegate>
{
    /** 标题默认间距 */
    CGFloat _defaultMinTitleMargin;
}

/**
 *  用于保存标题指示器
 */
@property(nonatomic, weak) UIView *scrollLine;

/**
 *  用于保存当前选中的标题按钮
 */
@property(nonatomic, weak) WJTitleButton *LastSelectBtn;

/** 保存标题按钮 */
@property(nonatomic, strong) NSMutableArray <WJTitleButton *>*titleButtons;

/**
 *  scrollView
 */
@property(nonatomic, weak) UIScrollView *scrollView;
/**
 *  标题栏的底线
 */
@property(nonatomic, weak) UIView *viewDownLine;

/**
 *  统一配置
 */
@property (nonatomic, strong) WJPageTitleViewConfig *config;


@end





@implementation WJPageTitleView


#pragma mark - 懒加载

- (NSMutableArray *)titleButtons {
    if (!_titleButtons) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (UIView *)viewDownLine{
    if (!_viewDownLine) {
        UIView *viewDownLine = [[UIView alloc] init];
        viewDownLine.backgroundColor = self.config.titleBarDownLineBgColor;
        viewDownLine.alpha = self.config.titleBarDownLineAlpha;
        [self addSubview:viewDownLine];
        _viewDownLine = viewDownLine;
    }
    return _viewDownLine;
}

- (UIView *)scrollLine{
    if (!_scrollLine) {
        UIView *scrollLine = [[UIView alloc] init];
       // WJTitleButton *firstTitleBtn = self.titleButtons.firstObject;
        scrollLine.layer.cornerRadius = 5;
        // scrollLine.backgroundColor = [firstTitleBtn titleColorForState:UIControlStateSelected];
        scrollLine.backgroundColor = [UIColor orangeColor];
        // 将指示器添加到 scrollView 中，让指示器可以跟着scrollView 的滚动而滚动
        [self.scrollView addSubview:scrollLine];
        _scrollLine = scrollLine;

    }
    return _scrollLine;
}

- (WJPageTitleViewConfig *)config{
    if (!_config) {
        _config = [WJPageTitleViewConfig defaultConfig];
    }
    return _config;
}

#pragma mark - 快速创建初始化的方法


- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles {
    self = [super initWithFrame:frame];
    if (self) {
        // 保存外界传递进来的参数
        self.titles = titles;
        

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = self.config.titleBarBgColor;
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray *)titles {
    if(self = [super init]){
        // 保存外界传递进来的参数
        self.titles = titles;
    }
    return self;

}

+ (instancetype)pageTitleViewWithTitles:(NSArray *)titles{
    return [[self alloc] initWithTitles:titles];
    
}

+ (instancetype)pageTitleViewWithFrame:(CGRect)frame titles:(NSArray *)titles{
    return [[self alloc] initWithFrame:frame titles:titles];
}



#pragma mark - 统一刷新设置标题栏方法
- (void)titleBarWithConfiguration: (void(^)(WJPageTitleViewConfig *config))configBlock{
    
    if (configBlock) {
        configBlock(self.config);
    }
    
    // 按照当前的 self.config 进行刷新
    self.backgroundColor = self.config.titleBarBgColor;
    //self.scrollLine.backgroundColor = [self.titleButtons.firstObject titleColorForState:UIControlStateSelected];
    self.scrollLine.backgroundColor = self.config.titleIndicatorColor;

    
    self.viewDownLine.backgroundColor = self.config.titleBarDownLineBgColor;
    self.viewDownLine.alpha = self.config.titleBarDownLineAlpha;
    if (self.config.minTitleMargin <= 0) {
        _defaultMinTitleMargin = 0;
    } else {
        _defaultMinTitleMargin = self.config.minTitleMargin;
    }
    

    
    for (WJTitleButton *btn in self.titleButtons) {
        [btn setTitleColor:self.config.titleNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.config.titleSelectColor forState:UIControlStateSelected];
        btn.titleLabel.font = self.config.tileFont;
    }

    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    // 解决第一个默认选中的标题在放大之后才进行布局导致的往下偏的问题
    if (self.config.titleSelectScale) {
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.titleButtons.firstObject.transform = CGAffineTransformMakeScale(weakSelf.config.titleSelectScale + 1.0, weakSelf.config.titleSelectScale + 1.0);
            }];
            
        });
    }
    
    
}




#pragma mark - 布局子控件
- (void)layoutSubviews {
    
    // 布局内容承载视图 scrollView
    _scrollView.frame = self.bounds;
    
    
    
    // 布局标题
    // 计算margin
    CGFloat totalBtnWidth = 0;
    for (WJTitleButton *btn in self.titleButtons) {
        [btn sizeToFit];
        totalBtnWidth += btn.width;
    }
    
    // 求标题间距
    _defaultMinTitleMargin =  _defaultMinTitleMargin ? _defaultMinTitleMargin : self.config.minTitleMargin;
    CGFloat caculateMargin = (self.width - totalBtnWidth) / (self.titles.count + 1);
    if (caculateMargin < _defaultMinTitleMargin) {
        caculateMargin = _defaultMinTitleMargin;
    }

    
    CGFloat lastX = caculateMargin;
    for (WJTitleButton *btn in self.titleButtons) {
        // w, h
        [btn sizeToFit];
        btn.height = self.height;
        // x, y,
        btn.y = 0;
        btn.x = lastX;
        lastX += btn.width + caculateMargin;
        
    }
    
    
    // 设置标题承载视图scrollView的滚动范围
    _scrollView.contentSize = CGSizeMake(lastX, 0);
    
    // 设置标题的指示器的位置和尺寸
    if (self.titleButtons.count == 0) {
        return;
    }
    UIButton *btn = self.titleButtons[self.selectIndex];
    self.scrollLine.width = btn.width;
    _scrollLine.centerX = btn.centerX;
    _scrollLine.height = self.config.titleIndicatorHeight;
    _scrollLine.y = _scrollView.height - _scrollLine.height;
    
    
    
    // 布局标题栏的底线
    CGRect rect = CGRectMake(0, self.height - self.config.titleBarDownLineHeight, self.width, self.config.titleBarDownLineHeight);
    // 创建并设置底线的 frame
    self.viewDownLine.frame = rect;
    
}





#pragma mark - 标题按钮点击
- (void)titleButtonClick:(WJTitleButton *)selectTitleBtn {
    
    // 标题重复点击发出通知
    if (selectTitleBtn.tag == self.LastSelectBtn.tag) {
        // NSLog(@"重复点击标题");
        
        // 发通知
        [[NSNotificationCenter defaultCenter] postNotificationName:WJPageTitleButtonDidRepeatClickNotification object:nil];
        
        return;
    }
    
    _selectIndex = selectTitleBtn.tag;
    
    // 取消之前的按钮形变
    [self transformReduction:self.LastSelectBtn];
    
    
    // 1. 标题按钮点击逻辑处理
    [self titleButtonStatus:selectTitleBtn];
    

    
    // 2. 滚动指示器到当前选中的标题按钮下
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollLine.width = selectTitleBtn.width;
        self.scrollLine.centerX = selectTitleBtn.centerX;
        if(self.config.titleSelectScale){
            selectTitleBtn.transform = CGAffineTransformMakeScale(self.config.titleSelectScale + 1.0, self.config.titleSelectScale + 1.0);
        }
    }];
    

    
    // 3. 通过代理滚动到对应的 pageContentView
    if ([self.delegate respondsToSelector:@selector(pageTitleView:didSelectTitleIndex:)]) {
        [self.delegate pageTitleView:self didSelectTitleIndex:self.LastSelectBtn.tag];
    }
    
    
    // 让标题判断并滚动到中间
    [self scrollTitleWithIndex:selectTitleBtn.tag];
    
    

    
    
    
}

/** 标题按钮选中状态判断处理 */
- (void)titleButtonStatus:(WJTitleButton *)btn {
    
    // 取消之前选中的标题按钮
    self.LastSelectBtn.selected = NO;
    // 设置当前点击的按钮为选中状态
    btn.selected = YES;
    // 记录点前点击的标题按钮为选中按钮
    self.LastSelectBtn = btn;
}



/**
 取消按钮形变
 */
- (void)transformReduction:(WJTitleButton *)btn{
    [UIView animateWithDuration:0.25 animations:^{
        btn.transform = CGAffineTransformIdentity;
    }];
    
}



#pragma mark - 接口
- (void)setTitleStatusChangeWithProgress:(CGFloat)progress fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    
    if (toIndex > self.titleButtons.count - 1) return;
    if (fromIndex < 0) return;
    
    // 1.取出源和目标按钮
    WJTitleButton *sourceTitleBtn = self.titleButtons[fromIndex];
    WJTitleButton *targetTitleBtn = self.titleButtons[toIndex];
    
    // 2.根据进度改变滑块的位置和宽度
    CGFloat moveTotalX = targetTitleBtn.frame.origin.x - sourceTitleBtn.frame.origin.x;
    CGFloat moveX = moveTotalX * progress;
    self.scrollLine.x = sourceTitleBtn.x + moveX;
    self.scrollLine.width = sourceTitleBtn.width + (targetTitleBtn.width - sourceTitleBtn.width) * progress;

    
    
    
    // 按钮放大的形变
    if (self.config.titleSelectScale) {
        targetTitleBtn.transform = CGAffineTransformMakeScale(progress * self.config.titleSelectScale + 1.0, progress * self.config.titleSelectScale + 1.0);
        sourceTitleBtn.transform = CGAffineTransformMakeScale((1 - progress) * self.config.titleSelectScale + 1.0, (1 - progress) * self.config.titleSelectScale + 1.0);
    }
    

    
    // 3. 处理外界界面左滑右滑标题按钮的选中以及指示器的状态
    if (1.0 != progress) return;
    
    if (fromIndex < toIndex) {
        
        [self titleButtonStatus:targetTitleBtn];
        // 让标题判断并滚动到中间
        [self scrollTitleWithIndex:toIndex];
    } else {
        
        // 右滑
        [self titleButtonStatus:targetTitleBtn];
        // 让标题判断并滚动到中间
        [self scrollTitleWithIndex:toIndex];
        
    }

  
}




- (void)setSelectIndex:(NSInteger)selectIndex {
    // 数据过滤
    if (self.titleButtons.count == 0 || selectIndex < 0 || selectIndex > self.titleButtons.count - 1) {
        return;
    }

    _selectIndex = selectIndex;
    
    WJTitleButton *btn = self.titleButtons[selectIndex];
    [self titleButtonStatus:btn];
    [self titleButtonClick:btn];
    

    
}


- (void)setTitles:(NSArray<NSString *> *)titles {
    _titles = titles;

    // 删除之前添加的标题
    [self.titleButtons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.titleButtons = nil;
    
    
    // 添加标题
    for (NSInteger i = 0; i < titles.count; i++) {
        WJTitleButton *btn = [[WJTitleButton alloc] init];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:self.config.titleNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.config.titleSelectColor forState:UIControlStateSelected];
        btn.titleLabel.font = self.config.tileFont;
        // 绑定 tag
        btn.tag = i;
        
        // 添加监听方法
        [btn addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 将标题按钮保存到一个数组中
        [self.titleButtons addObject:btn];
        [self.scrollView addSubview:btn];
        
    }
    
    // 取出第一个标题按钮
    WJTitleButton *firstTitleBtn = self.titleButtons.firstObject;
    
    // 4. 默认选中第一个标题按钮
    firstTitleBtn.selected = YES;
    
    _selectIndex = firstTitleBtn.tag;
    
    // 5. 保存当前默认选中的第一个按钮为当前选中按钮
    self.LastSelectBtn = firstTitleBtn;
    
    // 设置指示器的颜色
   // _scrollLine.backgroundColor = [firstTitleBtn titleColorForState:UIControlStateSelected];
    

    
    // 手动刷新布局
    [self layoutIfNeeded];
    [self setNeedsLayout];

    // 解决第一个默认选中的标题在放大之后才进行布局导致的往下偏的问题
    if (self.config.titleSelectScale) {
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                firstTitleBtn.transform = CGAffineTransformMakeScale(weakSelf.config.titleSelectScale + 1.0, weakSelf.config.titleSelectScale + 1.0);
            }];
        });
    }
    
    
}


#pragma mark - 让当前选中的标题滚动显示在中间
/**
 让当前选中的标题滚动显示在中间

 @param index 选中按钮的索引
 */
- (void)scrollTitleWithIndex:(NSInteger)index{
    
    // 获取当前选中的标题按钮
    WJTitleButton *btn = self.titleButtons[index];
    // 获取当前标题按钮的中心 x 轴
    CGFloat btnCenterX = btn.centerX;
    CGPoint offset = self.scrollView.contentOffset;
    // 求将该选中的标题按钮滚动到中间的偏移量
    offset.x = btnCenterX - self.scrollView.width * 0.5;
    // 左边超出处理
    if (offset.x < 0) offset.x = 0;
    // 右边超出处理
    CGFloat maxTitleOffsetX = self.scrollView.contentSize.width - self.scrollView.width;
    if (offset.x > maxTitleOffsetX ) offset.x = maxTitleOffsetX;
    
    [self.scrollView setContentOffset:offset animated:YES];

    
}

@end
