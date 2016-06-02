//
//  UIViewController+SAExtend.h
//  SAUIKit
//
//  Created by 吴潮 on 16/5/5.
//  Copyright © 2016年 浙江网仓科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
//自定义导航条返回按钮事件
@protocol SABackButtonHandlerProtocol <NSObject>

@optional

-(BOOL)navigationShouldPopOnBackButton;

@end

@interface UIViewController (SAExtend)<SABackButtonHandlerProtocol>

@end
