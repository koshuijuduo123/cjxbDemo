//
//  UserDefault.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/25.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginDataModel.h"
#import "MyCarModel.h"
#import "MapModel.h"
#import "YZUserModel.h"
@interface UserDefault : NSObject


//初始化存储类
+(void)initDefaults;

//存取应用启动的次数
+(void)setLaunchTimes:(NSString *)launchTimes;
+(NSString *)getLunchTimes;


//保存用户信息
+(void)saveUserInfo:(LoginDataModel *)model;
//保存车辆信息
//+(void)saveCarInfo:(MyCarModel *)model;

//获取用户信息
+(LoginDataModel *)getUserInfo;
//获取车辆信息
//+(MyCarModel *)getMyCarInfo;
//判断用户是否登录

+(BOOL)isLogin;


//清除用户信息
+(void)clearUserData;
//清除车辆信息
//+(void)clearMyCarData;
//存取uid
//+(void)setDianZiJuanDate:(NSString *)dateStr;

//获得uid
//+(NSString *)getDianZiJuanDate;

//数据格式转换
+ (YZUserModel *)modelWithUser:(LoginDataModel *)model;
@end
