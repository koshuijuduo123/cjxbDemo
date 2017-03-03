//
//  CarGroupModel.m
//  CarPrice
//
//  Created by stkcctv on 16/9/30.
//  Copyright © 2016年 JG. All rights reserved.
//

#import "CarGroupModel.h"
#import "MJExtension.h"


@implementation CarGroupModel

+ (NSDictionary *)objectClassInArray{
    return @{@"list": NSStringFromClass([Car class])};
}

@end


@implementation Car
+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"carid":@"id"};
}

@end

