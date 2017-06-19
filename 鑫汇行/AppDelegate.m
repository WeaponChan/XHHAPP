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
#import "WXApi.h"
@interface AppDelegate ()<WXApiDelegate>

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
    //向微信注册
    [WXApi registerApp:WXAppID];
    
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
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER"];
    NSLog(@"----user--->%@",user);
    if (user.length>0 && ![user isEqualToString:@""] && user != nil) {
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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation{
    return [WXApi handleOpenURL:url delegate:self];
}

-(void) onResp:(BaseResp*)resp{
    NSLog(@"resp %d",resp.errCode);
    
    /*
     enum  WXErrCode {
     WXSuccess           = 0,    成功
     WXErrCodeCommon     = -1,  普通错误类型
     WXErrCodeUserCancel = -2,    用户点击取消并返回
     WXErrCodeSentFail   = -3,   发送失败
     WXErrCodeAuthDeny   = -4,    授权失败
     WXErrCodeUnsupport  = -5,   微信不支持
     };
     */
//    if ([resp isKindOfClass:[SendAuthResp class]]) {   //授权登录的类。
//        if (resp.errCode == 0) {  //成功。
//            //这里处理回调的方法 。 通过代理吧对应的登录消息传送过去。
//            if ([_wxDelegate respondsToSelector:@selector(loginSuccessByCode:)]) {
//                SendAuthResp *resp2 = (SendAuthResp *)resp;
//                [_wxDelegate loginSuccessByCode:resp2.code];
//            }
//        }else{ //失败
//            NSLog(@"error %@",resp.errStr);
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:[NSString stringWithFormat:@"reason : %@",resp.errStr] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            [alert show];
//        }
//    }
    
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) { //微信分享 微信回应给第三方应用程序的类
        SendMessageToWXResp *response = (SendMessageToWXResp *)resp;
        NSLog(@"error code %d  error msg %@  lang %@   country %@",response.errCode,response.errStr,response.lang,response.country);
        
        if (resp.errCode == 0) {
            if (_wxDelegate) {
                if([_wxDelegate respondsToSelector:@selector(shareSuccessByCode:)]){
                    [_wxDelegate shareSuccessByCode:@"分享成功"];
                }
            }
        }else{ //失败
            NSLog(@"error %@",resp.errStr);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"reason : %@",resp.errStr] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
    
    /*
     0  展示成功页面
     -1  可能的原因：签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等。
     -2  用户取消	无需处理。发生场景：用户不支付了，点击取消，返回APP。
     */
//    if ([resp isKindOfClass:[PayResp class]]) { // 微信支付
//        
//        PayResp*response=(PayResp*)resp;
//        switch(response.errCode){
//            case 0:
//                //服务器端查询支付通知或查询API返回的结果再提示成功
//                NSLog(@"支付成功");
//                break;
//                
//            default:
//                NSLog(@"支付失败，retcode=%d  errormsg %@",resp.errCode ,resp.errStr);
//                break;
//        }
//    }
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
