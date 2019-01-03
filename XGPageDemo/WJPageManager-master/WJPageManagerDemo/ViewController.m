//
//  ViewController.m
//  WJPageMangerDemo
//
//  Created by 陈威杰 on 2017/3/5.
//  Copyright © 2017年 ChenWeiJie. All rights reserved.
//

#import "ViewController.h"
#import "WJPageManager.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

static CGFloat const kTitleViewH = 40;
static CGFloat const kStatuBarH = 20;

@interface ViewController ()<WJPageTitleViewDelegate, WJPageContentViewDelegate>


/** titleView */
@property(nonatomic, weak) WJPageTitleView *titleView;


/** pageContentView */
@property(nonatomic, weak) WJPageContentView *pageContentView;




@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 1.添加标题栏
    NSArray *titles = @[@"推荐", @"热点新闻", @"发现", @"音乐", @"视频", @"搞笑", @"小品", @"社会"];
    WJPageTitleView *titleView = [[WJPageTitleView alloc] init];
    titleView.titles = titles;

    self.titleView = titleView;
    titleView.delegate = self;
    self.titleView = titleView;
    // 统一设置标题栏及标题相关属性的方法
    [titleView titleBarWithConfiguration:^(WJPageTitleViewConfig *config) {
        
        config.tileFont = [UIFont systemFontOfSize:16];
        config.titleSelectColor = [UIColor redColor];
        config.titleNormalColor = [UIColor grayColor];
//        config.minTitleMargin = 10;
//        config.titleSelectScale = 0.1;
//        config.titleIndicatorHeight = 5;
        config.titleIndicatorColor = [UIColor blackColor];
        
    }];
    
    [self.view addSubview:titleView];

    
    
    // 如果要监听标题的重复点击进行下拉刷新操作，
    // 只需添加监听标题按钮重复点击发出的通知即可
    [self addNote];
    


    // 2. 添加分页控制器
    NSMutableArray *childVcs = [NSMutableArray array];
    for (NSInteger i = 0; i < titles.count; i++) {
        UIViewController *vc = [[UIViewController alloc] init];
        [childVcs addObject:vc];
    }

    WJPageContentView *pageContentView = [[WJPageContentView alloc] init];
    [pageContentView setUpParentVc:self childVcs:childVcs];
    pageContentView.delegate = self;
    
    self.pageContentView = pageContentView;
    [self.view addSubview:pageContentView];
     
    

}

// 设置标题栏个分页控制器的位置和尺寸
- (void)viewWillLayoutSubviews{
    CGRect frame = CGRectMake(0, kStatuBarH, kScreenW, kTitleViewH);
    self.titleView.frame = frame;
    
    CGRect contentFrame = CGRectMake(0, kStatuBarH + kTitleViewH, kScreenW, kScreenH - kTitleViewH - kStatuBarH);
    self.pageContentView.frame = contentFrame;

}


- (void)addNote {
    // 监听标题重复点击发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleRepeatClick) name:WJPageTitleButtonDidRepeatClickNotification object:nil];
}


/**
 按钮重复点击操作
 */
- (void)titleRepeatClick{
    
    // 如果当前控制器的view不在window上，就直接返回
    if (self.view.window == nil) return;
    
    // 如果当前控制器的view跟window没有重叠，就直接返回
    CGRect windowRect = [UIApplication sharedApplication].keyWindow.bounds;
    CGRect viewRect = [self.view convertRect:self.view.bounds toView:nil];
    if (!CGRectIntersectsRect(windowRect, viewRect)) return;
    
    // 下拉刷新操作....
    NSLog(@"下拉刷新操作....");
    
}


- (void)dealloc {
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - <WJPageTitleViewDelegate>
/** 
 * 点击标题后，滚动到对应的分页
 */
- (void)pageTitleView:(WJPageTitleView *)pageTitleView didSelectTitleIndex:(NSInteger)titleIndex{
    [self.pageContentView scrollPageToIndex:titleIndex];
}


#pragma mark - WJPageContentViewDelegate
/**
 * 拖拽分页，滚动到对应的标题
 */
- (void)pageContentView:(WJPageContentView *)pageContentView progress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex{
//     NSLog(@"from-%zd, to-%zd, progress-%f", sourceIndex, targetIndex, progress);
    [self.titleView setTitleStatusChangeWithProgress:progress fromIndex:sourceIndex toIndex:targetIndex];
    
}

@end
