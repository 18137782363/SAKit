//
//  SATransitionReversibleAnimation.h
//  SAKitDemo
//
//  Created by 学宝 on 2016/11/6.
//  Copyright © 2016年 学宝工作室. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SATransitionReversibleAnimation : NSObject<UIViewControllerAnimatedTransitioning>

/**
 The direction of the animation.
 */
@property (nonatomic, assign) BOOL reverse;

/**
 The animation duration.
 */
@property (nonatomic, assign) NSTimeInterval duration;

@end
