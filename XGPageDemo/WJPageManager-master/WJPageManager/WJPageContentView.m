//
//  WJPageContentView.m
//  WJPageManager
//
//  Created by 陈威杰 on 2017/3/4.
//  Copyright © 2017年 ChenWeiJie. All rights reserved.
//

#import "WJPageContentView.h"
#import "UIView+WJExtension.h"

// 随机颜色
#define WJRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0]


/** 当前这个 view 的宽度 */
#define kPageContentViewW self.bounds.size.width
/** 当前这个 view 的高度 */
#define kPageContentViewH self.bounds.size.height

@interface WJPageContentView ()<UIScrollViewDelegate>

/** 保存外界传递进来的父控制器 */
@property(nonatomic, weak) UIViewController *parentVc;
/** 保存外界传递进来的子控制器 */
@property(nonatomic, strong) NSArray<UIViewController *> *childVcs;
/** scrollView */
@property(nonatomic, weak) UIScrollView *scrollView;
/** 保存当前 scrollView 的 X 轴偏移量 */
@property(nonatomic, assign) CGFloat startOffsetX;
/** 保存当前选中的标题按钮索引 */
@property(nonatomic, assign) NSInteger selectTitleIndex;
/** 是否是点击了标题按钮 */
@property(nonatomic, assign, getter=isTitleButtonClick) BOOL titleButtonClick;

@end

@implementation WJPageContentView

#pragma mark - 懒加载
- (NSArray *)childVcs {
    if (_childVcs == nil) {
        _childVcs = [NSArray array];
    }
    return _childVcs;
}


#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame parentVc:(UIViewController *)parentVc childVcs:(NSArray<UIViewController *> *)childVcs{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        // 保存父子控制器
        self.parentVc = parentVc;
        self.childVcs = childVcs;
        
        // 设置 UI 界面
        [self setupUI];
    }
    return self;
    
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}




+ (instancetype)pageContentViewWithFrame:(CGRect)frame parentVc:(UIViewController *)parentVc childVcs:(NSArray<UIViewController *> *)childVcs{
    
    return [[self alloc] initWithFrame:frame parentVc:parentVc childVcs:childVcs];
}


- (void)setUpParentVc:(UIViewController *)parentVc childVcs:(NSArray<UIViewController *> *)childVcs{
    self.parentVc = parentVc;
    self.childVcs = childVcs;
    
    [self setupUI];
}


#pragma mark - 设置 UI 界面
- (void)setupUI {
    
    // 1. 将子控制器添加到父控制器中
    for (UIViewController *childVc in self.childVcs) {
        [self.parentVc addChildViewController:childVc];
    }
    
    // 2. 给当前的这个 View 添加一个 scrollView
    [self addScrollView];
    
    // 3. 将子控制器的 view 添加到 scrollView 上, 并布局子控制器的 view
    [self addChildVcsViewToScrollView];
    
    
    
}

#pragma mark - 添加 scrollView
- (void)addScrollView {
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView = scrollView;
    [self addSubview:scrollView];
}


#pragma mark - 布局子控件
- (void)layoutSubviews{
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(self.childVcs.count * kPageContentViewW, kPageContentViewH);
}

#pragma mark - 将子控制器的view添加到scrollView上并布局（懒加载控制器的 View）
/** 
 * 将子控制器的view添加到scrollView上并布局
 */
- (void)addChildVcsViewToScrollView {
    
    
    // 根据索引获取对应的控制器
    UIViewController *childVc = self.childVcs[self.selectTitleIndex];
    // NSLog(@"%zd", self.selectTitleIndex);
    
    if ([childVc isViewLoaded]) return;
    
    // 布局当前控制器的 View 到对应的位置
    childVc.view.x = self.selectTitleIndex * self.scrollView.width;
    childVc.view.y = self.scrollView.y;
    childVc.view.width = self.scrollView.width;
    childVc.view.height = self.scrollView.height;
    childVc.view.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:childVc.view];
    

    
}



#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    // 将是否点击标题设置为 NO，取消对拖拽页面产生的影响
    self.titleButtonClick = NO;
    
    // 保存当前 scrollView 的 X 轴偏移量
    self.startOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // 如果是点击标题的话就 return
    if (self.titleButtonClick == YES) return;
    
    // 1.定义获取需要的数据
    CGFloat progress = 0;
    NSInteger sourceIndex = 0;
    NSInteger targetIndex = 0;
    
    // 2.判断是左滑还是右滑
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    
    if (currentOffsetX > self.startOffsetX) { // 左滑
        // 1.计算progress
        progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW);
        
        // 2.计算sourceIndex
        sourceIndex = (NSInteger)currentOffsetX / scrollViewW;
        
        // 3.计算targetIndex
        targetIndex = sourceIndex + 1;
        if (targetIndex >= self.childVcs.count) {
            targetIndex = self.childVcs.count - 1;
        }
    
        // 4.如果完全划过去
        if (currentOffsetX - self.startOffsetX == scrollViewW) {
            progress = 1;
            targetIndex = sourceIndex;
            sourceIndex -= 1;
        } else if (progress == 0) {  // 快速左滑产生的 BUG
            progress = 1;
            targetIndex = sourceIndex;
            sourceIndex -= 1;
        }
        
        
    } else { // 右滑
        // 1.计算progress
        progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
        
        // 2.计算targetIndex
        targetIndex = (NSInteger)currentOffsetX / scrollViewW;
    
        // 3.计算sourceIndex
        sourceIndex = targetIndex + 1;
        if (sourceIndex >= self.childVcs.count) {
            sourceIndex = self.childVcs.count - 1;
        }
        

        
    }
    
    // 告诉代理，并将当前滚动的页面相关参数传出去
    if ([self.delegate respondsToSelector:@selector(pageContentView:progress:sourceIndex:targetIndex:)]) {
        [self.delegate pageContentView:self progress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
    }
    
    
}


/**
 *  在 scrollView 滚动动画结束时，就会调用该方法
 *  前提：使用 setContentOffset:animated: 或者 scrollRectVisible:animated: 方法让 scrollView 产生滚动动画
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    // 懒加载 子控制器的 view
    [self addChildVcsViewToScrollView];
    
}


/**
 *  在 scrollView 滚动动画结束时，就会调用该方法
 *  前提：认为拖拽 scrollView 产生的滚动动画
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 获取当前页面的 索引（第几个页面）
    NSInteger currentPageIndex = self.scrollView.contentOffset.x / self.scrollView.width;
    self.selectTitleIndex = currentPageIndex;
    
    // 懒加载 子控制器的 view
    [self addChildVcsViewToScrollView];
    
    
}




#pragma mark - 对外暴露的方法
/**
 根据索引滚动到对应的分页页面
 
 @param index 索引
 */
- (void)scrollPageToIndex:(NSInteger)index{
    
    // 保存当前选中的按钮索引
    self.selectTitleIndex = index;
    self.titleButtonClick = YES;
    
    // 滚动到指定的view
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = index * self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:offset animated:YES];
}





@end
