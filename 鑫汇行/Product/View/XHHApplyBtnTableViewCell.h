//
//  XHHApplyBtnTableViewCell.h
//  鑫汇行
//
//  Created by LHKH on 2017/5/16.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ApplyBlock)();
@interface XHHApplyBtnTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *apllyBtn;
@property (copy, nonatomic) ApplyBlock applyblock;

@end
