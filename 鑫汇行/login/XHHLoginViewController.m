//
//  XHHLoginViewController.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/15.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHLoginViewController.h"
#import "UIColor+LhkhColor.h"
#import "XHHTestnumViewController.h"
#import "XHHRegisterViewController.h"
#import "MBProgressHUD+Add.h"
#import "AppDelegate.h"
@interface XHHLoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@end

@implementation XHHLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor colorWithHexString:UIBgColorStr];
    self.navigationItem.title = @"登录";
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"back_more-1"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    left.imageInsets = UIEdgeInsetsMake(0, 10, 0, 15);
    self.navigationItem.leftBarButtonItem = left;
    self.nextBtn.layer.cornerRadius = 4.f;
    self.nextBtn.layer.masksToBounds = YES;
    self.phoneText.delegate = self;
    self.phoneText.keyboardType = UIKeyboardTypeNumberPad;
    
    
}

-(void)back{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isloginOut = YES;
    [(AppDelegate *)[UIApplication sharedApplication].delegate  openTabHomeCtrl];
}

- (IBAction)LoginClick:(id)sender {
    NSLog(@"----->%@",self.phoneText.text);
    if (self.phoneText.text.length > 0 && self.phoneText.text != nil && ![self.phoneText isKindOfClass:[NSNull  class]] && ![self.phoneText.text isEqualToString:@""] && !(self.phoneText.text.length > 11)) {
        XHHTestnumViewController *vc = [[XHHTestnumViewController alloc]init];
        vc.phoneNum = self.phoneText.text;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [MBProgressHUD show:@"请正确输入手机号码" view:self.view];
        return;
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.phoneText resignFirstResponder];
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
