//
//  NetworkManger.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/25.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManger : NSObject

//参数URLStr表示网络请求URL parmdic表示请求参数 finish回调指网络请求成功

//get请求
+(void)requestGETWithURLStr:(NSString *)urlStr parmDic:(NSDictionary *)paramDic finish:(void(^)(id responseObject))finish enError:(void(^)(NSError *error))enError;
//post请求
+(void)requestPOSTWithURLStr:(NSString *)urlStr parmDic:(NSDictionary *)paramDic finish:(void(^)(id responseObject))finish enError:(void(^)(NSError *error))enError;









@end
