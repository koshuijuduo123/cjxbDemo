//
//  MyMessageViewController.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/9.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "BaseViewController.h"

@interface MyMessageViewController : BaseViewController<NSURLSessionDataDelegate>
{
    
    NSMutableArray *resultarray;


}
@property(nonatomic,strong)NSMutableData *receivData;
@end
