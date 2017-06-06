//
//  XHHMidViewModel.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/17.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHMidViewModel.h"

@implementation XHHMidViewModel
+ (instancetype)modelWithName:(NSString *)name title:(NSString*)title info:(NSString *)info
{
    return [[self alloc] initWithName:name title:title info:info];
}

- (instancetype)initWithName:(NSString *)name title:(NSString*)title info:(NSString *)info
{
    if (self = [super init]) {
        self.name = name;
        self.title = title;
        self.info = info;
    }
    return self;
}
@end
