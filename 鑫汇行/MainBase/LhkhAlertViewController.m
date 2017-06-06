//
//  LhkhAlertViewController.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/17.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "LhkhAlertViewController.h"
#import "UIColor+LhkhColor.h"
@interface LhkhAlertViewController ()
@property (weak, nonatomic) IBOutlet UIView *allView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *messageLab;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqkefuBtn;
@property (nonatomic,copy)NSString *alert_Title;
@property (nonatomic,copy)NSString *alert_message;
@end

@implementation LhkhAlertViewController

+ (LhkhAlertViewController *)alertVcWithTitle:(NSString *)title message:(NSString*)message AndAlertDoneAction:(AlertDoneBlock)alertAction{
    LhkhAlertViewController *vc = [[LhkhAlertViewController alloc]initWithTitle:title message:message AndAlertDoneAction:(AlertDoneBlock)alertAction];
    return vc;
}

- (instancetype)initWithTitle:(NSString *)alert_Title message:(NSString*)alert_message AndAlertDoneAction:(AlertDoneBlock)alertAction{
    
    if (self = [super init]) {
        NSLog(@"----%@----%@",alert_Title,alert_message);
        self.alert_Title = alert_Title;
        self.alert_message = alert_message;
        self.alertDoneBlock = alertAction;

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = self.alert_Title;
    self.messageLab.text = self.alert_message;
    self.cancelBtn.layer.borderWidth = 1.f;
    self.cancelBtn.layer.borderColor = RGBA(200, 200, 200, 1).CGColor;
    self.sureBtn.layer.borderWidth = 1.f;
    self.sureBtn.layer.borderColor = RGBA(200, 200, 200, 1).CGColor;
    self.allView.layer.cornerRadius = 4.f;
    self.allView.layer.masksToBounds = YES;
    self.allView.layer.borderWidth = 1.f;
    self.allView.layer.borderColor = RGBA(200, 200, 200, 1).CGColor;
}

- (IBAction)clickAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 100) { //取消按钮
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    else if(btn.tag == 101){
        if (self.alertDoneBlock) {
            self.alertDoneBlock(btn.tag);
        }
        [self dismissViewControllerAnimated:NO completion:nil];
    }else{
        if (self.alertDoneBlock) {
            self.alertDoneBlock(btn.tag);
        }
        [self dismissViewControllerAnimated:NO completion:nil];
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
