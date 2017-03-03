//
//  LoginViewController.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/25.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"

@interface LoginViewController : BaseViewController<NSURLConnectionDelegate>

@property(nonatomic,strong)AppDelegate *app;
@property(nonatomic,strong)NSURLConnection *connecton;

@property(nonatomic,copy)void(^buttonPopClick)(NSDictionary *dict);

@property(nonatomic,assign)BOOL isUM;
@end
