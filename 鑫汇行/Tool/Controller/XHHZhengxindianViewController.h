//
//  XHHZhengxindianViewController.h
//  鑫汇行
//
//  Created by LHKH on 2017/5/24.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "LhkhBaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
@protocol JSObjectDelegate <JSExport>

- (void)shareMessage:(NSString *)datas;
- (void)shareWeChat:(NSString *)url;

@end
@interface XHHZhengxindianViewController : LhkhBaseViewController
@property (copy ,nonatomic)NSString *url;
@end
