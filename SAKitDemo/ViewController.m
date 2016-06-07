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
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor greenColor];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    TestViewController *testController = [[TestViewController alloc] init];
    SANavigationController *navController  =[[SANavigationController alloc] initWithRootViewController:testController];
    [self presentViewController:navController animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
