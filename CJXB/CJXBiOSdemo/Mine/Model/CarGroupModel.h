//
//  CarGroupModel.h
//  CarPrice
//
//  Created by stkcctv on 16/9/30.
//  Copyright © 2016年 JG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Car;

@interface CarGroupModel : NSObject

/** 车模型  */
@property (nonatomic, strong)NSArray<Car *> *list;
/** 标题  */
@property(nonatomic, copy) NSString *letter;



@end


@interface Car : NSObject

/** 图片  */
@property(nonatomic, copy) NSString *imgurl;
/** 名字  */
@property(nonatomic, copy) NSString *name;
@property(nonatomic,copy)NSString *carid;
@end

