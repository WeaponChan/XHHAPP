//
//  XHHOrderTableViewCell.h
//  鑫汇行
//
//  Created by LHKH on 2017/5/17.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^OrderApplyStatusBlock)();
@interface XHHOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *statusImg;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *companyLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;
@property (weak, nonatomic) IBOutlet UILabel *applyTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UIImageView *checkImg;
@property (copy, nonatomic) OrderApplyStatusBlock  orderApplyStatusBlock;
@property (weak, nonatomic) IBOutlet UILabel *failLab;
@end
