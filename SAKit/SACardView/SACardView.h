//
//  SACardView.h
//  SAKitDemo
//
//  Created by 学宝 on 16/9/1.
//  Copyright © 2016年 学宝工作室. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, SACardBottomBarStyle) {
    /**SAPageControl样式**/
    SACardBottomBarStylePageControl,
    /**空白**/
    SACardBottomBarStyleNone,
};

typedef NS_ENUM(NSInteger, SACardViewType) {
    /**多页， 默认为multiPage **/
    SACardViewTypeMultiPage,
    /**单页**/
    SACardViewTypeSinglePage
};

@protocol SACardViewAccessoryProtocol;
@protocol SACardViewDataSource;
@protocol SACardViewDelegate;

/**
 *  @author 学宝, 16-11-08 22:11
 *
 *  @brief 卡片视图
 */
@interface SACardView : UIView

@property (nonatomic, weak) id<SACardViewDataSource>dataSource;

@property (nonatomic, weak) id<SACardViewDelegate>delegate;

/**
 *  @author 学宝, 16-11-08 23:11
 *
 *  @brief 卡片视图的样式，默认SACardViewTypeMultiPage
 */
@property (nonatomic, assign) SACardViewType cardViewType;

@property (nonatomic, assign, readonly) NSUInteger currentIndex;


- (void)reloadData;

- (void)reloadCardsAtIndexs:(NSArray<NSNumber *> *)indexs completion:(void (^)(BOOL finished))completion;

- (void)deleteCardsAtIndexs:(NSArray<NSNumber *> *)indexs completion:(void (^)(BOOL finished))completion;

- (UICollectionViewCell *)cellForItemAtIndex:(NSUInteger)index;

- (void)scrollToCardAtIndex:(NSUInteger)index;

/*! 设置cardView是否能够滑动*/
- (void)setScrollViewScrollEnabled:(BOOL)enable;

/**
 *  @author 学宝, 16-11-08 21:11
 *
 *  @brief SACardBottomBarStyle 为SACardBottomBarStylePageControl 时，设置pageControl的总页数
 *
 *  @param pageTotalCount 总页数
 *
 *  @warning 考虑到分页的情况，统一手动设定（必须）
 *
 */
- (void)setPageControlTotalCount:(NSUInteger)pageTotalCount;

/**
 *  @author 学宝, 16-11-08 22:11
 *
 *  @brief 添加实现SACardViewAccessoryProtocol的对象，主要是考虑到交互渐变效果，与cardView之外视图的解耦
 *
 *  @param accessoryObject 实现SACardViewAccessoryProtocol的对象
 *
 */
- (void)addCardViewAccessoryObject:(id<SACardViewAccessoryProtocol>)accessoryObject;

- (void)resetCardViewStatusToNormal;
@end

@protocol SACardViewDataSource <NSObject>

@optional

/************************************************************************************
************************* SACardViewTypeMultiPage（多页）时 *************************
************************************************************************************/

/**
 *  @author 学宝, 16-11-08 22:11
 *
 *  @brief SACardViewTypeMultiPage时，必须实现！！！ 设置加载的卡片cell数量
 *
 *  @return 卡片cell数量
 *
 */
- (NSUInteger)numberOfCollectionViewCellInCardView:(SACardView *)cardView;

/**
 *  @author 学宝, 16-11-08 22:11
 *
 *  @brief SACardViewTypeMultiPage时，配置正面卡片的cell类
 *
 *  @return 正面cell的class
 *
 *  @since 1.0
 */
- (Class)collectionCellClassInCardView:(SACardView *)cardView;

/**
 *  @author 学宝, 16-11-08 22:11
 *
 *  @brief SACardViewTypeMultiPage时，配置反面卡片的cell类，反面卡片的cell配置后，双击卡片，正反面卡片将会轮回交替
 *
 *  @return 反面cell的class
 *
 */
- (Class)collectionBackCellClassInCardView:(SACardView *)cardView;

/**
 *  @author 学宝, 16-11-08 22:11
 *
 *  @brief SACardViewTypeMultiPage时，你应该必须实现，不然你用这个很让人费解，通过此方法，配置你个性化的视图，这个cell的class是你通过上面一个或两个数据源方法配置的，若没配置，默认为[UICollectionViewCell class]
 *
 *  @param collectionViewCell 你需要配置的cell，
 *  @param index              卡片cell的索引
 *
 *  @return 个性化之后的cell
 *
 */
- (UICollectionViewCell *)cardView:(SACardView *)cardView cellForDeployCollectionViewCell:(UICollectionViewCell *)collectionViewCell index:(NSUInteger)index;



/************************************************************************************
 ************************* SACardViewTypeSinglePage（单页）时 ************************
 ************************************************************************************/

/**
 *  @author 学宝, 16-11-08 22:11
 *
 *  @brief  SACardViewTypeSinglePage时，配置正面卡片视图
 *
 *  @return 正面卡片内容视图
 */
- (UIView *)frontViewInSingleCardView:(SACardView *)singleCardView;

/**
 *  @author 学宝, 16-11-08 22:11
 *
 *  @brief SACardViewTypeSinglePage时，配置反面卡片视图。反面视图配置后，双击卡片，正反面卡片将会轮回交替
 *
 *  @return 反面卡片内容视图
 */
- (UIView *)backViewInSingleCardView:(SACardView *)singleCardView;



/************************************************************************************
 **************************************  通  用  ***************************************
 ************************************************************************************/

/**
 *  @author 学宝, 16-11-08 22:11
 *
 *  @brief  index索引所对应的卡片顶部视图（下拉出来的视图），是否显示，默认不显示
 *
 *  @param index    卡片索引
 *
 *  @return 是否显示
 */
- (BOOL)cardView:(SACardView *)cardView shouldShowHeaderViewAtIndex:(NSUInteger)index;

/**
 *  @author 学宝, 16-11-08 22:11
 *
 *  @brief index索引所对应的卡片顶部视图（下拉出来的视图），交给具体业务自定义
 *
 *  @param index    卡片索引
 *
 *  @return 卡片顶部视图
 */
- (UIView *)cardView:(SACardView *)cardView headerViewAtIndex:(NSUInteger)index;

/**
 *  @author 学宝, 16-11-08 22:11
 *
 *  @brief index索引所对应的卡片底部视图（上拉出来的视图），是否显示，默认不显示
 *
 *  @param index    卡片索引
 *
 *  @return 是否显示
 */
- (BOOL)cardView:(SACardView *)cardView shouldShowFooterViewAtIndex:(NSUInteger)index;

/**
 *  @author 学宝, 16-11-08 22:11
 *
 *  @brief index索引所对应的卡片底部视图（上拉出来的视图），给具体业务自定义
 *
 *  @param index    卡片索引
 *
 *  @return 卡片底部视图
 */
- (UIView *)cardView:(SACardView *)cardView footerViewAtIndex:(NSUInteger)index;

/**
 *  @author 学宝, 16-11-08 22:11
 *
 *  @brief 配置底部默认视图样式（无需拉动，正常显示时的底部视图），目前只支持PageControl和不存在底部默认视图
 *
 *  @return 底部默认视图样式
 */
- (SACardBottomBarStyle)bottomBarStyleInCardView:(SACardView *)cardView;

/**
 *  @author 学宝, 16-11-08 22:11
 *
 *  @brief 是否存在长按手势，是dataSource(shouldResponseLongPressGestureAtIndex:)和delegate(didLongPressGestureAtIndex:)的前提
 *
 *  @return 是否存在长按手势
 */
- (BOOL)isExistLongPressGestureInCardView:(SACardView *)cardView;

/**
 *  @author 学宝, 16-11-08 22:11
 *
 *  @brief 存在长按手势的情况下，根据不同index设置cardView是否响应长按手势，这是delegate(didLongPressGestureAtIndex:)的前提
 *
 *  @param index    卡片cell的索引
 *
 *  @return 是在允许响应长按手势
 */
- (BOOL)cardView:(SACardView *)cardView shouldResponseLongPressGestureAtIndex:(NSUInteger)index;

@end

@protocol SACardViewDelegate <NSObject>

@optional

/**
 *  @author 学宝, 16-11-08 22:11
 *
 *  @brief SACardViewTypeMultiPage(多页)时，左右滑动减速停止时(滑动结束)的回调方法
 *
 *  @param index    左右滑动结束时，卡片cell的位置
 */
- (void)cardView:(SACardView *)cardView didEndDeceleratingAtIndex:(NSUInteger)index;

/**
 *  @author 学宝, 16-11-08 22:11
 *
 *  @brief 长按卡片视图的回调方法，需要依赖dataSource的([isExistLongPressGestureInCardView:] && [shouldResponseLongPressGestureAtIndex:]
 *
 *  @param index    长按卡片视图时，卡片视图的位置
 */
- (void)cardView:(SACardView *)cardView didLongPressGestureAtIndex:(NSUInteger)index;

/**
 *  @author 学宝, 16-11-08 22:11
 *
 *  @brief  SACardBottomBarStylePageControl 时，此回调方法准确的来说，应该是pageControl的回调，在完成pageControl的滑动后，会触发
 *
 *  @param index    滑动到的位置序列
 */
- (void)cardView:(SACardView *)cardView didScrollPageControlToIndex:(NSUInteger)index;

@end

@protocol SACardViewAccessoryProtocol <NSObject>

@optional
- (void)cardViewScrollingByProgress:(CGFloat)progress;

- (void)cardViewScrollDidEndByIsNormal:(BOOL)isNormal;

@end