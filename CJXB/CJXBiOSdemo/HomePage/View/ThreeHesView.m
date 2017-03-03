//
//  ThreeHesView.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/1.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "ThreeHesView.h"

@implementation ThreeHesView




-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"ThreeHesView" owner:self options:nil];
        
        self = viewArray[0];
        self.frame = frame;
        
        
        self.phoneBtn.showsTouchWhenHighlighted = YES;
        self.mapBtn.showsTouchWhenHighlighted = YES;
        
        
    }
    
    return self;
    
}
//电话
- (IBAction)phoneAction:(UIButton *)sender {
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.phoneArr[0]];
    
    
    self.buttonPhonClick(dic);
}

//地图
- (IBAction)mapAction:(UIButton *)sender {
    self.buttonMapClick(self.address.text);
    
    
    
}


@end
