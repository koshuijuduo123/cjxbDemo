//
//  MapDefaults.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/2.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "MapDefaults.h"
@interface MapDefaults()

//存储经纬度的字典
@property(nonatomic,strong)NSMutableDictionary *dataSource;

@end
@implementation MapDefaults

-(NSMutableDictionary *)dataSource{
    if (!_dataSource) {
        self.dataSource = [NSMutableDictionary dictionary];
    }
    return _dataSource;
}



+(MapDefaults *)standInstance{
    
    static MapDefaults *mapDefaults = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapDefaults = [[self alloc]init];
    });
    
    return mapDefaults;
}

//存取经纬度信息
-(void)setDataWith:(MapModel *)model{
    
    
    [self.dataSource setObject:model.addressTex forKey:@"address"];
    
    
    
}


-(NSString *)sentDataWith{
    return self.dataSource[@"address"];
}

@end
