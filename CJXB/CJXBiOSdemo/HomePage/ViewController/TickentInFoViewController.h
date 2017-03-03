//
//  TickentInFoViewController.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/31.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "BaseViewController.h"

@interface TickentInFoViewController : BaseViewController
@property(nonatomic,strong) NSString *tickid;

@property(nonatomic,strong)NSString  *MyTick;//判断是否是我的电卷详情

@property(nonatomic,strong)NSDictionary *tickDic;

@property(nonatomic,assign)BOOL isUse;//判断电子劵是否可用；

@end
