//
//  XHHTestnumViewController.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/15.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHTestnumViewController.h"
#import "AppDelegate.h"
#import "LhkhLodingView.h"
#import "XHHNoteViewController.h"
#import "MBProgressHUD+Add.h"
#import "LhkhHttpsManager.h"
@interface XHHTestnumViewController ()<UITextFieldDelegate>
{
    AppDelegate *appdelegate;
    NSTimer *mTimer;
    int time;
}
@property (weak, nonatomic) IBOutlet UITextField *testNumText;
@property (weak, nonatomic) IBOutlet UIButton *regetBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end

@implementation XHHTestnumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"输入验证码";
    self.regetBtn.layer.cornerRadius = 4.f;
    self.regetBtn.layer.masksToBounds = YES;
    self.timeLab.layer.cornerRadius = 4.f;
    self.timeLab.layer.masksToBounds = YES;
    self.timeLab.text = @"60秒";
    self.loginBtn.layer.cornerRadius = 4.f;
    self.loginBtn.layer.masksToBounds = YES;
    self.testNumText.delegate = self;
    self.testNumText.keyboardType = UIKeyboardTypeNumberPad;
    [self.testNumText becomeFirstResponder];
    appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self startTimer];
    
}
//登录
- (IBAction)loginClick:(id)sender {
    
    if (self.checkBtn.selected == YES) {
        NSMutableDictionary *params = [NSMutableDictionary  dictionary];
        params[@"action"] = @(1023);
        params[@"phone"] = @(self.phoneNum.integerValue);
        params[@"ver_code"] = @(self.testNumText.text.integerValue);
        
        NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1023",XHHBaseUrl];
        [LhkhHttpsManager requestWithURLString:url parameters:params type:2 success:^(id responseObject) {
            NSLog(@"-----LoginSuccess=%@",responseObject);
            if ([responseObject[@"status"] isEqualToString:@"1"]) {
                NSString *user_mobile = responseObject[@"list"][@"user_mobile"];
                NSString *user_id = responseObject[@"list"][@"user_id"];
                NSString *user_key = responseObject[@"list"][@"user_key"];
                [[NSUserDefaults standardUserDefaults] setObject:user_mobile forKey:@"USER"];
                [[NSUserDefaults standardUserDefaults] setObject:user_id forKey:@"USER_ID"];
                [[NSUserDefaults standardUserDefaults] setObject:user_key forKey:@"USER_KEY"];
                appdelegate.isloginOut = YES;
                [appdelegate openTabHomeCtrl];
            }else{
                [MBProgressHUD show:responseObject[@"msg"] view:self.view];
            }
            
        } failure:^(NSError *error) {
            NSString *str = [NSString stringWithFormat:@"%@",error];
            [MBProgressHUD show:str view:self.view];
        }];
        
    }else{
        [MBProgressHUD show:@"请同意鑫汇行的用户手册" view:self.view];
    }
    
  
}
//重新获取验证码
- (IBAction)regetNumClick:(id)sender {
    if (self.phoneNum.length > 0 && self.phoneNum != nil && ![self.phoneNum isKindOfClass:[NSNull  class]] && ![self.phoneNum isEqualToString:@""] && !(self.phoneNum.length > 11)) {
        
        NSMutableDictionary *params = [NSMutableDictionary  dictionary];
        params[@"action"] = @(1022);
        params[@"phone"] = @(self.phoneNum.integerValue);
        
        NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1022",XHHBaseUrl];
        [LhkhHttpsManager requestWithURLString:url parameters:params type:2 success:^(id responseObject) {
            NSLog(@"-----Login=%@",responseObject);
            if ([responseObject[@"status"] isEqualToString:@"1"]) {
                [self startTimer];
                [MBProgressHUD show:[NSString stringWithFormat:@"验证码%@",responseObject[@"msg"]] view:self.view];
                
            }else{
                [MBProgressHUD show:responseObject[@"msg"] view:self.view];
            }
            
        } failure:^(NSError *error) {
            NSString *str = [NSString stringWithFormat:@"%@",error];
            [MBProgressHUD show:str view:self.view];
        }];
        
    }else{
        [MBProgressHUD show:@"请正确输入手机号码" view:self.view];
        return;
    }
    
}
//是否同意用户手册
- (IBAction)checkClick:(id)sender {
    self.checkBtn.selected = !self.checkBtn.selected;
}
//跳转用户手册
- (IBAction)xhhNoteClick:(id)sender {
    XHHNoteViewController *vc = [[XHHNoteViewController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
}

// 开始定时器
- (void) startTimer{
    // 定义一个NSTimer
    time = 60;
    mTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(doTimer:)  userInfo:nil
                                             repeats:YES];
}

// 定时器执行的方法
- (void)doTimer:(NSTimer *)timer{
    time--;
    if (time > 0) {
        NSString *title = [NSString stringWithFormat:@"%d秒",time];
        self.timeLab.text = title;
        self.timeLab.textAlignment = NSTextAlignmentCenter;
        [self.regetBtn setEnabled:false];
    }else{
        [self.regetBtn setEnabled:true];
        self.timeLab.text = @"重新获取";
        [self stopTimer];
    }
}

// 停止定时器
- (void) stopTimer{
    if (mTimer != nil){
        [mTimer invalidate];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.testNumText resignFirstResponder];
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
