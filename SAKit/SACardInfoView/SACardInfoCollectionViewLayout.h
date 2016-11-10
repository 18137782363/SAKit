//
//  SACardInfoCollectionViewLayout
//
//  Created by ZG on 16/6/9.
//  Copyright © 2016年 ZG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SACardInfoCollectionViewLayout : UICollectionViewLayout

@property (nonatomic) CGFloat minimumLineSpacing; //行间距

@property (nonatomic) CGFloat minimumInteritemSpacing; //item间距

@property (nonatomic) CGSize itemSize; //item大小

@property (nonatomic) UIEdgeInsets sectionInset;

- (instancetype)init;

@end
