//
//  SACardInfoViewManager.m
//  SACardInfoView
//
//  Created by 汪志刚 on 2016/10/10.
//  Copyright © 2016年 ISCScom.cn.iscs.www. All rights reserved.
//

#import "SACardInfoViewManager.h"
#import <Masonry/Masonry.h>
#import "SACardAssistKit.h"

@implementation SACardInfoViewManager

- (void)setupSubviewContraintsWithSuperview:(UIView *)superView {
    
    if ([SACardAssistKit cardFrame].topEdgeSpace < 50.0f) {
        
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([SACardAssistKit cardFrame].leftEdgeSpace);
            make.height.mas_equalTo(60.0f);
            make.top.equalTo(superView);
            make.centerX.equalTo(superView);
        }];
        
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([SACardAssistKit cardFrame].leftEdgeSpace);
            make.height.mas_equalTo(60.0f);
            make.bottom.mas_equalTo(0);
            make.centerX.equalTo(superView);
        }];
        
    }else {
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superView).offset(20.0);
            make.left.mas_equalTo([SACardAssistKit cardFrame].leftEdgeSpace);
            make.height.mas_equalTo([SACardAssistKit cardFrame].topEdgeSpace-20.0);
            make.centerX.equalTo(superView);
        }];
        
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo([SACardAssistKit cardFrame].leftEdgeSpace);
            make.height.mas_equalTo([SACardAssistKit cardFrame].bottomEdgeSpace);
            make.centerX.equalTo(superView);
        }];
    }
}

- (void)startTopViewAnimationWithForceToNormal:(BOOL)ForceToNormal {
    
    [self.topView animateionWithForceToNormal:ForceToNormal];
    [self animationToupdateBottomViewUIWithRevertToNormal:YES];
}

- (void)animationToupdateBottomViewUIWithRevertToNormal:(BOOL)revertToNormal {
    
    switch (self.bottomViewStatus) {
            
        case SACardInfoBottomViewStatusDidAppear:{
            
            self.bottomViewStatus = SACardInfoBottomViewStatusNormal;
            
        }
            break;
        case SACardInfoBottomViewStatusNormal:{
            
            self.bottomViewStatus = revertToNormal?SACardInfoBottomViewStatusNormal:SACardInfoBottomViewStatusDidAppear;
            
        }
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        if (self.bottomViewStatus == SACardInfoBottomViewStatusDidAppear) {
            self.bottomView.itemContentView.alpha = 1;
            self.bottomView.pageControl.alpha = 0;
        }
        if (self.bottomViewStatus == SACardInfoBottomViewStatusNormal) {
            self.bottomView.itemContentView.alpha = 0;
            self.bottomView.pageControl.alpha = 1;
        }
    }];
}

- (void)updateTopViewUIWithProgress:(CGFloat)progress {
    
    progress =  progress > 1 ? 1 : progress;
    if (self.topView.topViewStstus == SACardInfoTopViewStatusNormal) {
        [self.topView updateSubViewsWithProgress:progress];
    }
}

- (void)updateBottomViewUIWithProgress:(CGFloat)progress {
    progress =  progress > 1 ? 1 : progress;
    if (self.bottomViewStatus == SACardInfoBottomViewStatusNormal) {
        self.bottomView.itemContentView.alpha = progress;
        self.bottomView.pageControl.alpha = 1-progress;
    }
}

- (void)pageDidChaged:(UIPageControl *)pageControl {
    
    if (self.pageDidChange) {
        self.pageDidChange(pageControl.currentPage);
    }
}

#pragma mark-
#pragma mark-   setter and getter
- (SACardInfoTopView *)topView {
    if (!_topView) {
        _topView = [SACardInfoTopView new];
        _topView.itemNormalImageArray = @[[UIImage imageNamed:@"nav_task"],[UIImage imageNamed:@"nav_message"],[UIImage imageNamed:@"nav_team"],[UIImage imageNamed:@"nav_me"]];
        _topView.itemHighLightedImageArray = @[[UIImage imageNamed:@"nav_taskCur"],[UIImage imageNamed:@"nav_messageCur"],[UIImage imageNamed:@"nav_teamCur"],[UIImage imageNamed:@"nav_meCur"]];
    }
    return _topView;
}

- (SACardInfoBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [SACardInfoBottomView new];
        _bottomView.pageControl.numberOfPages = 3;
        [_bottomView.pageControl addTarget:self action:@selector(pageDidChaged:) forControlEvents:UIControlEventValueChanged];
    }
    return _bottomView;
}

@end
