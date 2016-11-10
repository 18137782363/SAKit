//
//  SABubbleView.m
//  SAPageControl
//
//  Created by 汪志刚 on 16/8/16.
//  Copyright © 2016年 ISCS. All rights reserved.
//

#import "SABubbleView.h"

@interface SABubbleView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation SABubbleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initMethod];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initMethod];
    }
    return self;
}

- (void)initMethod{
    [self addSubview:self.imageView];
    [self addSubview:self.titleLab];
    self.titleLab.center = CGPointMake(self.center.x, self.center.y - 2);
}

#pragma mark--  setter and getter
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,20)];
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = [UIColor whiteColor];
        
    }
    return _titleLab;
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _imageView.image = [UIImage imageNamed:@"projection"];
    }
    return _imageView;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
}

@end
