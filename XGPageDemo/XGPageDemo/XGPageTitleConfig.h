//
//  XGPageTitleConfig.h
//  XGPageDemo
//
//  Created by 雷振华 on 2018/11/20.
//  Copyright © 2018年 xgh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGPageTitleConfig : NSObject
/**整个标题栏的背景颜色*/
@property (strong, nonatomic) UIColor *titleBackColor;
/**标题正常颜色*/
@property (strong, nonatomic) UIColor *titleNormalColor;
/**标题选中的颜色*/
@property (strong, nonatomic) UIColor *titleSelectColor;
/** 标题字体 */
@property (nonatomic, strong) UIFont *tileFont;
/** 标题最小间距, 默认值为 30; 取值范围必须大于或等于0 */
@property (nonatomic, assign) CGFloat minTitleMargin;
/** 指示器的高度，默认值为 2 */
@property (nonatomic, assign) CGFloat titleIndicatorHeight;
/** 指示器的颜色，默认为 orangeColor */
@property (nonatomic, strong) UIColor *titleIndicatorColor;
/**默认s配置*/
+ (instancetype)defaultConfig;
@end

NS_ASSUME_NONNULL_END
