//
//  SACardAssistView.m
//  SABaseViewDemo
//
//  Created by 阿宝 on 16/8/27.
//  Copyright © 2016年 浙江网仓科技有限公司. All rights reserved.
//

#import "SACardAssistView.h"
#import <Masonry/Masonry.h>
#import "SACardAssistKit.h"

static NSUInteger kItemButtonBaseTag = 400;

static CGFloat const kCardAssistButtonSpace = 20.0f;

@interface SACardAssistView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *scrollContentView;

@end
@implementation SACardAssistView {
    NSArray<UIButton *> *_buttonArray;
    SACardAssistType _type;
}

- (instancetype)initWithButtonArray:(NSArray<UIButton *> *)buttonArray type:(SACardAssistType)type
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _buttonArray = buttonArray;
        _type = type;
        
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.scrollContentView];
        
        [self setupSubviewsConstraints];
    }
    return self;
}
- (instancetype)initWithButtonImageNames:(NSArray<NSString *> *)btnNames type:(SACardAssistType)type{
    NSMutableArray *btns =[NSMutableArray array];
   [btnNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
       button.titleLabel.font = [UIFont systemFontOfSize:14];
       [button setImage:[UIImage imageNamed:btnNames[idx]] forState:UIControlStateNormal];
       button.frame = CGRectMake(0, 0, 60, 34);
       button.tag = kItemButtonBaseTag + idx;
       [btns addObject:button];
   }];
    return [[SACardAssistView alloc]initWithButtonArray:btns type:type];
}


#pragma mark-
#pragma mark-Private Methods

- (void)pressButton:(UIButton *)button {
    NSUInteger index = button.tag - kItemButtonBaseTag;
    if ([self.delegate respondsToSelector:@selector(cardAssistView:didPressItemButtonAtIndex:)]) {
        [self.delegate cardAssistView:self didPressItemButtonAtIndex:index];
    }
}

#pragma mark-
#pragma mark-Getters && Setters

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

- (UIView *)scrollContentView {
    if (_scrollContentView == nil) {
        _scrollContentView = [[UIView alloc] init];
        _scrollContentView.backgroundColor = [UIColor clearColor];
    }
    return _scrollContentView;
}

- (void)setupSubviewsConstraints {
    __block CGFloat originX = 0;
    __block CGFloat maxHeight = 0;
    if (_buttonArray.count > 0) {
        [_buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.tag = kItemButtonBaseTag + idx;
            [obj addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollContentView addSubview:obj];
            
            CGFloat buttonWidth = CGRectGetWidth(obj.bounds);
            CGFloat buttonHeight = CGRectGetHeight(obj.bounds);
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.scrollContentView);
                make.height.mas_equalTo(buttonHeight);
                make.left.mas_equalTo(originX);
                make.width.mas_equalTo(buttonWidth);
            }];
            originX += buttonWidth + kCardAssistButtonSpace;
            maxHeight = MAX(maxHeight, buttonHeight);
        }];
     }
    
    if (_type == SACardAssistTypeTop) {
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.scrollView.superview.mas_centerY).with.offset(10.0f);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(maxHeight);
        }];
    }else {
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(maxHeight);
            make.bottom.mas_equalTo(-10.0f);
        }];
    }
    
    [self.scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.size.mas_equalTo(CGSizeMake(originX, maxHeight));
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
