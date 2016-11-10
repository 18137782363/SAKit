//
//  SACardSingleView.m
//  SAKitDemo
//
//  Created by 学宝 on 16/9/20.
//  Copyright © 2016年 学宝工作室. All rights reserved.
//

#import "SACardSingleView.h"
#import <Masonry/Masonry.h>
#import "SACardAssistKit.h"

@interface SACardSingleView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@property (nonatomic, strong) UIButton *backBtn;


@end

@implementation SACardSingleView {
    UIView *_frontView;
    UIView *_headerView;
    UIView *_backView;
    
    UIView *_footerView;
    UIView *_footerBackView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollEnabled = NO;
        
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.contentView];
        
        [self setupSubviewsConstraints];
    }
    return self;
}

- (void)addBackbutton {
    
    [self addSubview:self.backBtn];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([SACardAssistKit cardFrame].leftEdgeSpace);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(43);
    }];
}

- (void)realodData {
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _frontView = [_dataSource frontViewInSingleCardView:self];
    if (_frontView == nil)  return;
    else {
        [self.contentView addSubview:_frontView];
        _frontView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _frontView.layer.shadowOffset = CGSizeZero;
        _frontView.layer.shadowOpacity = 0.6;
        _frontView.layer.shadowRadius = 9.0f;
        _frontView.layer.masksToBounds = YES;
        _frontView.layer.cornerRadius = 2.5f;
    }
    
    if ([self shouldShowHeaderView]) {
        _headerView = [self headerViewFromDataSource];
        [self.contentView addSubview:_headerView];
    }else {
        _headerView = nil;
    }
    [self setupSubViewsConstraintsFromDataSource];
}

- (void)backAction {
    if ([self.delegate respondsToSelector:@selector(didPressBackButtonInSingleCardView:)]) {
        [self.delegate didPressBackButtonInSingleCardView:self];
    }
}

#pragma mark-
#pragma mark- Setter&Getter

- (BOOL)shouldShowBackView {
    if ([self.dataSource respondsToSelector:@selector(shouldShowBackViewInSingleCardView:)]) {
        return [self.dataSource shouldShowBackViewInSingleCardView:self];
    }
    return NO;
}

- (BOOL)shouldShowHeaderView {
    if ([self.dataSource respondsToSelector:@selector(shouldShowHeaderViewInSingleCardView:)]) {
        return [self.dataSource shouldShowHeaderViewInSingleCardView:self];
    }
    return YES;
}

- (BOOL)shouldShowFooterView {
    if ([self.dataSource respondsToSelector:@selector(shouldShowFooterViewInSingleCardView:)]) {
        return [self.dataSource shouldShowFooterViewInSingleCardView:self];
    }
    return NO;
}

- (BOOL)shouldShowFooterBackView {
    if ([self.dataSource respondsToSelector:@selector(shouldShowFooterBackViewInSingleCardView:)]) {
        return [self.dataSource shouldShowFooterBackViewInSingleCardView:self];
    }
    return NO;
}

- (UIView *)headerViewFromDataSource {
    if ([self.dataSource respondsToSelector:@selector(headerViewInSingleCardView:)]) {
        return [self.dataSource headerViewInSingleCardView:self];
    }
    return nil;
}

- (void)setDataSource:(id<SACardSingleViewDataSource>)dataSource {
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        [self realodData];
    }
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = self.scrollEnabled;
        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _scrollView;
}

- (UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (void)setupSubviewsConstraints {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView.superview);
        make.size.mas_equalTo(CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)));
    }];
}

- (void)setExistBackBtn:(BOOL)existBackBtn {
    _existBackBtn = existBackBtn;
    if (existBackBtn) [self addBackbutton];
}

- (void)setupSubViewsConstraintsFromDataSource {
    if (_frontView) {
        [_frontView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo([SACardAssistKit cardFrame].topEdgeSpace);
            make.left.mas_equalTo([SACardAssistKit cardFrame].leftEdgeSpace);
            make.centerX.mas_equalTo(self);
            make.bottom.mas_equalTo(-[SACardAssistKit cardFrame].bottomEdgeSpace);
        }];
    }
    
    if (_headerView) {
        CGFloat height = [SACardAssistKit cardFrame].topEdgeSpace < 60.0f ? 60.0f : [SACardAssistKit cardFrame].topEdgeSpace;
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(self);
            make.left.mas_equalTo([SACardAssistKit cardFrame].leftEdgeSpace);
            make.height.mas_equalTo(height);
        }];
    }
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    self.scrollView.scrollEnabled = scrollEnabled;
    _scrollEnabled = scrollEnabled;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
