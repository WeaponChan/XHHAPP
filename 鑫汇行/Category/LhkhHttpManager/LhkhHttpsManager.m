//
//  LhkhHttpsManager.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/21.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "LhkhHttpsManager.h"
#import "AFNetworking.h"

@implementation LhkhHttpsManager
+ (void)requestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
                        type:(HttpRequestType)type
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    NSLog(@"URL---->%@",URLString);
    NSLog(@"params---->%@",parameters);
    NSString *netStatus = [[NSUserDefaults standardUserDefaults] objectForKey:@"status"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30.0f;
    switch (type) {
        case HttpRequestTypeGet:
        {
            [manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                if (success) {
                    id jsons = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers  error:nil];
                    success(jsons);
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
        case HttpRequestTypePost:
        {
            if ([netStatus isEqualToString:@"1"] || [netStatus isEqualToString:@"2"]) {//有网络时
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if (success) {
                        id jsons = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers  error:nil];
                        success(jsons);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    if (failure) {
                        failure(error);
                    }
                }];
            }else //无网络时
            {
                NSError *error = nil;
                failure(error);
            }
        }
            break;
        default:
            break;
    }
    
    
}
@end
