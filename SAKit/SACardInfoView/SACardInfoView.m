//
//  SACardInfoView.m
//  SACardInfoView
//
//  Created by 汪志刚 on 2016/10/9.
//  Copyright © 2016年 ISCScom.cn.iscs.www. All rights reserved.
//

#import "SACardInfoView.h"
#import "SACardAssistKit.h"
#import "SACardInfoCollectionViewLayout.h"
#import "SACardInfoViewManager.h"
#import <Masonry/Masonry.h>

#define kVerScale [SACardAssistKit cardFrame].height/517.5
#define kHorScale [SACardAssistKit cardFrame].width/345.0

static CGFloat const kHoriScrollViewTag = 1000;
static CGFloat const kVertScrollViewTag = 1100;
static CGFloat const kCollectionViewTag = 1200;

static CGFloat const kZoomStartOffset = 10.0f;
static CGFloat const kZoomEndOffset = 60.0f;

static CGFloat const kBottomSpace = 7.0;

//static NSString *const kCellIdentifier = @"cn.com.iscs.www.cardInfCell";

@interface SACardInfoView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    BOOL _isInit;
}

@property (nonatomic, strong) SACardInfoViewManager *manager;

/*! 当firstPageView不为空是，控制横向滑动,添加在vertScrollView上  */
@property (nonatomic, strong) UIScrollView *horiScrollView;
/*! 控制纵向滑动  */
@property (nonatomic, strong) UIScrollView *vertScrollView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign, getter=getNumOfItems) NSInteger numOfItems;

@property (nonatomic, strong) UIView *firstPageView;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) Class registCellClass;

@property (nonatomic, copy) NSString *cellIdentifier;

@end

@implementation SACardInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initMehtod];
    }
    return self;
}

- (void)initMehtod {
    _shouldHaveSubTitle = NO;
    self.existBackBtn = YES;
    self.vertScrollEnabled = YES;
    self.itemSize = CGSizeMake(108*kHorScale, 162.5*kVerScale);
    self.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    SACardFrame cardFrame = [SACardAssistKit cardFrame];
    self.horiScrollView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
    self.vertScrollView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
    
    if (self.firstPageView) {
        
        self.firstPageView.frame = CGRectMake(cardFrame.leftEdgeSpace, cardFrame.topEdgeSpace-kBottomSpace, cardFrame.width, cardFrame.height);
        self.collectionView.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds), cardFrame.topEdgeSpace-kBottomSpace, CGRectGetWidth([UIScreen mainScreen].bounds), cardFrame.height);
    }else{
        self.collectionView.frame = CGRectMake(0, cardFrame.topEdgeSpace-kBottomSpace, CGRectGetWidth([UIScreen mainScreen].bounds), cardFrame.height);
    }
}


#pragma mark-
#pragma mark-   UICollectionView Delegate and DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.numOfItems;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if ([self.dataSource respondsToSelector:@selector(cardInfoView:cellForDeployCardInfoViewCell:atIndex:)]) {
        cell = [self.dataSource cardInfoView:self cellForDeployCardInfoViewCell:cell atIndex:indexPath.item];
    }
    cell.layer.cornerRadius = 4;
    cell.clipsToBounds = YES;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.manager startTopViewAnimationWithForceToNormal:YES];
    
    if ([self.delegate respondsToSelector:@selector(cardInfoView:didSelectedItemAtIndex:)]) {
        [self.delegate cardInfoView:self didSelectedItemAtIndex:indexPath.item];
    }
}


#pragma mark-
#pragma mark-   UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.tag == kHoriScrollViewTag&&scrollView.isDragging) {
        if (scrollView.contentOffset.x >= CGRectGetWidth(self.frame)&&self.pageCount>2&&self.firstPageView) {
            self.horiScrollView.scrollEnabled = NO;
            self.collectionView.scrollEnabled = YES;
        }
    }
    if (scrollView.tag == kCollectionViewTag&&scrollView.isDragging) {
        if (scrollView.contentOffset.x<=0&&self.pageCount>2&&self.firstPageView) {
            self.horiScrollView.scrollEnabled = YES;
            self.collectionView.scrollEnabled = NO;
        }
    }
    
    if (scrollView.tag == kVertScrollViewTag&& scrollView.isDragging && !scrollView.isDecelerating) {
        if (scrollView.contentOffset.y < -kZoomStartOffset) {
            CGFloat progress = (fabs(scrollView.contentOffset.y) - kZoomStartOffset) / (kZoomEndOffset - kZoomStartOffset);
            
            //            [self.manager updateTopViewUIWithProgress:progress];
        }else if (scrollView.contentOffset.y > kZoomStartOffset) {
            CGFloat progress = (fabs(scrollView.contentOffset.y) - kZoomStartOffset) / (kZoomEndOffset - kZoomStartOffset);
            [self.manager updateBottomViewUIWithProgress:progress];
        }
    }
    
    if ((scrollView.tag == kHoriScrollViewTag||scrollView.tag == kCollectionViewTag) && scrollView.isDragging && !scrollView.isDecelerating) { //横向滑动渐隐
        [self.manager animationToupdateBottomViewUIWithRevertToNormal:YES];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (fabs(scrollView.contentOffset.y) > kZoomEndOffset && scrollView.tag == kVertScrollViewTag) {
        if (scrollView.contentOffset.y < -kZoomEndOffset) {
            [self.manager startTopViewAnimationWithForceToNormal:NO];
        }
        if (scrollView.contentOffset.y > kZoomEndOffset) {
            [self.manager animationToupdateBottomViewUIWithRevertToNormal:NO];
        }
    }else if (fabs(scrollView.contentOffset.y) < kZoomEndOffset && scrollView.tag == kVertScrollViewTag){
        
        if (scrollView.contentOffset.y < kZoomEndOffset) {
            [self.manager animationToupdateBottomViewUIWithRevertToNormal:YES];
        }
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.tag == kHoriScrollViewTag) {
        
        NSInteger currentPage = scrollView.contentOffset.x/CGRectGetWidth(self.frame);
        self.currentPage = currentPage;
    }else if (scrollView.tag == kCollectionViewTag) {
        NSInteger currentPage = scrollView.contentOffset.x/CGRectGetWidth(self.frame);
        if (self.firstPageView) {
            currentPage = currentPage + 1;
        }
        self.currentPage = currentPage;
    }
    self.horiScrollView.scrollEnabled = YES;
    self.collectionView.scrollEnabled = YES;
}


#pragma mark-
#pragma mark-   private method
- (void)reloadInfoView {
    
    if (!_vertScrollView) [self addSubview:self.vertScrollView];
    if (!_horiScrollView) [self.vertScrollView addSubview:self.horiScrollView];
    
    if (_firstPageView) {
        //  第一页上一次存在
        UIView *lastFirstPage = _firstPageView;
        _firstPageView = nil;
        if (self.firstPageView == nil) {
            //  当前返回的第一页为空
            [lastFirstPage removeFromSuperview];
        }else{
            //  当前返回的第一页不为空
            if (lastFirstPage == self.firstPageView) {
                //  当前返回和上一次返回的为同一个对象
            }else{
                //  当前返回和上一次返回的不是一个对象
                [lastFirstPage removeFromSuperview];
                [self.horiScrollView addSubview:self.firstPageView];
            }
        }
    }else{
        //  第一页上一次不存在
        if (self.firstPageView) {
            [self.horiScrollView addSubview:self.firstPageView];
        }else{
            
        }
    }
    
    if (self.numOfItems&&!_collectionView) {
        [self.horiScrollView addSubview:self.collectionView];
         self.horiScrollView.scrollEnabled = YES;
    }else if (self.numOfItems&&_collectionView) {
        if (!_collectionView.superview) [self.horiScrollView addSubview:_collectionView];
         self.horiScrollView.scrollEnabled = YES;
    }else {
        [_collectionView removeFromSuperview];
        self.horiScrollView.scrollEnabled = NO;
    }
   
    
//    if (_firstPageView) [_firstPageView removeFromSuperview];
//    self.firstPageView = nil;
//    [self addSubview:self.vertScrollView];
//    [self.vertScrollView addSubview:self.horiScrollView];
//    
//    if (self.firstPageView) {
//        [self.horiScrollView addSubview:self.firstPageView];
//        if (self.numOfItems) {
//            [self.horiScrollView addSubview:self.collectionView];
//        }
//        self.horiScrollView.scrollEnabled = YES;
//    }else{
//        self.horiScrollView.scrollEnabled = NO;
//        [self.horiScrollView addSubview:self.collectionView];
//    }
    
    //    if ([self.dataSource respondsToSelector:@selector(classOfCollectionViewCellInCardInfoView:)]) {
    //        [self.collectionView registerClass:[self.dataSource classOfCollectionViewCellInCardInfoView:self] forCellWithReuseIdentifier:kCellIdentifier];
    //    }else{
    //        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    //    }
    
    [_collectionView registerClass:self.registCellClass forCellWithReuseIdentifier:self.cellIdentifier];
    
    NSInteger pageCount = 1;
    if (self.firstPageView) {
        if (self.numOfItems) {
            pageCount = 2;
        }
    }
    
    [self.horiScrollView setContentSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds)*pageCount, CGRectGetHeight([UIScreen mainScreen].bounds))];
    [self.vertScrollView setContentSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    
    if (!_manager.bottomView.superview) {
        
        [self addSubview:self.manager.topView];
        [self addSubview:self.manager.bottomView];
        [self.manager setupSubviewContraintsWithSuperview:self];
    }
    
    self.manager.bottomView.pageControl.numberOfPages = self.pageCount;
    [self performSelector:@selector(scrollToCurrentPage) withObject:nil afterDelay:0.02];
    
    self.vertScrollView.scrollEnabled = self.vertScrollEnabled;
    
    if (self.existBackBtn&&!_backBtn) [self addBackbutton];
    
    [self.collectionView reloadData];
    if ([_firstPageView isKindOfClass:[UITableView class]]||[_firstPageView isKindOfClass:[UICollectionView class]]) {
//        _firstPageView reloda
        id firstPage = _firstPageView;
        [firstPage reloadData];
    }
    
    [self setNeedsLayout];
}

- (void)resetCardInfoViewCurrentPageWithCurrentPage:(NSInteger)currentPage animation:(BOOL)animation{
    _currentPage = _currentPage<self.pageCount?_currentPage:self.pageCount-1;
    if (_firstPageView) {
        if (currentPage < 2) {
            currentPage = currentPage<0?0:currentPage;
            [self.collectionView setContentOffset:CGPointMake(0, 0) animated:animation];
            [self.horiScrollView setContentOffset:CGPointMake(currentPage*CGRectGetWidth(self.frame), 0) animated:animation];
        }else{
            currentPage = currentPage+1 >= self.pageCount?(self.pageCount - 1):currentPage;
            currentPage = currentPage<0?0:currentPage;
            [self.horiScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0) animated:animation];
            [self.collectionView setContentOffset:CGPointMake((currentPage-1)*CGRectGetWidth(self.frame), 0) animated:animation];
        }
    }else{
        currentPage = currentPage+1 >= self.pageCount?(self.pageCount - 1):currentPage;
        
        currentPage = currentPage<0?0:currentPage;
        [self.collectionView setContentOffset:CGPointMake(currentPage*CGRectGetWidth(self.frame), 0) animated:animation];
    }
    NSLog(@"pageCurrent--->%ld",currentPage);
    _currentPage = currentPage;
}

- (UIView *)viewInTopViewAtIndex:(NSInteger)index {
    
    return [self.manager.topView viewWithTag:index];
}

//- (void)setInitCurrentPage {
//    
//    [self resetCardInfoViewCurrentPageWithCurrentPage:_currentPage<self.pageCount?_currentPage:self.pageCount-1 animation:NO];
//}

- (void)resetTopAndBottomViewToNormal {
    [self.manager startTopViewAnimationWithForceToNormal:YES];
}

- (void)addBackbutton {
    
    [self addSubview:self.backBtn];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([SACardAssistKit cardFrame].leftEdgeSpace);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(43);
    }];
}

- (void)backAction {
    if ([self.delegate respondsToSelector:@selector(didPressBackButtonInCardInfoView:)]) {
        [self.delegate didPressBackButtonInCardInfoView:self];
    }
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    
    return [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
}

#pragma mark-
#pragma mark-   setter and getter

- (UIScrollView *)horiScrollView {
    if (_horiScrollView == nil) {
        _horiScrollView = [[UIScrollView alloc] init];
        _horiScrollView.tag = kHoriScrollViewTag;
        _horiScrollView.pagingEnabled = YES;
        _horiScrollView.delegate = self;
        _horiScrollView.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1];
        _horiScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _horiScrollView;
}

- (UIScrollView *)vertScrollView {
    if (_vertScrollView == nil) {
        _vertScrollView = [[UIScrollView alloc] init];
        _vertScrollView.tag = kVertScrollViewTag;
        _vertScrollView.pagingEnabled = YES;
        _vertScrollView.delegate = self;
        _vertScrollView.alwaysBounceVertical = YES;
        _vertScrollView.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1];
        _vertScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _vertScrollView;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        
        SACardInfoCollectionViewLayout *flowLayout = [SACardInfoCollectionViewLayout new];
        flowLayout.sectionInset = UIEdgeInsetsMake(10*kVerScale, 15, 0, 15);
        flowLayout.itemSize = self.itemSize;
        flowLayout.minimumLineSpacing = 9.5*kVerScale;
        flowLayout.minimumInteritemSpacing = 10*kHorScale;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.tag = kCollectionViewTag;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        _collectionView.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1];
        _collectionView.showsHorizontalScrollIndicator = NO;
        
    }
    return _collectionView;
}



- (SACardInfoViewManager *)manager {
    if (!_manager) {
        _manager = [SACardInfoViewManager new];
        _titleLabel = _manager.topView.titleLabel;
        __weak __typeof(self)weakSelf = self;
        [_manager setPageDidChange:^(NSInteger currentPage) {
            
            [weakSelf resetCardInfoViewCurrentPageWithCurrentPage:currentPage animation:YES];
        }];
        [_manager.topView setDidClickItemBlock:^(NSInteger index) {
            if ([weakSelf.delegate respondsToSelector:@selector(cardInfoView:didSelectedItemInTopViewAtIndex:)]) {
                [weakSelf.delegate cardInfoView:weakSelf didSelectedItemInTopViewAtIndex:index];
            }
        }];
    }
    return _manager;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (void)setDataSource:(id<SACardInfoViewDataSource>)dataSource {
    
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        
        [self reloadInfoView];
    }
    //    [self reloadInfoView];
    //    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
}

- (NSInteger)getNumOfItems {
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsInCardInfoView:)]) {
        return [self.dataSource numberOfItemsInCardInfoView:self];
    }
    return 0;
}

- (void)scrollToCurrentPage {
    
    [self setCurrentPage:_currentPage animated:NO];
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    [self setCurrentPage:currentPage animated:NO];
}

- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated{
    _currentPage = currentPage;
    self.manager.bottomView.pageControl.currentPage = currentPage;
    [self resetCardInfoViewCurrentPageWithCurrentPage:currentPage animation:NO];

}

- (UIView *)firstPageView {
    if (!_firstPageView) {
        if ([self.dataSource respondsToSelector:@selector(firstPageViewInCardInfoView:)]) {
            _firstPageView = [self.dataSource firstPageViewInCardInfoView:self];
        }else{
            _firstPageView = nil;
        }
    }
    return _firstPageView;
}

- (Class)registCellClass {
    if ([self.dataSource respondsToSelector:@selector(classOfCollectionViewCellInCardInfoView:)]) {
        return [self.dataSource classOfCollectionViewCellInCardInfoView:self];
    }
    return [UICollectionViewCell class];
}

- (NSString *)cellIdentifier {
    
    return [NSString stringWithFormat:@"cn.com.iscs.www.%@",NSStringFromClass(self.registCellClass)];
}

- (NSInteger)pageCount {
    
    NSInteger count = 1;
    count = (self.numOfItems+8)/9;
    if (_firstPageView) {
        count = count + 1;
    }
    return count;
}

- (UILabel *)subTitleLabel {
    return self.shouldHaveSubTitle?self.manager.topView.subTitleLabel:nil;
}

- (void)setShouldHaveSubTitle:(BOOL)shouldHaveSubTitle {
    _shouldHaveSubTitle = shouldHaveSubTitle;
    self.manager.topView.shouldHaveSubTitle = shouldHaveSubTitle;
}

@end
