//
//  MinTouView.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/28.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "MinTouView.h"

@implementation MinTouView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"MinTouView" owner:self options:nil];
        self = viewArray[0];
        self.frame =frame;
        
        
        
    }
    
    return self;
    
}

- (IBAction)buttonAction:(UIButton *)sender {
    self.buttonTwosClick(sender.tag);
}

@end
