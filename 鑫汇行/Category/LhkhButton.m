//
//  LhkhButton.m
//  LhkhBaseProjectDemo
//
//  Created by LHKH on 2017/3/13.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "LhkhButton.h"
#import "UIColor+LhkhColor.h"
#define PADDING 5
@interface LhkhButton()
{
    CGPoint _beginPoint;//开始点的位置
}

@end

@implementation LhkhButton

-(nonnull instancetype )initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:UIColorStr] forState:UIControlStateDisabled];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return self;
}
/*
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    //取出触摸点
    UITouch *touch  = [touches anyObject];
    //取出触摸点的位置作为起点
    _beginPoint = [touch locationInView:self];

}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    //取出触摸点
    UITouch *touch = [touches anyObject];
    //取出当前点的位置
    CGPoint curPoint = [touch locationInView:self];
    //计算出偏移量
    CGFloat x = curPoint.x - _beginPoint.x;
    CGFloat y = curPoint.y - _beginPoint.y;
    
    self.center = CGPointMake(self.center.x + x, self.center.y + y);
    
}

//判断按钮在父视图的位置，如果按钮在父视图的顶部区域375*60范围内就让按钮向上移动，如果按钮在父视图底部区域375*60范围内就让按钮向下移动，如果按钮在父视图的大小不超过一般让其显示在对应的一边
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    //按钮的frame
    CGFloat btnX = self.frame.origin.x;
    CGFloat btnY = self.frame.origin.y;
    CGFloat btnH = self.frame.size.height;
    CGFloat btnW = self.frame.size.width;
    
    //屏幕宽高
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    //获取当前按钮距离左边的距离，就是按钮的x值
    CGFloat  marginLeft = btnX;
    //获取当前按钮距离右边的距离
    CGFloat  marginRight = screenW - btnX - btnW;
    //获取当前按钮距离上边的距离
    CGFloat  marginTop = btnY;
    //获取当前按钮距离下边的距离
    CGFloat  marginBottom = screenH - btnY - btnH;
    
    [UIView animateWithDuration:0.5 animations:^{
        //判断后按钮的 新位置
        CGFloat btnNewX;
        CGFloat btnNewY;
        //判断当前按钮的位置在哪
        //上边，按钮往上靠
        if (marginTop <60) {
            //判断是否在左边 否则在右边
            if (marginLeft < marginRight) {
                btnNewX = marginLeft < PADDING ? PADDING : btnX;
            }else{
            
                btnNewX = marginRight < PADDING ? (screenW - btnW - PADDING):btnX;
            }
            btnNewX = PADDING;
            self.frame = CGRectMake(btnNewX, btnNewY, btnW, btnH);
        }else if(marginBottom < 60){//下边 往下靠
            
            //判断是否在左边 否则在右边
            if (marginLeft < marginRight) {
                btnNewX = marginLeft < PADDING ? PADDING : btnX;
            }else{
                
                btnNewX = marginRight < PADDING ? (screenW - btnW - PADDING):btnX;
            }
            btnNewY = screenH - btnH - PADDING;
            self.frame = CGRectMake(btnNewX, btnNewY, btnW, btnH);
            
        }else{//其他情况
            btnNewX = (marginLeft < marginRight ? PADDING : (screenW - btnW - PADDING));
            btnNewY = btnY;
            self.frame = CGRectMake(btnNewX, btnNewY, btnW, btnH);
        }
        
    }];
    
}
*/
@end
