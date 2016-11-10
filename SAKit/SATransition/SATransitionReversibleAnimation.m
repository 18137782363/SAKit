//
//  SATransitionReversibleAnimation.m
//  SAKitDemo
//
//  Created by 学宝 on 2016/11/6.
//  Copyright © 2016年 学宝工作室. All rights reserved.
//

#import "SATransitionReversibleAnimation.h"

@implementation SATransitionReversibleAnimation
- (instancetype)init
{
    self = [super init];
    if (self) {
        _duration = 0.4f;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    [self animateTransition:transitionContext fromVC:fromViewController toVC:toViewController fromView:fromView toView:toView];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    //    return;
    UIView* containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    toView.frame = CGRectMake(self.reverse ? -CGRectGetWidth([UIScreen mainScreen].bounds) : CGRectGetWidth([UIScreen mainScreen].bounds), toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
    self.reverse ? [containerView sendSubviewToBack:toView] : [containerView bringSubviewToFront:toView];
    
    // animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    toView.transform = CGAffineTransformMakeScale(.8, .8);
    [UIView animateWithDuration:duration animations:^{
        fromView.frame = CGRectMake(!self.reverse ? -CGRectGetWidth([UIScreen mainScreen].bounds) : CGRectGetWidth([UIScreen mainScreen].bounds), fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
        CGAffineTransform trans = CGAffineTransformMakeScale(0.8, 0.8);
        fromView.transform = CGAffineTransformScale(trans, 1.0, 1.0);
        
        toView.transform = CGAffineTransformIdentity;
        toView.frame = CGRectMake(0, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            [toView removeFromSuperview];
            fromView.transform = CGAffineTransformIdentity;
            toView.transform = CGAffineTransformIdentity;
        } else {
            // reset from- view to its original state
            [fromView removeFromSuperview];
            toView.transform = CGAffineTransformIdentity;
            fromView.transform = CGAffineTransformIdentity;
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}
@end
