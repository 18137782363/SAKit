//
//  SACardScanCodeView.m
//  SAKitDemo
//
//  Created by xiaojie on 16/9/7.
//  Copyright © 2016年 学宝工作室. All rights reserved.
//

#import "SACardScanCodeView.h"


@interface SACardScanCodeView ()
@property (nonatomic, strong) UIButton *lightBtn;
@property (nonatomic, strong) UIButton *closeBtn;
@end
@implementation SACardScanCodeView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scanCodeView];
        [self addSubview:self.lightBtn];
        [self addSubview:self.closeBtn];
    }
    return self;
}

#pragma mark - Method
- (void)lightBtnAction{
    if (self.scanCodeView.device.torchMode == AVCaptureTorchModeOn) {
        [self.scanCodeView closeLight];
    }else{
        [self.scanCodeView openLight];
    }
}
- (void)closeBtnAction{
    [self.scanCodeView stopScan];
    [self removeFromSuperview];
}
- (void)startCardScan{
    [self.scanCodeView startScan];
}
- (SAScanCodeView *)scanCodeView{
    if (!_scanCodeView) {
        _scanCodeView = [[SAScanCodeView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
    }
    return _scanCodeView;
}
- (UIButton *)lightBtn{
    if (!_lightBtn) {
        _lightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lightBtn.frame = CGRectMake(50, 400, 100, 100);
        _lightBtn.backgroundColor = [UIColor redColor];
        [_lightBtn addTarget:self action:@selector(lightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lightBtn;
}
- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake(200, 400, 100, 100);
        _closeBtn.backgroundColor = [UIColor redColor];
        [_closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _closeBtn;
}

@end
