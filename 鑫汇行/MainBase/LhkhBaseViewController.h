//
//  LhkhBaseViewController.h
//  LhkhBaseProjectDemo
//
//  Created by LHKH on 2017/2/28.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *base64_encode_data(NSData *data){
    data = [data base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}
@interface LhkhBaseViewController : UIViewController
- (void)showLoadingView;
- (void)closeLoadingView;
- (void)showTransparentController:(UIViewController *)controller;
-(void)transformView:(UIViewController *)Vc;
@end
