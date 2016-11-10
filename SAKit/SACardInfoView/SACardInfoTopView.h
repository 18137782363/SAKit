//
//  SACardInfoTopView.h
//  SACardInfoView
//
//  Created by 汪志刚 on 2016/10/10.
//  Copyright © 2016年 ISCScom.cn.iscs.www. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, SACardInfoTopViewStatus) {
    
    SACardInfoTopViewStatusNormal,
    SACardInfoTopViewStatusDidAppear
};

@interface SACardInfoTopView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, assign) NSInteger countOfSubItems;
@property (nonatomic, assign) BOOL shouldHaveSubTitle;

@property (nonatomic, assign) SACardInfoTopViewStatus topViewStstus;

@property (nonatomic, strong) NSArray <UIImage *>*itemNormalImageArray;
@property (nonatomic, strong) NSArray <UIImage *>*itemHighLightedImageArray;

@property (nonatomic, copy) void(^didClickItemBlock)(NSInteger index);

- (void)animateionWithForceToNormal:(BOOL)forceToNormal;

- (void)updateSubViewsWithProgress:(CGFloat)progress;
@end
