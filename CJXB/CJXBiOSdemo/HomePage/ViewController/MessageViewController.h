//
//  MessageViewController.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/5.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "BaseViewController.h"

@interface MessageViewController : BaseViewController<NSURLSessionDataDelegate>
{
    
    NSMutableArray *resultarray;


}

@property(nonatomic,strong)NSMutableData *receivData;
@end
