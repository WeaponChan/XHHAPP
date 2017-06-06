//
//  UITabBarController+XHHTabarBadge.h
//  鑫汇行
//
//  Created by LHKH on 2017/5/31.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (XHHTabarBadge)
- (void)showBadgeOnItemIndex:(int)index;//显示提示小红点标记
- (void)hideBadgeOnItemIndex:(int)index;//隐藏小红点标记
- (void)removeBadgeOnItemIndex:(int)index;//移除小红点标记
@end
