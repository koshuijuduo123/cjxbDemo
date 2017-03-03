//
//  MessageModel.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/5.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "BaseModel.h"

@interface MessageModel : BaseModel
@property(nonatomic,copy)NSString *username;//用户名
@property(nonatomic,copy)NSString *password;//密码
@property(nonatomic,copy)NSString *dabh;//档案编号
@property(nonatomic,copy)NSString *jszh;//驾驶证号
@property(nonatomic,copy)NSString *xm;//姓名
@property(nonatomic,copy)NSString *zjcx;//准驾车型
@property(nonatomic,copy)NSString *qfrq;//清分日期
@property(nonatomic,copy)NSString *syrq;//审验日期
@property(nonatomic,copy)NSString *syyxqz;//审验有效期止
@property(nonatomic,copy)NSString *yxqz;//有效期止
@property(nonatomic,copy)NSString *ljjf;//累积积分
@property(nonatomic,copy)NSString *sjhm;//手机号码
@property(nonatomic,copy)NSString *zt;//状态
@property(nonatomic,copy)NSString *ztsm;//状态说明
@property(nonatomic,copy)NSString *gxsj;//更新时间
@property(nonatomic,copy)NSString *bz;//备注




@end
