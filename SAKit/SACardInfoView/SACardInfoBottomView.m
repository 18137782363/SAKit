//
//  SACardInfoBottomView.m
//  SACardInfoView
//
//  Created by 汪志刚 on 2016/10/10.
//  Copyright © 2016年 ISCScom.cn.iscs.www. All rights reserved.
//

#import "SACardInfoBottomView.h"
#import "SACardAssistKit.h"
#import <Masonry/Masonry.h>

@implementation SACardInfoBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initMethod];
    }
    return self;
}

- (void)initMethod {
    
    self.itemNum = 2;
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.pageControl];
    [self addSubview:self.itemContentView];
    
    for (int i = 0; i<self.itemNum; i++) {
        
    }
    
    [self setupSubviewsContraints];
}

#pragma mark-
#pragma mark-   private method 
- (void)setupSubviewsContraints {
    
    [self.itemContentView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_equalTo(0);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.centerX.mas_equalTo(0);
    }];
}

#pragma mark-
#pragma mark-   setter and getter
- (UIPageControl *)pageControl {
    if (!_pageControl) {
        
        _pageControl = [UIPageControl new];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0 green:148.0/255.0 blue:246.0/255.0 alpha:1.0];
    }
    return _pageControl;
}

- (UIView *)itemContentView {
    if (!_itemContentView) {
        _itemContentView = [UIView new];
//        _itemContentView.backgroundColor = [UIColor redColor];
        _itemContentView.alpha = 0;
    }
    return _itemContentView;
}

@end
