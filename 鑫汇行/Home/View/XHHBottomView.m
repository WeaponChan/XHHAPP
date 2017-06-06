//
//  XHHBottomView.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/23.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHBottomView.h"
#import "Masonry.h"
#import "XHHBottomViewModel.h"
@interface XHHBottomView ()<UIScrollViewDelegate>

@property (nonatomic, weak) UILabel *title1;
@property (nonatomic, weak) UILabel *title2;
@property (nonatomic, weak) UILabel *title3;
@property (nonatomic, weak) UILabel *title4;
@property (nonatomic, weak) NSArray *titleArr;
@property (nonatomic,strong) UIScrollView *LhkhScrollView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) CGFloat viewH;

@end
@implementation XHHBottomView

- (UIScrollView *)ccpScrollView {
    
    if (_LhkhScrollView == nil) {
        
        _LhkhScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _LhkhScrollView.showsHorizontalScrollIndicator = NO;
        _LhkhScrollView.showsVerticalScrollIndicator = NO;
        _LhkhScrollView.scrollEnabled = NO;
        _LhkhScrollView.pagingEnabled = YES;
        [self addSubview:_LhkhScrollView];
        
        [_LhkhScrollView setContentOffset:CGPointMake(0 , self.viewH) animated:YES];
    }
    
    return _LhkhScrollView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UILabel *title1 = [[UILabel alloc] init];
        title1.textAlignment = NSTextAlignmentCenter;
        title1.font = [UIFont systemFontOfSize:14];
        title1.textColor = [UIColor grayColor];
        self.title1 = title1;
        [_LhkhScrollView addSubview:title1];
        
        UILabel *title2 = [[UILabel alloc] init];
        title2.textAlignment = NSTextAlignmentCenter;
        title2.font = [UIFont systemFontOfSize:14];
        title2.textColor = [UIColor grayColor];
        self.title2 = title2;
        [_LhkhScrollView addSubview:title2];
        
        UILabel *title3 = [[UILabel alloc] init];
        title3.textAlignment = NSTextAlignmentCenter;
        title3.font = [UIFont systemFontOfSize:14];
        title3.textColor = [UIColor grayColor];
        self.title3 = title3;
        [_LhkhScrollView addSubview:title3];
        
        UILabel *title4 = [[UILabel alloc] init];
        title4.textAlignment = NSTextAlignmentCenter;
        title4.font = [UIFont systemFontOfSize:14];
        title4.textColor = [UIColor grayColor];
        self.title4 = title4;
        [_LhkhScrollView addSubview:title4];
        
        if (_titleArr == nil) {
            _titleArr = [NSArray array];
        }
        self.viewH = frame.size.height;
        self.LhkhScrollView.delegate = self;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.title1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(5);
        make.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self).offset(-10);
    }];
    
    [self.title2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self).offset(-10);
        make.top.mas_equalTo(self.title1.mas_bottom).offset(10);
    }];
    
    [self.title3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self).offset(-10);
        make.top.mas_equalTo(self.title2.mas_bottom).offset(10);
    }];
    
    [self.title4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self).offset(-10);
        make.top.mas_equalTo(self.title3.mas_bottom).offset(10);
    }];
    
}


- (void)setModel:(XHHBottomViewModel *)model
{
    _model = model;
    
    self.title1.text = model.titles[0];
    self.title2.text = model.titles[1];
    self.title3.text = model.titles[2];
    self.title4.text = model.titles[3];
    
}

@end
