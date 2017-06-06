//
//  LhkhBaseViewController.m
//  LhkhBaseProjectDemo
//
//  Created by LHKH on 2017/2/28.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "LhkhBaseViewController.h"
#import "LhkhBaseNavigationViewController.h"
#import "CABasicAnimation+LhkhCategory.h"
#import "LhkhLodingView.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
@interface LhkhBaseViewController ()

@end

@implementation LhkhBaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)showTransparentController:(UIViewController *)controller{
    controller.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    controller.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:controller animated:NO completion:^(void){
        controller.view.superview.backgroundColor = [UIColor clearColor];
    }];
}

-(void)transformView:(UIViewController *)Vc{
    
    LhkhBaseNavigationViewController *BaseNavigationViewController = [[LhkhBaseNavigationViewController  alloc] initWithRootViewController:Vc];
    UIViewController *rootViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
    [rootViewController addChildViewController:BaseNavigationViewController];
    [rootViewController.view addSubview:BaseNavigationViewController.view];
}

#pragma mark - 窗体加载进度条
- (void)showLoadingView
{
//    [LhkhLodingView showCircleJoinView:self.view];
    [SVProgressHUD show];
}

- (void)closeLoadingView
{
//    [LhkhLodingView hide];
    [SVProgressHUD dismiss];
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
