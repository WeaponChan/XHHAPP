//
//  XHHMidView.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/17.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHMidView.h"
#import "Masonry.h"
#import "XHHMidViewModel.h"
#import "UIColor+LhkhColor.h"
@interface XHHMidView ()

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *infoLabel;

@end
@implementation XHHMidView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:40];
        nameLabel.textColor = RGBA(221, 90, 17, 1);
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:18];
//        titleLabel.textColor = RGBA(120, 120, 120, 1);
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        
        UILabel *infoLabel = [[UILabel alloc] init];
        infoLabel.textAlignment = NSTextAlignmentCenter;
        infoLabel.font = [UIFont systemFontOfSize:15];
        infoLabel.textColor = RGBA(120, 120, 120, 1);
        infoLabel.numberOfLines = 0;
        self.infoLabel = infoLabel;
        [self addSubview:infoLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    CGFloat nameLabelX = 0;
//    CGFloat nameLabelY = 0;
//    CGFloat nameLabelW = self.bounds.size.width;
//    CGFloat nameLabelH = 40;
//    self.nameLabel.frame = CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH);
//    
//    CGFloat infoLabelX = 0;
//    CGFloat infoLabelY = nameLabelH +15;
//    CGFloat infoLabelW = nameLabelW;
//    CGFloat infoLabelH = self.bounds.size.height - nameLabelH-15;
//    self.infoLabel.frame = CGRectMake(infoLabelX, infoLabelY, infoLabelW, infoLabelH);
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(0);
        make.right.left.mas_equalTo(self).offset(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.right.mas_equalTo(self).offset(-15);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self).offset(15);
        make.right.mas_equalTo(self).offset(-15);
        make.height.mas_equalTo(40);
//        make.bottom.mas_equalTo(self).offset(-25);
    }];
    
}


- (void)setModel:(XHHMidViewModel *)model
{
    _model = model;
    NSString *str = model.name;
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange rangel = [[textColor string] rangeOfString:[str substringWithRange:NSMakeRange(str.length-1, 1)]];
    [textColor addAttribute:NSForegroundColorAttributeName value:RGBA(221, 90, 17, 1) range:rangel];
    [textColor addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:rangel];
    [self.nameLabel setAttributedText:textColor];
    self.titleLabel.text = model.title;
    self.infoLabel.text = model.info;
    
}

@end
