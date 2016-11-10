//
//  SACardSingleView.h
//  SAKitDemo
//
//  Created by 学宝 on 16/9/20.
//  Copyright © 2016年 学宝工作室. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SACardSingleViewType) {
    SACardSingleViewNone,
};

@protocol SACardSingleViewDataSource;
@protocol SACardSingleViewDelegate;
@interface SACardSingleView : UIView
@property (nonatomic, weak) id<SACardSingleViewDataSource> dataSource;
@property (nonatomic, weak) id<SACardSingleViewDelegate> delegate;

@property (nonatomic, assign) BOOL existMenuView;

@property (nonatomic, assign) BOOL existBackBtn;

@property (nonatomic, assign) BOOL scrollEnabled;

- (void)realodData;

@end

@protocol SACardSingleViewDataSource <NSObject>

@required
- (UIView *)frontViewInSingleCardView:(SACardSingleView *)singleCardView;

@optional

- (BOOL)shouldShowBackViewInSingleCardView:(SACardSingleView *)singleCardView;

- (UIView *)backViewInSingleCardView:(SACardSingleView *)singleCardView;

- (BOOL)shouldShowHeaderViewInSingleCardView:(SACardSingleView *)singleCardView;

- (UIView *)headerViewInSingleCardView:(SACardSingleView *)singleCardView;

- (BOOL)shouldShowFooterViewInSingleCardView:(SACardSingleView *)singleCardView;

- (UIView *)footerViewInSingleCardView:(SACardSingleView *)singleCardView;

- (BOOL)shouldShowFooterBackViewInSingleCardView:(SACardSingleView *)singleCardView;

- (UIView *)footerBackViewInSingleCardView:(SACardSingleView *)singleCardView;

@end

@protocol SACardSingleViewDelegate <NSObject>

@optional

- (void)didPressBackButtonInSingleCardView:(SACardSingleView *)singleCardView;

- (BOOL)shouldLongPressForScanCodeInSingleCardView:(SACardSingleView *)singleCardView;

- (void)singleCardView:(SACardSingleView *)singleCardView scanningOfResultCode:(NSString *)scanCode;

@end
