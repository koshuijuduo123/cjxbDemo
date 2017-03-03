//
//  MyCarModel.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 17/2/23.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "MyCarModel.h"

@implementation MyCarModel

//单利
+(MyCarModel *)shareInstance {
static MyCarModel *manger = nil;
static dispatch_once_t onceToken;
dispatch_once(&onceToken, ^{
    manger = [[MyCarModel alloc]init];
});
return manger;
}






@end
