//
//  CarXiModel.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 17/2/23.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "CarXiModel.h"
#import "MJExtension.h"

@implementation CarXiModel

+ (NSDictionary *)objectClassInArray{
    return @{@"serieslist": NSStringFromClass([CarXi class])};
}


@end



@implementation CarXi
+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"carXiId":@"id"};
}

@end