//
//  LhkhLodingView.h
//  鑫汇行
//
//  Created by LHKH on 2017/5/15.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LhkhLodingView : UIView
/**
 *  show circle LoadingView
 *  点的圆圈
 *  @param view showed
 */
+ (void)showCircleView:(UIView *)view;
/**
 *  show dot LoadingView
 *  横向三个点
 *  @param view showed
 */

+ (void)showDotView:(UIView *)view;

/**
 *  show line LoadingView
 *  三条线上下
 *  @param view showed
 */
+ (void)showLineView:(UIView *)view;

/**
 *  show CircleJoin LoadingView
 *  实线圆圈
 *  @param view showed
 */
+ (void)showCircleJoinView:(UIView *)view;

/**
 *  hide loadingView
 *  隐藏
 */
+ (void)hide;
@end
