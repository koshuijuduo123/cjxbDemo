//
//  BaseViewController.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/25.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"

@interface BaseViewController ()

@property(nonatomic,strong)MBProgressHUD *hud;

@end

@implementation BaseViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化hud
    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    //设置等待框动画样式
    _hud.mode = MBProgressHUDModeCustomView;
    [self ImgAction];
    
    [self.view addSubview:self.hud];
    
    
    
    
}



-(void)ImgAction{
    NSMutableArray *refreshImages = [NSMutableArray array];
    
    for (NSUInteger i=1; i<5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"wawago%ld",(unsigned long)i]];
        [refreshImages addObject:image];
    }
    
    UIImageView *refresH = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wawago1"]];
    refresH.animationImages = refreshImages;
    refresH.animationDuration = 0.4;
    refresH.animationRepeatCount = 0;
    refresH.tag = 7777;
    
    
    _hud.customView = refresH;
    
 
}



//显示加载圈，title为加载圈上显示的内容
-(void)showHUDWith:(NSString *)title{
    [self.hud show:YES];
    UIImageView *imgView = [_hud viewWithTag:7777];
    [imgView startAnimating];
    self.hud.labelText = title;
}

//隐藏加载圈
-(void)hidenHUD{
    UIImageView *imgView = [_hud viewWithTag:7777];
    [imgView stopAnimating];
    [self.hud hide:YES];
}


-(void)showAlertWith:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    
}








//不用点击自动消失的提示框
+(void)showAlertMessageWithMessage:(NSString*)message duration:(NSTimeInterval)time
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示:" message:message delegate:nil
                                          cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:time];
}

//------------------------------------------------------------------------------

#pragma mark - 2、外部调用接口的回调方法

//------------------------------------------------------------------------------

+(void) dimissAlert:(UIAlertView *)alert {
    if(alert)     {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}



-(void)hsUpdateApp{
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];//为当前工程项目版本号
    
    NSString *storeAppID = @"1163572663";//配置自己项目在商店的ID
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",storeAppID]]] returningResponse:nil error:nil];
    
    
    
    
    
    if (response == nil) {
        
        return;
    }
    NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        
        return;
    }
    
    NSArray *array = appInfoDic[@"results"];
    if (array.count < 1) {
        
        return;
    }
    NSDictionary *dic = array[0];
    
    //商店版本号
    NSString *appStoreVersion = dic[@"version"];
    
    currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (currentVersion.length==2) {
        currentVersion  = [currentVersion stringByAppendingString:@"0"];
    }else if (currentVersion.length==1){
        currentVersion  = [currentVersion stringByAppendingString:@"00"];
    }
    appStoreVersion = [appStoreVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (appStoreVersion.length==2) {
        appStoreVersion  = [appStoreVersion stringByAppendingString:@"0"];
    }else if (appStoreVersion.length==1){
        appStoreVersion  = [appStoreVersion stringByAppendingString:@"00"];
    }
    
    //4当前版本号小于商店版本号,就更新
    if([currentVersion floatValue] < [appStoreVersion floatValue])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alercConteoller = [UIAlertController alertControllerWithTitle:@"版本有更新" message:[NSString stringWithFormat:@"新版本(%@),是否更新?\n新版本更新内容:\n%@",dic[@"version"],dic[@"releaseNotes"]] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //此处加入应用在app store的地址，方便用户去更新，一种实现方式如下
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", storeAppID]];
                [[UIApplication sharedApplication] openURL:url];
            }];
            UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alercConteoller addAction:actionYes];
            [alercConteoller addAction:actionNo];
            [self presentViewController:alercConteoller animated:YES completion:nil];
            
        });
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    }
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
