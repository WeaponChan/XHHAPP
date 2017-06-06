//
//  UIColor+LhkhColor.h
//  LhkhBaseProjectDemo
//
//  Created by LHKH on 2017/2/28.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LhkhColor)
+(UIColor *)colorWithHexString:(NSString *)hexString;

+(UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

- (CGFloat)red;
- (CGFloat)green;
- (CGFloat)blue;
- (CGFloat)alpha;

- (UIColor *)darkerColor;
- (UIColor *)lighterColor;
- (BOOL)isLighterColor;
- (BOOL)isClearColor;
@end
