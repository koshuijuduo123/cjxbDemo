//
//  MyNewsModel.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 17/3/10.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "BaseModel.h"

@interface MyNewsModel : BaseModel
@property(nonatomic,copy)NSString *title;//新闻标题
@property(nonatomic,copy)NSString *imgUrl;//新闻图片
@property(nonatomic,copy)NSString *pushUrl;//跳转链接
@property(nonatomic,copy)NSString *newsId;//新闻标示ID
@property(nonatomic,copy)NSString *timeAdd;//添加时间
@end
