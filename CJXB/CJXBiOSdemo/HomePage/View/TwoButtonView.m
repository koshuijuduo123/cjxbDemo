//
//  TwoButtonView.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/26.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "TwoButtonView.h"

@implementation TwoButtonView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"TwoButtonView" owner:self options:nil];
        self = viewArray[0];
        self.frame =frame;
        
        for (UIButton *button in self.subviews) {
            button.layer.cornerRadius = 10.0;
            button.clipsToBounds = YES;
        }
        
        if (size_width>375) {
            self.carBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
            self.cardBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
             
        }else if (size_width==375){
            self.carBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
            self.cardBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        }else{
            self.carBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
            self.cardBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        }
        
        
    }
    
    return self;
    
}

- (IBAction)buttonAction:(UIButton *)sender {
    self.buttonClick(sender.tag);


}

@end
