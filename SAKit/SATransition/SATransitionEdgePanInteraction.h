//
//  SAEdgePanInteraction.h
//  SAKitDemo
//
//  Created by 学宝 on 2016/11/6.
//  Copyright © 2016年 学宝工作室. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SATransitionEdgePanInteraction : UIPercentDrivenInteractiveTransition 

- (void)wireToViewController:(UIViewController *)viewController;

@property (nonatomic, assign) BOOL interactionInProgress;

@end
