//
//  MyCarModel.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 17/2/23.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "BaseModel.h"

@interface MyCarModel : BaseModel
//存储用户选择的车辆信息
@property(nonatomic,copy)NSString *carImgUrl;// 车辆品牌图片
@property(nonatomic,copy)NSString *carPinPai;//车牌
@property(nonatomic,copy)NSString *carName;//车系名字
@property(nonatomic,copy)NSString *carPhotosImgUrl;//车系实体图
@property(nonatomic,copy)NSString *carLeveliname;//车辆类型
@property(nonatomic,copy)NSString *carXing;//车辆型号
@property(nonatomic,copy)NSString *carDang;//挡位
@property(nonatomic,copy)NSString *carPrice;//车辆估价
+(MyCarModel *)shareInstance;
@end
