//
//  BaseWebViewController.h
//  YouzaniOSDemo
//
//  Created by 可乐 on 16/10/31.
//  Copyright © 2016年 张伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZSDK.h"
#import "UserDefault.h"
#import "LoginDataModel.h"
#import "JGPopView.h"
typedef NS_ENUM(NSUInteger, loginTime) {
    kLoginTimeNever = 0,     //不登录
    kLoginTimePrior = 1,     //先登录
    kLoginTimeWhenNeed = 2,  //需要时登录
};

//分享相关参数
static NSString *SHARE_TITLE = @"title";
static NSString *SHARE_LINK = @"link";
static NSString *SHARE_IMAGE_URL = @"img_url";
static NSString *SHARE_DESC = @"desc";


@interface BaseWebController : UIViewController
@property (strong, nonatomic) UIBarButtonItem *closeBarButtonItem; /**< 关闭按钮 */

@property (assign, nonatomic) loginTime loginTime;
@property (copy, nonatomic) NSString *loadUrl;

@property(nonatomic,strong)NSArray *logTypeArrM;
@property(nonatomic,strong)UIButton *shareBtn;
@property(nonatomic,strong)UIButton *searchBtn;
@property(nonatomic,strong)NSString *aoutMyMessage;
- (void)showShareData:(id)data;

- (void)reloadButtonAction;

- (void)shareButtonAction;

- (void)loadWithString:(NSString *)urlStr;
//-(void)timerCallback;
-(void)webViewFail;
+(void)showAlertMessageWithMessage:(NSString*)message duration:(NSTimeInterval)time;
@end
