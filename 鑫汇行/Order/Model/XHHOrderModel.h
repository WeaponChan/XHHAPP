//
//  XHHOrderModel.h
//  鑫汇行
//
//  Created by LHKH on 2017/5/24.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHHOrderModel : NSObject
@property(copy,nonatomic)NSString *ID;
@property(copy,nonatomic)NSString *order_id;
@property(copy,nonatomic)NSString *user_name;
@property(copy,nonatomic)NSString *phone;
@property(copy,nonatomic)NSString *addtime;
@property(copy,nonatomic)NSString *status;
@property(copy,nonatomic)NSString *sure_money;
@property(copy,nonatomic)NSString *pro_id;
@property(copy,nonatomic)NSString *pro_name;
@property(copy,nonatomic)NSString *refuse_reason;
@property(copy,nonatomic)NSString *order_money;
@end
