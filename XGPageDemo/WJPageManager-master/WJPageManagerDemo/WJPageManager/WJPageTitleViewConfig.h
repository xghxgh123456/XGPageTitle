//
//  WJPageTitleViewConfig.h
//  WJPageManagerDemo
//
//  Created by 陈威杰 on 2017/3/16.
//  Copyright © 2017年 ChenWeiJie. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WJPageTitleViewConfig : NSObject

/*********************** 提供设置标题栏的属性 ******************/




/** 标题栏的背景颜色 */
@property (nonatomic, strong) UIColor *titleBarBgColor;
/** 标题的正常状态的颜色 */
@property (nonatomic, strong) UIColor *titleNormalColor;
/** 标题的选中状态的颜色 */
@property (nonatomic, strong) UIColor *titleSelectColor;
/** 标题字体 */
@property (nonatomic, strong) UIFont *tileFont;
/** 标题最小间距, 默认值为 30; 取值范围必须大于或等于0 */
@property (nonatomic, assign) CGFloat minTitleMargin;

/** 指示器的高度，默认值为 2 */
@property (nonatomic, assign) CGFloat titleIndicatorHeight;
/** 指示器的颜色，默认为 orangeColor */
@property (nonatomic, strong) UIColor *titleIndicatorColor;

/** 标题栏底线的高度，默认值为 1 */
@property (nonatomic, assign) CGFloat titleBarDownLineHeight;
/** 标题栏底线的背景颜色 */
@property (nonatomic, strong) UIColor *titleBarDownLineBgColor;
/** 标题栏底线的透明度 */
@property (nonatomic, assign) CGFloat titleBarDownLineAlpha;

/** 标题选中时放大的倍数, 默认值为 0； 如果设置为 0.5， 即缩放形变为 1 + 0.5 = 1.5 */
@property (nonatomic, assign) CGFloat titleSelectScale;

/**
 标题栏默认配置
 */
+ (instancetype)defaultConfig;

@end
