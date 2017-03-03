//
//  CarViewController.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/4.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "BaseViewController.h"

@interface CarViewController : BaseViewController<NSURLSessionDataDelegate>
{
    
    NSMutableArray *resultarray;


}

@property(nonatomic,strong)NSMutableData *receivData;



@end
