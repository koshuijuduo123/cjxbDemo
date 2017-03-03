//
//  WebViewController.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/31.
//  Copyright © 2016年 wang. All rights reserved.
//
typedef void(^ButtonClcik) (NSString *string);
typedef void (^WebBack)();
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@class IMYWebView;


@interface WebViewController : UIViewController

@property(nonatomic,copy)NSString *titleLab; //分享标题

@property(nonatomic,copy)UIImage *titleImg; //分享图片

//@property(nonatomic,strong)UIWebView *webView; //属性webView

//@property(nonatomic,strong)IMYWebView *webView2;//签到


@property(nonatomic,strong)IMYWebView *webView;


@property(nonatomic,assign)BOOL isUIWebView;//使用的是UIwebView


@property(nonatomic,copy)ButtonClcik buttonClcik;

@property(nonatomic,copy)NSString *qiandao;

@property(nonatomic,copy)NSString *articleId;//文章ID参数
@property (weak, nonatomic) IBOutlet UIView *backView;
@property(nonatomic,copy)WebBack webBack;
@property(nonatomic,assign)int AppDelegateSele;
@end
