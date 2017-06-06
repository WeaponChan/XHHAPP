//
//  LhkhBaseNavigationViewController.m
//  LhkhBaseProjectDemo
//
//  Created by LHKH on 2017/2/28.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "LhkhBaseNavigationViewController.h"
#import "UIImage+LhkhExtension.h"
#import "UIColor+LhkhColor.h"
#import "UIView+LhkhExtension.h"
@interface LhkhBaseNavigationViewController ()

@end

@implementation LhkhBaseNavigationViewController

-(void)loadView{

    [super loadView];
    //背景颜色
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:UIColorStr] size:CGSizeMake(self.navigationBar.width, self.navigationBar.height+20)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    //状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //title颜色和字体
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:UIToneTextColorStr],  NSFontAttributeName:[UIFont systemFontOfSize:18]};
    if ([UIDevice currentDevice].systemVersion.floatValue >8.0 ) {
        self.navigationBar.barTintColor = [UIColor colorWithHexString:UIColorStr];
    }
    //系统返回按钮图片设置
    NSString *imageName = @"back_more";
    if ([UIApplication sharedApplication].statusBarStyle == UIStatusBarStyleDefault) {
        imageName = @"back_more";
    }
    UIImage *image = [UIImage imageNamed:imageName];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, image.size.width-1, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithHexString:UIToneTextColorStr]];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark push
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    for (Class classes in self.rootVcAry) {
        if ([viewController isKindOfClass:classes]) {
            if (self.navigationController.viewControllers.count > 0) {
                viewController.hidesBottomBarWhenPushed = YES;
            } else {
                viewController.hidesBottomBarWhenPushed = NO;
            }
        }else{
            viewController.hidesBottomBarWhenPushed = YES;
        }
    }
    [super pushViewController:viewController animated:NO];
}

-(NSMutableArray*)rootVcAry{
    if (!_rootVcAry) {
        _rootVcAry = [NSMutableArray array];
    }
    return _rootVcAry;
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
