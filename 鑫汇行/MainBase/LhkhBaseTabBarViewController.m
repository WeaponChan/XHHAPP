//
//  LhkhBaseTabBarViewController.m
//  LhkhBaseProjectDemo
//
//  Created by LHKH on 2017/2/28.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "LhkhBaseTabBarViewController.h"
#import "LhkhBaseNavigationViewController.h"
#import "UIColor+LhkhColor.h"
#import "UIImage+LhkhExtension.h"
#import "UIView+LhkhExtension.h"
#import "XHHHomeViewController.h"
#import "XHHMeViewController.h"
#import "AppDelegate.h"
#import "UITabBarController+XHHTabarBadge.h"
#import "LhkhHttpsManager.h"
#import "MBProgressHUD+Add.h"
@interface LhkhBaseTabBarViewController ()<UITabBarDelegate>

@end

@implementation LhkhBaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _vcsArray = [NSMutableArray array];
    
    [self setTabBarVCs];
    NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_ID"];
    if (user_id != nil && user_id.length > 0 && ![user_id isEqualToString:@""]) {
        [self loadMessageNum];
    }
    
//    [self removeTabarTopLine];//移除tabbar上面横线
}

//创建tabBarVC
-(void)setTabBarVCs{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TabBarConfigure" ofType:@"plist"];
    NSArray *VCsArr = [NSArray arrayWithContentsOfFile:path];
    [_vcsArray removeAllObjects];
    for (NSDictionary *VCsDic in VCsArr) {
        Class classs = NSClassFromString(VCsDic[@"class"]);
        NSString *title = VCsDic[@"title"];
        NSString *imageName = VCsDic[@"image"];
        NSString *selectedImage = VCsDic[@"selectedImage"];
        NSString *badgeValue = VCsDic[@"badgeValue"];
        [self navigationChildController:classs title:title imageName:imageName seletedImage:selectedImage badgeValue:badgeValue];
    }

    [self setViewControllers:_vcsArray];

}
-(void)viewWillLayoutSubviews{
    float height = 54;
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = height;
    tabFrame.origin.y = self.view.height - height;
    self.tabBar.frame = tabFrame;
}

-(LhkhBaseNavigationViewController*)navigationChildController:(Class)class title:(NSString*)title imageName:(NSString*)imageName seletedImage:(NSString*)seletedImage badgeValue:(NSString*)badgeValue{
    
    UIViewController *vc = [class new];
    vc.tabBarItem.image = [[[UIImage imageNamed:imageName]imageToColor:[UIColor grayColor]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[[UIImage imageNamed:seletedImage] imageToColor:[UIColor colorWithHexString:UIColorStr]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIGraphicsBeginImageContext(CGSizeMake(22, 22));
//    [vc.tabBarItem.selectedImage drawInRect:CGRectMake(0.0f, 0.0f, 22, 22)];
//    vc.tabBarItem.selectedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    float origin = -3;
    vc.tabBarItem.imageInsets = UIEdgeInsetsMake(origin, 0, -origin, 0);
    vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(6, -6);
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor colorWithHexString:UIColorStr],NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateSelected];
    vc.tabBarItem.title = title;
    LhkhBaseNavigationViewController *navc = nil;
    if ([vc isKindOfClass:[XHHHomeViewController class]] || [vc isKindOfClass:[XHHMeViewController class]]) {
        [_vcsArray addObject:vc];
    }else{
        if (navc == nil) {
            navc = [[LhkhBaseNavigationViewController alloc]initWithRootViewController:vc];
            navc.navigationItem.title = title;
            [_vcsArray addObject:navc];
            [navc.rootVcAry addObject:class];
        }   
    }
//    [_vcsArray addObject:vc];
    return navc;
    
}

-(void)loadMessageNum{
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_ID"];
    params[@"action"] = @(1015);
    params[@"user_id"] = @(user_id.integerValue);
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1015&do=1",XHHBaseUrl];
    [LhkhHttpsManager requestWithURLString:url parameters:params type:2 success:^(id responseObject) {
        NSLog(@"-----menum=%@",responseObject);
        NSString *nums = responseObject[@"list"][@"nums"];
        if (![nums isEqualToString:@"0"]) {
            [self showBadgeOnItemIndex:4];
        }else{
            [self hideBadgeOnItemIndex:4];
        }
    } failure:^(NSError *error) {
        NSString *str = [NSString stringWithFormat:@"%@",error];
        [MBProgressHUD show:str view:self.view];
    }];
}

//去掉tabbar上面的横线
-(void)removeTabarTopLine
{
    CGRect rect = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];
    
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSString *user = [[NSUserDefaults standardUserDefaults]objectForKey:@"USER"];
    NSLog(@"-----点击了%@---user-->%@",item.title,user);
    
    if ([item.title isEqualToString:@"订单"] || [item.title isEqualToString:@"我的"]) {
        if (user.length > 0 && ![user isEqualToString:@""] && user != nil) {
            
        }else{
            [(AppDelegate *)[UIApplication sharedApplication].delegate openLoginCtrl];
        }
    }
}

/*
-(NSMutableArray*)vcsArray{
    if (!_vcsArray) {
        _vcsArray = [NSMutableArray array];
    }
    return _vcsArray;
}
*/

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
