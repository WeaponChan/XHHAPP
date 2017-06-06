//
//  XHHApplyBtnTableViewCell.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/16.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHApplyBtnTableViewCell.h"

@implementation XHHApplyBtnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.apllyBtn.layer.cornerRadius = 4.f;
    self.apllyBtn.layer.masksToBounds = YES;
}
- (IBAction)applyClick:(id)sender {
    if (self.applyblock) {
        self.applyblock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
