//
//  SACardView.m
//  SAKitDemo
//
//  Created by 学宝 on 16/9/1.
//  Copyright © 2016年 学宝工作室. All rights reserved.
//

#import "SACardView.h"
#import <Masonry/Masonry.h>
#import "SACardCollectionViewLayout.h"
#import "SACardAssistKit.h"
#import "SAPageControl.h"

typedef NS_ENUM(NSInteger, SACardViewStatus) {
    SACardViewStatusNormal,
    SACardViewStatusHeaderAppear,
    SACardViewStatusFooterAppear,
};

static inline NSString *cardHeaderViewKey(NSUInteger index) {
    return [NSString stringWithFormat:@"com.sakit.cardheaderview.index(%ld).key",(long)index];
};
static inline NSString *cardFooterViewKey(NSUInteger index) {
    return [NSString stringWithFormat:@"com.sakit.cardfooterview.index(%ld).key",(long)index];
};

static NSString *const kCellIdentifier = @"com.sakit.cardCell.identifier";
static NSString *const kBackCellIdentifer = @"com.sakit.cardBackCell.identifer";

static NSInteger const kScrollViewTag = 2012;
static NSInteger const kCollectionTag = 2016;

static CGFloat const kZoomStartOffset = 10.0f;
static CGFloat const kZoomEndOffset = 60.0f;

@interface SACardView ()<UICollectionViewDataSource,UIScrollViewDelegate,UICollectionViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *singleCardContentView;
@property (nonatomic, strong) UIView *singleCardView;
@property (nonatomic, strong) UIView *singleBackCardView;

@property (nonatomic, strong) SACardCollectionViewLayout *collectionViewLayout;

@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic, strong) UILongPressGestureRecognizer *longTap;

@property (nonatomic, assign) SACardBottomBarStyle bottomBarStyle;
@property (nonatomic, assign) SACardViewStatus cardViewStatus;

@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, assign) BOOL shouldShowCurrentHeaderView;
@property (nonatomic, assign) BOOL shouldShowCurrentFooterView;
@property (nonatomic, strong) UIView *currentHeaderView;
@property (nonatomic, strong) UIView *currentFooterView;
@property (nonatomic, strong) NSMutableDictionary *headerViewDictionary;
@property (nonatomic, strong) NSMutableDictionary *footerViewDictionary;

@property (nonatomic, strong) SAPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray<id<SACardViewAccessoryProtocol>> *accessoryArray;

@end

@implementation SACardView {
    BOOL _isInfluenceTopView;
    BOOL _isInfluenceBottomView;
    CGFloat lastOffset;
    BOOL _isCanShowBackView;
    BOOL _isShowInBackView;
    BOOL _changeBackView;
    UICollectionViewCell *_oldCell;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isCanShowBackView = NO;
        _currentIndex = 0;
        _cardViewType = SACardViewTypeMultiPage;
        _cardViewStatus = SACardViewStatusNormal;
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (_dataSource) {
        [self setupDataSourceDataWithDataSource:_dataSource];
    }
}

- (void)setDataSource:(id<SACardViewDataSource>)dataSource {
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        if (self.superview) {
            [self setupDataSourceDataWithDataSource:dataSource];
        }
    }
}

- (void)setupDataSourceDataWithDataSource:(id<SACardViewDataSource>)dataSource {
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self addSubview:self.scrollView];
    
    switch (self.cardViewType) {
        case SACardViewTypeMultiPage:{
            //多个Card
            _bottomBarStyle = SACardBottomBarStylePageControl;

            [self.scrollView addSubview:self.collectionView];
            
            //注册正面Cell
            if ([dataSource respondsToSelector:@selector(collectionCellClassInCardView:)] && [dataSource collectionCellClassInCardView:self] != Nil) {
                [self.collectionView registerClass:[dataSource collectionCellClassInCardView:self] forCellWithReuseIdentifier:kCellIdentifier];
            }else {
                [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
            }
            
            //注册背面Cell
            if ([dataSource respondsToSelector:@selector(collectionBackCellClassInCardView:)] && [dataSource collectionBackCellClassInCardView:self] != Nil) {
                [self.collectionView registerClass:[dataSource collectionBackCellClassInCardView:self] forCellWithReuseIdentifier:kBackCellIdentifer];
                _isCanShowBackView = YES;
                if (![self.collectionView.gestureRecognizers containsObject:self.doubleTap]) {
                    _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
                    self.doubleTap.numberOfTapsRequired = 2;
                    [self.collectionView addGestureRecognizer:self.doubleTap];
                }
            }
            
            if ([dataSource respondsToSelector:@selector(isExistLongPressGestureInCardView:)] && [dataSource isExistLongPressGestureInCardView:self]) {
                if (![self.collectionView.gestureRecognizers containsObject:self.longTap]) {
                    _longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureAction:)];
                    self.longTap.minimumPressDuration = 0.8f;
                    [self.collectionView addGestureRecognizer:self.longTap];
                }
            }
        }
            break;
        case SACardViewTypeSinglePage:{
            _bottomBarStyle = SACardBottomBarStyleNone;
            [self.scrollView addSubview:self.singleCardContentView];

            if ([dataSource respondsToSelector:@selector(frontViewInSingleCardView:)]) {
                [self.singleCardContentView addSubview:self.singleCardView];
                [self.singleCardView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo([SACardAssistKit cardFrame].topEdgeSpace);
                    make.left.mas_equalTo([SACardAssistKit cardFrame].leftEdgeSpace);
                    make.centerX.mas_equalTo(self);
                    make.bottom.mas_equalTo(-[SACardAssistKit cardFrame].bottomEdgeSpace);
                }];
            }
            
            //注册背面
            if ([dataSource respondsToSelector:@selector(backViewInSingleCardView:)] && [dataSource backViewInSingleCardView:self] != Nil) {
                _isCanShowBackView = YES;
                if (![self.singleCardContentView.gestureRecognizers containsObject:self.doubleTap]) {
                    _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
                    self.doubleTap.numberOfTapsRequired = 2;
                    [self.singleCardContentView addGestureRecognizer:self.doubleTap];
                }
            }
        }
            break;
        default:
            break;
    }

    if (self.bottomBarStyle == SACardBottomBarStylePageControl) {
        [self addSubview:self.pageControl];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([SACardAssistKit cardFrame].leftEdgeSpace + 50.0f);
            make.height.mas_equalTo(50.0f);
            make.bottom.equalTo(self);
            make.centerX.equalTo(self);
        }];
        __weak typeof(self) weakSelf = self;
        [self.pageControl setPageDidEndChange:^(NSInteger page) {
            if ([weakSelf.delegate respondsToSelector:@selector(cardView:didScrollPageControlToIndex:)]) {
                [weakSelf.delegate cardView:weakSelf didScrollPageControlToIndex:page];
            }
        }];
    }
    
    [self setupSubviewsConstraints];
    [self updateCurrentHeaderAndFooterView];
}

- (void)updateCurrentHeaderAndFooterView {
    [self.currentHeaderView removeFromSuperview];
    [self.currentFooterView removeFromSuperview];
    _currentHeaderView = nil;
    _currentFooterView = nil;
    if (self.shouldShowCurrentHeaderView && self.currentHeaderView) {
        self.currentHeaderView.alpha = 0;
        [self addSubview:self.currentHeaderView];
    }
    
    if (self.shouldShowCurrentFooterView && self.currentFooterView) {
        self.currentFooterView.alpha = 0;
        [self addSubview:self.currentFooterView];
    }
    if (self.currentHeaderView) {
        if ([SACardAssistKit cardFrame].topEdgeSpace < 50.0f) {
            [self.currentHeaderView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo([SACardAssistKit cardFrame].leftEdgeSpace);
                make.height.mas_equalTo(60.0f);
                make.top.mas_equalTo(0);
                make.centerX.equalTo(self);
            }];
        }else{
            [self.currentHeaderView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo([SACardAssistKit cardFrame].leftEdgeSpace);
                make.height.mas_equalTo([SACardAssistKit cardFrame].topEdgeSpace);
                make.centerX.equalTo(self);
            }];
        }
    }
    
    if (self.currentFooterView) {
        [self.currentFooterView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([SACardAssistKit cardFrame].leftEdgeSpace);
            make.height.mas_equalTo(50.0f);
            make.bottom.equalTo(self);
            make.centerX.equalTo(self);
        }];
    }
}

- (void)reloadData {
    //回归到normal状态
    switch (self.cardViewType) {
        case SACardViewTypeSinglePage:{
            [self.singleCardContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            if (self.singleCardView) {
                [self.singleCardContentView addSubview:self.singleCardView];
                [self.singleCardView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo([SACardAssistKit cardFrame].topEdgeSpace);
                    make.left.mas_equalTo([SACardAssistKit cardFrame].leftEdgeSpace);
                    make.centerX.mas_equalTo(self);
                    make.bottom.mas_equalTo(-[SACardAssistKit cardFrame].bottomEdgeSpace);
                }];
            }
        }
            break;
        case SACardViewTypeMultiPage:{
            [self.collectionView reloadData];
            [self setPageControlCurrentPage:self.currentIndex + 1];
        }
            break;
        default:
            break;
    }
    [self.headerViewDictionary removeAllObjects];
    [self.footerViewDictionary removeAllObjects];
}

- (void)reloadCardsAtIndexs:(NSArray<NSNumber *> *)indexs completion:(void (^)(BOOL))completion{
    NSAssert(self.cardViewType != SACardViewTypeSinglePage, @"刷新指定的indexs，必须是SACardViewTypeSinglePage");
    
    NSMutableArray *indexPathArray = [NSMutableArray new];
    __weak typeof(self) weakself = self;
    [indexs enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [indexPathArray addObject:[NSIndexPath indexPathForItem:[obj integerValue] inSection:0]];
        [weakself.headerViewDictionary removeObjectForKey:cardHeaderViewKey(idx)];
        [weakself.footerViewDictionary removeObjectForKey:cardFooterViewKey(idx)];
    }];
    [self.collectionView performBatchUpdates:^{
        [self.collectionView reloadItemsAtIndexPaths:indexPathArray];
    } completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
    }];
}

- (void)deleteCardsAtIndexs:(NSArray<NSNumber *> *)indexs completion:(void (^)(BOOL))completion{
    NSAssert(self.cardViewType != SACardViewTypeSinglePage, @"删除指定的indexs，必须是SACardViewTypeSinglePage");

    NSMutableArray *indexPathArray = [NSMutableArray new];
    [indexs enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [indexPathArray addObject:[NSIndexPath indexPathForItem:[obj integerValue] inSection:0]];
    }];
    __weak typeof(self) weakSelf = self;
    [self.collectionView performBatchUpdates:^{
        [weakSelf.collectionView deleteItemsAtIndexPaths:indexPathArray];
    } completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
        //更新slide信息
        weakSelf.currentIndex = roundl(weakSelf.collectionView.contentOffset.x / CGRectGetWidth(weakSelf.collectionView.bounds));
        [weakSelf setPageControlTotalCount:self.pageControl.pageCount - indexPathArray.count];
        [weakSelf setPageControlCurrentPage:weakSelf.currentIndex+1];
    }];
    [self.headerViewDictionary removeAllObjects];
    [self.footerViewDictionary removeAllObjects];
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSUInteger)index {
    NSAssert(self.cardViewType != SACardViewTypeSinglePage, @"获取指定的cell，必须是SACardViewTypeSinglePage");
    return [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
}

- (void)scrollToCardAtIndex:(NSUInteger)index {
    NSAssert(self.cardViewType != SACardViewTypeSinglePage, @"滑到到指定的card，必须是SACardViewTypeSinglePage");
    
    BOOL isAnimated = NO;
    if (self.currentIndex > index) {
        isAnimated = self.currentIndex - index == 1 ? YES : NO;
    } else {
        isAnimated = index - self.currentIndex == 1 ? YES : NO;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:isAnimated];
    //更新slide信息
    [self setPageControlCurrentPage:index + 1];
}
- (void)setScrollViewScrollEnabled:(BOOL)enable{
    self.scrollView.scrollEnabled = enable;
    if (self.cardViewType == SACardViewTypeMultiPage) {
        self.collectionView.scrollEnabled = enable;
    }
}

- (void)setPageControlTotalCount:(NSUInteger)pageTotalCount {
    self.pageControl.pageCount = pageTotalCount;
}

- (void)resetCardViewStatusToNormal {
    self.cardViewStatus = SACardViewStatusNormal;
    [self updateCardViewUI];
}
#pragma mark-
#pragma mark- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource numberOfCollectionViewCellInCardView:self];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    if (_isCanShowBackView && _isShowInBackView) {
        cell = [_collectionView dequeueReusableCellWithReuseIdentifier:kBackCellIdentifer forIndexPath:indexPath];
    }else{
        cell = [_collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    }
    cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    cell.layer.shadowOffset = CGSizeZero;
    cell.layer.shadowOpacity = 0.6;
    cell.layer.shadowRadius = 9.0f;
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 2.5f;
    cell.backgroundColor = [UIColor whiteColor];
    if ([self.dataSource respondsToSelector:@selector(cardView:cellForDeployCollectionViewCell:index:)]) {
        cell = [self.dataSource cardView:self cellForDeployCollectionViewCell:cell index:indexPath.item];
    }
    if (_changeBackView) {
        [UIView transitionFromView:_oldCell toView:cell duration:0.5 options:_isShowInBackView ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight completion:NULL];
        _changeBackView = NO;
    }
    return cell;
}
#pragma mark-
#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {//拖拽时的渐变效果，松手没有渐变
    //纵向滑动渐隐
    if (scrollView.tag == kScrollViewTag && scrollView.isDragging && !scrollView.isDecelerating) {
        if (scrollView.contentOffset.y < -kZoomStartOffset || scrollView.contentOffset.y > kZoomStartOffset) {
            //竖直方向的有效拉动
            CGFloat progress = (fabs(scrollView.contentOffset.y) - kZoomStartOffset) / (kZoomEndOffset - kZoomStartOffset);
            [self verticalScrollWithProgress:progress];
            if (scrollView.contentOffset.y < -kZoomStartOffset) {
                _isInfluenceTopView = YES;
            } else {
                _isInfluenceBottomView = YES;
            }
        }
    }
    
    //横向滑动渐隐
    if (scrollView.tag == kCollectionTag && scrollView.isDragging && !scrollView.isDecelerating) {
        CGFloat progress = 1-  fabs((fabs(scrollView.contentOffset.x) - lastOffset) / (CGRectGetWidth([UIScreen mainScreen].bounds)/2.f));
        [self horizontalScrollWithProgress:progress];
    }
    _isShowInBackView = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"%s",__func__);
    //判断这次拖拽是否有效，并改变状态
    if (fabs(scrollView.contentOffset.y) > kZoomEndOffset && scrollView.tag == kScrollViewTag) {
        if (_isInfluenceTopView && scrollView.contentOffset.y < -kZoomEndOffset) {
            switch (self.cardViewStatus) {
                case SACardViewStatusNormal:
                    self.cardViewStatus = SACardViewStatusHeaderAppear;
                    break;
                default:
                    self.cardViewStatus = SACardViewStatusNormal;
                    break;
            }
        }
        if (_isInfluenceBottomView && scrollView.contentOffset.y > kZoomEndOffset) {
            switch (self.cardViewStatus) {
                case SACardViewStatusNormal:
                    self.cardViewStatus = SACardViewStatusFooterAppear;
                    break;
                default:
                    self.cardViewStatus = SACardViewStatusNormal;
                    break;
            }
        }
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{//根据改变后的状态，更新UI
    NSLog(@"%s",__func__);
    if (_isInfluenceTopView || _isInfluenceBottomView) {
        [self updateCardViewUI];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"%s",__func__);
    _isInfluenceTopView = NO;
    _isInfluenceBottomView = NO;
    if (scrollView.tag == kCollectionTag) {
        if (fabs((fabs(scrollView.contentOffset.x) - lastOffset)) - CGRectGetWidth([UIScreen mainScreen].bounds)/2.f > 0) {//有效
            //横向滑动(根据缓冲系数大小，有时候开始结束拖拽的offSet和结束减速的offset不一致，故这里再判断一次，保证状态正确)
            self.cardViewStatus = SACardViewStatusNormal;
            [UIView animateWithDuration:0.15 animations:^{
                [self updateCardViewUI];
            }];
            self.currentIndex = roundl(self.collectionView.contentOffset.x / CGRectGetWidth(self.collectionView.bounds));
            [self updateCurrentHeaderAndFooterView];
            [self setPageControlCurrentPage:self.currentIndex + 1];
        }else{
            [self updateCardViewUI];
        }
        
        lastOffset = fabs(scrollView.contentOffset.x);
        if ([self.delegate respondsToSelector:@selector(cardView:didEndDeceleratingAtIndex:)]) {
            [self.delegate cardView:self didEndDeceleratingAtIndex:self.currentIndex];
        }
    }
}

- (void)updateCardViewUI {
    switch (self.cardViewStatus) {
        case SACardViewStatusNormal:
            [self accessoryScrollDidEndByIsNormal:YES];
            self.pageControl.alpha = 1;
            self.currentHeaderView.alpha = 0;
            self.currentFooterView.alpha = 0;
            break;
        case SACardViewStatusFooterAppear:
            [self accessoryScrollDidEndByIsNormal:NO];
            self.pageControl.alpha = 0;
            self.currentHeaderView.alpha = 0;
            self.currentFooterView.alpha = 1;
            break;
        case SACardViewStatusHeaderAppear:
            [self accessoryScrollDidEndByIsNormal:NO];
            self.pageControl.alpha = 0;
            self.currentHeaderView.alpha = 1;
            self.currentFooterView.alpha = 0;
            break;
        default:
            break;
    }
}

#pragma mark-
#pragma mark-渐变

/**
 *  @author 学宝, 16-11-07 16:11
 *
 *  @brief 竖直方向拉动scrollView
 *
 *  @param 比例
 *
 *  @since 1.0
 */
- (void)verticalScrollWithProgress:(CGFloat)progress {
    progress = progress > 1 ? 1 : progress;
    progress = progress < 0 ? 0 : progress;
    switch (self.cardViewStatus) {
        case SACardViewStatusNormal:
            //正常状态下，下拉
            [self accessoryScrollingByProgress:1-progress];
            self.pageControl.alpha = 1 - progress;
            break;
        case SACardViewStatusFooterAppear:
            //自定义底部视图显示状态下，下拉
            self.currentFooterView.alpha = 1- progress;
            break;
        case SACardViewStatusHeaderAppear:
             //自定义头部视图显示状态下，下拉
            self.currentHeaderView.alpha = 1- progress; //菜单视图渐现
            break;
        default:
            break;
    }
}

- (void)horizontalScrollWithProgress:(CGFloat)progress {
    progress = progress > 1 ? 1: progress;
    progress = progress < 0 ? 0 : progress;
    switch (self.cardViewStatus) {
        case SACardViewStatusNormal:
            [self accessoryScrollingByProgress:progress];
            break;
        case SACardViewStatusHeaderAppear:
            self.currentHeaderView.alpha = progress;
            break;
        case SACardViewStatusFooterAppear:
            self.currentFooterView.alpha = progress;
            break;
        default:
            break;
    }
}


#pragma mark-
#pragma mark- Method

- (void)doubleTapAction:(UITapGestureRecognizer *)tap{
    _changeBackView = YES;
    _isShowInBackView = !_isShowInBackView;
    
    switch (self.cardViewType) {
        case SACardViewTypeMultiPage:{
            _oldCell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
            _oldCell.backgroundColor = [UIColor redColor];
            [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.currentIndex inSection:0]]];
        }
            break;
        case SACardViewTypeSinglePage:{
            if (self.singleBackCardView.superview == nil) {
                [self.singleCardContentView addSubview:self.singleBackCardView];
                [self.singleBackCardView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo([SACardAssistKit cardFrame].topEdgeSpace);
                    make.left.mas_equalTo([SACardAssistKit cardFrame].leftEdgeSpace);
                    make.centerX.mas_equalTo(self);
                    make.bottom.mas_equalTo(-[SACardAssistKit cardFrame].bottomEdgeSpace);
                }];
            }
            if (self.singleCardView.superview == nil) {
                [self.singleCardContentView addSubview:self.singleCardView];
                [self.singleCardView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo([SACardAssistKit cardFrame].topEdgeSpace);
                    make.left.mas_equalTo([SACardAssistKit cardFrame].leftEdgeSpace);
                    make.centerX.mas_equalTo(self);
                    make.bottom.mas_equalTo(-[SACardAssistKit cardFrame].bottomEdgeSpace);
                }];
            }
            UIView *fromView = _isShowInBackView ? self.singleCardView : self.singleBackCardView;
            UIView *toView = _isShowInBackView ? self.singleBackCardView : self.singleCardView;
            [UIView transitionFromView:fromView toView:toView duration:0.5 options:_isShowInBackView ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight completion:NULL];
        }
            break;
        default:
            break;
    }

}

- (void)longPressGestureAction:(UILongPressGestureRecognizer *)longTap{
    if ([self.dataSource respondsToSelector:@selector(cardView:shouldResponseLongPressGestureAtIndex:)] && [self.dataSource cardView:self shouldResponseLongPressGestureAtIndex:self.currentIndex]) {
        if ([self.delegate respondsToSelector:@selector(cardView:didLongPressGestureAtIndex:)]) {
            [self.delegate cardView:self didLongPressGestureAtIndex:self.currentIndex];
        }
    }
}

- (void)setPageControlCurrentPage:(NSInteger)currentPage{
    if (self.bottomBarStyle == SACardBottomBarStylePageControl) {
        self.pageControl.currentPage = currentPage;
        self.pageControl.hidden = [self.collectionView numberOfItemsInSection:0] > 1 ? NO : YES;
    }
}

#pragma mark-
#pragma mark-Accessory

- (void)addCardViewAccessoryObject:(id<SACardViewAccessoryProtocol>)accessoryObject {
    if (_accessoryArray == nil) {
        _accessoryArray = [NSMutableArray array];
    }
    [self.accessoryArray addObject:accessoryObject];
}

- (void)accessoryScrollingByProgress:(CGFloat)progress {
    [self.accessoryArray enumerateObjectsUsingBlock:^(id<SACardViewAccessoryProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(cardViewScrollingByProgress:)]) {
            [obj cardViewScrollingByProgress:progress];
        }
    }];
}

- (void)accessoryScrollDidEndByIsNormal:(BOOL)isNormal {
    [self.accessoryArray enumerateObjectsUsingBlock:^(id<SACardViewAccessoryProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(cardViewScrollDidEndByIsNormal:)]) {
            [obj cardViewScrollDidEndByIsNormal:isNormal];
        }
    }];
}

#pragma mark-
#pragma mark- Setter&Getter
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.delegate = self;
        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _scrollView.tag = kScrollViewTag;
    }
    return _scrollView;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _collectionView.tag = kCollectionTag;
    }
    return _cardViewType == SACardViewTypeMultiPage?_collectionView:nil;
}

- (SACardCollectionViewLayout *)collectionViewLayout {
    if (_collectionViewLayout == nil) {
        _collectionViewLayout = [[SACardCollectionViewLayout alloc] init];
        _collectionViewLayout.innerHorizontalSpace = [SACardAssistKit cardFrame].leftEdgeSpace;
        _collectionViewLayout.innerTopSpace = [SACardAssistKit cardFrame].topEdgeSpace;
        _collectionViewLayout.innerBottomSpace = [SACardAssistKit cardFrame].bottomEdgeSpace;
    }
    return _collectionViewLayout;
}

- (SACardBottomBarStyle)bottomBarStyle {
    if ([_dataSource respondsToSelector:@selector(bottomBarStyleInCardView:)]) {
        return [_dataSource bottomBarStyleInCardView:self];
    }
    switch (self.cardViewType) {
        case SACardViewTypeMultiPage:
            return SACardBottomBarStylePageControl;
        default:
            return SACardBottomBarStyleNone;
    }
}

- (void)setupSubviewsConstraints {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIView *view = nil;
    switch (self.cardViewType) {
        case SACardViewTypeMultiPage:
            view = self.collectionView;
            break;
        case SACardViewTypeSinglePage:
            view = self.singleCardContentView;
            break;
        default:
            break;
    }

    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view.superview);
        make.size.mas_equalTo(CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)));
    }];
}

- (UIView *)singleCardContentView {
    if (!_singleCardContentView) {
        _singleCardContentView = [UIView new];
        _singleCardContentView.backgroundColor = [UIColor clearColor];
    }
    return _singleCardContentView;
}

- (UIView *)singleCardView {
    if (!_singleCardView) {
        if ([self.dataSource respondsToSelector:@selector(frontViewInSingleCardView:)]) {
            _singleCardView = [self.dataSource frontViewInSingleCardView:self];
            _singleCardView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
            _singleCardView.layer.shadowOffset = CGSizeZero;
            _singleCardView.layer.shadowOpacity = 0.6;
            _singleCardView.layer.shadowRadius = 9.0f;
            _singleCardView.layer.masksToBounds = YES;
            _singleCardView.layer.cornerRadius = 2.5f;
        }else {
            _singleCardView = nil;
        }
    }
    return _singleCardView;
}

- (UIView *)singleBackCardView {
    if (!_singleBackCardView) {
        if ([self.dataSource respondsToSelector:@selector(backViewInSingleCardView:)]) {
            _singleBackCardView = [self.dataSource backViewInSingleCardView:self];
            _singleBackCardView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
            _singleBackCardView.layer.shadowOffset = CGSizeZero;
            _singleBackCardView.layer.shadowOpacity = 0.6;
            _singleBackCardView.layer.shadowRadius = 9.0f;
            _singleBackCardView.layer.masksToBounds = YES;
            _singleBackCardView.layer.cornerRadius = 2.5f;
        }else {
            _singleBackCardView = nil;
        }
    }
    return _singleBackCardView;
}

- (BOOL)shouldShowCurrentHeaderView {
    if ([self.dataSource respondsToSelector:@selector(cardView:shouldShowHeaderViewAtIndex:)]) {
        return [self.dataSource cardView:self shouldShowHeaderViewAtIndex:self.currentIndex];
    }
    return NO;
}

- (BOOL)shouldShowCurrentFooterView {
    if ([self.dataSource respondsToSelector:@selector(cardView:shouldShowFooterViewAtIndex:)]) {
        return [self.dataSource cardView:self shouldShowFooterViewAtIndex:self.currentIndex];
    }
    return NO;
}

- (UIView *)currentHeaderView {
    if (_currentHeaderView == nil) {
        if (self.currentIndex == NSNotFound) {
            NSLog(@"\n\n\n\n-----------currentHeaderView---NSNotFound----------\n\n\n\n");
            return nil;
        }
        if ([self.dataSource respondsToSelector:@selector(cardView:headerViewAtIndex:)]) {
            _currentHeaderView = self.headerViewDictionary[cardHeaderViewKey(self.currentIndex)];
            NSLog(@"headerViewDictionary::%@\n_currentHeaderView:%@",self.headerViewDictionary,_currentHeaderView);
            if (_currentHeaderView == nil) {
                _currentHeaderView = [self.dataSource cardView:self headerViewAtIndex:self.currentIndex];
            } else {
                return _currentHeaderView;
            }
            if (_currentHeaderView) {
                self.headerViewDictionary[cardHeaderViewKey(self.currentIndex)] = _currentHeaderView;
            }else{
                [self.headerViewDictionary removeObjectForKey:cardHeaderViewKey(self.currentIndex)];
            }
            return _currentHeaderView;
        }
    }
    return _currentHeaderView;
}

- (UIView *)currentFooterView {
    if (_currentFooterView == nil) {
        if (self.currentIndex == NSNotFound) {
            NSLog(@"\n\n\n\n-----------currentFooterView--NSNotFound----------\n\n\n\n");
            return nil;
        }
        if ([self.dataSource respondsToSelector:@selector(cardView:footerViewAtIndex:)]) {
            _currentFooterView = self.footerViewDictionary[cardFooterViewKey(self.currentIndex)];
            if (_currentFooterView == nil) {
                _currentFooterView = [self.dataSource cardView:self footerViewAtIndex:self.currentIndex];
            } else {
                return _currentFooterView;
            }
            if (_currentFooterView) {
                self.footerViewDictionary[cardFooterViewKey(self.currentIndex)] = _currentFooterView;
            }else{
                [self.footerViewDictionary removeObjectForKey:cardFooterViewKey(self.currentIndex)];
            }
            return _currentFooterView;
        }
    }
    return _currentFooterView;
}

- (SAPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[SAPageControl alloc]init];
    }
    return _pageControl;
}

- (NSMutableDictionary *)headerViewDictionary {
    if (_headerViewDictionary == nil) {
        _headerViewDictionary = [[NSMutableDictionary alloc] init];
    }
    return _headerViewDictionary;
}

- (NSMutableDictionary *)footerViewDictionary {
    if (_footerViewDictionary == nil) {
        _footerViewDictionary = [[NSMutableDictionary alloc] init];
    }
    return _footerViewDictionary;
}
@end
