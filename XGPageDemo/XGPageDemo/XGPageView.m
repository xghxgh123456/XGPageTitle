//
//  XGPageView.m
//  XGPageDemo
//
//  Created by 雷振华 on 2018/11/21.
//  Copyright © 2018年 xgh. All rights reserved.

#import "XGPageView.h"

@interface XGPageView ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *pageScrollView;
@end

@implementation XGPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (void)initlizeView:(NSInteger)page{
    UIView *currentView = self.pageContents[page];
    currentView.frame = CGRectMake(page*CGRectGetWidth(self.frame), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [self.pageScrollView addSubview:currentView];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger currentPage = scrollView.contentOffset.x/CGRectGetWidth(self.frame);
    UIView *currentView = self.pageContents[currentPage];
    if (CGSizeEqualToSize(currentView.frame.size, CGSizeZero)) {
        [self initlizeView:currentPage];
    }
    if (self.delegate) {
        [self.delegate pageViewDidScroll:self selectIndex:currentPage];
    }
}
-(void)setPageContents:(NSArray *)pageContents{
    _pageContents = pageContents;
    [self.subviews makeObjectsPerformSelector:@selector(removeAllObjects)];
    [self initlizeView:0];
}
-(UIScrollView *)pageScrollView{
    if (!_pageScrollView) {
        _pageScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _pageScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame)*self.pageContents.count, 0);
        _pageScrollView.showsVerticalScrollIndicator = NO;
        _pageScrollView.showsHorizontalScrollIndicator = NO;
        _pageScrollView.delegate = self;
        _pageScrollView.pagingEnabled = YES;
        [self addSubview:_pageScrollView];
    }
    return _pageScrollView;
}

-(void)setSelectView:(NSInteger)selectView{
    _selectView = selectView;
    [self.pageScrollView setContentOffset:CGPointMake(selectView*CGRectGetWidth(self.frame), 0) animated:YES];
}

@end
