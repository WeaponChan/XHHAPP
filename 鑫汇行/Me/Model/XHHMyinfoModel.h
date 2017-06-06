//
//  XHHMyinfoModel.h
//  鑫汇行
//
//  Created by LHKH on 2017/5/25.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHHMyinfoModel : NSObject
@property (copy,nonatomic)NSString *ID;
@property (copy,nonatomic)NSString *pic;
@property (copy,nonatomic)NSString *name;
@property (copy,nonatomic)NSString *phone;
@property (copy,nonatomic)NSString *birth;
@property (copy,nonatomic)NSString *city;
@property (copy,nonatomic)NSString *rec_name;
@end
/*
{
    "id": "1",
    "pic": "/uploads/my_hader.jpg",
    "name": "张三",
    "phone": "11377606508",
    "birth": "2017-05-25",
    "city": "南京",
    "rec_name": "jack"
}*/
