//
//  MyWKWebViewController.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 17/4/17.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "BaseWebController.h"
#import "UserDefault.h"
#import "LoginDataModel.h"
typedef void (^WebBack)();
@interface MyWKWebViewController : BaseWebController
@property (strong, nonatomic) WKWebView *webView;
@property(nonatomic,assign)int AppDelegateSele;
@property(nonatomic,copy)WebBack webBack;
@end
