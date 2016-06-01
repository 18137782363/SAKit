//
//  SAMutilSelectedItem.m
//  SAMutilSelectedView
//
//  Created by WZG on 16/4/25.
//  Copyright © 2016年 浙江网仓科技有限公司. All rights reserved.
//

#import "SAMutilSelectedItem.h"

@implementation SAMutilSelectedItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init{
    self = [super init];
    if (self) {
        
        [self initMethod];
    }
    return self;
}

- (void)initMethod{
    
    self.backgroundColor = [UIColor yellowColor];
    
    self.layer.shadowOpacity = 1;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowRadius = 1;
}

@end
