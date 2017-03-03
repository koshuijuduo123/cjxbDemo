//
//  ChouJiangView.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/14.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "ChouJiangView.h"
#import "UserDefault.h"
#import "NetworkManger.h"
#import "WebViewController.h"
@implementation ChouJiangView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"ChouJiangView" owner:self options:nil];
        self = viewArray[0];
        self.frame = frame;
        
        
        
    }
    return self;
}




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.touchBlockClick(YES);
    
    
    
    

    
    
}


@end
