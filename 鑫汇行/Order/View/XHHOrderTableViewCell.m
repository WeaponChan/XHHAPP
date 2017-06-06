//
//  XHHOrderTableViewCell.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/17.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHOrderTableViewCell.h"
#import "UIColor+LhkhColor.h"
@implementation XHHOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.statusBtn.layer.cornerRadius = 4.f;
    self.statusBtn.layer.masksToBounds = YES;
    self.statusBtn.layer.borderColor = [UIColor colorWithHexString:UIColorStr].CGColor;
    self.statusBtn.layer.borderWidth = 1.f;
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/6);
    self.checkImg.transform = transform;
}
- (IBAction)statusClick:(id)sender {
    if (self.orderApplyStatusBlock) {
        self.orderApplyStatusBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
