//
//  UMComViewController.h
//  UMCommunity
//
//  Created by umeng on 15/9/14.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^WebBack)();
@interface UMComViewController : UIViewController

@property (nonatomic, assign) BOOL doNotShowBackButton;
@property(nonatomic,assign)BOOL isPushWebView;//是否push web页面

@property (nonatomic, strong) UIWebView *webView;

@property(nonatomic,assign)int AppDelegateSele;
@property(nonatomic,copy)WebBack webBack;
@end
