//
//  UMComLoginManager.h
//  UMCommunity
//
//  Created by Gavin Ye on 8/25/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMComUserAccount.h"
#import "UMComLoginDelegate.h"


@interface UMComLoginManager : NSObject

@property (nonatomic, strong) id<UMComLoginDelegate> loginHandler;

@property (nonatomic, copy) NSString *appKey;

@property (nonatomic, strong) UIViewController *currentViewController;

@property (nonatomic, copy) void (^loginCompletion)(id responseObject, NSError *error);//登录回调


@property (nonatomic, assign) BOOL didUpdateFinish;


/********************UMComFirstTimeHandelerDelegate*******************/

+ (UMComLoginManager *)shareInstance;

+ (void)loginWithLoginViewController:(UIViewController *)loginViewController userAccount:(UMComUserAccount *)loginUserAccount loginCompletion:(LoginCompletion)completion;

/**
 设置登录SDK的appkey
 
 */
+ (void)setAppKey:(NSString *)appKey;

/**
 处理SSO跳转回来之后的url
 
 */
+ (BOOL)handleOpenURL:(NSURL *)url;

/**
 得到登录SDK实现对象
 
 */
+ (id<UMComLoginDelegate>)getLoginHandler;

/**
 设置登录SDK实现对象
 
 */
+ (void)setLoginHandler:(id <UMComLoginDelegate>)loginHandler;


/**
 获取当前是否登录
 
 */
+ (BOOL)isLogin;


/**
 提供社区SDK调用，默认使用友盟登录SDK，或者自定义的第三方登录SDK，实现登录功能
 
 */
+ (void)performLogin:(UIViewController *)viewController completion:(void (^)(id responseObject, NSError *error))completion;

/**
 提供社区SDK调用，默认使用友盟登录SDK，或者自定义的第三方登录SDK，实现登录功能
 @discuss 在外部进行登录请求后将回调传入方法，具体结构参考方法实现
 */
+ (void)loginWithLoginViewController:(UIViewController *)loginViewController userAccount:(UMComUserAccount *)loginUserAccount response:(id)responseObject error:(NSError *)error loginCompletion:(LoginCompletion)completion;

/**
 用户注销方法
 
 @warning 调用这个方法退出登录同时会清空数据库（在没登陆的情况下慎重调用）
 */
+ (void)userLogout;



- (void)showRecommendViewControllerWithLoginViewController:(UIViewController *)viewController loginComletion:(void (^)())loginCompletion;


- (void)showUserAccountSettingViewController:(UIViewController *)viewController
                                  userAccont:(UMComUserAccount *)userAccount
                                       error:(NSError *)error
                                  completion:(void (^)(UIViewController *viewController, UMComUserAccount *loginUserAccount))completion;

@end



