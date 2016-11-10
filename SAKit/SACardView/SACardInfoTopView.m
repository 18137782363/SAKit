
//  SACardInfoTopView.m
//  SACardInfoView
//
//  Created by 汪志刚 on 2016/10/10.
//  Copyright © 2016年 ISCScom.cn.iscs.www. All rights reserved.
//

#import "SACardInfoTopView.h"
#import <Masonry/Masonry.h>
#import "SACardAssistKit.h"
#import "UIView+SAExtend.h"

static NSInteger const kHomeItemTag     = 100;
static NSInteger const kScanItemTag     = 101;

//static NSInteger const kTaskItemTag     = 102;
//static NSInteger const kMessageItemTag  = 103;
//static NSInteger const kTeamItemTag     = 104;
//static NSInteger const kMeItemTag       = 105;

static NSInteger const kSortItemTag     = 106;
static NSInteger const kRefreshItemTag  = 107;

static CGFloat kItemHeight = 34.0;
static CGFloat kAnimationDuration = 0.25;

@interface SACardInfoTopView (){
    BOOL _isTitleAtMiddle;
    BOOL _hideOfSubItems;
    BOOL _isAnimation;
}

@property (nonatomic, strong) UIButton *homeItem;
@property (nonatomic, strong) UIButton *scanItem;

@property (nonatomic, strong) UIButton *refreshItem;
@property (nonatomic, strong) UIButton *sortItem;

@property (nonatomic, strong) UIButton *lastSelectedItem;

@property (nonatomic, strong) NSMutableArray *subItemList;

@end

@implementation SACardInfoTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initMethod];
    }
    return self;
}

- (void)initMethod {
    
    _topViewStstus = SACardInfoTopViewStatusNormal;
    _shouldHaveSubTitle = NO;
    _isAnimation = NO;
    _hideOfSubItems = YES;
    _isTitleAtMiddle = YES;
    self.countOfSubItems = 4;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.homeItem];
    [self addSubview:self.scanItem];
    [self addSubview:self.sortItem];
    [self addSubview:self.refreshItem];
//    [self addSubItems];
    [self setupSubviewsContraints];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self addSubItems];
}

#pragma mark-
#pragma mark-   action method
- (void)didClickHomeItem:(UIButton *)item {
    
    //    [self resetSubItemsStateWithState:NO];
    [self resetSubItemsAlphaWithAlpha:1];
    self.homeItem.alpha = 0;
    self.titleLabel.alpha = 0;
    self.subTitleLabel.alpha = 0;
    //    self.homeItem.hidden = YES;
    //    self.titleLabel.hidden = YES;
    
    _hideOfSubItems = NO;
    if (self.didClickItemBlock) {
        self.didClickItemBlock(item.tag);
    }
    
}

- (void)didClickScanItem:(UIButton *)item {
    
    if (self.didClickItemBlock) {
        self.didClickItemBlock(item.tag);
    }
}

- (void)didClickSubItem:(UIButton *)item {
    
    [self animateionToHideSubItems];
    
    if (item.selected) {
        return;
    }
    
    item.selected = YES;
    self.lastSelectedItem.selected = NO;
    self.lastSelectedItem = item;
    
    if (self.didClickItemBlock) {
        self.didClickItemBlock(item.tag);
    }
    
}

- (void)didClickSortItem:(UIButton *)item {
    
    if (self.didClickItemBlock) {
        self.didClickItemBlock(item.tag);
    }
}


- (void)didClickRefreshItem:(UIButton *)item {
    if (self.refreshItem.isAnimation) {
        return;
    }
    if (self.didClickItemBlock) {
        self.didClickItemBlock(item.tag);
    }
}



#pragma mark-
#pragma mark-   private method
- (void)addSubItems {
    
    UIView *lastItem = nil;
    for (int i = 0; i<self.countOfSubItems; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = kScanItemTag+1+i;
        button.clipsToBounds = YES;
        button.alpha = 0;
        button.layer.cornerRadius = kItemHeight/2.0;
        //            button.frame = CGRectMake(i*(20*[SACardAssistKit cardFrame].width/345.0+kItemHeight), CGRectGetMinY(self.homeItem.frame), kItemHeight, kItemHeight);
        if (self.itemNormalImageArray.count > i) {
            [button setImage:self.itemNormalImageArray[i] forState:UIControlStateNormal];
        }
        if (self.itemHighLightedImageArray.count > i) {
            [button setImage:self.itemHighLightedImageArray[i] forState:UIControlStateHighlighted];
        }
        if (self.itemHighLightedImageArray.count > i) {
            [button setImage:self.itemHighLightedImageArray[i] forState:UIControlStateSelected];
        }
        [button addTarget:self action:@selector(didClickSubItem:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            self.lastSelectedItem = button;
            button.selected = YES;
        }
        [self.subItemList addObject:button];
        
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (lastItem) {
                make.leading.equalTo(lastItem.mas_trailing).offset(20*[SACardAssistKit cardFrame].width/345.0);
            }else{
                make.leading.mas_equalTo(0);
            }
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(kItemHeight);
            make.width.mas_equalTo(kItemHeight);
        }];
        lastItem = button;
    }

}

- (void)setupSubviewsContraints {
    
    [self.refreshItem mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.mas_equalTo(0);
        make.height.mas_equalTo(kItemHeight);
        make.centerY.mas_equalTo(0);
        make.width.equalTo(self.refreshItem.mas_height);
    }];
    
    [self.sortItem mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self.refreshItem.mas_leading).offset(0);
        make.height.mas_equalTo(kItemHeight);
        make.centerY.mas_equalTo(0);
        make.width.equalTo(self.sortItem.mas_height);
    }];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(kItemHeight);
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.homeItem mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(0);
        make.height.mas_equalTo(kItemHeight);
        make.centerY.mas_equalTo(0);
        make.width.equalTo(self.homeItem.mas_height);
    }];
    
    [self.scanItem mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(kItemHeight);
        make.width.equalTo(self.homeItem.mas_height);
    }];
    
}

- (void)animateionWithForceToNormal:(BOOL)forceToNormal {
    
    if (forceToNormal) {
        if (!_isAnimation&&!_isTitleAtMiddle) {
            _isAnimation = YES;
            [self animateToNormal];
        }
        if (!_hideOfSubItems) {
            [self animateionToHideSubItems];
        }
        return;
    }
    
    if (!_isAnimation) {
        _isAnimation = YES;
        if (_isTitleAtMiddle) {
            [self animateToLeft];
        }else{
            [self animateToNormal];
        }
    }
}

- (void)animateToNormal {
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(kItemHeight);
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    }];
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        
        [self layoutIfNeeded];
        //        self.scanItem.hidden = NO;
        //        self.homeItem.hidden = NO;
        self.homeItem.alpha = 1;
        self.scanItem.alpha = 1;
        self.sortItem.alpha = 0;
        self.refreshItem.alpha = 0;
        _subTitleLabel.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        _isAnimation = NO;
        _isTitleAtMiddle = YES;
        //        self.sortItem.hidden = YES;
        //        self.refreshItem.hidden = YES;
        //        self.topViewStstus = SACardInfoTopViewStatusNormal;
    }];
    
}

- (void)animateToLeft {
    
    if (!_hideOfSubItems) {
        [self resetSubItemsAlphaWithAlpha:0];
        //        [self resetSubItemsStateWithState:YES];
        //        self.titleLabel.hidden = NO;
        self.titleLabel.alpha = 1;
        self.subTitleLabel.alpha = 1;
    }
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_offset(0);
        make.centerY.mas_offset(0);
        make.height.mas_offset(kItemHeight);
    }];
    [UIView animateWithDuration:kAnimationDuration animations:^{
        
        [self layoutIfNeeded];
        //        self.sortItem.hidden = NO;
        //        self.refreshItem.hidden = NO;
        self.homeItem.alpha = 0;
        self.scanItem.alpha = 0;
        self.sortItem.alpha = 1;
        self.refreshItem.alpha = 1;
        _subTitleLabel.alpha = 0;
    } completion:^(BOOL finished) {
        
        _isTitleAtMiddle = NO;
        _isAnimation = NO;
        //        self.scanItem.hidden = YES;
        //        self.homeItem.hidden = YES;
        //        self.topViewStstus = SACardInfoTopViewStatusDidAppear;
    }];
    
}

- (void)resetSubItemsAlphaWithAlpha:(CGFloat)alpha {
    
    [self.subItemList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //        [obj setHidden:state];
        [obj setAlpha:alpha];
    }];
    
}

- (void)animateionToHideSubItems {
    
    [self resetSubItemsAlphaWithAlpha:0];
    //    [self resetSubItemsStateWithState:YES];
    //    self.titleLabel.hidden = NO;
    //    self.homeItem.hidden = NO;
    self.titleLabel.alpha = 1;
    self.homeItem.alpha = 1;
    self.subTitleLabel.alpha = 1;
    _hideOfSubItems = YES;
}

- (void)updateSubViewsWithProgress:(CGFloat)progress {
    
    //    self.titleLabel.alpha = 1-progress;
    _subTitleLabel.alpha = 1-progress;
    self.homeItem.alpha = 1-progress;
    //    [self resetSubItemsStateWithState:1];
    [self resetSubItemsAlphaWithAlpha:progress];
    self.scanItem.alpha = 1-progress;
    self.refreshItem.alpha = progress;
    self.sortItem.alpha = progress;
//    CGFloat width = [SACardAssistKit cardFrame].width/2.0;
    //    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.leading.mas_offset(0);
    //        make.centerY.mas_offset(0);
    //        make.height.mas_offset(kItemHeight);
    //    }];
}

#pragma mark-
#pragma mark-   setter and getter
- (UIButton *)homeItem {
    if (!_homeItem) {
        _homeItem = [UIButton buttonWithType:UIButtonTypeCustom];
        _homeItem.tag = kHomeItemTag;
        [_homeItem setImage:[UIImage imageNamed:@"nav_more"] forState:UIControlStateNormal];
        [_homeItem setImage:[UIImage imageNamed:@"nav_moreCur"] forState:UIControlStateHighlighted];
        [_homeItem addTarget:self action:@selector(didClickHomeItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _homeItem;
}

- (UIButton *)scanItem {
    if (!_scanItem) {
        _scanItem = [UIButton buttonWithType:UIButtonTypeCustom];
        _scanItem.tag = kScanItemTag;
        [_scanItem setImage:[UIImage imageNamed:@"nav_scanning"] forState:UIControlStateNormal];
        [_scanItem setImage:[UIImage imageNamed:@"nav_scanningCur"] forState:UIControlStateHighlighted];
        [_scanItem addTarget:self action:@selector(didClickScanItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanItem;
}

- (UIButton *)sortItem {
    if (!_sortItem) {
        _sortItem = [UIButton buttonWithType:UIButtonTypeCustom];
        _sortItem.tag = kSortItemTag;
        //        _sortItem.hidden = YES;
        _sortItem.alpha = 0;
        [_sortItem setImage:[UIImage imageNamed:@"nav_sort"] forState:UIControlStateNormal];
        [_sortItem setImage:[UIImage imageNamed:@"nav_sortCur"] forState:UIControlStateHighlighted];
        [_sortItem addTarget:self action:@selector(didClickSortItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sortItem;
}

- (UIButton *)refreshItem {
    if (!_refreshItem) {
        _refreshItem = [UIButton buttonWithType:UIButtonTypeCustom];
        _refreshItem.tag = kRefreshItemTag;
        //        _refreshItem.hidden = YES;
        _refreshItem.alpha = 0;
        [_refreshItem setImage:[UIImage imageNamed:@"nav_refresh"] forState:UIControlStateNormal];
        [_refreshItem setImage:[UIImage imageNamed:@"nav_refreshCur"] forState:UIControlStateHighlighted];
        [_refreshItem addTarget:self action:@selector(didClickRefreshItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshItem;
}

- (NSMutableArray *)subItemList {
    if (!_subItemList) {
        _subItemList = [NSMutableArray arrayWithCapacity:self.countOfSubItems];
    }
    return _subItemList;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:21];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.font = [UIFont systemFontOfSize:12];
        _subTitleLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subTitleLabel;
}

- (void)setShouldHaveSubTitle:(BOOL)shouldHaveSubTitle {
    _shouldHaveSubTitle = shouldHaveSubTitle;
    if (shouldHaveSubTitle) {
        if (!_subTitleLabel) {
            [self addSubview:self.subTitleLabel];
            [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerX.mas_equalTo(0);
                make.top.equalTo(self.titleLabel.mas_bottom).offset(2.5*[SACardAssistKit cardFrame].height/517.5);
                make.height.mas_equalTo(12*[SACardAssistKit cardFrame].height/517.5);
            }];
        }else{
            self.subTitleLabel.hidden = NO;
            //            self.subTitleLabel.alpha = 1;
        }
    }else{
        self.subTitleLabel.hidden = YES;
        //        self.subTitleLabel.alpha = 0;
    }
}

@end
