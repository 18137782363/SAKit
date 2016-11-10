//
//  SACardAssistKit.m
//  SAKitDemo
//
//  Created by 学宝 on 16/9/1.
//  Copyright © 2016年 学宝工作室. All rights reserved.
//

#import "SACardAssistKit.h"

@implementation SACardAssistKit
+ (SACardFrame)cardFrame {
    static SACardFrame cardFrame;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
        CGFloat leftSpace = 15.0f;
        if (screenHeight / screenWidth < 1.7) {
            cardFrame.topEdgeSpace = leftSpace;
            cardFrame.bottomEdgeSpace = leftSpace;
            cardFrame.leftEdgeSpace = leftSpace;
        }else {
            CGFloat innerHeight;
            innerHeight = 1.5 * (screenWidth - 2 * leftSpace);
            cardFrame.topEdgeSpace = screenHeight - innerHeight - 50.0f;
            cardFrame.leftEdgeSpace = leftSpace;
            cardFrame.bottomEdgeSpace = 50.0f;
        }
        cardFrame.width = screenWidth - 2 * cardFrame.leftEdgeSpace;
        cardFrame.height = screenHeight - cardFrame.topEdgeSpace - cardFrame.bottomEdgeSpace;
    });
    return cardFrame;
}
@end
