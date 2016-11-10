//
//  RootViewController.m
//  SAKitDemo
//
//  Created by 学宝 on 2016/11/8.
//  Copyright © 2016年 学宝工作室. All rights reserved.
//

#import "RootViewController.h"
#import "SACardInfoView.h"
#import <Masonry/Masonry.h>
#import "ViewController.h"
#import "UIViewController+SAExtend.h"

@interface RootViewController () <SACardInfoViewDelegate,SACardInfoViewDataSource>
@property (nonatomic, strong) SACardInfoView *cardInfoView;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.modalPresentationCapturesStatusBarAppearance=NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.cardInfoView];
    [self.cardInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setMenuViewHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self setMenuViewHidden:NO];
}

- (SACardInfoView *)cardInfoView {
    if (!_cardInfoView) {
        _cardInfoView = [SACardInfoView new];
        _cardInfoView.shouldHaveSubTitle = YES;
        _cardInfoView.existBackBtn = NO;
        _cardInfoView.backgroundColor = [UIColor redColor];
        _cardInfoView.delegate = self;
        _cardInfoView.dataSource = self;
    }
    return _cardInfoView;
}

- (NSInteger)numberOfItemsInCardInfoView:(SACardInfoView *)cardInfoView {
    return 20;
}

- (UICollectionViewCell *)cardInfoView:(SACardInfoView *)cardInfoView cellForDeployCardInfoViewCell:(UICollectionViewCell *)deployCell atIndex:(NSInteger)index {
    deployCell.backgroundColor = [UIColor blueColor];
    return deployCell;
}

- (void)cardInfoView:(SACardInfoView *)cardInfoView didSelectedItemAtIndex:(NSInteger)index {
    ViewController *vieC = [[ViewController alloc] init];
    [self.navigationController pushViewController:vieC animated:YES];

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
