//
//  XHHOrderViewController.h
//  鑫汇行
//
//  Created by LHKH on 2017/5/15.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "LhkhBaseViewController.h"
typedef NS_ENUM(NSUInteger, OrderType) {
    OrderTypeAll = 0, // 全部
    OrderTypeAplly = 1, // 申请中
    OrderTypeHandle = 2, // 处理中
    OrderTypeSuccess = 3, // 已放贷
    OrderTypeFail = 5 // 未通过
};
@interface XHHOrderViewController : LhkhBaseViewController

@end
