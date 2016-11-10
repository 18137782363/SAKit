//
//  SANavigationController.m
//  SAKitDemo
//
//  Created by 学宝 on 16/6/7.
//  Copyright © 2016年 学宝工作室. All rights reserved.
//

#import "SANavigationController.h"
#import <Masonry/Masonry.h>
#import "SACardAssistKit.h"
#import "SATransitionReversibleAnimation.h"
#import "SATransitionEdgePanInteraction.h"
#import "SAMenuView.h"
#import "SACardView.h"

@interface SANavigationController ()<UINavigationControllerDelegate,SAMenuViewDelegate>

@property (nonatomic, strong) SATransitionReversibleAnimation *transitionReversibleAnimation;
//@property (nonatomic, strong) SATransitionEdgePanInteraction *transitionEdgePanInteraction;
@property (nonatomic, strong) SAMenuView *menuView;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation SANavigationController {
}

#pragma mark-
#pragma mark-View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.navigationBarHidden = YES;
    self.hiddenBackButton = NO;
}

#pragma mark-
#pragma mark- UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    [self.transitionEdgePanInteraction wireToViewController:viewController];
    if (self.hiddenBackButton) {
        self.backButton.hidden = YES;
    }else if (!self.backButton.hidden) {
        self.backButton.hidden = navigationController.viewControllers.count < 2;
    }
    
    self.menuView.hidden = self.hiddenMenuView;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.hiddenBackButton) {
        self.backButton.hidden = YES;
    }else if (self.backButton.hidden) {
        self.backButton.hidden = navigationController.viewControllers.count < 2;
    }
    
    self.menuView.hidden = self.hiddenMenuView;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    self.transitionReversibleAnimation.reverse = operation == UINavigationControllerOperationPop;
    return self.transitionReversibleAnimation;
}

//- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
//    NSLog(@"interactionControllerForAnimationController");
//
//    return self.transitionEdgePanInteraction.interactionInProgress && self.hiddenBackButton ? self.transitionEdgePanInteraction : nil;
//}

- (void)menuView:(SAMenuView *)menuView didPressMenuItemAtIndex:(NSUInteger)index {
    if (self.didSelectMenuBlock) {
        self.didSelectMenuBlock(index);
    }    
}

- (void)didPressRightItemInMenuView:(SAMenuView *)menuView {
    if (self.didSelectScanBlock) {
        self.didSelectScanBlock();
    }
}

- (void)cardViewScrollingByProgress:(CGFloat)progress {
    self.menuView.alpha = progress;
    self.backButton.alpha = progress;
}

- (void)cardViewScrollDidEndByIsNormal:(BOOL)isNormal {
    self.menuView.alpha = isNormal ? 1 : 0;
    self.backButton.alpha = isNormal ? 1 : 0;
}

- (void)setHiddenBackButton:(BOOL)hiddenBackButton {
    _hiddenBackButton = hiddenBackButton;
    self.backButton.hidden = hiddenBackButton;
}

- (void)setHiddenMenuView:(BOOL)hiddenMenuView {
    _hiddenMenuView = hiddenMenuView;
    self.menuView.hidden = hiddenMenuView;
}
#pragma mark-
#pragma mark-Event response

- (void)addMenuViewWithLeftItemNormalImage:(UIImage *)leftItemNormalImage leftItemSelectedImage:(UIImage *)leftItemSelectedImage rightItemNormalImage:(UIImage *)rightItemNormalImage rightItemSelectedImage:(UIImage *)rightItemSelectedImage expandItemNormalImageArray:(NSArray<UIImage *> *)expandItemNormalImageArray expandSelectImageArray:(NSArray<UIImage *> *)expandSelectImageArray{
    if (self.menuView.superview == nil) {
        _menuView = [[SAMenuView alloc] init];
        [self.menuView setLeftItemNormalImage:leftItemNormalImage
                        leftItemSelectedImage:leftItemSelectedImage
                         rightItemNormalImage:rightItemNormalImage
                       rightItemSelectedImage:rightItemSelectedImage];
        [self.menuView setExpandItemNormalImageArray:expandItemNormalImageArray
                                    selectImageArray:expandSelectImageArray];
        [self.view addSubview:self.menuView];
        [self.menuView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([SACardAssistKit cardFrame].leftEdgeSpace);
            make.centerX.equalTo(self.view);
            if ([SACardAssistKit cardFrame].topEdgeSpace < 50.0f) {
                make.height.mas_equalTo(60.0f);
                make.top.equalTo(self.view);
            }
            else {
                make.top.equalTo(self.view);
                make.height.mas_equalTo([SACardAssistKit cardFrame].topEdgeSpace);
            }
        }];
    }

}

- (void)addBackButtonWithNormalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage {
    if (self.backButton.superview == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backButton setImage:normalImage forState:UIControlStateNormal];
        [self.backButton setImage:selectedImage forState:UIControlStateSelected];
        [self.backButton setImage:selectedImage forState:UIControlStateHighlighted];
        [self.backButton addTarget:self action:@selector(pressBackButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.backButton];
        [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([SACardAssistKit cardFrame].leftEdgeSpace);
            make.bottom.equalTo(self.view);
            make.width.mas_equalTo(43.0f);
            make.height.mas_equalTo(50.0f);
        }];
    }
}
- (void)pressBackButtonAction {
    if (self.didSelectBackButtonBlock) {
        self.didSelectBackButtonBlock(self.topViewController);
    }
    [self popViewControllerAnimated:YES];
}

#pragma mark-
#pragma mark-Private Methods


#pragma mark-
#pragma mark-Getters && Setters

- (SATransitionReversibleAnimation *)transitionReversibleAnimation {
    if (_transitionReversibleAnimation == nil) {
        _transitionReversibleAnimation = [[SATransitionReversibleAnimation alloc] init];
    }
    return _transitionReversibleAnimation;
}

//- (SATransitionEdgePanInteraction *)transitionEdgePanInteraction {
//    if (_transitionEdgePanInteraction == nil) {
//        _transitionEdgePanInteraction = [[SATransitionEdgePanInteraction alloc] init];
//    }
//    return _transitionEdgePanInteraction;
//}

- (SAMenuView *)menuView {
    if (_menuView == nil) {

    }
    return _menuView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
