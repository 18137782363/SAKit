//
//  SACardAssistKit.h
//  SAKitDemo
//
//  Created by 学宝 on 16/9/1.
//  Copyright © 2016年 学宝工作室. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

struct SACardFrame {
    CGFloat leftEdgeSpace;
    CGFloat topEdgeSpace;
    CGFloat bottomEdgeSpace;
    CGFloat width;
    CGFloat height;
};
typedef struct SACardFrame SACardFrame;

@interface SACardAssistKit : NSObject

+ (SACardFrame)cardFrame;

@end
