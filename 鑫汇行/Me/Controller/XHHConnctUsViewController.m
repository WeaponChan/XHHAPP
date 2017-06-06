//
//  XHHConnctUsViewController.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/18.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHConnctUsViewController.h"
#import "Masonry.h"
#import "XHHCusTableViewCell.h"
#import "UIColor+LhkhColor.h"
#import "LhkhHttpsManager.h"

@interface XHHConnctUsViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    UIView *headview;
    UIImageView *headviewBg;
}
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation XHHConnctUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"联系我们";
    self.view.backgroundColor = [UIColor colorWithHexString:UIBgColorStr];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"back_more-1"] style:UIBarButtonItemStylePlain target:self action:@selector(hide)];
    left.imageInsets = UIEdgeInsetsMake(0, 10, 0, 15);
    self.navigationItem.leftBarButtonItem = left;
//    [self buildheadView];
//    [self setTableView];
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
    NSString *user =  [[NSUserDefaults standardUserDefaults]objectForKey:@"User"];
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1006&key=%@&phone=%@&news_id=2",XHHBaseUrl,KEY,user];
    [LhkhHttpsManager requestWithURLString:url parameters:nil type:1 success:^(id responseObject) {
        NSLog(@"----aboutusresponseObject=%@",responseObject);
        NSString *htmlCode = [responseObject objectForKey:@"list"];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:htmlCode]];
        [self.webView loadRequest:request];
    } failure:^(NSError *error) {
        
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

-(void)hide{
    [self.parentViewController.view removeFromSuperview];
    [self.parentViewController removeFromParentViewController];
}
-(void)setTableView{
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = RGBA(236, 236, 236, 1);
        [tableView registerNib:[UINib nibWithNibName:@"XHHCusTableViewCell" bundle:nil] forCellReuseIdentifier:@"XHHCusTableViewCell"];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView;
    });
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-54);
    }];
    
}
-(void)buildheadView{
    
    headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    headviewBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, headview.frame.size.width, headview.frame.size.height)];
    headviewBg.image = [UIImage imageNamed:@"headBg"];
    [headview addSubview:headviewBg];
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString * cellID = @"tableviewCellID";
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell addSubview:headview];
        return cell;
    }else{
        static NSString *CellIdentifier = @"XHHCusTableViewCell" ;
        XHHCusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 150;
    }else{
        return 285;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
