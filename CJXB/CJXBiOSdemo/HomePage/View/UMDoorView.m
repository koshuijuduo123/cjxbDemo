//
//  UMDoorView.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/11/29.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "UMDoorView.h"
#import "UMComUnReadNoticeModel.h"
#import "UMComSession.h"

@implementation UMDoorView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //从xib中找到我们定义的view
        NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"UMDoorView" owner:self options:nil];
        self = viewArray[0];
        self.frame = frame;
        
       [self.unPushLab setFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:30]];
        
        self.layer.cornerRadius = 5.0;
        
        self.clipsToBounds = YES;
        
        self.unPushLab.layer.cornerRadius = 50.0;
        self.unPushLab.clipsToBounds = YES;
        
        [self WeiDuMessageWithView:_unPushLab];
        
        
        
        
        
    }
    
    return self;
    
}


//未读消息标记
-(void)WeiDuMessageWithView:(UILabel *)label{
    JSBadgeView *bageView = [[JSBadgeView alloc]initWithParentView:label alignment:JSBadgeViewAlignmentCenterRight];
    //调整bageView显示的位置
    bageView.badgePositionAdjustment = CGPointMake(-label.frame.size.width/4, -label.frame.size.height/3);
    
    //标记背景色
    bageView.badgeBackgroundColor = [UIColor redColor];
    bageView.badgeOverlayColor = [UIColor clearColor];
    bageView.badgeStrokeColor = [UIColor redColor];
    bageView.tag = 9999;
}


- (IBAction)umMessageAction:(UIButton *)sender {
    sender.showsTouchWhenHighlighted = YES;
    
    self.buttonUMPushAction(@"分类按钮");
    
    
}



//友盟跳转
- (IBAction)UMPushAction:(UIButton *)sender {
    sender.showsTouchWhenHighlighted = YES;
    self.buttonUMPushAction(@"success");
}

@end
