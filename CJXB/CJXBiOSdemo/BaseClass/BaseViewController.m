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







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
