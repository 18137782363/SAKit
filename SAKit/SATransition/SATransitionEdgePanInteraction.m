//
//  SAEdgePanInteraction.m
//  SAKitDemo
//
//  Created by 学宝 on 2016/11/6.
//  Copyright © 2016年 学宝工作室. All rights reserved.
//

#import "SATransitionEdgePanInteraction.h"
#import <objc/runtime.h>

const NSString *kSAEdgePanGestureKey = @"com.sakit.SAEdgePanGestureKey";

@implementation SATransitionEdgePanInteraction{
    BOOL _shouldCompleteTransition;
    UIViewController *_viewController;
}

- (void)wireToViewController:(UIViewController *)viewController{
    _viewController = viewController;
    [self prepareGestureRecognizerInView:viewController.view];
}

- (void)prepareGestureRecognizerInView:(UIView *)view {
    UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer = objc_getAssociatedObject(view, (__bridge const void *)(kSAEdgePanGestureKey));
    if (edgePanGestureRecognizer) {
        [view removeGestureRecognizer:edgePanGestureRecognizer];
    }
    
    edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleEdgePanGestureRecognizer:)];
    edgePanGestureRecognizer.edges = UIRectEdgeLeft;
    [view addGestureRecognizer:edgePanGestureRecognizer];
    objc_setAssociatedObject(view, (__bridge const void *)(kSAEdgePanGestureKey), edgePanGestureRecognizer, OBJC_ASSOCIATION_RETAIN);
}

- (void)handleEdgePanGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
//    CGPoint vel = [gestureRecognizer velocityInView:gestureRecognizer.view];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            self.interactionInProgress = YES;
            [_viewController.navigationController popViewControllerAnimated:YES];
        }
            
            break;
        case UIGestureRecognizerStateChanged:
            if (self.interactionInProgress) {
                CGFloat fraction = fabs(translation.x / 200.0f);
                fraction = fminf(fmaxf(fraction, 0), 1.0f);
                _shouldCompleteTransition = fraction > 0.5;
                if (fraction >= 1) {
                    fraction = 0.99;
                }
                [self updateInteractiveTransition:fraction];
            }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            if (self.interactionInProgress) {
                self.interactionInProgress = NO;
                if (!_shouldCompleteTransition || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                    [self cancelInteractiveTransition];
                }else {
                    [self finishInteractiveTransition];
                }
            }
            break;
        default:
            break;
    }
}

@end
