//
//  SAScanCodeView.h
//  SAKitDemo
//
//  Created by xiaojie on 16/9/7.
//  Copyright © 2016年 学宝工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@protocol SAScanCodeViewDelegate <NSObject>

- (void)scanCodeResult:(NSString *)result;

@end
@interface SAScanCodeView : UIView
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong)  AVCaptureDevice *device;
@property (nonatomic, weak) id<SAScanCodeViewDelegate> delegate;

- (void)startScan;
- (void)stopScan;
- (void)openLight;
- (void)closeLight;
@end
