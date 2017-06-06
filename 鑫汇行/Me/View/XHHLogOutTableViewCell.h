//
//  XHHLogOutTableViewCell.h
//  鑫汇行
//
//  Created by LHKH on 2017/5/19.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^LogoutBlock)();
@interface XHHLogOutTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *logOutBtn;
@property (copy,nonatomic)LogoutBlock logoutblock;
@end
