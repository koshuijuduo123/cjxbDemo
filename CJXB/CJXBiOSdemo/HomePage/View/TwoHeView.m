//
//  TwoHeView.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/31.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "TwoHeView.h"

@implementation TwoHeView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"TwoHeView" owner:self options:nil];
        
        self = viewArray[0];
        self.frame = frame;
        
        
        
        
    }
    
    return self;
    
}



@end
