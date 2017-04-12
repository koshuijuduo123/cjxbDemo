//
//  LoginViewController.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/25.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
@class LoginDataModel;
typedef void (^LoginResultBlock)(LoginDataModel *model, BOOL success);
@interface LoginViewController : BaseViewController<NSURLConnectionDelegate>

@property(nonatomic,strong)AppDelegate *app;
@property(nonatomic,strong)NSURLConnection *connecton;

@property(nonatomic,copy)void(^buttonPopClick)(NSDictionary *dict);

@property(nonatomic,assign)BOOL isUM;
@property (copy, nonatomic) LoginResultBlock loginBlock;

@property(nonatomic,assign)BOOL isShoping;//是否是商城调用登陆页
@end
