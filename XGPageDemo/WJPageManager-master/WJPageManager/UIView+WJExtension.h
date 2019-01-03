//
//  UIView+WJExtension.h
//
//  Created by 陈威杰 on 16/10/25.
//  Copyright © 2016年 ChenWeiJie. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 
 在分类当中添加属性：
     1.在分类当中一般情况下, 是不能添加属性的.
     2.如果说非要添加属性的话, 必须得要实现该属性的set与get方法.如果不实现该,可以用@dynamic声明
         @dynamic x;
         @dynamic y;
         @dynamic width;
         @dynamic height;
     或者自己去实现它的get与set方法.
 
     3.在分类当中使用@property是会声明get与set方法.没有帮你实现
     4.在分类当中不会生成带有下划线的成员属性.
 
 */



@interface UIView (WJExtension)

/** UIView+WJExtension 返回 size */
@property (nonatomic, assign) CGSize size;

/** UIView+WJExtension 返回 width */
@property (nonatomic, assign) CGFloat width;

/** UIView+WJExtension 返回 height */
@property (nonatomic, assign) CGFloat height;

/** UIView+WJExtension 返回 x */
@property (nonatomic, assign) CGFloat x;

/** UIView+WJExtension 返回 y */
@property (nonatomic, assign) CGFloat y;

/** UIView+WJExtension 返回 centerX */
@property (nonatomic, assign) CGFloat centerX;

/** UIView+WJExtension 返回 centerY */
@property (nonatomic, assign) CGFloat centerY;

@end
