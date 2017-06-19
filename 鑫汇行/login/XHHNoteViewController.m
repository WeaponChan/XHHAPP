//
//  XHHNoteViewController.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/15.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHNoteViewController.h"
#import "MBProgressHUD+Add.h"
#import "LhkhHttpsManager.h"
@interface XHHNoteViewController ()<UIWebViewDelegate>
//@property (nonatomic,strong)UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation XHHNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"鑫汇行用户手册";
//    _webView = ({
//        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
//        webView.delegate = self;
//        [self.view addSubview:webView];
//        webView;
//    });
    _webView.delegate =self;
    [self loadData];
    [self showLoadingView];
}

-(void)loadData{
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1024",XHHBaseUrl];
    [LhkhHttpsManager requestWithURLString:url parameters:nil type:1 success:^(id responseObject) {
        NSLog(@"------>note=%@",responseObject);
        [self closeLoadingView];
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            NSDictionary *dic = [responseObject objectForKey:@"list"];
            NSString *title = [dic objectForKey:@"title"];
            NSString *htmlCode = [dic objectForKey:@"content"];
            self.navigationItem.title = title;
            [_webView loadHTMLString:htmlCode baseURL:nil];
        }else{
            [MBProgressHUD show:@"暂无数据" view:self.view];
        }
    } failure:^(NSError *error) {
        [self closeLoadingView];
        [MBProgressHUD show:@"暂无数据" view:self.view];
    }];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
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
