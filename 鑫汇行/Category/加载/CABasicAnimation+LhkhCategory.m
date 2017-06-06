//
//  CABasicAnimation+LhkhCategory.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/15.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "CABasicAnimation+LhkhCategory.h"

@implementation CABasicAnimation (LhkhCategory)
#pragma mark === 永久闪烁的动画 ======
+ (CABasicAnimation *)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = @1.f;
    animation.toValue = @0;//这是透明度。
    animation.autoreverses = YES; //
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    //定义动画的样式 渐入式   timingFunction 控制动画运行的节奏
    animation.timingFunction =[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return animation;
    
}
@end
