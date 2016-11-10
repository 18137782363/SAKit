//
//  SAScanCodeView.m
//  SAKitDemo
//
//  Created by xiaojie on 16/9/7.
//  Copyright © 2016年 学宝工作室. All rights reserved.
//

#import "SAScanCodeView.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface SAScanCodeView ()<AVCaptureMetadataOutputObjectsDelegate>
@end
@implementation SAScanCodeView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self getAuthorization];
    }
    return self;
}
- (void)getAuthorization{
    AVAuthorizationStatus avStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    if (avStatus == AVAuthorizationStatusAuthorized) {
        [self setAVSession];
    }
    else if (avStatus == AVAuthorizationStatusDenied){
        [self showHudWithText:@"请打开相机权限"];
    }else if (avStatus == AVAuthorizationStatusNotDetermined){
        [self setAVSession];
    }
}
- (void)setAVSession{
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!_device) {
        return;
    }
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    if (!input) {
        return;
    }
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [self.session addInput:input];
    [self.session addOutput:output];

    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.bounds;
    
    [self.layer insertSublayer:layer above:0];
    
}
- (void)startScan{
    [self.session startRunning];
}
- (void)stopScan{
    [self.session stopRunning];
}
- (void)openLight{
    if ([self.device hasFlash]) {
        [self.session beginConfiguration];
        [self.device lockForConfiguration:nil];
        
        // Set torch to on
        [self.device setTorchMode:AVCaptureTorchModeOn];
        
        [self.device unlockForConfiguration];
        [self.session commitConfiguration];
        
        [self startScan];
    }
}
- (void)closeLight{
    if ([self.device hasFlash]) {
        [self.session beginConfiguration];
        [self.device lockForConfiguration:nil];
        
        // Set torch to on
        [self.device setTorchMode:AVCaptureTorchModeOff];
        
        [self.device unlockForConfiguration];
        [self.session commitConfiguration];
        
        [self startScan];
    }
}


#pragma mark-
#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];
        if (metadataObject && [metadataObject isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            NSString *scanContent = metadataObject.stringValue;
            if ([self.delegate respondsToSelector:@selector(scanCodeResult:)]) {
                [self.delegate scanCodeResult:scanContent];
                [self stopScan];
            }
        }
    }
}
- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    [self stopScan];
}

- (void)showHudWithText:(NSString *)text{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = text;
    [hud hide:YES afterDelay:1];
}
- (void)dealloc{
    [self stopScan];
}
@end
