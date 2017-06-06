//
//  XHHOrderViewController.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/15.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHOrderViewController.h"
#import "LhkhButton.h"
#import "UIView+LhkhExtension.h"
#import "UIColor+LhkhColor.h"
#import "XHHOrderStatusViewController.h"

@interface XHHOrderViewController ()<UIScrollViewDelegate>
//上面的一行标题栏
@property (weak, nonatomic) UIView *titlesView;
//标题栏上的按钮
@property (weak, nonatomic) LhkhButton *selectedButton;
//标题栏下面的滑条
@property (weak, nonatomic) UIView *sliderView;
//底部的内容
@property (weak, nonatomic) UIScrollView *contentView;
@end

@implementation XHHOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"贷款订单";
    [self setupChildViewControllers];
    [self setupTitlesView];
    [self setupContentView];
}
#pragma mark 创建标题栏
- (void)setupTitlesView
{
    //标题数组
    NSArray *titleArr = @[@"全部",@"申请中",@"办理中",@"已放款",@"未通过"];
    
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
    //点击标题按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self  titleClick:self.titlesView.subviews[index]];
    
}


#pragma mark 创建标题对应的子控制器
- (void)setupChildViewControllers
{
    [self setupOneChildViewController:OrderTypeAll];
    [self setupOneChildViewController:OrderTypeAplly];
    [self setupOneChildViewController:OrderTypeHandle];
    [self setupOneChildViewController:OrderTypeSuccess];
    [self setupOneChildViewController:OrderTypeFail];
}

- (void)setupOneChildViewController:(OrderType)type
{
    XHHOrderStatusViewController *vc = [[XHHOrderStatusViewController alloc] init];
    vc.type = type;
    if (type == OrderTypeAll) {
        vc.title = @"全部";
    }else if (type == OrderTypeAplly){
        vc.title = @"申请中";
    }else if (type == OrderTypeHandle){
        vc.title = @"办理中";
    }else if (type == OrderTypeSuccess){
        vc.title = @"已放款";
    }else{
        vc.title = @"未通过";
    }
    [self addChildViewController:vc];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
