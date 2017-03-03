//
//  NoticeView.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/18.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "NoticeView.h"

@implementation NoticeView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"NoticeView" owner:self options:nil];
        self = viewArray[0];
        self.frame =frame;
        
        self.headerImage.layer.cornerRadius = 40;
        self.headerImage.clipsToBounds = YES;
        
        
        
        
    }
    
    return self;
    
}




//查看特权
- (IBAction)buttonAction:(UIButton *)sender {
    self.buttonActionClcik(@"success");
    
}
//点击头像进入编辑界面
- (IBAction)headImgClick:(UITapGestureRecognizer *)sender {
    self.buttonActionClcik(@"tapSuccess");
    
    
    
}

@end
