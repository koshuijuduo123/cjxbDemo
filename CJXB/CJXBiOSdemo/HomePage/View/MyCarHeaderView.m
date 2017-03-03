//
//  MyCarHeaderView.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/24.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "MyCarHeaderView.h"

@implementation MyCarHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //从xib中找到我们定义的view
        NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"MyCarHeaderView" owner:self options:nil];
        self = viewArray[0];
        self.frame = frame;
        
        [self birdFly];
        
    }
    
    return self;
    
}


//定义小鸟动画
-(void)birdFly{
    NSMutableArray *gifArr = [NSMutableArray array];
    for (int i =0; i < 11; i++) {
        NSString *imageName = [NSString stringWithFormat:@"鸟的煽动动画000%d",i+1];
        NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [gifArr addObject:image];
    }
    self.birdAnimationImageView.animationImages =gifArr;
    self.birdAnimationImageView.animationDuration = 0.8;
    
    //设置动画的重复次数
    self.birdAnimationImageView.animationRepeatCount = 0;
    [self.birdAnimationImageView startAnimating];
    
    
}









@end
