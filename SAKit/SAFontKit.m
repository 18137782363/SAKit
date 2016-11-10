//
//  SAFontKit.m
//  ZGTextFontTest
//
//  Created by 汪志刚 on 16/8/30.
//  Copyright © 2016年 ISCS. All rights reserved.
//

#import "SAFontKit.h"
#import <objc/runtime.h>

static NSString *const kHelveticaNeueLightFont = @"HelveticaNeue-Light";

@interface UIFont (MyFont)      @end

@interface UILabel (MyFont)     @end

@interface UIButton (MyFont)    @end

@interface UITextField (MyFont) @end

@interface UITextView (MyFont)  @end


@implementation SAFontKit   @end


@implementation UIFont (MyFont)

+ (void)load{
    
    Method imp = class_getClassMethod([self class], @selector(systemFontOfSize:));
    Method myImp = class_getClassMethod([self class], @selector(mySystemFontOfSize:));
    method_exchangeImplementations(imp, myImp);
}

+ (id)mySystemFontOfSize:(CGFloat)size{
    
    UIFont *font = [UIFont mySystemFontOfSize:size];
    if (font) {
        font = [UIFont fontWithName:kHelveticaNeueLightFont size:size];
    }
    return font;
}

@end


@implementation UILabel (MyFont)

+ (void)load{
    
    Method imp = class_getInstanceMethod([self class], @selector(initWithFrame:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithFrame:));
    method_exchangeImplementations(imp, myImp);
    
    Method impCoder = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImpCoder = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(impCoder, myImpCoder);
}

- (id)myInitWithFrame:(CGRect)frame{
    
    [self myInitWithFrame:frame];
    if (self) {
        CGFloat fontSize = self.font.pointSize;
        self.font = [UIFont fontWithName:kHelveticaNeueLightFont size:fontSize];
    }
    return self;
}

- (id)myInitWithCoder:(NSCoder*)aDecode{
    
    [self myInitWithCoder:aDecode];
    if (self) {
        CGFloat fontSize = self.font.pointSize;
        self.font = [UIFont fontWithName:kHelveticaNeueLightFont size:fontSize];
    }
    return self;
}

@end



@implementation UIButton (MyFont)

+ (void)load{
    
    Method imp = class_getClassMethod([self class], @selector(buttonWithType:));
    Method myImp = class_getClassMethod([self class], @selector(myButtonWithType:));
    method_exchangeImplementations(imp, myImp);
    
    Method impCoder = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImpCoder = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(impCoder, myImpCoder);
}

+ (id)myButtonWithType:(UIButtonType)buttonType{
    
    UIButton *button = [self myButtonWithType:buttonType];
    if (button) {
        CGFloat fontSize = button.titleLabel.font.pointSize;
        button.titleLabel.font = [UIFont fontWithName:kHelveticaNeueLightFont size:fontSize];
    }
    return button;
}

- (id)myInitWithCoder:(NSCoder*)aDecode{
    
    [self myInitWithCoder:aDecode];
    if (self) {
        CGFloat fontSize = self.titleLabel.font.pointSize;
        self.titleLabel.font = [UIFont fontWithName:kHelveticaNeueLightFont size:fontSize];
    }
    return self;
}

@end



@implementation UITextField (MyFont)


+ (void)load{
    
    Method imp = class_getInstanceMethod([self class], @selector(initWithFrame:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithFrame:));
    method_exchangeImplementations(imp, myImp);
    
    Method impCoder = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImpCoder = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(impCoder, myImpCoder);
}

- (id)myInitWithFrame:(CGRect)frame{
    
    [self myInitWithFrame:frame];
    if (self) {
        CGFloat fontSize = self.font.pointSize;
        self.font = [UIFont fontWithName:kHelveticaNeueLightFont size:fontSize];
    }
    return self;
}

- (id)myInitWithCoder:(NSCoder*)aDecode{
    
    [self myInitWithCoder:aDecode];
    if (self) {
        CGFloat fontSize = self.font.pointSize;
        self.font = [UIFont fontWithName:kHelveticaNeueLightFont size:fontSize];
    }
    return self;
}

@end



@implementation UITextView (MyFont)


+ (void)load{
    
    Method imp = class_getInstanceMethod([self class], @selector(initWithFrame:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithFrame:));
    method_exchangeImplementations(imp, myImp);
    
    Method impCoder = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImpCoder = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(impCoder, myImpCoder);
}

- (id)myInitWithFrame:(CGRect)frame{
    
    [self myInitWithFrame:frame];
    if (self) {
        CGFloat fontSize = self.font.pointSize;
        self.font = [UIFont fontWithName:kHelveticaNeueLightFont size:fontSize];
    }
    return self;
}

- (id)myInitWithCoder:(NSCoder*)aDecode{
    
    [self myInitWithCoder:aDecode];
    if (self) {
        CGFloat fontSize = self.font.pointSize;
        self.font = [UIFont fontWithName:kHelveticaNeueLightFont size:fontSize];
    }
    return self;
}

@end

