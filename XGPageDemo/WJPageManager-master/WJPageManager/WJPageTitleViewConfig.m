//
//  WJPageTitleViewConfig.m
//  WJPageManagerDemo
//
//  Created by 陈威杰 on 2017/3/16.
//  Copyright © 2017年 ChenWeiJie. All rights reserved.
//

#import "WJPageTitleViewConfig.h"

@implementation WJPageTitleViewConfig

+ (instancetype)defaultConfig {
    
    WJPageTitleViewConfig *config = [[WJPageTitleViewConfig alloc] init];
    config.titleBarBgColor = [UIColor clearColor];
    config.tileFont = [UIFont systemFontOfSize:15];
    config.titleNormalColor = [UIColor blackColor];
    config.titleSelectColor = [UIColor orangeColor];
    config.minTitleMargin = 30;
    
    config.titleIndicatorColor = [UIColor orangeColor];
    
    config.titleIndicatorHeight = 2;
    
    config.titleBarDownLineHeight = 1;
    config.titleBarDownLineBgColor = [UIColor grayColor];
    config.titleBarDownLineAlpha = 0.4;
    
    config.titleSelectScale = 0;
    
    return config;
    
}

@end
