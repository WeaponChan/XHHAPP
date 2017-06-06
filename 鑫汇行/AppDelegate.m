//
//  AppDelegate.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/15.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "AppDelegate.h"
#import "UIColor+LhkhColor.h"
#import "XHHLoginViewController.h"
#import "JXGuideFigure.h"
#import "Reachability.h"
#import "IQKeyboardManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor colorWithHexString:UIBgColorStr];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    
    //当前设备的网络类型
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    NSString *status = nil;
    if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
        if ([conn currentReachabilityStatus] == ReachableViaWiFi) {
            status = @"1";
            NSLog(@"使用WIFI网络进行上网===%@",status);
            
        }
        if ([conn currentReachabilityStatus] == ReachableViaWWAN) {
            status = @"2";
            NSLog(@"使用手机自带网络进行上网===%@",status);
        }
    }else { // 没有网络
        status = @"0";
    }
    [[NSUserDefaults standardUserDefaults]setObject:status forKey:@"status"];
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    NSLog(@"----user--->%@",user);
    if (user.length>0) {
        [self openTabHomeCtrl];
    }else{
        [self openLoginCtrl];
    }
    return YES;
}

-(void)openLoginCtrl
{

    XHHLoginViewController *LoginVc = [[XHHLoginViewController alloc]init];
    self.BaseNavigationViewController = [[LhkhBaseNavigationViewController  alloc] initWithRootViewController:LoginVc];
    [JXGuideFigure figureWithImages:@[@"guide1",@"guide2",@"guide3",@"guide4"] finashMainViewController:self.BaseNavigationViewController];
//    self.window.rootViewController = self.BaseNavigationViewController;
    [self.window addSubview:self.BaseNavigationViewController.view];
    [self.window makeKeyAndVisible];
    
}

- (void)openTabHomeCtrl
{
    self.BaseTabBarController = [LhkhBaseTabBarViewController new];
    [JXGuideFigure figureWithImages:@[@"guide1",@"guide2",@"guide3",@"guide4"] finashMainViewController:self.BaseTabBarController];
    if (self.isloginOut) {
        self.window.rootViewController = self.BaseTabBarController;
    }
    [self.window makeKeyAndVisible];
}

+ (AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *) [UIApplication sharedApplication].delegate;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
