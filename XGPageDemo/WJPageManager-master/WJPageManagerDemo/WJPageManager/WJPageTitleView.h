//
//  WJPageTitleView.h
//  WJPageManager
//
//  Created by 陈威杰 on 2017/3/3.
//  Copyright © 2017年 ChenWeiJie. All rights reserved.
//
//  标题封装





#import <UIKit/UIKit.h>
@class WJPageTitleView;
#import "WJPageTitleViewConfig.h"

#pragma mark - 定义协议
@protocol WJPageTitleViewDelegate <NSObject>

/**
 告诉代理当前点击的标题按钮的索引

 @param pageTitleView pageTitleView
 @param titleIndex 当前点击的标题按钮的索引
 */

- (void)pageTitleView:(WJPageTitleView *)pageTitleView didSelectTitleIndex:(NSInteger)titleIndex;

@end





@interface WJPageTitleView : UIView

#pragma mark - 定义属性
/**
 *  数据源：标题数组
 */
@property(nonatomic, strong) NSArray <NSString *>*titles;
/** 代理 */
@property(nonatomic, weak) id<WJPageTitleViewDelegate> delegate;
/** 当前选中的标题索引 */
@property (nonatomic, assign) NSInteger selectIndex;


#pragma mark - 快速初始化的方法


/**
 快速设置 PageTitleView，标题默认普通状态颜色为black，选中状态颜色为orange，字体大小为 14

 @param frame 设置pageTitleView的位置和尺寸
 @param titles 需要显示的标题数组
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

/**
 根据标题数组创建标题栏

 @param titles 标题数组
 */
- (instancetype)initWithTitles:(NSArray *)titles;

/**
 根据标题数组创建标题栏
 
 @param titles 标题数组
 */
+ (instancetype)pageTitleViewWithTitles:(NSArray *)titles;


/**
 快速设置 PageTitleView，标题默认普通状态颜色为black，选中状态颜色为orange，字体大小为 14
 
 @param frame 设置pageTitleView的位置和尺寸
 @param titles 需要显示的标题数组
 @return self
 */
+ (instancetype)pageTitleViewWithFrame:(CGRect)frame titles:(NSArray *)titles;



#pragma mark - 滚动标题指示器相关设置方法
/**
 根据 pageContentView 的滚动进度等信息设置指示器以及标题的状态。
 如果点击标题，滚动到对应的 pageContentView 可以通过 pageContentView 的代理方法获得 pageContentView 的拖拽页面相关信息。然后调用该方法设置标题的指示器

 @param progress pageContentView滚动进度
 @param fromIndex 页面滚动前所在的索引
 @param toIndex 将要滚动到的下一个页面的索引
 */
- (void)setTitleStatusChangeWithProgress:(CGFloat)progress fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;


#pragma mark - 标题栏统一配置

/**
 对标题栏以及标题进行统一的刷新设置
 */
- (void)titleBarWithConfiguration: (void(^)(WJPageTitleViewConfig *config))configBlock;

@end
