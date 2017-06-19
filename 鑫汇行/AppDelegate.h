//
//  AppDelegate.h
//  鑫汇行
//
//  Created by LHKH on 2017/5/15.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LhkhBaseTabBarViewController.h"
#import "LhkhBaseNavigationViewController.h"
@protocol WXDelegate <NSObject>
-(void)shareSuccessByCode:(NSString*) codeStr;
@end
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LhkhBaseTabBarViewController *BaseTabBarController;
@property (strong, nonatomic) LhkhBaseNavigationViewController *BaseNavigationViewController;
@property BOOL isloginOut;
-(void)openLoginCtrl;
- (void)openTabHomeCtrl;
+(AppDelegate *)sharedAppDelegate;
@property (nonatomic, weak) id<WXDelegate> wxDelegate;
@end

