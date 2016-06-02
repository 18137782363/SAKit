//
//  SAMutilSelectedView.h
//  SAMutilSelectedView
//
//  Created by WZG on 16/4/25.
//  Copyright © 2016年 浙江网仓科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAMutilSelectedItem.h"

@protocol SAMutilSelectedViewDelegate;

typedef NS_ENUM(NSInteger,SACoreSelectedItemAlignment) {
    
    //  ********  圆弧形  ********//
    SACoreSelectedItemAlignmentCenter = 0,      //  默认，此模式下的 itemsAngle 不可变
    SACoreSelectedItemAlignmentBottomAndLeft,   //  此模式下的 itemsAngle 默认为90
    SACoreSelectedItemAlignmentBottomAndRight,  //  同上
    SACoreSelectedItemAlignmentBottomAndCenter, //  此模式下的 itemsAngle 不可变
    SACoreSelectedItemAlignmentTopAndLeft,      //  此模式下的 itemsAngle 默认为90
    SACoreSelectedItemAlignmentTopAndRight,     //  同上
    SACoreSelectedItemAlignmentTopAndCenter,    //  此模式下的 itemsAngle 不可变
    
    //  ********  直线型  ********//
    SACoreSelectedItemAlignmentLineLeft,
    SACoreSelectedItemAlignmentLineRight,
    SACoreSelectedItemAlignmentLineTop,
    SACoreSelectedItemAlignmentLineBottom,
    
};

@interface SAMutilSelectedView : UIView

/** item的直径，默认25.0.可以设置所有item的直径，包括coreItem.*/
@property (nonatomic,assign) CGFloat itemDiameter;

/** item和中心item所成的角度,只有在 SACoreSelectedItemAlignment 不为 0,3,6 的时候设置才有效，且大小不能小于90，不能大于180.*/
@property (nonatomic,assign) CGFloat itemsAngle;

/** 动画执行顺序，默认为  顺时针*/
@property (nonatomic,assign) BOOL animationClockwise;

@property (nonnull,nonatomic,assign,) id<SAMutilSelectedViewDelegate>delegate;  

@property (nonatomic,assign) SACoreSelectedItemAlignment coreItemAlignment;

/** 核心item*/
@property (nonnull,nonatomic,strong) SAMutilSelectedItem *coreSelectedItem;

/** SACoreSelectedItemAlignment 为直线型才有值*/
@property (nullable,nonatomic,strong) UIScrollView *bgScrollView;

- (_Nonnull instancetype)initWithCoreSelectedItemAlignment:(SACoreSelectedItemAlignment)coreSelectedItemAlignment;

- (SAMutilSelectedItem * _Nonnull)itemAtIndex:(NSInteger)index;

- (void)close;

- (void)open;

- (void)reloadMutilSelectedView;

@end

@protocol SAMutilSelectedViewDelegate <NSObject>

@required
//  返回个数不能小于2
- (NSInteger)numberOfItemInMutilSelectedView:(SAMutilSelectedView * _Nonnull)mutilSelectedView;

- (SAMutilSelectedItem * _Nonnull)mutilSelectedView:(SAMutilSelectedView * _Nonnull)mutilSelectedView itemAtIndex:(NSInteger)index;

@optional
- (void)mutilSelectedView:(SAMutilSelectedView * _Nonnull)mutilSelectedView didSelectedItemAtIndex:(NSInteger)index;

- (CGSize)mutilSelectedView:(SAMutilSelectedView * _Nonnull)mutilSelectedView sizeForItemAtIndex:(NSInteger)index;

@end
