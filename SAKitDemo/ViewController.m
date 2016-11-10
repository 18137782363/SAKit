//
//  ViewController.m
//  SAKitDemo
//
//  Created by ISCS01 on 16/6/1.
//  Copyright © 2016年 学宝工作室. All rights reserved.
//

#import "ViewController.h"
#import "SANavigationController.h"
#import "TestViewController.h"
#import <Masonry/Masonry.h>
#import "SACardView.h"
#import "SACardAssistView.h"
#import "UIViewController+SAExtend.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<SACardViewDataSource,SACardAssistViewDelegate,SACardViewDelegate>

@property (nonatomic, strong) SACardView *cardView;
@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) SACardAssistView *header1View, *header2View;
@property (nonatomic, strong) SACardAssistView *footer1View, *footer2View;

@end

@implementation ViewController{
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    SACardView *cardView = [[SACardView alloc] init];
//    cardView.cardViewType = SACardViewTypeSinglePage;
    [self.view addSubview:cardView];
    
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    cardView.dataSource = self;
    cardView.delegate = self;
    _cardView = cardView;
    
    self.data = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"", nil];
    [self.cardView reloadData];
    [self.cardView setPageControlTotalCount:self.data.count];
    [self.cardView addCardViewAccessoryObject:(SANavigationController *)self.navigationController];
    
    NSLog(@"111viewDidLoad");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setBackButtonHidden:NO backBlock:^(UIViewController *currentViewController) {
        NSLog(@"TestViewController: %@",currentViewController);
    }];
    NSLog(@"111viewWillAppear");
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"111viewDidAppear");
}

- (NSUInteger)numberOfCollectionViewCellInCardView:(SACardView *)cardView {
    return 1;
}

- (Class)collectionCellClassInCardView:(SACardView *)cardView {
    return [UICollectionViewCell class];
}

- (Class)collectionBackCellClassInCardView:(SACardView *)cardView {
    return [UICollectionViewCell class];
}

- (UIView *)frontViewInSingleCardView:(SACardView *)singleCardView {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor orangeColor];
    titleLabel.text = @"正面";
    return titleLabel;
}

- (UIView *)backViewInSingleCardView:(SACardView *)singleCardView {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor purpleColor];
    titleLabel.text = @"反面";
    return titleLabel;
}

- (UIView *)cardView:(SACardView *)cardView headerViewAtIndex:(NSUInteger)index{
    if (index == 2) {
        return self.header2View;
    }else{
        return self.header1View;
    }
}

- (BOOL)cardView:(SACardView *)cardView shouldShowHeaderViewAtIndex:(NSUInteger)index {
    return YES;
}

- (BOOL)cardView:(SACardView *)cardView shouldShowFooterViewAtIndex:(NSUInteger)index {
    return YES;
}

- (UIView *)cardView:(SACardView *)cardView footerViewAtIndex:(NSUInteger)index{
    if (index) {
        return self.footer2View;
    }else{
        return self.footer1View;
    }
}

- (UICollectionViewCell *)cardView:(SACardView *)cardView cellForDeployCollectionViewCell:(UICollectionViewCell *)collectionViewCell index:(NSUInteger)index {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 290, 40)];
    titleLabel.text = @(index).stringValue;
    titleLabel.backgroundColor = [UIColor yellowColor];
    [collectionViewCell.contentView addSubview:titleLabel];
    if (index % 2) {
        collectionViewCell.backgroundColor = [UIColor redColor];
    }else{
        collectionViewCell.backgroundColor = [UIColor blueColor];
    }
    if ([collectionViewCell.reuseIdentifier isEqualToString:@"com.sakit.cardBackCell.identifer"]) {
        titleLabel.text = @"背面";
        collectionViewCell.backgroundColor = [UIColor yellowColor];
    }
    
    UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(0, 200, 200, 40)];
    [collectionViewCell addSubview:field];
    field.backgroundColor = [UIColor whiteColor];
    return collectionViewCell;
}

- (void)cardView:(SACardView *)cardHeaderView didEndDeceleratingAtIndex:(NSUInteger)index {
    NSLog(@"didEndDeceleratingAtIndex: %li",(long)index);
}

- (BOOL)isExistLongPressGestureInCardView:(SACardView *)cardView {
    return YES;
}

- (BOOL)cardView:(SACardView *)cardView shouldResponseLongPressGestureAtIndex:(NSUInteger)index {
    return YES;
}

- (void)cardView:(SACardView *)cardView didLongPressGestureAtIndex:(NSUInteger)index {
    NSLog(@"didLongPressGestureAtIndex");

}

- (void)cardAssistView:(SACardAssistView *)cardAssistView didPressItemButtonAtIndex:(NSUInteger)index{
    if (index == 0) {
        [self.cardView reloadData];
    }else if(index == 1){
        [self.data removeObjectAtIndex:1];
        
        [self.cardView deleteCardsAtIndexs:@[@(1)] completion:^(BOOL finished) {
            NSLog(@"finished: %i",finished);
        }];
    }else {
        [self.cardView resetCardViewStatusToNormal];
        TestViewController *testController = [[TestViewController alloc] init];
        [self.navigationController pushViewController:testController animated:YES];
    }
}

- (SACardAssistView *)header1View{
    if (!_header1View) {
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button1 setTitle:@"reload" forState:UIControlStateNormal];
        button1.titleLabel.font = [UIFont systemFontOfSize:14];
        button1.backgroundColor = [UIColor blackColor];
        button1.frame = CGRectMake(0, 0, 60, 34);
        
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button2 setTitle:@"delete" forState:UIControlStateNormal];
        button2.backgroundColor = [UIColor orangeColor];
        button2.titleLabel.font = [UIFont systemFontOfSize:14];
        button2.frame = CGRectMake(0, 0, 60, 34);
//        [button2 addTarget:self action:@selector(deleteCard) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button3 setTitle:@"button3" forState:UIControlStateNormal];
        button3.backgroundColor = [UIColor purpleColor];
        button3.titleLabel.font = [UIFont systemFontOfSize:14];
        button3.frame = CGRectMake(0, 0, 60, 34);
        
        _header1View = [[SACardAssistView alloc]initWithButtonArray:@[button1,button2,button3] type:SACardAssistTypeTop];
        _header1View.tag = 1000;
        _header1View.delegate = self;

    }
    return _header1View;
}
- (SACardAssistView *)header2View{
    if (!_header2View) {
        _header2View = [[SACardAssistView alloc]initWithButtonImageNames:@[@"icon_agreeCur",@"icon_agreeCur"] type:SACardAssistTypeBottom];
        _header2View.tag = 2000;
        _header2View.delegate = self;
    }
    return _header2View;
}

- (SACardAssistView *)footer1View{
    if (!_footer1View) {
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button1 setTitle:@"footer1" forState:UIControlStateNormal];
        button1.titleLabel.font = [UIFont systemFontOfSize:14];
        button1.backgroundColor = [UIColor blackColor];
        button1.frame = CGRectMake(0, 0, 60, 34);
        
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button2 setTitle:@"footer2" forState:UIControlStateNormal];
        button2.backgroundColor = [UIColor orangeColor];
        button2.titleLabel.font = [UIFont systemFontOfSize:14];
        button2.frame = CGRectMake(0, 0, 60, 34);
        
        UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button3 setTitle:@"footer3" forState:UIControlStateNormal];
        button3.backgroundColor = [UIColor purpleColor];
        button3.titleLabel.font = [UIFont systemFontOfSize:14];
        button3.frame = CGRectMake(0, 0, 60, 34);
        
        _footer1View = [[SACardAssistView alloc]initWithButtonArray:@[button1,button2,button3] type:SACardAssistTypeTop];
        _footer1View.tag = 1000;
        _footer1View.delegate = self;
        
    }
    return _footer1View;
}
- (SACardAssistView *)footer2View{
    if (!_footer2View) {
        _footer2View = [[SACardAssistView alloc]initWithButtonImageNames:@[@"icon_agreeCur",@"icon_agreeCur",@"nav_task"] type:SACardAssistTypeBottom];
        _footer2View.tag = 2000;
        _footer2View.delegate = self;
    }
    return _footer2View;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
