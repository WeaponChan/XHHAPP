//
//  XHHLogOutTableViewCell.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/19.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHLogOutTableViewCell.h"

@implementation XHHLogOutTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.logOutBtn.layer.cornerRadius = 4.f;
    self.logOutBtn.layer.masksToBounds = YES;
}
- (IBAction)logOutClick:(id)sender {
    if (self.logoutblock) {
        self.logoutblock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
