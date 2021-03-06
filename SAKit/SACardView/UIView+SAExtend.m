//
//  UIView+SAExtend.m
//  SAFoundationCategory
//
//  Created by 吴潮 on 16/3/25.
//  Copyright © 2016年 wuchao. All rights reserved.
//

#import "UIView+SAExtend.h"
#import <objc/runtime.h>

static char const *kIsAnimation = "isAnimation";

@implementation UIView (SAExtend)

-(UIImage *)imageForCutScreen{
    UIGraphicsBeginImageContext(self.frame.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenImage;
}

-(BOOL)isExistFirstResponder{
    if (self.isFirstResponder) {
        return YES;
    }
    for (UIView *subView in self.subviews) {
        if ([subView isExistFirstResponder]) {
            return YES;
        }
    }
    return NO;
}

- (void)setBorderWithRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.cornerRadius = radius;
    self.clipsToBounds = YES;
}

- (void)setDashBorderWithRadius:(CGFloat)radius borderColor:(UIColor *)color{
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:radius].CGPath;
    borderLayer.lineWidth = 0.5f;
    borderLayer.lineDashPattern = @[@4,@4];
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = color.CGColor;
    [self.layer addSublayer:borderLayer];
}

- (void)lineFromTop:(float)top left:(float)left toRight:(float)right lineColor:(UIColor *)color {
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = color.CGColor;
    layer.frame = CGRectMake(left, top, self.bounds.size.width - left - right, 0.5);
    [self.layer addSublayer:layer];
}

- (void)startRotation {
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 2.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)setIsAnimation:(BOOL)isAnimation {
    
    objc_setAssociatedObject(self, kIsAnimation, @(isAnimation), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isAnimation {
    BOOL isAnimation = [objc_getAssociatedObject(self, kIsAnimation) boolValue];
    return isAnimation;
}

@end
