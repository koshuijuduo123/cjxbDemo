//
//  YZSDK.h
//  CustomerNetwork
//
//  Created by 益达 on 15/11/19.
//  Copyright (c) 2015年 张伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, YouzanNotice) {
    NotYouzanNotice      = (1 << 0), //非有赞的
    IsYouzanNotice       = (1 << 1), //
    YouzanNoticeLogin    = (1 << 2), //登录通知
    YouzanNoticeShare    = (1 << 3), //分享数据的通知
    YouzanNoticeReady    = (1 << 4), //交互环境初始化成功的通知
    YouzanNoticeWXWapPay = (1 << 5), //已废弃
    YouzanNoticeOther    = (1 << 6), //无效通知
};

@interface YZNotice : NSObject
@property (assign, nonatomic) YouzanNotice notice;;
@property (nullable, strong, nonatomic) id response;
@end


@class WKWebView,YZUserModel;
@interface YZSDK : NSObject

+ (nonnull instancetype)sharedInstance;

/**
 *  设置UA
 *
 *  @param userAgent
 *  @param version   app的版本号【可选,可以设置为空】
 */
+ (void)userAgentInit:(nonnull NSString *)userAgent version:(nullable NSString *)version;
+ (void)userAgentInitNoPrefix:(nonnull NSString *)userAgent version:(nullable NSString *)version DEPRECATED_MSG_ATTRIBUTE("已经废弃的规则");;

/**
 *  设置appID和appSecret
 *
 *  @param appID
 *  @param appSecret
 */
+ (void)setOpenInterfaceAppID:(nonnull NSString *)appID
                    appSecret:(nonnull NSString *)appSecret;

/**
 *  是否开启日志【必须在debug模式下才有效，release模式下无效】
 *
 *  @param open YES是开启，NO是关闭
 */
+ (void)setOpenDebugLog:(BOOL)open;

/**
 *   同步三方app用户信息到有赞服务端【带有回调函数，判断用户信息同步成功或者失败】
 *
 *  @param userModel
 *  @param callback
 */
+ (void)registerYZUser:(nonnull YZUserModel *)userModel
              callBack:(nonnull void (^)( NSString * _Nonnull message , BOOL isError) )callback;

/**
 *  退出登录
 *
 */
+ (BOOL)logoutYouzan;
+ (BOOL)logoutYouzanWithWKWebView;

/**
 *  根据制定模块的协议获取Service
 *
 *  @param protocol
 *
 *  @return
 */
- (nullable id)getService:(nonnull Protocol *)protocol;

/**
 *  获取userAgent
 *
 *  @return
 */
+ (nonnull NSString *)getUserAgent;

/**
 *  获取userAgent带有浏览器信息
 *
 *  @return
 */
+ (nonnull NSString *)getUserAgentContent;

/**
 *  获取sdk的版本号
 *
 *  @return sdk的版本号
 */
+ (nonnull NSString *)getSdkVersion;

/**
 *  解析有赞命令
 *
 *  @param url 当前传入的url参数
 */
+ (nonnull YZNotice *)noticeFromYouzanWithUrl:(nonnull NSURL *)url;

#pragma mark - WKWebView

/**
 *  构造请求
 *
 *  @param webView webview
 */
+ (nullable NSURLRequest *)requestInWKWebViewWithUrl:(nonnull NSURL *)url;

/**
 *  页面加载完成，初始化有赞交互环境
 *
 *  @param webView webview
 */
+ (void)initYouzanWithWKWebView:(nonnull WKWebView *)webView;

/**
 *  触发分享操作
 *
 *  @param webView webview
 */
+ (void)shareActionWithWKWebView:(nonnull WKWebView *)webView;

/**
 *  触发登录操作
 *
 *  @param model 用户信息
 *  @param webView webview
 */
+ (void)loginIfNeedWithModel:(nonnull YZUserModel *)model
                 inWKWebView:(nonnull WKWebView *)webView;


#pragma mark - UIWebView

/**
 *  页面加载完成，初始化有赞交互环境
 *
 */
- (nonnull NSString *)jsBridgeWhenWebDidLoad;

/**
 * 触发分享操作
 */
- (nonnull NSString *)jsBridgeWhenShareBtnClick;

/**
 *  解析url的参数
 *
 *  @param url 当前传入的url参数
 */
- (YouzanNotice)parseYOUZANScheme:(nonnull NSURL *)url DEPRECATED_MSG_ATTRIBUTE("Use noticeFromYouzanWithUrl: method instead");

/**
 *  触发登录操作
 *
 *  @param userInfo 用户信息，包含用户唯一识别的id，性别，昵称等等，详情见文档说明
 *
 *  @return
 */
- (nullable NSString *)webUserInfoLogin:(nonnull YZUserModel *)userInfo;

/**
 *  获取分享数据
 *
 *  @param url 分享的URL中可以解析需要分享的数据
 *
 *  @return
 */
- (nullable NSDictionary *)shareDataInfo:(nonnull NSURL *)url DEPRECATED_MSG_ATTRIBUTE("Use noticeFromYouzanWithUrl: method instead");

@end
