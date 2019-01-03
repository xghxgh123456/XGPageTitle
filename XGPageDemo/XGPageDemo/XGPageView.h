//
//  XGPageView.h
//  XGPageDemo
//
//  Created by 雷振华 on 2018/11/21.
//  Copyright © 2018年 xgh. All rights reserved.


@class XGPageView;

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XGPageViewDelegate <NSObject>

- (void)pageViewDidScroll:(XGPageView *)pageView selectIndex:(NSInteger)selectIndex;

@end

@interface XGPageView : UIView

@property (strong, nonatomic) NSArray *pageContents;
@property (assign, nonatomic) NSInteger selectView;
@property(nonatomic, weak) id<XGPageViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
