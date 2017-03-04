//
//  UserDefault.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/25.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "UserDefault.h"



#define KLunch_Time @"launch_times"

#define KLogin_Data  @"user_data"

#define KMap_Data @"map_data"


static LoginDataModel *model = nil;
static MyCarModel *myModel = nil;
@implementation UserDefault
+(void)initDefaults{
    if ([UserDefault getLunchTimes] == nil) {
        NSDictionary *dic = [NSDictionary dictionaryWithObject:@"1" forKey:KLunch_Time];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dic];
    }
}

//存取应用启动的次数
+(void)setLaunchTimes:(NSString *)launchTimes{
    [[NSUserDefaults standardUserDefaults]setValue:launchTimes forKey:KLunch_Time];
    
}
//获得应用启动次数
+(NSString *)getLunchTimes{
    return [[NSUserDefaults standardUserDefaults]valueForKey:KLunch_Time];
}








//保存用户信息
+(void)saveUserInfo:(LoginDataModel *)model{
    //由于model继承自NSObject,存入时需要转成归档后的data
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //转成data
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    [userDefaults setObject:data forKey:KLogin_Data];
    
    //NSUserDefault不是立即写入内存,需要我们手动同步一下
    [userDefaults synchronize];
}

//保存车辆信息
+(void)saveCarInfo:(MyCarModel *)model{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    [userDefaults setObject:data forKey:@"myCar_Data"];
    [userDefaults synchronize];
}




//获取用户信息
+(LoginDataModel *)getUserInfo{
    if (model==nil) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [userDefaults objectForKey:KLogin_Data];
        
        if (data) {
            model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }else{
            return nil;
        }
    }
    
    return model;
}

//获取车辆信息
+(MyCarModel *)getMyCarInfo{
    if (myModel==nil) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [userDefaults objectForKey:@"myCar_Data"];
        if (data) {
            myModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }else{
            return nil;
        }
    }
    return myModel;
}


//判断用户是否登录

+(BOOL)isLogin{
    if ([UserDefault getUserInfo] ==nil) {
        return NO;
    }
    
    return YES;
}
//清除用户信息
+(void)clearUserData{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KLogin_Data];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"date_Dian"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    model = nil;
    
    
    
}

//清除车辆信息
+(void)clearMyCarData{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"myCar_Data"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    myModel = nil;
}


//存取uid
+(void)setDianZiJuanDate:(NSString *)dateStr{
    [[NSUserDefaults standardUserDefaults]setValue:dateStr forKey:@"date_Dian"];
}

//获取uid
+(NSString *)getDianZiJuanDate{
     return [[NSUserDefaults standardUserDefaults]valueForKey:@"date_Dian"];
}



@end
