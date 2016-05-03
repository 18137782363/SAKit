//
//  SAMutilSelectedView.m
//  SAMutilSelectedView
//
//  Created by WZG on 16/4/25.
//  Copyright © 2016年 浙江网仓科技有限公司. All rights reserved.
//

#import "SAMutilSelectedView.h"


#define kAnimationDuration  0.5
#define kAnimationBaseDelayDuration  0.1
#define kAngleToRadian(_angle_) (_angle_)*M_PI/180.0

#define kOriginScale 0.5
#define kEnlargeScale 1.2

#define kLineStyleItemSpace 15

@interface SAMutilSelectedView (){
    BOOL _itemShow;
    BOOL _isAnimation;
}

@property (nonatomic,assign,getter=getItemCount) NSInteger itemCount;
@property (nonatomic,strong) NSMutableArray <UIView *> *bgViewArray;
@property (nonatomic,strong) NSMutableArray <SAMutilSelectedItem *> *itemArray;

@end

@implementation SAMutilSelectedView


#pragma mark-   init
- (instancetype)initWithCoreSelectedItemAlignment:(SACoreSelectedItemAlignment)coreSelectedItemAlignment{
    
    self = [super init];
    if (self) {
        
        self.coreItemAlignment = coreSelectedItemAlignment;
        [self initMethod];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.coreItemAlignment = SACoreSelectedItemAlignmentCenter;
        [self initMethod];
    }
    return self;
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        self.coreItemAlignment = SACoreSelectedItemAlignmentCenter;
        [self initMethod];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.coreItemAlignment = SACoreSelectedItemAlignmentCenter;
        [self initMethod];
    }
    return self;
}

- (void)initMethod{

    self.animationClockwise = YES;
    self.itemDiameter = 30;
    self.itemsAngle = 90;
    self.backgroundColor = [UIColor clearColor];
}


#pragma mark-   reloadMutilSelectedView
- (void)reloadMutilSelectedView{
    
    [self removeAllSubviews];
    
    if (self.coreItemAlignment > 6) [self addSubview:self.bgScrollView];
    
    NSInteger itemCount = [self getItemCount];
    for (int i = 0; i<itemCount; i++) {
        
        if (self.coreItemAlignment <= 6) {
            
            [self createItemBgViewAtIndex:i];
            [self addSubview:[self createItemAtIndex:i]];
        }else{
            [self.bgScrollView addSubview:[self createItemAtIndex:i]];
        }
    }
    
    [self addSubview:self.coreSelectedItem];

    [self setItemFrame];
}

- (void)createItemBgViewAtIndex:(NSInteger)index{
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.bounds = CGRectMake(0, 0, [self getSizeAtIndex:index].width, [self getSizeAtIndex:index].height);
    bgView.layer.cornerRadius = [self getSizeAtIndex:index].height/2.0;
    [self addSubview:bgView];
    [self.bgViewArray addObject:bgView];
}

- (SAMutilSelectedItem *)createItemAtIndex:(NSInteger)i{
    
    SAMutilSelectedItem *item = nil;
    if ([self.delegate respondsToSelector:@selector(mutilSelectedView:itemAtIndex:)]) {
        item = [self.delegate mutilSelectedView:self itemAtIndex:i];
        item.tag = i;
        if (_coreItemAlignment <= 6) item.hidden = YES;
        [item addTarget:self action:@selector(selectedItem:) forControlEvents:UIControlEventTouchUpInside];
        item.bounds = CGRectMake(0, 0, [self getSizeAtIndex:i].width, [self getSizeAtIndex:i].height);
        item.layer.cornerRadius = [self getSizeAtIndex:i].height/2.0;
        if (_coreItemAlignment <= 6) item.transform = CGAffineTransformMakeScale(0.5, 0.5);
//        [self addSubview:item];
        [self.itemArray addObject:item];
    }else{
        NSAssert(NO, @"返回的SAMutilSelectedItem不能为空");
    }
    return item;
}

- (void)setItemFrame{
    
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width = CGRectGetWidth(self.frame);
    
    CGFloat centerToCenterX = width - _itemDiameter;
    CGFloat centerToCenterY = height - _itemDiameter;
    
    NSInteger itemCount = [self getItemCount];
    __block CGFloat x = 0;
    __block CGFloat y = 0;
    CGFloat averageAngle = 0;
    
    if (itemCount<=1) NSAssert(NO, @"返回的Item个数不能小于2");
    
    switch (_coreItemAlignment) {
            
            //  ********  以下为     圆弧形     ********//
            //  下左
        case SACoreSelectedItemAlignmentBottomAndLeft:{
            
            averageAngle = 90.0/(itemCount-1);
            self.coreSelectedItem.frame = CGRectMake(centerToCenterX*(_itemsAngle/90.0-1.0), centerToCenterY, _itemDiameter, _itemDiameter);
            [_bgViewArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                CGSize size = [self getSizeAtIndex:idx];
                x = cos(kAngleToRadian(-90+idx*averageAngle))*centerToCenterX+_itemDiameter/2.0;
                y = sin(kAngleToRadian(-90+idx*averageAngle))*centerToCenterY+(height-_itemDiameter/2.0-size.height/2.0)+size.height/2.0;
                obj.center = CGPointMake(x, y);
                
            }];
            
            break;
        }
            //  下右
        case SACoreSelectedItemAlignmentBottomAndRight:{
            
            averageAngle = 90.0/(itemCount-1);
            self.coreSelectedItem.frame = CGRectMake(centerToCenterX*(2.0-_itemsAngle/90.0), centerToCenterY, _itemDiameter, _itemDiameter);
            [_bgViewArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                x = cos(kAngleToRadian(180+idx*averageAngle))*centerToCenterX+centerToCenterX+_itemDiameter/2.0;
                y = sin(kAngleToRadian(180+idx*averageAngle))*centerToCenterY+(height-_itemDiameter/2.0);
                obj.center = CGPointMake(x, y);
                
            }];
            break;
        }
            
            //  下中
        case SACoreSelectedItemAlignmentBottomAndCenter:{
            
            averageAngle = 180.0/(itemCount-1);
            self.coreSelectedItem.frame = CGRectMake(centerToCenterX/2.0, centerToCenterY, _itemDiameter, _itemDiameter);
            [_bgViewArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                x = cos(kAngleToRadian(180+idx*averageAngle))*centerToCenterX/2.0+centerToCenterX/2.0+_itemDiameter/2.0;
                y = sin(kAngleToRadian(180+idx*averageAngle))*centerToCenterY/2.0+(height-_itemDiameter/2.0);
                obj.center = CGPointMake(x, y);
                
            }];
            break;
        }
            
            //  上左
        case SACoreSelectedItemAlignmentTopAndLeft:{
            
            averageAngle = 90.0/(itemCount-1);
            self.coreSelectedItem.frame = CGRectMake(centerToCenterX*(_itemsAngle/90.0-1), 0, _itemDiameter, _itemDiameter);
            [_bgViewArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                x = cos(kAngleToRadian(0+idx*averageAngle))*centerToCenterX+_itemDiameter/2.0;
                y = sin(kAngleToRadian(0+idx*averageAngle))*centerToCenterY+_itemDiameter/2.0;
                obj.center = CGPointMake(x, y);
                
            }];
            break;
        }
            //  上右
        case SACoreSelectedItemAlignmentTopAndRight:{
            
            averageAngle = 90.0/(itemCount-1);
            self.coreSelectedItem.frame = CGRectMake(centerToCenterX*(2.0-_itemsAngle/90.0), 0, _itemDiameter, _itemDiameter);
            [_bgViewArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                x = cos(kAngleToRadian(90+idx*averageAngle))*centerToCenterX+centerToCenterX+_itemDiameter/2.0;
                y = sin(kAngleToRadian(90+idx*averageAngle))*centerToCenterY+_itemDiameter/2;
                obj.center = CGPointMake(x, y);
                
            }];
            break;
        }
            //  上中
        case SACoreSelectedItemAlignmentTopAndCenter:{
            
            averageAngle = 180.0/(itemCount-1);
            self.coreSelectedItem.frame = CGRectMake(centerToCenterX/2.0, 0, _itemDiameter, _itemDiameter);
            [_bgViewArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                x = cos(kAngleToRadian(0+idx*averageAngle))*centerToCenterX/2.0+centerToCenterX/2.0+_itemDiameter/2.0;
                y = sin(kAngleToRadian(0+idx*averageAngle))*centerToCenterY/2.0+_itemDiameter/2.0;
                obj.center = CGPointMake(x, y);
                
            }];
            break;
        }
            //  居中
        case SACoreSelectedItemAlignmentCenter:{
            
            averageAngle = 360/itemCount;
            self.coreSelectedItem.frame = CGRectMake(0, 0, _itemDiameter, _itemDiameter);
            self.coreSelectedItem.center = CGPointMake(width/2.0, height/2.0);
            
            [_bgViewArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                x = cos(kAngleToRadian(90+idx*averageAngle))*centerToCenterX/2.0+centerToCenterX/2.0+_itemDiameter/2.0;
                y = sin(kAngleToRadian(90+idx*averageAngle))*centerToCenterY/2.0+centerToCenterX/2.0+_itemDiameter/2.0;
                obj.center = CGPointMake(x, y);
            }];

            break;
        }
        //  ********    以上为 圆弧形     ********//
            
            
        //  ********    以下为 直线型     ********//
        //  coreSelectedItem 居左
        case SACoreSelectedItemAlignmentLineLeft:{
            
            self.coreSelectedItem.frame = CGRectMake(2, centerToCenterY/2.0, _itemDiameter, _itemDiameter);
            _bgScrollView.frame = CGRectMake(-CGRectGetWidth(self.frame), 0, CGRectGetWidth(_bgScrollView.frame), CGRectGetWidth(self.frame));
            __block CGFloat tempX = 0;
            [_itemArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                CGSize size = [self getSizeAtIndex:idx];
                CGSize lastSize = [self getSizeAtIndex:idx-1];
                tempX += kLineStyleItemSpace+lastSize.width;
                x = tempX;
                y = (height-size.height)/2.0;
                obj.frame = CGRectMake(x, y, size.width, size.height);
            }];
            
            
            break;
        }
            
        //  coreSelectedItem 居右
        case SACoreSelectedItemAlignmentLineRight:{
            
            self.coreSelectedItem.frame = CGRectMake(centerToCenterX-2, centerToCenterY/2.0, _itemDiameter, _itemDiameter);
            __block CGFloat tempX = 0;
            _bgScrollView.frame = CGRectMake(CGRectGetWidth(self.frame), 0, CGRectGetWidth(_bgScrollView.frame), CGRectGetWidth(self.frame));
            [_itemArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                CGSize size = [self getSizeAtIndex:idx];
                CGSize lastSize = [self getSizeAtIndex:idx-1];
                tempX += kLineStyleItemSpace+lastSize.width;
                x = tempX;
                y = (height-size.height)/2.0;
                obj.frame = CGRectMake(x, y, size.width, size.height);
            }];
            break;
        }
        case SACoreSelectedItemAlignmentLineTop:{
            break;
        }
        default:{
            
            break;
        }
    }
    
    __block CGFloat widthOfContentSize = kLineStyleItemSpace;
    [_itemArray enumerateObjectsUsingBlock:^(SAMutilSelectedItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (_bgScrollView) {
            widthOfContentSize += ([self getSizeAtIndex:idx].width+kLineStyleItemSpace);
            if (idx == _itemArray.count-1){
                _bgScrollView.contentSize = CGSizeMake(widthOfContentSize, height);
            }
        }else{
            obj.center = _coreSelectedItem.center;
        }
    }];
}

- (void)removeAllSubviews{
    
  
    [_itemArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_bgViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_itemArray removeAllObjects];
    [_bgViewArray removeAllObjects];
    [_coreSelectedItem removeFromSuperview];
    [_bgScrollView removeFromSuperview];
    _bgScrollView = nil;
    _coreSelectedItem = nil;
    _itemShow = NO;
}

#pragma mark-   action method
- (void)coreItemPress:(SAMutilSelectedItem *)item{
    if (_isAnimation) return;
    if (_itemShow) {
        [self animationToHide];
    }else{
         [self animationToShow];
    }
}

- (void)selectedItem:(SAMutilSelectedItem *)item{
    
    if (_isAnimation) return;
    [self itemClickToHideWithItem:item];
    
    if ([self.delegate respondsToSelector:@selector(mutilSelectedView:didSelectedItemAtIndex:)]) {
        [self.delegate mutilSelectedView:self didSelectedItemAtIndex:item.tag];
    }
}

#pragma mark-   private method
- (void)close{
    [self coreItemPress:nil];
}

- (void)open{
    [self coreItemPress:nil];
}

- (void)itemClickToHideWithItem:(SAMutilSelectedItem *)item{
    _isAnimation = YES;
    
    if (_coreItemAlignment > 6) {
        
        [self animationToHide];
        
        return;
    }
    
    [_itemArray enumerateObjectsUsingBlock:^(SAMutilSelectedItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.tag!=item.tag) {
            obj.transform = CGAffineTransformMakeScale(kOriginScale, kOriginScale);
            obj.center = _coreSelectedItem.center;
            obj.hidden = YES;
        }else{
            
            [UIView animateWithDuration:kAnimationDuration animations:^{
               
                obj.transform = CGAffineTransformMakeScale(kEnlargeScale, kEnlargeScale);
                obj.alpha = 0;
            } completion:^(BOOL finished) {
                obj.transform = CGAffineTransformMakeScale(kOriginScale, kOriginScale);
                obj.center = _coreSelectedItem.center;
                obj.alpha = 1;
                _isAnimation = NO;
                obj.hidden = YES;
                _itemShow = NO;
            }];
        }

    }];
    
    
}

- (void)animationToShow{

    _isAnimation = YES;
    
    if (_coreItemAlignment > 6) {
        [UIView animateWithDuration:kAnimationDuration delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:6 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            if (_coreItemAlignment == SACoreSelectedItemAlignmentLineRight) {
                
                _bgScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(_bgScrollView.frame), CGRectGetWidth(self.frame));
            }else if (_coreItemAlignment == SACoreSelectedItemAlignmentLineLeft){
                
                _bgScrollView.frame = CGRectMake(CGRectGetMaxX(_coreSelectedItem.frame), 0, CGRectGetWidth(_bgScrollView.frame), CGRectGetWidth(self.frame));
            }
            
        } completion:^(BOOL finished) {
            _itemShow = YES;
            _isAnimation = NO;
        }];
        return;
    }
    
    if (_animationClockwise) {
        [_itemArray enumerateObjectsUsingBlock:^(SAMutilSelectedItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            obj.hidden = NO;
            [UIView animateWithDuration:kAnimationDuration delay:idx*kAnimationBaseDelayDuration usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                UIView *view = _bgViewArray[idx];
                obj.center = view.center;
                obj.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                if (idx == _itemArray.count-1){
                    _itemShow = YES;
                    _isAnimation = NO;
                }
            }];
        }];
        
        return;
    }
    
    //  逆时针
    [_itemArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(SAMutilSelectedItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.hidden = NO;
        [UIView animateWithDuration:kAnimationDuration delay:(_itemArray.count-1-idx)*kAnimationBaseDelayDuration usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            UIView *view = _bgViewArray[idx];
            obj.center = view.center;
            obj.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (idx == 0){
                _itemShow = YES;
                _isAnimation = NO;
            }
        }];
    }];

}

- (void)animationToHide{

    _isAnimation = YES;
    
    if (_coreItemAlignment > 6) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            
            if (_coreItemAlignment == SACoreSelectedItemAlignmentLineRight) {
                
                _bgScrollView.frame = CGRectMake(CGRectGetWidth(self.frame), 0, CGRectGetWidth(_bgScrollView.frame), CGRectGetWidth(self.frame));
            }else if (_coreItemAlignment == SACoreSelectedItemAlignmentLineLeft){
                
                _bgScrollView.frame = CGRectMake(-CGRectGetWidth(self.frame), 0, CGRectGetWidth(_bgScrollView.frame), CGRectGetWidth(self.frame));
            }
            
        } completion:^(BOOL finished) {
            _itemShow = NO;
            _isAnimation = NO;
        }];
        return;
    }
    
    if (_animationClockwise) {
        [_itemArray enumerateObjectsUsingBlock:^(SAMutilSelectedItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [UIView animateWithDuration:kAnimationDuration delay:idx*kAnimationBaseDelayDuration usingSpringWithDamping:0.99 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                obj.transform = CGAffineTransformMakeScale(kOriginScale, kOriginScale);
                obj.center = _coreSelectedItem.center;
            } completion:^(BOOL finished) {
                if (idx == _itemArray.count-1){
                    _itemShow = NO;
                    _isAnimation = NO;
                }
                obj.hidden = YES;
            }];
        }];
        return;
    }
    
    //  逆时针
    [_itemArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(SAMutilSelectedItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [UIView animateWithDuration:kAnimationDuration delay:(_itemArray.count-1-idx)*kAnimationBaseDelayDuration usingSpringWithDamping:0.99 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            obj.transform = CGAffineTransformMakeScale(kOriginScale, kOriginScale);
            obj.center = _coreSelectedItem.center;
        } completion:^(BOOL finished) {
            if (idx == 0){
                _itemShow = NO;
                _isAnimation = NO;
            }
            obj.hidden = YES;
        }];
    }];
    
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if (_itemShow) {
        if (CGRectContainsPoint(self.bounds, point)) {
            return YES;
        }
        return NO;
    }else{
        if (CGRectContainsPoint(_coreSelectedItem.frame, point)) {
            return YES;
        }
        return NO;
    }
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    if (_delegate) {
        [self reloadMutilSelectedView];
    }
}

#pragma mark-   setter and getter
- (NSInteger)getItemCount{
    if ([self.delegate respondsToSelector:@selector(numberOfItemInMutilSelectedView:)]) {
        return [self.delegate numberOfItemInMutilSelectedView:self];
    }
    return 0;
}

- (void)setDelegate:(id<SAMutilSelectedViewDelegate>)delegate{
    _delegate = delegate;
    if (self.superview) [self reloadMutilSelectedView];
}

- (UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] init];
        _bgScrollView.frame = CGRectMake( 0, 0, CGRectGetWidth(self.frame)-_itemDiameter-10.0, CGRectGetHeight(self.frame));
        _bgScrollView.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
    }
    return _bgScrollView;
}

- (SAMutilSelectedItem *)coreSelectedItem{
    if (!_coreSelectedItem) {
        _coreSelectedItem = [[SAMutilSelectedItem alloc] init];
        _coreSelectedItem.backgroundColor = [UIColor redColor];
        _coreSelectedItem.layer.cornerRadius = _itemDiameter/2.0;
        [_coreSelectedItem addTarget:self action:@selector(coreItemPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coreSelectedItem;
}

- (NSMutableArray *)itemArray{
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

- (NSMutableArray *)bgViewArray{
    if (!_bgViewArray) {
        _bgViewArray = [NSMutableArray array];
    }
    return _bgViewArray;
}

- (CGSize)getSizeAtIndex:(NSInteger)index{
    if (index<0) return CGSizeZero;
    if ([self.delegate respondsToSelector:@selector(mutilSelectedView:sizeForItemAtIndex:)]) {
        if (!CGSizeEqualToSize([self.delegate mutilSelectedView:self sizeForItemAtIndex:index], CGSizeZero)) {
            return [self.delegate mutilSelectedView:self sizeForItemAtIndex:index];
        }
    }
    return CGSizeMake(_itemDiameter, _itemDiameter);
}

- (SAMutilSelectedItem *)itemAtIndex:(NSInteger)index{

    return self.itemArray[index];
}

- (void)setItemsAngle:(CGFloat)itemsAngle{
    _itemsAngle = itemsAngle;
    if (itemsAngle<90||itemsAngle>180) {
        NSAssert(NO, @"itemAngle设置不能小于90，且不能大于180");
    }
}

@end
