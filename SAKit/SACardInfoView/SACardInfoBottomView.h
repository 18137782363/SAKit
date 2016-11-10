//
//  SACardInfoBottomView.h
//  SACardInfoView
//
//  Created by 汪志刚 on 2016/10/10.
//  Copyright © 2016年 ISCScom.cn.iscs.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SACardInfoBottomView : UIView

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIView *itemContentView;

@property (nonatomic, assign) NSInteger itemNum;

@property (nonatomic, strong) NSArray <UIImage *>*itemNormalImageArray;
@property (nonatomic, strong) NSArray <UIImage *>*itemHighLightedImageArray;


@end
