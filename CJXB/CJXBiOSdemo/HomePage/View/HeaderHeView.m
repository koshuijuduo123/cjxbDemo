//
//  HeaderHeView.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/31.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "HeaderHeView.h"
@interface HeaderHeView()
@property(nonatomic,assign)BOOL isBtn; //判断点击状态

@end
@implementation HeaderHeView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"HeaderHeView" owner:self options:nil];
        
        self = viewArray[0];
        self.frame = frame;
        
        self.isBtn = NO;
        
        self.quButton.layer.cornerRadius =5.0;
        self.quButton.clipsToBounds = YES;
        self.quButton.showsTouchWhenHighlighted = YES;
        
        //页面废除，禁止交互了
        self.quButton.enabled = NO;
        
    }
    
    return self;
    
}
- (IBAction)buttonAction:(UIButton *)sender {
    self.buttonQuClick(sender.titleLabel.text);
}

@end
