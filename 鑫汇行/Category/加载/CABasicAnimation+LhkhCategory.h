//
//  CABasicAnimation+LhkhCategory.h
//  鑫汇行
//
//  Created by LHKH on 2017/5/15.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CABasicAnimation (LhkhCategory)
/**
 *  forever twinkling  永久闪烁的动画
 *
 *  @param time   time duration 持续时间
 *
 *  @return self   返回当前类
 */
+ (CABasicAnimation *)opacityForever_Animation:(float)time;
@end
