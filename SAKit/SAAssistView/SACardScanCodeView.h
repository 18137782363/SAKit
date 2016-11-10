//
//  SACardScanCodeView.h
//  SAKitDemo
//
//  Created by xiaojie on 16/9/7.
//  Copyright © 2016年 学宝工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAScanCodeView.h"

@interface SACardScanCodeView : UIView
@property (nonatomic, strong) SAScanCodeView *scanCodeView;

- (void)startCardScan;
@end
