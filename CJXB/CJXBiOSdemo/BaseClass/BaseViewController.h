//
//  BaseViewController.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/25.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController



//显示加载圈，title为加载圈上显示的内容
-(void)showHUDWith:(NSString *)title;

//隐藏加载圈
-(void)hidenHUD;

//弹出提示框提醒用户
-(void)showAlertWith:(NSString *)message;


//不用点击就会消失的提示框
+(void)showAlertMessageWithMessage:(NSString*)message duration:(NSTimeInterval)time;

//提示更新
-(void)hsUpdateApp;


@end
