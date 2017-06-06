//
//  XHHModifyInfoViewController.h
//  鑫汇行
//
//  Created by LHKH on 2017/5/19.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "LhkhBaseViewController.h"
@class XHHModifyInfoViewController;
@protocol modifyValueDelegate <NSObject>

-(void)modifyValue:(NSString*)value;

@end
@interface XHHModifyInfoViewController : LhkhBaseViewController
@property (nonatomic,weak) id<modifyValueDelegate> delegate;
@end
