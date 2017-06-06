//
//  XHHModifyInfoViewController.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/19.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHModifyInfoViewController.h"
#import "UIColor+LhkhColor.h"
#import "MBProgressHUD+Add.h"
@interface XHHModifyInfoViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *modifyText;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation XHHModifyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改用户信息";
    self.view.backgroundColor = [UIColor colorWithHexString:UIBgColorStr];
    self.modifyText.layer.cornerRadius = 4.f;
    self.modifyText.layer.masksToBounds = YES;
    self.saveBtn.layer.cornerRadius = 4.f;
    self.saveBtn.layer.masksToBounds = YES;
    
}
- (IBAction)saveClick:(id)sender {
    if (self.modifyText.text.length > 0) {
        if ([self.delegate respondsToSelector:@selector(modifyValue:)]) {
            [self.delegate modifyValue:self.modifyText.text];
        }
        [self.navigationController popViewControllerAnimated:NO];
    }else{
    
        [MBProgressHUD show:@"修改信息不能为空额" view:self.view];
    }
    
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
