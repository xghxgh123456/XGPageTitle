//
//  XGPageTitleConfig.m
//  XGPageDemo
//
//  Created by 雷振华 on 2018/11/20.
//  Copyright © 2018年 xgh. All rights reserved.
//

#import "XGPageTitleConfig.h"

@implementation XGPageTitleConfig
+ (instancetype)defaultConfig {
    
    XGPageTitleConfig *config = [[XGPageTitleConfig alloc] init];
    config.titleBackColor = [UIColor clearColor];
    config.tileFont = [UIFont systemFontOfSize:15];
    config.titleNormalColor = [UIColor blackColor];
    config.titleSelectColor = [UIColor orangeColor];
    config.minTitleMargin = 30;
    config.titleIndicatorColor = [UIColor orangeColor];
    config.titleIndicatorHeight = 2;
    
    return config;
    
}

@end
