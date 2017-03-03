//
//  CarInfoViewController.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/12.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "BaseViewController.h"

@interface CarInfoViewController : BaseViewController<NSURLSessionDataDelegate>
{
    
    NSMutableArray *resultarray;

}
@property(nonatomic,strong)NSMutableData *receivData;

@property(nonatomic,copy)NSArray *dataSourceArr;//传递数据源

@property(nonatomic,copy)NSString *hm; //传递车牌号码

@property(nonatomic,copy)NSString *mm; //传递车码

@property(nonatomic,copy)NSString *lz;//车类型代码

@end
