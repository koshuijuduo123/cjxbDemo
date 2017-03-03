//
//  SetupSectionHeaderView.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/30.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "SetupSectionHeaderView.h"

@implementation SetupSectionHeaderView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"SetupSectionHeaderView" owner:self options:nil];
        self = viewArray[0];
        self.frame = frame;
        
       for (UIButton *button in self.subviews) {
           button.layer.cornerRadius = 5.0;
           button.layer.masksToBounds = YES;
          
       }
        
        
        
        
    }
    return self;
}


- (IBAction)ButtonAction:(UIButton *)sender {
    sender.showsTouchWhenHighlighted = YES;
    self.buttonHeaderViewClicks(sender.tag);
}





@end
