//
//  LoginDataModel.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/25.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "LoginDataModel.h"
@implementation LoginDataModel


-(instancetype)initWithCoder:(NSCoder *)coder{
    if (self=[super init]) {
        _allsell = [coder decodeObjectForKey:@"allsell"];
        _bd_channelid_android = [coder decodeObjectForKey:@"bd_channelid_android"];
        _bd_userid_android = [coder decodeObjectForKey:@"bd_userid_android"];
        _city = [coder decodeObjectForKey:@"city"];
        _country = [coder decodeObjectForKey:@"country"];
        _device_token = [coder decodeObjectForKey:@"device_token"];
        _device_type = [coder decodeObjectForKey:@"device_type"];
        _freeze = [coder decodeObjectForKey:@"freeze"];
        _headimgurl = [coder decodeObjectForKey:@"headimgurl"];
        _myid = [coder decodeObjectForKey:@"myid"];
        _mobile = [coder decodeObjectForKey:@"mobile"];
        _money = [coder decodeObjectForKey:@"money"];
        _nickname = [coder decodeObjectForKey:@"nickname"];
        _openid = [coder decodeObjectForKey:@"openid"];
        _password = [coder decodeObjectForKey:@"password"];
        _points = [coder decodeObjectForKey:@"points"];
        _province = [coder decodeObjectForKey:@"province"];
        _sellsave = [coder decodeObjectForKey:@"sellsave"];
        _sex = [coder decodeObjectForKey:@"sex"];
        _unionid = [coder decodeObjectForKey:@"unionid"];
        _username = [coder decodeObjectForKey:@"username"];
        _vipendtime = [coder decodeObjectForKey:@"vipendtime"];
        _viplevel = [coder decodeObjectForKey:@"viplevel"];
        _vipname = [coder decodeObjectForKey:@"vipname"];
        _vipstarttime = [coder decodeObjectForKey:@"vipstarttime"];
        _wc_uid = [coder decodeObjectForKey:@"wc_uid"];
        
        _img = [coder decodeObjectForKey:@"img"];
        
    }
    
    
    return self;
    
}


-(void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:_allsell forKey:@"allsell"];
    [coder encodeObject:_bd_channelid_android forKey:@"bd_channelid_android"];
    [coder encodeObject:_bd_userid_android forKey:@"bd_userid_android"];
    [coder encodeObject:_city forKey:@"city"];
    [coder encodeObject:_country forKey:@"country"];
    [coder encodeObject:_device_token forKey:@"device_token"];
    [coder encodeObject:_device_type forKey:@"device_type"];
    [coder encodeObject:_freeze forKey:@"freeze"];
    [coder encodeObject:_headimgurl forKey:@"headimgurl"];
    [coder encodeObject:_myid forKey:@"myid"];
    [coder encodeObject:_mobile forKey:@"mobile"];
    [coder encodeObject:_money forKey:@"money"];
    [coder encodeObject:_nickname forKey:@"nickname"];
    [coder encodeObject:_openid forKey:@"openid"];
    [coder encodeObject:_password forKey:@"password"];
    [coder encodeObject:_points forKey:@"points"];
    [coder encodeObject:_province forKey:@"province"];
    [coder encodeObject:_sellsave forKey:@"sellsave"];
    [coder encodeObject:_sex forKey:@"sex"];
    [coder encodeObject:_unionid forKey:@"unionid"];
    [coder encodeObject:_username forKey:@"username"];
    [coder encodeObject:_vipendtime forKey:@"vipendtime"];
    [coder encodeObject:_viplevel forKey:@"viplevel"];
    [coder encodeObject:_vipname forKey:@"vipname"];
    [coder encodeObject:_vipstarttime forKey:@"vipstarttime"];
    [coder encodeObject:_wc_uid forKey:@"wc_uid"];

    
    [coder encodeObject:_img forKey:@"img"];
}












@end
