//
//  XHHBottomViewModel.h
//  鑫汇行
//
//  Created by LHKH on 2017/5/23.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHHBottomViewModel : NSObject
@property(copy,nonatomic)NSString *title;
@property (nonatomic, strong) NSArray *titles;
+ (instancetype)modelWithArr:(NSArray *)titleArr;
- (instancetype)initWithArr:(NSArray *)titleArr;
@end
