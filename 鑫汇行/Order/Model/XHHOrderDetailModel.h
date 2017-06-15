//
//  XHHOrderDetailModel.h
//  鑫汇行
//
//  Created by LHKH on 2017/5/24.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHHOrderDetailModel : NSObject
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
@property(copy,nonatomic)NSString *icard;
@end
//{"status":"1","action":"1008","key":"0f32201f62082c20a31a9ba2d6f6fe7b","totalnum":"0","msg":"","list":{"order_info":{"id":"1","order_id":"1561515616","user_name":"u5f20u4e09","phone":"13555555555","addtime":"2017-05-16 16:11:19","status":"1","sure_money":"10000.00","pro_id":"1","pro_name":"u5357u6d0bu4fddu5355u5b89u4fe1u8d37","refuse_reason":""},"user_pics":[{"id":"3","name":"u8eabu4efdu8bc1","pic":"/Uploads/test.jpg"},{"id":"2","name":"u8eabu4efdu8bc1","pic":"/Uploads/test.jpg"},{"id":"1","name":"u8eabu4efdu8bc1","pic":"\Uploads\test.jpg"}]}}
