//
//  UMTabHeaderView.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 17/4/27.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "UMTabHeaderView.h"

@implementation UMTabHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"UMTabHeaderView" owner:self options:nil];
        
        self = viewArray[0];
        self.frame = frame;
        
        
        [self WeiDuMessageWithView:_umMyInfoMessageBtn];
        
    }
    
    return self;
    
}

//未读消息标记
-(void)WeiDuMessageWithView:(UIButton *)button{
    JSBadgeView *bageView = [[JSBadgeView alloc]initWithParentView:button alignment:JSBadgeViewAlignmentCenterRight];
    //调整bageView显示的位置
    bageView.badgePositionAdjustment = CGPointMake(-button.frame.size.width/10, -button.frame.size.height/3);
    
    //标记背景色
    bageView.badgeBackgroundColor = [UIColor redColor];
    bageView.badgeOverlayColor = [UIColor clearColor];
    bageView.badgeStrokeColor = [UIColor redColor];
    bageView.tag = 9999;
}




- (IBAction)umMyMessageAction:(UIButton *)sender {
    sender.showsTouchWhenHighlighted = YES;
    self.buttonHeaderClick(@"分类按钮");
}

- (IBAction)buttonAction:(UIButton *)sender {
    sender.showsTouchWhenHighlighted = YES;
    self.buttonHeaderClick(@"success");
}

@end
