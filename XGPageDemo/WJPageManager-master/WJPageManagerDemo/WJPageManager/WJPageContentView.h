//
//  WJPageContentView.h
//  WJPageManager
//
//  Created by 陈威杰 on 2017/3/4.
//  Copyright © 2017年 ChenWeiJie. All rights reserved.
//
//  分页封装

#import <UIKit/UIKit.h>
@class WJPageContentView;

#pragma mark - 定义协议

@protocol WJPageContentViewDelegate <NSObject>


/**
 当 pageContentView 滚动的时候会将滚动进度以及当前、下一个页面告诉代理。
 

 @param pageContentView  self
 @param progress 滚动进度
 @param sourceIndex 滚动前的当前页面
 @param targetIndex 下一个页面
 */
- (void)pageContentView:(WJPageContentView *)pageContentView progress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex;

@end

@interface WJPageContentView : UIView

#pragma mark - 定义属性
/**
 *  代理属性
 */
@property(nonatomic, weak) id<WJPageContentViewDelegate> delegate;




#pragma mark - 快速创建初始化的方法
/**
 快速创建分页控制器

 @param frame 尺寸
 @param parentVc 父控制器
 @param childVcs 子控制器数组
 */ 
- (instancetype)initWithFrame:(CGRect)frame parentVc:(UIViewController *)parentVc childVcs:(NSArray<UIViewController *> *)childVcs;
+ (instancetype)pageContentViewWithFrame:(CGRect)frame parentVc:(UIViewController *)parentVc childVcs:(NSArray<UIViewController *> *)childVcs;




#pragma mark - 相关接口
/**
 根据索引滚动到对应的分页页面
 
 @param index 索引
 */
- (void)scrollPageToIndex:(NSInteger)index;

/**
 添加父子控制器，以便创建分页控制器
 
 @param parentVc 父控制器
 @param childVcs 子控制器数组
 */
- (void)setUpParentVc:(UIViewController *)parentVc childVcs:(NSArray<UIViewController *> *)childVcs;


@end
