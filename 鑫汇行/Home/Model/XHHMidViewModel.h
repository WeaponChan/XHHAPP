//
//  XHHMidViewModel.h
//  鑫汇行
//
//  Created by LHKH on 2017/5/17.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHHMidViewModel : NSObject
@property(copy,nonatomic)NSString *name;
@property(copy,nonatomic)NSString *title;
@property(copy,nonatomic)NSString *info;

+ (instancetype)modelWithName:(NSString *)name title:(NSString*)title info:(NSString *)info;
- (instancetype)initWithName:(NSString *)name title:(NSString*)title info:(NSString *)info;
@end
