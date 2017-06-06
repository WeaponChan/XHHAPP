//
//  LhkhAlertViewController.h
//  鑫汇行
//
//  Created by LHKH on 2017/5/17.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "LhkhBaseViewController.h"
typedef void(^AlertDoneBlock)(NSInteger tag);
@interface LhkhAlertViewController : LhkhBaseViewController


@property (nonatomic,copy)AlertDoneBlock  alertDoneBlock;
+ (LhkhAlertViewController *)alertVcWithTitle:(NSString *)title message:(NSString*)message AndAlertDoneAction:(AlertDoneBlock)alertAction;
@end
