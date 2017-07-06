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
#import "WXApi.h"
@interface XHHInvitefriViewController ()<WXDelegate>
{
    AppDelegate *appdelegate;
    UIControl *_blackView;
    NSString *yqm_url;
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
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1014&key=%@&phone=%@",XHHBaseUrl,user_key,user];
    [LhkhHttpsManager requestWithURLString:url parameters:params type:2 success:^(id responseObject) {
        NSLog(@"-----Invite=%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            NSString *bannerUrl = responseObject[@"list"][@"pic"];
            NSString *erweimaUrl = responseObject[@"list"][@"yqm_url"];
            yqm_url = erweimaUrl;
            [self.headBannerImg sd_setImageWithURL:[NSURL URLWithString:bannerUrl] placeholderImage:[UIImage imageNamed:@""]];
            self.erweimaImg.image = [QRCodeGenerator qrImageForString:erweimaUrl imageSize:self.erweimaImg.bounds.size.width];
        }else if ([responseObject[@"status"] isEqualToString:@"3"]){
            [MBProgressHUD show:@"登录身份已失效，请重新登录" view:self.view];
            [self performSelector:@selector(login) withObject:self afterDelay:2.f];
            
        }else{
            [MBProgressHUD show:responseObject[@"msg"] view:self.view];
        }
        
        
    } failure:^(NSError *error) {
        NSString *str = [NSString stringWithFormat:@"%@",error];
        [MBProgressHUD show:str view:self.view];
    }];
    
}
-(void)login{
    [(AppDelegate *)[UIApplication sharedApplication].delegate openLoginCtrl];
}

-(void)hide{
    [self.parentViewController.view removeFromSuperview];
    [self.parentViewController removeFromParentViewController];
}
- (IBAction)inviteClick:(id)sender {

    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        
        _blackView.hidden = self.bottomView.hidden = NO;
        
    }else{
        self.bottomView.hidden = YES;
        return;
    }
//    _blackView.hidden = self.bottomView.hidden = NO;
}

- (IBAction)weixinClick:(id)sender {
    NSLog(@"-----微信好友");
    
    [self isShareToPengyouquan:NO];
}

- (IBAction)pengyouqClick:(id)sender {
    NSLog(@"-----朋友圈");
    [self isShareToPengyouquan:YES];
}

-(void)isShareToPengyouquan:(BOOL)isPengyouquan{
    
    //缩略图
    UIImage *image = [UIImage imageNamed:@"share"];
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"鑫汇行";
    message.description = @"加入小鑫在线吧";
    //png图片压缩成data的方法，如果是jpg就要用 UIImageJPEGRepresentation
    message.thumbData = UIImagePNGRepresentation(image);
    [message setThumbImage:image];
    
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = yqm_url;
    message.mediaObject = ext;
    message.mediaTagName = @"ISOFTEN_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq *sentMsg = [[SendMessageToWXReq alloc]init];
    sentMsg.message = message;
    sentMsg.bText = NO;
    if (isPengyouquan) {
        sentMsg.scene = WXSceneTimeline;
    }else{
        sentMsg.scene =  WXSceneSession;
    }
    
    //如果我们想要监听是否成功分享，我们就要去appdelegate里面 找到他的回调方法
    // -(void) onResp:(BaseResp*)resp .我们可以自定义一个代理方法，然后把分享的结果返回回来。
    appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //添加对appdelgate的微信分享的代理
    appdelegate.wxDelegate = self;
    BOOL isSuccess = [WXApi sendReq:sentMsg];
   
}

#pragma mark 监听微信分享是否成功 delegate
-(void)shareSuccessByCode:(int)code{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享成功" message:[NSString stringWithFormat:@"reason : %d",code] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
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
