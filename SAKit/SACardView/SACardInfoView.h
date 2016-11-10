//
//  SACardInfoView.h
//  SACardInfoView
//
//  Created by 汪志刚 on 2016/10/9.
//  Copyright © 2016年 ISCScom.cn.iscs.www. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSInteger const kHomeItemTag     = 100;
static NSInteger const kScanItemTag     = 101;

static NSInteger const kTaskItemTag     = 102;
static NSInteger const kMessageItemTag  = 103;
static NSInteger const kTeamItemTag     = 104;
static NSInteger const kMeItemTag       = 105;

static NSInteger const kSortItemTag     = 106;
static NSInteger const kRefreshItemTag  = 107;

@protocol SACardInfoViewDelegate;
@protocol SACardInfoViewDataSource;

@interface SACardInfoView : UIView

@property (nonatomic, assign) id<SACardInfoViewDelegate>delegate;
@property (nonatomic, assign) id<SACardInfoViewDataSource>dataSource;

@property (nonatomic, assign) BOOL existBackBtn;
@property (nonatomic, assign) BOOL vertScrollEnabled;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, assign) BOOL shouldHaveSubTitle;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign, readonly) NSInteger pageCount;


- (UIView *)viewInTopViewAtIndex:(NSInteger)index;

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index;

- (void)reloadInfoView;

- (void)resetTopAndBottomViewToNormal;

- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated;

@end

@protocol SACardInfoViewDataSource <NSObject>

- (NSInteger)numberOfItemsInCardInfoView:(SACardInfoView *)cardInfoView;

- (UICollectionViewCell *)cardInfoView:(SACardInfoView *)cardInfoView cellForDeployCardInfoViewCell:(UICollectionViewCell *)deployCell atIndex:(NSInteger)index;

@optional

- (UIView *)firstPageViewInCardInfoView:(SACardInfoView *)cardInfoView;

- (Class)classOfCollectionViewCellInCardInfoView:(SACardInfoView *)cardInfoView;

@end

@protocol SACardInfoViewDelegate <NSObject>

@optional

- (void)didPressBackButtonInCardInfoView:(SACardInfoView *)singleCardView;

- (void)cardInfoView:(SACardInfoView *)cardInfoView didSelectedItemAtIndex:(NSInteger)index;

- (void)cardInfoView:(SACardInfoView *)cardInfoView didSelectedItemInTopViewAtIndex:(NSInteger)index;
@end

