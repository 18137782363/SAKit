//
//  SACardAssistView.h
//  SABaseViewDemo
//
//  Created by 阿宝 on 16/8/27.
//  Copyright © 2016年 浙江网仓科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SACardAssistViewDelegate;

typedef NS_ENUM(NSInteger, SACardAssistType) {
    SACardAssistTypeTop,
    SACardAssistTypeBottom
};

@interface SACardAssistView : UIView

@property (nonatomic, weak) id<SACardAssistViewDelegate>delegate;

@property (nonatomic, assign) SACardAssistType type;

- (instancetype)initWithButtonArray:(NSArray<UIButton *> *)buttonArray type:(SACardAssistType)type;

- (instancetype)initWithButtonImageNames:(NSArray<NSString *> *)btnNames type:(SACardAssistType)type;

@end


@protocol SACardAssistViewDelegate <NSObject>

- (void)cardAssistView:(SACardAssistView *)cardAssistView didPressItemButtonAtIndex:(NSUInteger)index;



@end