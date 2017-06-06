//
//  XHHMyCardViewController.h
//  鑫汇行
//
//  Created by LHKH on 2017/5/18.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "LhkhBaseViewController.h"

@interface XHHMyCardViewController : LhkhBaseViewController
@property (copy,nonatomic)NSString *user_id;
@property (weak, nonatomic) IBOutlet UIView *blankView;
@property BOOL isHaveCard;
@end
