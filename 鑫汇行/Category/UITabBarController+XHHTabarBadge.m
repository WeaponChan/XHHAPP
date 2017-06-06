//
//  UITabBarController+XHHTabarBadge.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/31.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "UITabBarController+XHHTabarBadge.h"
#define TabbarItemNums 5.0    //tabbar的数量
@implementation UITabBarController (XHHTabarBadge)
- (void)showBadgeOnItemIndex:(int)index{
    
    [self removeBadgeOnItemIndex:index];
    
    UIView *badgeView = [[UIView alloc]init];
    
    badgeView.tag =888 + index;
    
    badgeView.layer.cornerRadius = 4;
    
    badgeView.backgroundColor = [UIColor redColor];
    
    CGRect tabFrame = self.tabBar.frame;
    
    float percentX = (index +0.6) /TabbarItemNums;
    
    CGFloat x = ceilf(percentX * tabFrame.size.width)+ 5;
    
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    
    badgeView.frame =CGRectMake(x, y, 8,8);
    
    [self.tabBar addSubview:badgeView];
    
}

- (void)hideBadgeOnItemIndex:(int)index{
    
    [self removeBadgeOnItemIndex:index];
    
}

- (void)removeBadgeOnItemIndex:(int)index{
    
    for (UIView *subView in self.tabBar.subviews) {
        
        if (subView.tag ==888+index) {
            
            [subView removeFromSuperview];
            
        }
    }
}
@end
