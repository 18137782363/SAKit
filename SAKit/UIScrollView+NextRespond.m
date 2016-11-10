//
//  UIScrollView+NextRespond.m
//  SAKitDemo
//
//  Created by xiaojie on 16/9/2.
//  Copyright © 2016年 学宝工作室. All rights reserved.
//

#import "UIScrollView+NextRespond.h"

@implementation UIScrollView (NextRespond)
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self nextResponder] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self nextResponder] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}
@end
