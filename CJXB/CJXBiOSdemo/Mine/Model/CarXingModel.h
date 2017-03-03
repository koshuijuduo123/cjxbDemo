//
//  CarXingModel.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 17/2/24.
//  Copyright © 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CarXing;
@interface CarXingModel : NSObject
/** 车模型  */
@property (nonatomic, strong)NSArray<CarXing *> *speclist;
/** 标题  */
@property(nonatomic, copy) NSString *name;
@end





@interface CarXing : NSObject

/** 名字  */
@property(nonatomic, copy) NSString *name;
@property(nonatomic,copy)NSString *carXingId;
@end
