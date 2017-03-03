//
//  HeaderFoundView.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/24.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "HeaderFoundView.h"

@implementation HeaderFoundView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //从xib中找到我们定义的view
        NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"HeaderFoundView" owner:self options:nil];
        self = viewArray[0];
        self.frame = frame;
        
        self.DaFengCheimg.layer.cornerRadius = 90.0;
        self.clipsToBounds = YES;
        
    }
    
    return self;
    
}

//大风车轻拍触发方法
- (IBAction)DaFengCheRelreseData:(UITapGestureRecognizer *)sender {
    
    
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self DaFengChe];

                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             self.tapClcik(@"success");
                         }
                     }];
    
    
    
    
}

//定义大风车动画
-(void)DaFengChe{
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionRepeat
                     animations:^{
                         self.DaFengCheimg.transform = CGAffineTransformMakeRotation(M_PI);
                         
                         
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             
                         }
                     }];

    
    
   
}




@end
