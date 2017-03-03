//
//  TabHeaderView.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/27.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "TabHeaderView.h"

@implementation TabHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"TabHeaderView" owner:self options:nil];
        
        self = viewArray[0];
        self.frame = frame;
        
        
        
        
    }
    
    return self;
    
}


- (IBAction)buttonAction:(UIButton *)sender {
    sender.showsTouchWhenHighlighted = YES;
    self.buttonHeaderClick(@"success");
}


@end
