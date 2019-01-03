//
//  XGPageTitleView.h
//  XGPageDemo
//
//  Created by 雷振华 on 2018/11/20.
//  Copyright © 2018年 xgh. All rights reserved.
//


@class XGPageTitleView;

#import <UIKit/UIKit.h>
#import "XGPageTitleConfig.h"


NS_ASSUME_NONNULL_BEGIN

@protocol XGPageTitleViewDelegate <NSObject>

- (void)titlePageView:(XGPageTitleView *)pageView select:(NSInteger)index;

@end

@interface XGPageTitleView : UIView
/**
 标题数组
 */
@property (strong, nonatomic) NSArray *titles;
/**选中第几个 默认0*/
@property (assign, nonatomic) NSInteger selectIndex;
@property (weak, nonatomic) id<XGPageTitleViewDelegate>delegate;
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;
/** 修改样式 */
- (void)titlePageViewResetConfig:(void(^)(XGPageTitleConfig  * _Nonnull config))configBlock;
@end

NS_ASSUME_NONNULL_END
