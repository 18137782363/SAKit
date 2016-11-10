//
//  UIViewController+SAExtend.m
//  SAUIKit
//
//  Created by 吴潮 on 16/5/5.
//  Copyright © 2016年 浙江网仓科技有限公司. All rights reserved.
//

#import "UIViewController+SAExtend.h"
#import "SANavigationController.h"

@implementation UIViewController (SAExtend)
- (void)setBackButtonHidden:(BOOL)hidden backBlock:(void (^)(UIViewController *))backBlock{
    if ([self.navigationController isKindOfClass:[SANavigationController class]]) {
        SANavigationController *navController = (SANavigationController *)self.navigationController;
        navController.hiddenBackButton = hidden;
        navController.didSelectBackButtonBlock = backBlock;
    }
}

- (void)setMenuViewHidden:(BOOL)hidden {
    if ([self.navigationController isKindOfClass:[SANavigationController class]]) {
        SANavigationController *navController = (SANavigationController *)self.navigationController;
        navController.hiddenMenuView = hidden;
    }
}
@end

@implementation UINavigationController (ShouldPopOnBackButton)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem*)item {
    
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    
    BOOL shouldPop = YES;
    UIViewController* vc = [self topViewController];
    if([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
        shouldPop = [vc navigationShouldPopOnBackButton];
    }
    
    if(shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    } else {
        for(UIView *subview in [navigationBar subviews]) {
            if(subview.alpha < 1.) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
    }
    
    return NO;
}

@end