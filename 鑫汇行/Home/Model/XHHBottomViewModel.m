//
//  XHHBottomViewModel.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/23.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHBottomViewModel.h"

@implementation XHHBottomViewModel
+ (instancetype)modelWithArr:(NSArray *)titleArr
{
    return [[self alloc] initWithArr:titleArr];
}

- (instancetype)initWithArr:(NSArray *)titleArr
{
    if (self = [super init]) {
        
        self.titles = titleArr;
    }
    return self;
}

- (NSArray *)titles
{
    if (!_titles) {
        _titles = [NSArray array];
    }
    return _titles;
}
@end
