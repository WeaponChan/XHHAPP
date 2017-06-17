//
//  XHHInvitefriViewController.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/18.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHInvitefriViewController.h"
#import "UIColor+LhkhColor.h"
#import "LhkhHttpsManager.h"
#import "MBProgressHUD+Add.h"
#import "UIImageView+WebCache.h"
#import "QRCodeGenerator.h"
#import "AppDelegate.h"
@interface XHHInvitefriViewController ()
{
    UIControl *_blackView;
}
@property (nonatomic, strong) NSDictionary *params;
@end

@implementation XHHInvitefriViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"邀请好友";
//    self.view.backgroundColor = [UIColor colorWithHexString:UIBgColorStr];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"back_more-1"] style:UIBarButtonItemStylePlain target:self action:@selector(hide)];
    left.imageInsets = UIEdgeInsetsMake(0, 10, 0, 15);
    self.navigationItem.leftBarButtonItem = left;
    self.inviteBtn.layer.cornerRadius = 4.f;
    self.inviteBtn.layer.masksToBounds = YES;
    
    self.bottomView.hidden = YES;
    _blackView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -  90)];
    [_blackView addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    _blackView.backgroundColor = [UIColor blackColor];
    _blackView.alpha = 0.4;
    _blackView.hidden = YES;
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:_blackView];
    [self loadData];
}

-(void)loadData{
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *user_id =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_ID"];
    NSString *user =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER"];
    NSString *user_key =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_KEY"];
    params[@"action"] = @(1014);
    params[@"key"] = user_key;
    params[@"phone"] = @(user.integerValue);
    params[@"user_id"] = @(user_id.integerValue);
    self.params = params;
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1014&key=%@&phone=11377606508",XHHBaseUrl,user_key];
    [LhkhHttpsManager requestWithURLString:url parameters:params type:2 success:^(id responseObject) {
        NSLog(@"-----Invite=%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            NSString *bannerUrl = responseObject[@"list"][@"pic"];
            NSString *erweimaUrl = responseObject[@"list"][@"yqm_url"];
            [self.headBannerImg sd_setImageWithURL:[NSURL URLWithString:bannerUrl] placeholderImage:[UIImage imageNamed:@"default"]];
            self.erweimaImg.image = [QRCodeGenerator qrImageForString:erweimaUrl imageSize:self.erweimaImg.bounds.size.width];
        }else if ([responseObject[@"status"] isEqualToString:@"3"]){
            [MBProgressHUD show:@"登录身份已失效，请重新登录" view:self.view];
            [(AppDelegate *)[UIApplication sharedApplication].delegate openLoginCtrl];
        }else{
            [MBProgressHUD show:responseObject[@"msg"] view:self.view];
        }
        
        
    } failure:^(NSError *error) {
        NSString *str = [NSString stringWithFormat:@"%@",error];
        [MBProgressHUD show:str view:self.view];
    }];
    
}

-(void)hide{
    [self.parentViewController.view removeFromSuperview];
    [self.parentViewController removeFromParentViewController];
}
- (IBAction)inviteClick:(id)sender {
    _blackView.hidden = self.bottomView.hidden = NO;
}

- (IBAction)weixinClick:(id)sender {
    NSLog(@"-----微信好友");
}

- (IBAction)pengyouqClick:(id)sender {
    NSLog(@"-----朋友圈");
}

- (IBAction)cancelClick:(id)sender {
    _blackView.hidden = self.bottomView.hidden = YES;
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
