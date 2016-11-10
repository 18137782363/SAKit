//
//  SACardCollectionViewLayout.h
//  SABaseViewDemo
//
//  Created by 阿宝 on 16/8/26.
//  Copyright © 2016年 浙江网仓科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SACardCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, assign) CGFloat innerHorizontalSpace;

@property (nonatomic, assign) CGFloat innerTopSpace;

@property (nonatomic, assign) CGFloat innerBottomSpace;

@property (nonatomic, assign) NSInteger visibleCount;

@end
