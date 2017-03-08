//
//  CarInfoTableViewCell.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/12.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "CarInfoTableViewCell.h"

@implementation CarInfoTableViewCell

- (void)awakeFromNib {
    self.timeView.layer.cornerRadius = 10.0;
    self.clipsToBounds = YES;
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 3;
    animation.calculationMode = kCAAnimationCubic;
    //把动画添加上去就OK了
    [self.layer addAnimation:animation forKey:nil];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
