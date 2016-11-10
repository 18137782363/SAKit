//
//  SAMenuView.m
//  SAKitDemo
//
//  Created by 学宝 on 2016/10/29.
//  Copyright © 2016年 学宝工作室. All rights reserved.
//

#import "SAMenuView.h"
#import <Masonry/Masonry.h>

static NSInteger const kMenuExpandButtonBaseTag = 102;

@interface SAMenuView ()
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIView *expandView;
@end
@implementation SAMenuView

#pragma mark-
#pragma mark-View Life Cycle

//+ (SAMenuView *)shareInstance {
//    static SAMenuView *menuView = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        menuView = [[SAMenuView alloc] init];
//    });
//    return menuView;
//}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
        [self addSubview:self.expandView];
        [self setupSubviewsConstraints];
    }
    return self;
}


#pragma mark-
#pragma mark-Event response

- (void)reset{
    self.alpha = 1;
    self.expandView.hidden = YES;
    self.leftButton.hidden = NO;
}

- (void)setLeftItemNormalImage:(UIImage *)leftItemNormalImage leftItemSelectedImage:(UIImage *)leftItemSelectedImage rightItemNormalImage:(UIImage *)rightItemNormalImage rightItemSelectedImage:(UIImage *)rightItemSelectedImage {
    [self.leftButton setImage:leftItemNormalImage forState:UIControlStateNormal];
    [self.leftButton setImage:leftItemSelectedImage forState:UIControlStateSelected];
    [self.leftButton setImage:leftItemSelectedImage forState:UIControlStateHighlighted];
    
    [self.rightButton setImage:rightItemNormalImage forState:UIControlStateNormal];
    [self.rightButton setImage:rightItemSelectedImage forState:UIControlStateSelected];
    [self.rightButton setImage:rightItemSelectedImage forState:UIControlStateHighlighted];
}

- (void)setExpandItemNormalImageArray:(NSArray<UIImage *> *)normalImageArray selectImageArray:(NSArray<UIImage *> *)selectImageArray {
    if (normalImageArray.count != selectImageArray.count)  return;
    [self.expandView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [normalImageArray enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setImage:normalImageArray[idx] forState:UIControlStateNormal];
        [button setImage:selectImageArray[idx] forState:UIControlStateSelected];
        [button setImage:selectImageArray[idx] forState:UIControlStateHighlighted];
        button.tag = kMenuExpandButtonBaseTag + idx;
        [button addTarget:self action:@selector(pressExprandButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.expandView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(50.0f * idx);
            make.top.bottom.equalTo(self.expandView);
            make.width.mas_equalTo(50.0f);
        }];
    }];
}

#pragma mark-
#pragma mark-Private Methods

- (void)pressLeftButtonAction {
    self.expandView.hidden = NO;
    self.leftButton.hidden = YES;
}

- (void)pressRightButtonAction {
    if ([self.delegate respondsToSelector:@selector(didPressRightItemInMenuView:)]) {
        [self.delegate didPressRightItemInMenuView:self];
    }
}

- (void)pressExprandButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(menuView:didPressMenuItemAtIndex:)]) {
        [self.delegate menuView:self didPressMenuItemAtIndex:button.tag];
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self reset];
    }];
}

#pragma mark-
#pragma mark-Getters && Setters


- (UIButton *)leftButton {
	if (_leftButton == nil) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_leftButton addTarget:self action:@selector(pressLeftButtonAction) forControlEvents:UIControlEventTouchUpInside];
	}
	return _leftButton;
}

- (UIButton *)rightButton {
	if (_rightButton == nil) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_rightButton addTarget:self action:@selector(pressRightButtonAction) forControlEvents:UIControlEventTouchUpInside];
	}
	return _rightButton;
}

- (UIView *)expandView {
    if (_expandView == nil) {
        _expandView = [[UIView alloc] init];
        _expandView.hidden = YES;
    }
    return _expandView;
}

- (void)setupSubviewsConstraints {
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).with.offset(10.0f);
        make.trailing.equalTo(self.rightButton.superview);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rightButton);
        make.leading.equalTo(self.leftButton.superview);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    [self.expandView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.left.height.equalTo(self.leftButton);
        make.right.equalTo(self.rightButton.mas_right).with.offset(-5.0f);
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
