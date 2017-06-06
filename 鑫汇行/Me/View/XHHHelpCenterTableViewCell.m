//
//  XHHHelpCenterTableViewCell.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/22.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHHelpCenterTableViewCell.h"

@implementation XHHHelpCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)openClick:(id)sender {
    if (self.opencellBlock) {
        self.opencellBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
