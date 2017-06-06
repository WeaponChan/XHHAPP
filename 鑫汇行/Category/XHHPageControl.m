//
//  XHHPageControl.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/31.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHPageControl.h"

@implementation XHHPageControl

-(id) initWithFrame:(CGRect)frame
{
     self = [super initWithFrame:frame];
     return self;
}
-(void) updateDots
{
     for (int i = 0; i < [self.subviews count]; i++)
     {
         UIView *dot = [self.subviews objectAtIndex:i];
         if (i == self.currentPage) {
             dot.backgroundColor = RGBA(152, 152, 152, 1);
             
         }
         else {
             dot.layer.borderWidth = 1.f;
             dot.layer.borderColor = RGBA(152, 152, 152, 1).CGColor;
//             dot.backgroundColor = [UIColor clearColor];
         }
     }
}
-(void) setCurrentPage:(NSInteger)page
{
     [super setCurrentPage:page];
     [self updateDots];
}

@end
