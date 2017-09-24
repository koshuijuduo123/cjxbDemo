//
//  LoginViewController.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/25.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "LoginViewController.h"
#import "NetworkManger.h"
#import "LoginDataModel.h"
#import "UserDefault.h"
#import "MJExtension.h"
#import "UMComLoginManager.h"
#import "UMComPushRequest.h"
#import "UMComNavigationController.h"
#import "UMComImageUrl.h"

#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/Extend/SMSSDKResultHanderDef.h>
#import <SMS_SDK/Extend/SMSSDKUserInfo.h>
#import <SMS_SDK/Extend/SMSSDK+AddressBookMethods.h>
#import <MessageUI/MessageUI.h>


#import "UMComSession.h"
#import "UMComUser.h"
#import "UMComHomeFeedViewController.h"


@interface LoginViewController ()<UITextFieldDelegate,UMComLoginDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFirld;
@property (weak, nonatomic) IBOutlet UITextField *maTextFirld;


@property (weak, nonatomic) IBOutlet UIButton *maBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;


@end

@implementation LoginViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    
}





-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    //默认不启用通讯录好友
    [SMSSDK enableAppContactFriends:NO];
   
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UMComLoginManager setAppKey:@"57ca6a40e0f55ac3c6003450"];
    [UMComLoginManager setLoginHandler:(id <UMComLoginDelegate>)self];
    
    for (UIButton *button in self.view.subviews) {
       
            button.layer.cornerRadius = 5.0;
            button.clipsToBounds = YES;
    }
    
    [self borderWith:self.maBtn];
    [self borderWith:self.loginBtn];
    //[self borderWith:self.backBtn];
    
    self.phoneTextFirld.delegate = self;
    self.maTextFirld.delegate = self;
    
}

//为选定button加白框
-(void)borderWith:(UIButton *)button{
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 1;
    button.layer.masksToBounds = YES;
}



//获取验证码
- (IBAction)maButtonAction:(UIButton *)sender {
    [self.phoneTextFirld resignFirstResponder];
    if (!(self.phoneTextFirld.text.length==11)) {
        
        
        [LoginViewController showAlertMessageWithMessage:@"号码格式不正确" duration:1.0];
  
        return;
        
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:self.phoneTextFirld.text];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:self.phoneTextFirld.text];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:self.phoneTextFirld.text];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            
        }else{
            [LoginViewController showAlertMessageWithMessage:@"号码格式不正确" duration:1.0];

            return ;
        }
        
[SMSSDK  getVerificationCodeByMethod:SMSGetCodeMethodSMS
                                 phoneNumber:self.phoneTextFirld.text
                                        zone:@"86"
                            customIdentifier:nil
                                      result:^(NSError *error) {
if (!error) {
    [LoginViewController showAlertMessageWithMessage:@"验证码已发送" duration:1.0];
}else{
[LoginViewController showAlertMessageWithMessage:@"发送失败" duration:1.0];
return ;
}
}];
        __block int timeout=60; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
                    sender.userInteractionEnabled = YES;
                });
            }else{
                int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    //NSLog(@"____%@",strTime);
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:1];
                    [sender setTitle:[NSString stringWithFormat:@"%@S后重发",strTime] forState:UIControlStateNormal];
                    [UIView commitAnimations];
                    sender.userInteractionEnabled = NO;
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }
    
    
}



//登录
- (IBAction)loginButtonAction:(UIButton *)sender {
    [self.phoneTextFirld resignFirstResponder];
    [self.maTextFirld resignFirstResponder];
    
    [self showHUDWith:@"正在登录..."];
    /*
    if (![self.phoneTextFirld.text isEqualToString:@"15090356563"]||![self.maTextFirld.text isEqualToString:@"0000"]) {
        [self hidenHUD];
        [LoginViewController showAlertMessageWithMessage:@"请重新输入测试号" duration:1.0];
        return;
    }
    */
    //去除空格符号
    self.maTextFirld.text = [self.maTextFirld.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    //测试登录逻辑
    if ([self.phoneTextFirld.text isEqualToString:@"15090356563"]&&[self.maTextFirld.text isEqualToString:@"12345"]) {
        [NetworkManger requestPOSTWithURLStr:@"http://x.xiaobang520.com/com/handler.ashx" parmDic:@{@"exec":@"getuserinfo",@"username":@"XB_100006227",@"password":@"c89de99418d07a11ce2c47cc6b654df1"} finish:^(id responseObject) {
            
            if([responseObject[@"IsError"] integerValue]==1) {
                [self hidenHUD];
                [LoginViewController showAlertMessageWithMessage:@"网络不稳定，请再获取一次验证码" duration:2.0];
                return ;
                
            }else{
            
            LoginDataModel *model = [[LoginDataModel alloc]init];
            [model setValuesForKeysWithDictionary:responseObject[@"Data"]];
            model.myid = [responseObject[@"Data"] objectForKey:@"id"];
            
            
            
            if ([model.nickname isEqualToString:@""]) {
                
                model.nickname = [NSString stringWithFormat:@"%@",model.username];
            }
            
            
            
            
            
            UMComUserAccount *userAccounts = [[UMComUserAccount alloc] init];
            
            
            userAccounts.usid = [NSString stringWithFormat:@"%@",model.username];
            userAccounts.name = model.nickname;
            userAccounts.gender = [NSNumber numberWithInteger:[model.sex integerValue]];
            
            userAccounts.icon_url = model.headimgurl;
            [UMComPushRequest loginWithCustomAccountForUser:userAccounts completion:^(id responseObject, NSError *error)  {
                
                if (!error) {
                   //登录成功
                   [self hidenHUD];
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject: data forKey: @"kUserDefaultsCookie"];
                    [userDefaults synchronize];
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                        
                        //将登录数据存入本地
                        [UserDefault saveUserInfo:model];
                        NSDictionary *dic = model.keyValues;
                        
                        //发送通知
                        //创建通知
                        NSNotification *notification = [NSNotification notificationWithName:@"Login" object:nil userInfo:dic];
                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                        
                        
                        NSNotification *notification2 = [NSNotification notificationWithName:kUMComUnreadNotificationRefreshNotification object:nil userInfo:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:notification2];
                        
                        NSNotification *notification3 = [NSNotification notificationWithName:@"Count" object:nil userInfo:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:notification3];
                        //传递给有赞
                        [self callBlockWithResult:YES];

                        [LoginViewController showAlertMessageWithMessage:@"成功登录" duration:1.0];
                        }];
                    }else{
                    [self hidenHUD];
                    [LoginViewController showAlertMessageWithMessage:@"登录失败" duration:1.0];
                }
            }];
            }
            } enError:^(NSError *error) {
            [self hidenHUD];
            [LoginViewController showAlertMessageWithMessage:@"网络出问题了，去问问神奇海螺吧" duration:2.0];
        }];
        return;
        
    }

    
    //短信验证登录
    [SMSSDK    commitVerificationCode:self.maTextFirld.text
phoneNumber:self.phoneTextFirld.text
zone:@"86"result:^(SMSSDKUserInfo *userInfo, NSError *error) {
    
    if (!error) {
    [NetworkManger requestPOSTWithURLStr:@"http://x.xiaobang520.com/com/handler.ashx" parmDic:@{@"exec":@"loginorregister",@"key":@"d7ce1e8949bc",@"phone":self.phoneTextFirld.text,@"code":self.maTextFirld.text} finish:^(id responseObject) {
    LoginDataModel *model = [[LoginDataModel alloc]init];
    if([responseObject[@"IsError"] integerValue]==1) {
    [self hidenHUD];
    [LoginViewController showAlertMessageWithMessage:@"网络不稳定，请再获取一次验证码" duration:2.0];
    return ;
                                              
    }else{
    [model setValuesForKeysWithDictionary:responseObject[@"Data"]];
    model.myid = [responseObject[@"Data"] objectForKey:@"id"];
        
    if (model.nickname==nil||model.nickname.length==0) {
    model.nickname = [NSString stringWithFormat:@"%@",model.username];
    }
    }
   UMComUserAccount *userAccounts = [[UMComUserAccount alloc] init];
   userAccounts.usid = [NSString stringWithFormat:@"%@",model.username];
   userAccounts.name = model.nickname;
   if (model.headimgurl==nil||model.headimgurl.length==0) {
       userAccounts.icon_url = UMLoginImgURL;
   }else{
       userAccounts.icon_url = model.headimgurl;
   }
                                    
   userAccounts.gender = [NSNumber numberWithInteger:[model.sex integerValue]];
 
    __weak typeof(self)weakSelf = self;
   [UMComPushRequest loginWithCustomAccountForUser:userAccounts completion:^(id responseObject, NSError *error)  {
    if (!error) {
    //登录成功
    [weakSelf hidenHUD];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject: data forKey: @"kUserDefaultsCookie"];
    [userDefaults synchronize];
                                                  
    [weakSelf dismissViewControllerAnimated:YES completion:^{
    //将登录数据存入本地
    [UserDefault saveUserInfo:model];
    NSDictionary *dic = model.keyValues;
    //发送通知
    //创建通知
    NSNotification *notification = [NSNotification notificationWithName:@"Login" object:nil userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
                                                      
    NSNotification *notification2 = [NSNotification notificationWithName:kUMComUnreadNotificationRefreshNotification object:nil userInfo:nil];
                                                      [[NSNotificationCenter defaultCenter] postNotification:notification2];
                                                      
    NSNotification *notification3 = [NSNotification notificationWithName:@"Count" object:nil userInfo:nil];
  [[NSNotificationCenter defaultCenter] postNotification:notification3];
    //传递给有赞
    [self callBlockWithResult:YES];
                                                      
  [LoginViewController showAlertMessageWithMessage:@"成功登录" duration:1.0];
                                                      
  }];
                                                  
  }else{
  [weakSelf hidenHUD];
  [LoginViewController showAlertMessageWithMessage:@"登录失败" duration:1.0];
  }
                                              
  }];
  } enError:^(NSError *error) {
  [self hidenHUD];
  [LoginViewController showAlertMessageWithMessage:@"网络出问题了，去问问神奇海螺吧" duration:2.0];
  }];
  }else{
  [self hidenHUD];
  [LoginViewController showAlertMessageWithMessage:@"验证失败" duration:1.0];
  }
  }];
    
}

//返回
- (IBAction)fanButtonAction:(UIButton *)sender {
   
    if (self.isShoping==YES) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认不登录" delegate:self cancelButtonTitle:@"不登录" otherButtonTitles:@"登录",nil];
        [alertView show];
        
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:^{
        [self callBlockWithResult:buttonIndex == 1?YES:NO];
    }];
}


#pragma mark - UMComLogin代理
- (void)presentLoginViewController:(UIViewController *)viewController finishResponse:(void (^)(id responseObject, NSError *))completion{
    
    if ([UMComLoginManager isLogin]) {
        if (completion) {
            completion([UMComSession sharedInstance].loginUser,nil);
        }
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
            
            [viewController presentViewController:self animated:YES completion:^{
            }];
            
            
            
        });
    }

}
#pragma TextFirld代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
    
}



//接受到服务器回应的时候调用此方法
-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
    
}



- (void)callBlockWithResult:(BOOL)success {
    if (success) {
        LoginDataModel *model = [UserDefault getUserInfo];
        if (self.loginBlock) {
            if (!model) {
                self.loginBlock(nil,NO);
                [LoginViewController showAlertMessageWithMessage:@"登录信息错误，请重新登录" duration:2.0];
            }else{
                
                self.loginBlock(model,YES);
            }
            
        }
    } else {
        if (self.loginBlock) {
            self.loginBlock(nil,NO);
        }
    }
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
