//
//  SAMenuView.h
//  SAKitDemo
//
//  Created by 学宝 on 2016/10/29.
//  Copyright © 2016年 学宝工作室. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SAMenuViewDelegate;
/**
 *  @author 学宝, 16-10-29 11:10
 *
 *  @brief 定制的菜单视图，样式基本定死，该视图的展现，需要传入对应的image。
 *              点击左边的按钮，会展开你设置(ExpandButton)的按钮
 *
 *  @since 1.0
 */
@interface SAMenuView : UIView
@property (nonatomic, weak) id<SAMenuViewDelegate> delegate;

/**
 *  @author 学宝, 16-10-29 13:10
 *
 *  @brief 配置左右按钮图片
 *
 *  @param leftItemNormalImage    左 正常状态时的image
 *  @param leftItemSelectedImage  左 点击状态时的image
 *  @param rightItemNormalImage   右 正常状态时的image
 *  @param rightItemSelectedImage 右 点击状态时的image
 *
 *  @since 1.0
 */
- (void)setLeftItemNormalImage:(UIImage *)leftItemNormalImage leftItemSelectedImage:(UIImage *)leftItemSelectedImage rightItemNormalImage:(UIImage *)rightItemNormalImage rightItemSelectedImage:(UIImage *)rightItemSelectedImage;

/**
 *  @author 学宝, 16-10-29 13:10
 *
 *  @brief 配置点击 左 按钮后，出现的按钮
 *
 *  @param normalImageArray 展开按钮正常状态时的image集合
 *  @param selectImageArray 展开按钮选中状态时的image集合
 *  @warning normalImageArray 和 selectImageArray 必须都是image集合，且数量要相等
 *  @since 1.0
 */
- (void)setExpandItemNormalImageArray:(NSArray<UIImage *> *)normalImageArray selectImageArray:(NSArray<UIImage *> *)selectImageArray;

/**
 *  @author 学宝, 16-10-29 13:10
 *
 *  @brief 菜单视图的全局单例
 *
 *  @return 单例对象
 *
 *  @since 1.0
 */
//+ (SAMenuView *)shareInstance;

- (void)reset;
@end

@protocol SAMenuViewDelegate <NSObject>

/**
 *  @author 学宝, 16-10-29 13:10
 *
 *  @brief 展开按钮的点击事件
 *
 *  @param menuView 菜单视图
 *  @param index    从左至右的次序
 *
 *  @since 1.0
 */
- (void)menuView:(SAMenuView *)menuView didPressMenuItemAtIndex:(NSUInteger)index;

/**
 *  @author 学宝, 16-10-29 13:10
 *
 *  @brief 点击右侧按钮
 *
 *  @param menuView 菜单视图
 *
 *  @since 1.0
 */
- (void)didPressRightItemInMenuView:(SAMenuView *)menuView;

@end
