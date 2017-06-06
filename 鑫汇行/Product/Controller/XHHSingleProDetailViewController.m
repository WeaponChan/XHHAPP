//
//  XHHSingleProDetailViewController.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/16.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHSingleProDetailViewController.h"
#import "XHHSingleProViewController.h"
#import "Masonry.h"
#import "UIColor+LhkhColor.h"
#import "LhkhHttpsManager.h"
#import "MBProgressHUD+Add.h"
@interface XHHSingleProDetailViewController ()<UIWebViewDelegate>{
    NSString *pro_id;
}
@property (nonatomic,strong)UIWebView *webView;

@end

@implementation XHHSingleProDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[XHHSingleProViewController class]]) {
            XHHSingleProViewController *provc = (XHHSingleProViewController *)vc;
            pro_id = provc.pro_id;
            break;
        }
    }
    [self setupView];
    [self showLoadingView];
}

-(void)setupView{
    _webView = ({
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 45, self.view.bounds.size.width, self.view.bounds.size.height-110)];
        webView.delegate = self;
        [self.view addSubview:webView];
        webView;
    });
    
    NSLog(@"---->pro_id=%@",pro_id);
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1005&pro_id=%@",XHHBaseUrl,pro_id];
    [LhkhHttpsManager requestWithURLString:url parameters:nil type:1 success:^(id responseObject) {
        NSString *url = responseObject[@"list"][@"pro_info"];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [self.webView loadRequest:request];
        
    } failure:^(NSError *error) {
        NSString *str = [NSString stringWithFormat:@"%@",error];
        [MBProgressHUD show:str view:self.view];
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self closeLoadingView];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var script = document.createElement('script');"
                                                     "script.type = 'text/javascript';"
                                                     "script.text = \"function ResizeImages() { "
                                                     "var myimg,oldwidth;"
                                                     "var maxwidth=%f;" //缩放系数
                                                     "for(i=0;i <document.images.length;i++){"
                                                     "myimg = document.images[i];"
                                                     "if(myimg.width > maxwidth){"
                                                     "oldwidth = myimg.width;"
                                                     "myimg.width = maxwidth;"
                                                     //                                                     "myimg.height = myimg.height * (maxwidth/oldwidth);"
                                                     "myimg.height = myimg.height * (myimg.width/myimg.height);"
                                                     "}"
                                                     "}"
                                                     "}\";"
                                                     "document.getElementsByTagName('head')[0].appendChild(script);",ScreenWidth]
     ];
    
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
