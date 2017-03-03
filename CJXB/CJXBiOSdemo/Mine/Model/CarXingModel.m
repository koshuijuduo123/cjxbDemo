//
//  CarXingModel.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 17/2/24.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "CarXingModel.h"
#import "MJExtension.h"
@implementation CarXingModel
+ (NSDictionary *)objectClassInArray{
    return @{@"speclist": NSStringFromClass([CarXing class])};
}

@end





@implementation CarXing
+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"carXingId":@"id"};
}

@end