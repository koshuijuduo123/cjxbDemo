//
//  MessageData.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/26.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "BaseModel.h"

@interface MessageData : BaseModel

@property(nonatomic,copy)NSString *dabh;//行车编号
@property(nonatomic,copy)NSString *sfzmhm;//身份证编号
@property(nonatomic,copy)NSString *zjcx;//证件型号
@property(nonatomic,copy)NSString *yxqs;//办证时间
@property(nonatomic,copy)NSString *yxqz;//证件到期时间
@property(nonatomic,copy)NSString *ljjf;//已扣除积分
@property(nonatomic,copy)NSString *zt;//A
@property(nonatomic,copy)NSString *fzjg;//豫H
@property(nonatomic,copy)NSString *xm;//姓名
@property(nonatomic,copy)NSString *xb; //1
@property(nonatomic,copy)NSString *qfrq;//清分日期
@property(nonatomic,copy)NSString *syrq;//审验日期


@end
