//
//  SAPageControl.m
//  SAPageControl
//
//  Created by 汪志刚 on 16/8/13.
//  Copyright © 2016年 ISCS. All rights reserved.
//

#import "SAPageControl.h"
#import "SABubbleView.h"
#import <Masonry/Masonry.h>
static CGFloat kCurrentLabWidth = 20.0;

@interface SAPageControl ()

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIButton *firstButton;
@property (nonatomic, strong) UIButton *lastButton;
@property (nonatomic, strong) UILabel *currentPageLab;

@property (nonatomic, strong) SABubbleView *bubbleView;

@property (nonatomic, assign) BOOL isInit;


@end

@implementation SAPageControl

- (instancetype)init{
    self = [super init];
    if (self) {
        
        [self initAction];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initAction];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self initAction];
    }
    return self;
}

- (void)initAction{

    self.backgroundColor = [UIColor clearColor];
    _isInit = YES;
    self.pageCount = 2;
    _currentPage = 1;
    
    [self addSubview:self.lineView];
    [self addSubview:self.firstButton];
    [self addSubview:self.lastButton];
    [self addSubview:self.currentPageLab];
    [self addSubview:self.bubbleView];
    [self bringSubviewToFront:self.bubbleView];

    [self.firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(kCurrentLabWidth);
        make.height.equalTo(self);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstButton.mas_right).offset(10);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [self.lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(10);
        make.centerY.equalTo(self);
        make.right.equalTo(self);
    }];

    self.currentPageLab.frame = CGRectMake(0, 0, 20, 14);
}

- (void)layoutSubviews{
    [super layoutSubviews];

    if (_isInit) {
        if (_currentPage == 1) {
             self.currentPageLab.center = CGPointMake(self.lineView.frame.origin.x + 10, self.frame.size.height / 2.f);
        }else if (_currentPage == _pageCount){
            self.currentPageLab.center = CGPointMake(CGRectGetMaxX(self.lineView.frame) - 10, self.frame.size.height / 2.f);
        }else{
            self.currentPageLab.center = CGPointMake(self.lineView.frame.size.width * _currentPage/_pageCount + self.lineView.frame.origin.x, self.frame.size.height / 2.f);
        }
        self.bubbleView.center = CGPointMake(self.currentPageLab.center.x, self.currentPageLab.frame.origin.y-30);

        [self.lastButton setTitle:@(_pageCount).stringValue forState:UIControlStateNormal];
        self.currentPageLab.text = @(_currentPage).stringValue;
        _isInit = NO;
    }

}


#pragma mark--  action method
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.bubbleView.hidden = NO;
    self.bubbleView.center = CGPointMake(self.currentPageLab.center.x, self.currentPageLab.frame.origin.y-20);
    self.bubbleView.title = self.currentPageLab.text;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.lineView];
    
    
    if (point.x <= 0) {
        self.currentPageLab.center = CGPointMake(self.lineView.frame.origin.x, self.currentPageLab.center.y);
        
    }else if (point.x > 0 && point.x < self.lineView.frame.size.width-1){
        self.currentPageLab.center = CGPointMake(point.x+self.lineView.frame.origin.x, self.currentPageLab.center.y);
        
    }else{
        self.currentPageLab.center = CGPointMake(self.lineView.frame.origin.x + self.lineView.frame.size.width, self.currentPageLab.center.y);
    }


    [self calculateCurrentPage];
    self.bubbleView.center = CGPointMake(self.currentPageLab.center.x, self.currentPageLab.frame.origin.y-20);
    self.bubbleView.title = self.currentPageLab.text;
    
    if (self.pageDidChange) {
        self.pageDidChange(self.currentPageLab.text.integerValue);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.bubbleView.hidden = YES;
    if (self.pageDidEndChange) {
        self.pageDidEndChange(self.currentPageLab.text.integerValue);
    }
    [self scrollToCurrenPage];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.bubbleView.hidden = YES;
}


#pragma mark--  calculate current page
//  计算所选中的页面为第几页，并显示在currentPageLab上，
- (void)calculateCurrentPage{
    CGFloat lineViewLefe = self.lineView.frame.origin.x;
    if (self.currentPageLab.center.x<= lineViewLefe) {
        _currentPage = 1;
        self.currentPageLab.text = @"1";
    }else if (self.currentPageLab.center.x > lineViewLefe && self.currentPageLab.center.x < self.lineView.frame.size.width + lineViewLefe){
        _currentPage = ceil((self.currentPageLab.center.x-lineViewLefe)/self.lineView.frame.size.width * (_pageCount));
        if (_currentPage > _pageCount) {
            _currentPage = _pageCount;
        }
        self.currentPageLab.text = @(_currentPage).stringValue;
    }else{
        _currentPage = _pageCount;
        self.currentPageLab.text = @(_currentPage).stringValue;
    }
    
    
}



- (void)reloadPageControl{
    [self scrollToCurrenPage];
}
- (void)scrollToNextPage{
    NSInteger index = self.currentPage + 1;
    if (index > self.pageCount) {
        index = self.pageCount;
    }else if (index < 1){
        index = 1;
    }
    self.currentPage = index;
    if (self.pageDidEndChange) {
        self.pageDidEndChange(self.currentPage);
    }
}
- (void)animateToLastPage{
    self.currentPage = _pageCount;
    if (self.pageDidEndChange) {
        self.pageDidEndChange(self.currentPage);
    }
}
- (void)animateToFirstPage{
    self.currentPage = 1;
    if (self.pageDidEndChange) {
        self.pageDidEndChange(self.currentPage);
    }
}
#pragma mark--  setter and getter
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithRed:220/255.f green:220/255.f blue:220/255.f alpha:1];
    }
    return _lineView;
}

- (SABubbleView *)bubbleView{
    if (!_bubbleView) {
        _bubbleView = [[SABubbleView alloc]initWithFrame:CGRectMake(0, 0, 39, 37)];
        [_bubbleView setTitle:@"1"];
        _bubbleView.hidden = YES;
    }
    return _bubbleView;
}

- (UILabel *)currentPageLab{
    if (!_currentPageLab) {
        _currentPageLab = [[UILabel alloc]init];
        _currentPageLab.font = [UIFont systemFontOfSize:8];
        _currentPageLab.textColor = [UIColor whiteColor];
        _currentPageLab.backgroundColor = [UIColor colorWithRed:185/255.f green:185/255.f blue:185/255.f alpha:1];
        _currentPageLab.textAlignment = NSTextAlignmentCenter;
        _currentPageLab.userInteractionEnabled = YES;
    }
    return _currentPageLab;
}

- (UIButton *)firstButton{
    if (!_firstButton) {
        _firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_firstButton.titleLabel setFont:[UIFont systemFontOfSize:9]];
        [_firstButton setTitleColor:[UIColor colorWithRed:180/255.f green:180/255.f blue:180/255.f alpha:1] forState:UIControlStateNormal];
        [_firstButton setTitle:@(1).stringValue forState:UIControlStateNormal];
        [_firstButton addTarget:self action:@selector(animateToFirstPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _firstButton;
}

- (UIButton *)lastButton{
    if (!_lastButton) {
        _lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lastButton.titleLabel setFont:[UIFont systemFontOfSize:9]];
        [_lastButton setTitleColor:[UIColor colorWithRed:180/255.f green:180/255.f blue:180/255.f alpha:1] forState:UIControlStateNormal];
        [_lastButton addTarget:self action:@selector(animateToLastPage) forControlEvents:UIControlEventTouchUpInside];

    }
    return _lastButton;
}
- (void)setPageCount:(NSInteger)pageCount{
    if (pageCount < 0) {
        return;
    }
    _pageCount = pageCount;
    [self.lastButton setTitle:[NSString stringWithFormat:@"%ld",(long)_pageCount] forState:UIControlStateNormal];
}

- (void)setCurrentPage:(NSInteger)currentPage{
    currentPage = currentPage <= 0?1:currentPage;
    currentPage = currentPage > _pageCount ? _pageCount : currentPage;
    _currentPage = currentPage;
    self.currentPageLab.text = @(currentPage).stringValue;
    [self scrollToCurrenPage];
}
- (void)scrollToCurrenPage{
    if (self.currentPage == 1) {
        self.currentPageLab.center = CGPointMake( self.lineView.frame.origin.x+10, self.currentPageLab.center.y);

    }else if (_currentPage >= _pageCount) {
        self.currentPageLab.center = CGPointMake( self.lineView.frame.size.width + self.lineView.frame.origin.x - 10, self.currentPageLab.center.y);

    }else{
        self.currentPageLab.center = CGPointMake( (self.lineView.frame.size.width) * (_currentPage - 1)/(_pageCount - 1) + self.lineView.frame.origin.x, self.currentPageLab.center.y);
    }
    
}


@end
