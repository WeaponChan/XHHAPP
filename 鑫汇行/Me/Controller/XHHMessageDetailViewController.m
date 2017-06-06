//
//  XHHMessageDetailViewController.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/22.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHMessageDetailViewController.h"
#import "UIColor+LhkhColor.h"
#import "Masonry.h"

@interface XHHMessageDetailViewController (){

    UILabel *titleLab;
    UILabel *timeLab;
    UILabel *messageLab;
}

@end

@implementation XHHMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息详情";
    self.view.backgroundColor = [UIColor colorWithHexString:UIBgColorStr];
    [self setMessageView];
}

-(void)setMessageView{
    titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.text = @"有趣的网站互动设计欣赏";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:titleLab];
    timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    timeLab.text = @"05-12 14:02";
    timeLab.textAlignment = NSTextAlignmentCenter;
    timeLab.font = [UIFont systemFontOfSize:12];
    timeLab.textColor = [UIColor grayColor];
    [self.view addSubview:timeLab];
    messageLab = [[UILabel alloc] initWithFrame:CGRectZero];
    messageLab.text = @"如果你无法简洁的表达你的想法,那只说明你还不够了解它。如果你无法简洁的表达你的想法,那只说明你还不够了解它。如果你无法简洁的表达你的想法,那只说明你还不够了解它。如果你无法简洁的表达你的想法,那只说明你还不够了解它。如果你无法简洁的表达你的想法,那只说明你还不够了解它。如果你无法简洁的表达你的想法,那只说明你还不够了解它。如果你无法简洁的表达你的想法,那只说明你还不够了解它。如果你无法简洁的表达你的想法,那只说明你还不够了解它。";
    messageLab.numberOfLines = 0;
    messageLab.textColor = [UIColor darkGrayColor];
    messageLab.textAlignment = NSTextAlignmentLeft;
    messageLab.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:messageLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(20);
        make.left.right.mas_equalTo(self.view).offset(0);
        make.height.mas_equalTo(20);
    }];
    
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLab.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.view).offset(0);
        make.height.mas_equalTo(20);
    }];
    
    [messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeLab.mas_bottom).offset(20);
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view).offset(-10);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
