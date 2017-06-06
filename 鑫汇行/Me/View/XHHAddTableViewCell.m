//
//  XHHAddTableViewCell.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/18.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHAddTableViewCell.h"

@implementation XHHAddTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.sureBtn.layer.cornerRadius = 4.f;
    self.sureBtn.layer.masksToBounds = YES;
    self.telView.layer.cornerRadius  = 4.f;
    self.telView.layer.masksToBounds = YES;
    self.telView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.telView.layer.borderWidth = 1.f;
}
- (IBAction)sureClick:(id)sender {
    if (self.sureblock) {
        self.sureblock();
    }
}
- (IBAction)telClick:(id)sender {
    if (self.telblock) {
        self.telblock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
