//
//  SANavigationController.h
//  SAKitDemo
//
//  Created by 学宝 on 16/6/7.
//  Copyright © 2016年 学宝工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SACardView.h"


typedef void(^SANavigationDidSelectMenuBlock)(NSUInteger index);
typedef void(^SANavigationDidSelectScanBlock)();
typedef void(^SANavigationDidSelectBackButtonBlock)(UIViewController *currentViewController);

@interface SANavigationController : UINavigationController<SACardViewAccessoryProtocol>

@property (nonatomic, copy) SANavigationDidSelectMenuBlock didSelectMenuBlock;
@property (nonatomic, copy) SANavigationDidSelectScanBlock didSelectScanBlock;
@property (nonatomic, copy) SANavigationDidSelectBackButtonBlock didSelectBackButtonBlock;

- (void)addMenuViewWithLeftItemNormalImage:(UIImage *)leftItemNormalImage leftItemSelectedImage:(UIImage *)leftItemSelectedImage rightItemNormalImage:(UIImage *)rightItemNormalImage rightItemSelectedImage:(UIImage *)rightItemSelectedImage expandItemNormalImageArray:(NSArray <UIImage *>*)expandItemNormalImageArray expandSelectImageArray:(NSArray <UIImage *>*)expandSelectImageArray;

- (void)addBackButtonWithNormalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage;

@property (nonatomic, assign) BOOL hiddenBackButton;

@property (nonatomic, assign) BOOL hiddenMenuView;

@end

//是否可返回