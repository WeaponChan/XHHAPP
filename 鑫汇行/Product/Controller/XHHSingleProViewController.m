//
//  XHHSingleProViewController.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/16.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHSingleProViewController.h"
#import "XHHSingleProDetailViewController.h"
#import "XHHSingleProInfoViewController.h"
#import "XHHSingleProApplyViewController.h"
#import "XHHSingleProProcessViewController.h"
#import "LhkhButton.h"
#import "UIView+LhkhExtension.h"
#import "UIColor+LhkhColor.h"
#import "MBProgressHUD+Add.h"
#import "LhkhHttpsManager.h"
@interface XHHSingleProViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) UIView *titlesView;
@property (weak, nonatomic) LhkhButton *selectedButton;
@property (weak, nonatomic) UIView *sliderView;
@property (weak, nonatomic) UIScrollView *contentView;
@end

@implementation XHHSingleProViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.pro_name;
//    [self loadData];
    if (self.isshouye == YES) {
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"back_more-1"] style:UIBarButtonItemStylePlain target:self action:@selector(hide)];
        left.imageInsets = UIEdgeInsetsMake(0, 10, 0, 15);
        self.navigationItem.leftBarButtonItem = left;
    }
    
    [self setupChildViewControllers];
    [self setupTitlesView];
    [self setupContentView];
}

-(void)hide{
    [self.parentViewController.view removeFromSuperview];
    [self.parentViewController removeFromParentViewController];
}

-(void)loadData{
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1005&pro_id=%@",XHHBaseUrl,self.pro_id];
    [LhkhHttpsManager requestWithURLString:url parameters:nil type:1 success:^(id responseObject) {
        NSLog(@"-----productdetail=%@",responseObject);
        
    } failure:^(NSError *error) {
        NSString *str = [NSString stringWithFormat:@"%@",error];
        [MBProgressHUD show:str view:self.view];
    }];
    
}

#pragma mark 创建标题栏
- (void)setupTitlesView
{
    //标题数组
    NSArray *titleArr = @[@"产品详情",@"在线申请",@"办理流程",@"资料清单"];
    
    //标题栏设置
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
    titlesView.width = self.view.width;
    titlesView.height = 35;
    titlesView.y = 0;
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 底部滑条
    UIView *sliderView = [[UIView alloc] init];
    sliderView.backgroundColor = [UIColor colorWithHexString:UIColorStr];
    sliderView.height = 2;
    sliderView.tag = -1;
    sliderView.y = titlesView.height - sliderView.height;
    
    self.sliderView = sliderView;
    
    //设置上面的按钮
    NSInteger width = titlesView.width / titleArr.count;
    NSInteger height = titlesView.height;
    for (NSInteger i=0; i<titleArr.count; i++) {
        LhkhButton *btn = [[LhkhButton alloc] init];
        btn.width = width;
        btn.height = height;
        btn.x = i * width;
        btn.tag = i;
        [btn setTitle: titleArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:btn];
  
        if (i == 0) {
            btn.enabled = NO;
            self.selectedButton = btn;
            [btn.titleLabel sizeToFit];
            self.sliderView.width = btn.titleLabel.width;
            self.sliderView.centerX = btn.centerX;
        }
    }
  [self.titlesView addSubview:sliderView];
}
#pragma mark 标题栏每个按钮的点击事件
-(void)titleClick:(LhkhButton *)button{
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    [UIView animateWithDuration:0.25 animations:^{
        self.sliderView.width = button.titleLabel.width;
        self.sliderView.centerX = button.centerX;
    }];
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
}

#pragma mark 设置scrollview的内容部分
- (void)setupContentView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.backgroundColor = RGBA(236, 236, 236, 1);
    contentView.frame = self.view.bounds;
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    [self.view insertSubview:contentView atIndex:0];
    self.contentView = contentView;
    //添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
}

#pragma mark UIScrollViewDelegate

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / scrollView.width;

    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0;
    vc.view.height = scrollView.height;
    [scrollView addSubview:vc.view];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView  {
    [self scrollViewDidEndScrollingAnimation:scrollView];

    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self  titleClick:self.titlesView.subviews[index]];
    
}

#pragma mark 创建标题对应的子控制器
- (void)setupChildViewControllers
{
    XHHSingleProDetailViewController *ProDetailVC = [[XHHSingleProDetailViewController  alloc ] init];

    XHHSingleProApplyViewController *ProApplyVC = [[XHHSingleProApplyViewController  alloc ] init];
    XHHSingleProProcessViewController *ProProcessVC = [[XHHSingleProProcessViewController  alloc ] init];

    XHHSingleProInfoViewController *ProInfoVC = [[XHHSingleProInfoViewController  alloc ] init];

    [self addChildViewController:ProDetailVC];
    [self addChildViewController:ProApplyVC];
    [self addChildViewController:ProProcessVC];
    [self addChildViewController:ProInfoVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
