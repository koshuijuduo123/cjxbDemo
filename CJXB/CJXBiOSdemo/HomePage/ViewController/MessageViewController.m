//
//  MessageViewController.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/5.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageData.h"
#import "AppDelegate.h"
#import "MessageEntity.h"
#import "StringUtils.h"
#import "JSONKit.h"
#import "MyMessageViewController.h"
#import "LoginDataModel.h"
#import "UserDefault.h"
#import "NetworkManger.h"
#define KLogin_Data  @"user_data"
@interface MessageViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *prsonFirld;
@property (weak, nonatomic) IBOutlet UITextField *messageidFirld;
@property (weak, nonatomic) IBOutlet UITextField *nameFirld;

@property (weak, nonatomic) IBOutlet UITextField *numberFirld;

@property(nonatomic,assign)BOOL isSame;

@property(nonatomic,strong)NSMutableDictionary *dataDic;//存放数据的字典

@end

@implementation MessageViewController


-(NSMutableDictionary *)dataDic{
    if (!_dataDic) {
        self.dataDic = [NSMutableDictionary dictionary];
    }
    
    return _dataDic;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSame = NO;
    self.prsonFirld.delegate = self;
    self.messageidFirld.delegate = self;
    self.nameFirld.delegate = self;
    self.numberFirld.delegate = self;
    self.title = @"驾驶证信息录入";
    
}
//小圆圈button
- (IBAction)quanButtonAction:(UIButton *)sender {
    if (self.isSame==NO) {
        [sender setImage:[UIImage imageNamed:@"选中按钮"] forState:(UIControlStateNormal)];
        self.isSame=YES;
        self.messageidFirld.text = self.prsonFirld.text;
    }else{
        [sender setImage:[UIImage imageNamed:@"未选中状态"] forState:(UIControlStateNormal)];
        self.isSame=NO;
        self.messageidFirld.text = nil;
    }
    
    
}



//确定button
- (IBAction)sureButtonAction:(UIButton *)sender {
    
    if (self.prsonFirld.text.length==0||self.messageidFirld.text.length==0||self.nameFirld.text.length==0||self.numberFirld.text.length==0) {
        [MessageViewController showAlertMessageWithMessage:@"内容不能为空" duration:1.0];
        return;
    }
    
    AppDelegate *app = CJXBAPP;
    
    if ([app searchMessageEntity].count>0) {
        [MessageViewController showAlertMessageWithMessage:@"驾驶证一个就够了" duration:2.0];
        
        return;
        
    }
    
    
    
    
    
    
    [self showHUDWith:@"驾驶证验证中..."];
    
    NSURL *url = [NSURL URLWithString:@"http://app1.henanga.gov.cn/jmt/app/trafficInfo_selectJSYWZXX"];
    //第二步，创建请求
    
    NSString *postStr = [[NSString alloc] initWithFormat:@"{\"SFZMHM\":\"%@\",\"DABH\":\"%@\",\"pageNo\":\"1\"}",self.prsonFirld.text,self.numberFirld.text];
    
    NSString *requeststr = [[NSString alloc] initWithFormat:@"auth=%@&info=%@", [StringUtils getAuthJsonObject:postStr],postStr];
    
   // NSLog(@"%@",postStr);
    
    NSData *postData = [requeststr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    //创建网络会话配置对象
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    //发起任务
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    [dataTask resume];
}

//接收到服务器回应的时候调用此方法
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    self.receivData = [NSMutableData data];//数据存储对象的的初始化
    completionHandler(NSURLSessionResponseAllow);
    
}

//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    
    [self.receivData appendData:data];
    
    
}
//数据传完之后调用此方法
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error{
    
    
    if (error==nil) {
        NSString *receiveStr = [[NSString alloc]initWithData:self.receivData encoding:NSUTF8StringEncoding];
        
        NSString *b  =[NSString stringWithFormat:@"%@",receiveStr];
        NSDictionary  *parserData = [b objectFromJSONString];
        if (!parserData) {
            [self hidenHUD];
            [MessageViewController showAlertMessageWithMessage:@"网络不稳定，稍后再试" duration:1.0];
            return;

        }
        
        
        
        if (parserData.allKeys.count<=2) {
            [self hidenHUD];
            [MessageViewController showAlertMessageWithMessage:@"无法查到对应的驾驶证信息" duration:1.0];
            return;
        }
        
        
        
        
        NSDictionary *dic = [parserData objectForKey:@"resultData"];
        
        
        MessageData *model = [[MessageData alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        
        AppDelegate *app = CJXBAPP;
        [app addMessageEntity:model];
        
        MyMessageViewController *messVC = [[MyMessageViewController alloc]init];
        [self hidenHUD];
        
        
        //取出保存的cookie
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        //对取出的cookie进行反归档处理
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:@"kUserDefaultsCookie"]];
        
        if (cookies) {
            
            //设置cookie
            NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (id cookie in cookies) {
                [cookieStorage setCookie:(NSHTTPCookie *)cookie];
            }
        }else{
            
            [self.navigationController pushViewController:messVC animated:YES];
            return;
        }
        
        NSData *data = [userDefaults objectForKey:KLogin_Data];
        LoginDataModel *usermodel = [[LoginDataModel alloc]init];
        if (data) {
            usermodel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            NSDictionary *parDic = @{@"exec":@"uploadjszinfo",@"dabh":model.dabh,@"jszh":model.sfzmhm,@"xm":model.xm,@"zjcx":model.zjcx,@"qfrq":model.qfrq,@"syrq":model.syrq,@"syyxqz":model.yxqs,@"yxqz":model.yxqz,@"ljjf":model.ljjf,@"sjhm":usermodel.mobile};
            
            [NetworkManger requestPOSTWithURLStr:@"http://x.xiaobang520.com/Sys/syshandler.ashx" parmDic:parDic finish:^(id responseObject) {
                [MessageViewController showAlertMessageWithMessage:responseObject[@"Message"] duration:1.0];
            } enError:^(NSError *error) {
                
            }];
        }else{
            usermodel = nil;
        }
        
        
        
        
        
        [self.navigationController pushViewController:messVC animated:YES];
        
        
    }else{
        [self hidenHUD];
        
        [MessageViewController showAlertMessageWithMessage:@"驾驶证录入失败，稍后再试" duration:2.0];
    }
    
    
    
}






#pragma TextFirld代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
