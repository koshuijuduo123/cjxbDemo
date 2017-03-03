//
//  NetworkManger.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/25.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "NetworkManger.h"
#import "AFNetworking.h"

@implementation NetworkManger


//get请求
+(void)requestGETWithURLStr:(NSString *)urlStr parmDic:(NSDictionary *)paramDic finish:(void(^)(id responseObject))finish enError:(void(^)(NSError *error))enError{
    //创建一个sessionMessage管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    
    manager.requestSerializer.timeoutInterval = 8.0f;
    
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    //manager.securityPolicy.allowInvalidCertificates = YES;
    //AFNetworking请求结果回调时,failure方法会在两种情况下回调:1.请求服务器失败  服务器返回失败信息  2.服务器返回数据成功,AFN解析返回数据失败
    //指定我们能够解析的数据类型包含html
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json",nil];
    [manager GET:urlStr parameters:paramDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (finish) {
        finish(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            if (error.code==-1001) {
                //超时操作
                [[manager operationQueue] cancelAllOperations];
                
            }
            enError(error);
        }
    }];
}
//post请求
+(void)requestPOSTWithURLStr:(NSString *)urlStr parmDic:(NSDictionary *)paramDic finish:(void(^)(id responseObject))finish enError:(void(^)(NSError *error))enError{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    
    manager.requestSerializer.timeoutInterval = 8.0f;
    
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain", nil];
    
    [manager POST:urlStr parameters:paramDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (finish) {
            finish(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            if (error.code==-1001) {
                //超时操作
                
                [[manager operationQueue] cancelAllOperations];
                
                }
            enError(error);
        }
    }];
}










@end
