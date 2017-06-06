//
//  XHHxiugaiTableViewCell.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/19.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHxiugaiTableViewCell.h"

@implementation XHHxiugaiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.xiugaiBtn.layer.cornerRadius = 4.f;
    self.xiugaiBtn.layer.masksToBounds = YES;
}
- (IBAction)xiugaiClick:(id)sender {
    if (self.xiugaiblock) {
        self.xiugaiblock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
