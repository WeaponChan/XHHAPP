//
//  XHHxiugaiTableViewCell.h
//  鑫汇行
//
//  Created by LHKH on 2017/5/19.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^xiugaiBlock)();

@interface XHHxiugaiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *xiugaiBtn;
@property (copy,nonatomic)xiugaiBlock xiugaiblock;
@end
