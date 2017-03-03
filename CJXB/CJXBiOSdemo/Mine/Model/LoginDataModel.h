//
//  LoginDataModel.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/25.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "BaseModel.h"

@interface LoginDataModel : BaseModel<NSCopying>
@property(nonatomic,copy)NSString *allsell;

@property(nonatomic,copy)NSString *bd_channelid_android;
@property(nonatomic,copy)NSString *bd_userid_android;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *country;
@property(nonatomic,copy)NSString *device_token;
@property(nonatomic,copy)NSString *device_type;
@property(nonatomic,copy)NSString *freeze;
@property(nonatomic,copy)NSString *headimgurl;
@property(nonatomic,copy)NSString *myid; //系统特殊符号，需要额外进行赋值
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *money;
@property(nonatomic,copy)NSString *nickname;
@property(nonatomic,copy)NSString *openid;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,copy)NSString *points;//积分
@property(nonatomic,copy)NSString *province;
@property(nonatomic,copy)NSString *sellsave;
@property(nonatomic,copy)NSString *sex;
@property(nonatomic,copy)NSString *unionid;
@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *vipendtime;
@property(nonatomic,copy)NSString *viplevel;
@property(nonatomic,copy)NSString *vipname;
@property(nonatomic,copy)NSString *vipstarttime;
@property(nonatomic,copy)NSString *wc_uid;
@property(nonatomic,copy)UIImage *img;
@end
