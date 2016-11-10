//
//  SAPageControl.h
//  SAPageControl
//
//  Created by 汪志刚 on 16/8/13.
//  Copyright © 2016年 ISCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SACardView.h"

typedef void(^PageControlDidChange)(NSInteger page);
typedef void(^PageControlDidEndChange)(NSInteger page);

@protocol SACardViewAccessoryProtocol;
@interface SAPageControl : UIView<SACardViewAccessoryProtocol>

@property (nonatomic, copy) PageControlDidChange pageDidChange;
@property (nonatomic, copy) PageControlDidEndChange pageDidEndChange;
/*! 页数,默认为2 */
@property (nonatomic, assign) NSInteger pageCount;
/*! 当前选中的页面,默认为1 */
@property (nonatomic, assign, getter=getCurrentPage) NSInteger currentPage;


- (void)reloadPageControl;
- (void)scrollToNextPage;

@end
