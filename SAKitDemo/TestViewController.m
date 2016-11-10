//
//  TestViewController.m
//  SAKitDemo
//
//  Created by ISCS01 on 16/6/7.
//  Copyright © 2016年 学宝工作室. All rights reserved.
//

#import "TestViewController.h"
#import "SACardView.h"
#import <Masonry/Masonry.h>
#import "SANavigationController.h"
#import "UIViewController+SAExtend.h"
@interface TestViewController ()<SACardViewDataSource,SACardViewDelegate>

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.modalPresentationCapturesStatusBarAppearance=NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    SACardView *cardView = [[SACardView alloc] init];
    [self.view addSubview:cardView];
    cardView.cardViewType = SACardViewTypeSinglePage;
    cardView.dataSource = self;
    cardView.delegate = self;
    
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self setBackButtonHidden:NO backBlock:^(UIViewController *currentViewController) {
        NSLog(@"TestViewController: %@",currentViewController);
    }];
}

- (UIView *)frontViewInSingleCardView:(SACardView *)singleCardView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor orangeColor];
    return view;
}

- (BOOL)cardView:(SACardView *)cardView shouldShowBackViewAtIndex:(NSUInteger)index {
    return NO;
}
//- (UIView *)headerViewInSingleCardView:(SACardSingleView *)singleCardView {
//    UIView *view = [UIView new];
//    view.backgroundColor = [UIColor blueColor];
//    return view;
//}

- (void)didPressBackButtonInCardView:(SACardView *)cardView{
    [self.navigationController popViewControllerAnimated:YES];
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
