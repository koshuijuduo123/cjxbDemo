//
//  FourWebView.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/1.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "FourWebView.h"

@implementation FourWebView


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"FourWebView" owner:self options:nil];
        
        self = viewArray[0];
        self.frame = frame;
        
        
        
        
    }
    
    return self;
    
}





@end
