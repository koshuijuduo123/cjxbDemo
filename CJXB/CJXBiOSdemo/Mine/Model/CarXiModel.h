//
//  CarXiModel.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 17/2/23.
//  Copyright © 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CarXi;
@interface CarXiModel : NSObject
/** 车模型  */
@property (nonatomic, strong)NSArray<CarXi *> *serieslist;
/** 标题  */
@property(nonatomic, copy) NSString *name;

@end


@interface CarXi : NSObject

/** 名字  */
@property(nonatomic, copy) NSString *name;
@property(nonatomic,copy)NSString *carXiId;
@end
