//
//  XHHAddTableViewCell.h
//  鑫汇行
//
//  Created by LHKH on 2017/5/18.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^sureBlock)();
typedef void (^telBlock)();
@interface XHHAddTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *telView;
@property (copy,nonatomic)telBlock telblock;
@property (copy,nonatomic)sureBlock sureblock;
@property (weak, nonatomic) IBOutlet UIButton *telNum;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end
