//
//  SACardInfoViewManager.h
//  SACardInfoView
//
//  Created by 汪志刚 on 2016/10/10.
//  Copyright © 2016年 ISCScom.cn.iscs.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SACardInfoTopView.h"
#import "SACardInfoBottomView.h"

typedef NS_ENUM(NSInteger, SACardInfoBottomViewStatus) {
    
    SACardInfoBottomViewStatusNormal,
    SACardInfoBottomViewStatusDidAppear,
    
};


@interface SACardInfoViewManager : NSObject

@property (nonatomic, strong) SACardInfoTopView *topView;
@property (nonatomic, strong) SACardInfoBottomView *bottomView;

@property (nonatomic, assign) SACardInfoBottomViewStatus bottomViewStatus;
@property (nonatomic, copy) void(^pageDidChange)(NSInteger currentPage);

- (void)updateTopViewUIWithProgress:(CGFloat)progress;
- (void)startTopViewAnimationWithForceToNormal:(BOOL)ForceToNormal;

- (void)updateBottomViewUIWithProgress:(CGFloat)progress;
- (void)animationToupdateBottomViewUIWithRevertToNormal:(BOOL)revertToNormal;



- (void)setupSubviewContraintsWithSuperview:(UIView *)superView;

@end
