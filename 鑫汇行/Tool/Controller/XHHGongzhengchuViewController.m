//
//  XHHGongzhengchuViewController.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/24.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHGongzhengchuViewController.h"
#import "UIColor+LhkhColor.h"
#import "MBProgressHUD+Add.h"
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import "WXApi.h"
@interface XHHGongzhengchuViewController ()<UIWebViewDelegate,JSObjectDelegate,MFMessageComposeViewControllerDelegate,WXDelegate>{
    AppDelegate *appdelegate;
}
@property (nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)JSContext *context;
@end

@implementation XHHGongzhengchuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"公证处";
    self.view.backgroundColor = [UIColor colorWithHexString:UIBgColorStr];
    _webView = ({
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
        webView.delegate = self;
        [self.view addSubview:webView];
        webView;
    });
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
    [self showLoadingView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context[@"webViewInterface"] = self;
    __weak typeof(self) weakself = self;
    
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
        [MBProgressHUD showMessag:@"调用JS出现异常" toView:weakself.view];
    };
    [self closeLoadingView];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var script = document.createElement('script');"
                                                     "script.type = 'text/javascript';"
                                                     "script.text = \"function ResizeImages() { "
                                                     "var myimg,oldwidth;"
                                                     "var maxwidth=%f;"
                                                     "for(i=0;i <document.images.length;i++){"
                                                     "myimg = document.images[i];"
                                                     "if(myimg.width > maxwidth){"
                                                     "oldwidth = myimg.width;"
                                                     "myimg.width = maxwidth;"
                                                     "myimg.height = myimg.height * (myimg.width/myimg.height);"
                                                     "}"
                                                     "}"
                                                     "}\";"
                                                     "document.getElementsByTagName('head')[0].appendChild(script);",ScreenWidth]
     ];
    
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    
}

#pragma mark js回调
//短信
-(void)shareMessage:(NSString *)datas {
    NSLog(@"-------data=%@",datas);
    NSData *JSONData = [datas dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *datasDic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    NSString *message = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",datasDic[@"name"],datasDic[@"phone"],datasDic[@"address"],datasDic[@"time"]];
    [self showMessageView:message];
}

- (void)showMessageView:(NSString *)datas
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc]init];
        messageVC.body = datas;
        messageVC.recipients = @[];
        messageVC.messageComposeDelegate = self;
        [self presentViewController:messageVC animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];
    }
}



#pragma mark -
#pragma mark MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result){
        case MessageComposeResultCancelled:
            NSLog(@"取消发送");
            [MBProgressHUD show:@"取消发送" view:self.view];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case MessageComposeResultFailed:
            NSLog(@"发送失败");
            [MBProgressHUD show:@"发送失败" view:self.view];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case MessageComposeResultSent:
            NSLog(@"发送成功");
            [MBProgressHUD show:@"发送成功" view:self.view];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
            
        default:
            break;
    }
    
}

//微信
-(void)shareWeChat:(NSString *)url{
    
    NSData *JSONData = [url dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *urlDic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"-------link=%@=%@",url,urlDic);
    [self isShareToPengyouquan:NO message:urlDic];
}

-(void)isShareToPengyouquan:(BOOL)isPengyouquan message:(NSDictionary *)msg{
    
    //缩略图
    UIImage *image = [UIImage imageNamed:@"share"];
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"鑫汇行";
    message.description = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",msg[@"name"],msg[@"phone"],msg[@"address"],msg[@"time"]];
    message.thumbData = UIImagePNGRepresentation(image);
    [message setThumbImage:image];
    
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = msg[@"url"];
    message.mediaObject = ext;
    message.mediaTagName = @"ISOFTEN_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq *sentMsg = [[SendMessageToWXReq alloc]init];
    sentMsg.message = message;
    sentMsg.bText = NO;
    //选择发送到会话(WXSceneSession)或者朋友圈(WXSceneTimeline)
    if (isPengyouquan) {
        sentMsg.scene = WXSceneTimeline;  //分享到朋友圈
    }else{
        sentMsg.scene =  WXSceneSession;  //分享到会话。
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
