//
//  XHHAboutUsViewController.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/18.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHAboutUsViewController.h"
#import "UIColor+LhkhColor.h"
#import "LhkhHttpsManager.h"
#import "AppDelegate.h"
#import "MBProgressHUD+Add.h"
@interface XHHAboutUsViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;

@end

@implementation XHHAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于鑫汇行";
    self.view.backgroundColor = [UIColor colorWithHexString:UIBgColorStr];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"back_more-1"] style:UIBarButtonItemStylePlain target:self action:@selector(hide)];
    left.imageInsets = UIEdgeInsetsMake(0, 10, 0, 15);
    self.navigationItem.leftBarButtonItem = left;
    
    _webView = ({
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
        webView.delegate = self;
        [self.view addSubview:webView];
        webView;
    });
  
    [self getWebContent];
    
}

- (void)getWebContent{
    [self showLoadingView];
    NSString *user_id =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_ID"];
    NSString *user =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER"];
    NSString *user_key =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_KEY"];
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1006&key=%@&phone=%@&news_id=1",XHHBaseUrl,user_key,user];
    [LhkhHttpsManager requestWithURLString:url parameters:nil type:1 success:^(id responseObject) {
        NSLog(@"----aboutusresponseObject=%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            NSString *htmlCode = [responseObject objectForKey:@"list"];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:htmlCode]];
            [self.webView loadRequest:request];
        }
        else if ([responseObject[@"status"] isEqualToString:@"3"]){
            
            [MBProgressHUD show:@"登录身份已失效，请重新登录" view:self.view];
            [self performSelector:@selector(login) withObject:self afterDelay:2.f];
        }else{
            [MBProgressHUD show:responseObject[@"msg"] view:self.view];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)login{
    [(AppDelegate *)[UIApplication sharedApplication].delegate openLoginCtrl];
}

-(void)hide{
    [self.parentViewController.view removeFromSuperview];
    [self.parentViewController removeFromParentViewController];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
