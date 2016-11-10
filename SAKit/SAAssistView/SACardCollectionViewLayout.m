//
//  SACardCollectionViewLayout.m
//  SABaseViewDemo
//
//  Created by 阿宝 on 16/8/26.
//  Copyright © 2016年 浙江网仓科技有限公司. All rights reserved.
//

#import "SACardCollectionViewLayout.h"

@implementation SACardCollectionViewLayout {
    CGFloat _viewWidth;
    CGFloat _itemWidth;
}

- (void)prepareLayout {
    [super prepareLayout];
    if (self.visibleCount < 1) {
        self.visibleCount = 3;
    }
    _viewWidth =  CGRectGetWidth(self.collectionView.frame);
    _itemWidth = CGRectGetWidth(self.collectionView.frame) - 2 * self.innerHorizontalSpace;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake([self.collectionView numberOfItemsInSection:0] * _viewWidth, CGRectGetHeight(self.collectionView.frame));
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    CGFloat centerX = self.collectionView.contentOffset.x;
    NSInteger index = centerX / _itemWidth;
    NSInteger count = (self.visibleCount - 1) / 2;
    NSInteger minIndex = MAX(0, (index - count));
    NSInteger maxIndex = MIN((cellCount - 1), (index + count));
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = minIndex; i <= maxIndex; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [array addObject:attributes];
    }
    return array;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = CGSizeMake(_itemWidth, CGRectGetHeight(self.collectionView.bounds) - self.innerTopSpace - self.innerBottomSpace);
    CGFloat cX =  self.collectionView.contentOffset.x + _viewWidth / 2;
    CGFloat attributesX = _viewWidth * indexPath.item + _viewWidth / 2;
    attributes.zIndex = -fabs(attributesX - cX);
    
    CGFloat delta = cX - attributesX;
//    NSLog(@"delta : %f",delta);
    CGFloat ratio =  - delta / (_itemWidth * 2);
    CGFloat scale = 1 - ABS(delta) / (_itemWidth * 8.0) * cos(ratio * M_PI_4);
    attributes.transform = CGAffineTransformMakeScale(scale, scale);
    attributes.center = CGPointMake(attributesX, CGRectGetHeight(self.collectionView.frame) / 2 + (self.innerTopSpace - self.innerBottomSpace)/2);
//    NSLog(@"center: %@",NSStringFromCGPoint(attributes.center));
    return attributes;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGFloat index = roundf(proposedContentOffset.x / _viewWidth);
//    NSLog(@"index: %f---proposedContentOffset.x===%f",index,proposedContentOffset.x);
    proposedContentOffset.x = _viewWidth * index + _viewWidth / 2 - _itemWidth / 2;
    return proposedContentOffset;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return !CGRectEqualToRect(newBounds, self.collectionView.bounds);
}

@end
