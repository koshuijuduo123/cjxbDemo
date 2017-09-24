//
//  WebViewController.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/31.
//  Copyright © 2016年 wang. All rights reserved.
//
typedef void(^ButtonClcik) (NSString *string);
typedef void (^WebBack)();
typedef void (^ReleareMyNews)(NSString *string);
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "YZSDK.h"
#import "LoginDataModel.h"
@class IMYWebView;

@interface WebViewController : UIViewController
@property(nonatomic,copy)NSString *titleLab; //分享标题

@property(nonatomic,copy)UIImage *titleImg; //分享图片
@property(nonatomic,copy)NSString *imgUrl;//图片url
@property(nonatomic,strong)IMYWebView *webView;
@property(nonatomic,assign)BOOL shareHiddnBtn;//是否隐藏导航栏分享按钮

@property(nonatomic,assign)BOOL isUIWebView;//使用的是UIwebView


@property(nonatomic,copy)ButtonClcik buttonClcik;
@property(nonatomic,copy)ReleareMyNews releareMyNews;//我的收藏页面回调

@property(nonatomic,copy)NSString *qiandao;

@property(nonatomic,copy)NSString *articleId;//文章ID参数
@property (weak, nonatomic) IBOutlet UIView *backView;
@property(nonatomic,copy)WebBack webBack;
@property(nonatomic,assign)int AppDelegateSele;

@property(nonatomic,assign)BOOL isPushExtcl;//是不是跳转了保养表格

@property(nonatomic,assign)BOOL isMyNewsIn;//是否是收藏列表进入的

@end
