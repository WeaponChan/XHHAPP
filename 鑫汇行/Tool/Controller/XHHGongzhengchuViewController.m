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

@interface XHHGongzhengchuViewController ()<UIWebViewDelegate,JSObjectDelegate,MFMessageComposeViewControllerDelegate>
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
    NSString *message1 = [datas stringByReplacingOccurrencesOfString:@"{" withString:@""];
    NSString *message = [message1 stringByReplacingOccurrencesOfString:@"}" withString:@""];
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
    NSLog(@"-------link=%@",url);
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
