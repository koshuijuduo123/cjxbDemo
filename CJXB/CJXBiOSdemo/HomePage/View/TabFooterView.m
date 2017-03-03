//
//  TabFooterView.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/27.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "TabFooterView.h"
@interface TabFooterView()


@end
@implementation TabFooterView

-(instancetype)initWithFrame:(CGRect)frame withDataSourceArray:(NSArray *)array{
    
    if (self = [super initWithFrame:frame]) {
        NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"TabFooterView" owner:self options:nil];
        
        self = viewArray[0];
        self.frame = frame;
        
        for (UIButton *button in self.subviews) {
            if (button.tag&&button.tag!=806) {
                
                button.layer.cornerRadius = 5.0;
                button.clipsToBounds = YES;
            }
            
        }
        
        
       // self.dataArr = array;
        
        
            [self.juanImage1 sd_setImageWithURL:[array[0] objectForKey:@"img"]placeholderImage:[UIImage imageNamed:@"zwt"]];
            [self.juanImage2 sd_setImageWithURL:[array[1] objectForKey:@"img"]placeholderImage:[UIImage imageNamed:@"zwt"]];
            [self.juanImage3 sd_setImageWithURL:[array[2] objectForKey:@"img"] placeholderImage:[UIImage imageNamed:@"zwt"]];
            [self.juanImage4 sd_setImageWithURL:[array[3] objectForKey:@"img"] placeholderImage:[UIImage imageNamed:@"zwt"]];
            [self.juanImage5 sd_setImageWithURL:[array[4] objectForKey:@"img"] placeholderImage:[UIImage imageNamed:@"zwt"]];
            [self.juanImage6 sd_setImageWithURL:[array[5] objectForKey:@"img"] placeholderImage:[UIImage imageNamed:@"zwt"]];
        
            self.titleLab1.text = [array[0] objectForKey:@"name"];
            self.titleLab2.text = [array[1] objectForKey:@"name"];
            self.titleLab3.text = [array[2] objectForKey:@"name"];
            self.titleLab4.text = [array[3] objectForKey:@"name"];
            self.titleLab5.text = [array[4] objectForKey:@"name"];
            self.titleLabel6.text = [array[5] objectForKey:@"name"];
        
        self.countLab1.text =[NSString stringWithFormat:@"%@分",[array[0] objectForKey:@"usepoint"]];
        self.countLab2.text = [NSString stringWithFormat:@"%@分",[array[1] objectForKey:@"usepoint"]];
        self.countLab3.text = [NSString stringWithFormat:@"%@分",[array[2] objectForKey:@"usepoint"]];
        self.countLab4.text = [NSString stringWithFormat:@"%@分",[array[3] objectForKey:@"usepoint"]];
        self.countLab5.text = [NSString stringWithFormat:@"%@分",[array[4] objectForKey:@"usepoint"]];
        self.countLab6.text = [NSString stringWithFormat:@"%@分",[array[5] objectForKey:@"usepoint"]];
        
        self.yuLab1.text = [NSString stringWithFormat:@"剩：%@",[array[0] objectForKey:@"sycount"]];
        self.yuLab2.text = [NSString stringWithFormat:@"剩：%@",[array[1] objectForKey:@"sycount"]];
        self.yuLab3.text = [NSString stringWithFormat:@"剩：%@",[array[2] objectForKey:@"sycount"]];
        self.yuLab4.text = [NSString stringWithFormat:@"剩：%@",[array[3] objectForKey:@"sycount"]];
        self.yuLab5.text =[NSString stringWithFormat:@"剩：%@", [array[4] objectForKey:@"sycount"]];
        self.yuLab6.text = [NSString stringWithFormat:@"剩：%@",[array[5] objectForKey:@"sycount"]];

        //是否强光
        [self hiddinWith:array];
        
    }
    
    return self;
    
}

//优惠劵详情点击按钮
- (IBAction)ButtonAction:(UIButton *)sender {
    self.buttonJuanClick(sender.tag);
}

//查看更多
- (IBAction)ButtonMoreAction:(UIButton *)sender {
    self.buttonJuanClick(sender.tag);
}


-(void)hiddinWith:(NSArray *)arr{
    self.Zimg1.hidden = YES;
    self.Zimg2.hidden = YES;
    self.Zimg3.hidden = YES;
    self.Zimg4.hidden = YES;
    self.Zimg5.hidden = YES;
    self.Zimg6.hidden = YES;
    NSArray *array = @[self.Zimg1,self.Zimg2,self.Zimg3,self.Zimg4,self.Zimg5,self.Zimg6];
    for (int i =0; i<6; i++) {
        if ([[arr[i] objectForKey:@"sycount"] integerValue]==0) {
            UIImageView *img = array[i];
            img.hidden = NO;
        }
    }
    
}




-(void)geiYuDataSource:(NSArray *)array{
    self.dataArr = array;
}

-(void)updataWith:(NSArray *)data{
    [self.juanImage1 sd_setImageWithURL:[data[0] objectForKey:@"smallimg"]];
    [self.juanImage2 sd_setImageWithURL:[data[1] objectForKey:@"smallimg"]];
    [self.juanImage3 sd_setImageWithURL:[data[2] objectForKey:@"smallimg"]];
    [self.juanImage4 sd_setImageWithURL:[data[3] objectForKey:@"smallimg"]];
    [self.juanImage5 sd_setImageWithURL:[data[4] objectForKey:@"smallimg"]];
    [self.juanImage6 sd_setImageWithURL:[data[5] objectForKey:@"smallimg"]];
    
    self.titleLab1.text = [data[0] objectForKey:@"name"];
    self.titleLab2.text = [data[1] objectForKey:@"name"];
    self.titleLab3.text = [data[2] objectForKey:@"name"];
    self.titleLab4.text = [data[3] objectForKey:@"name"];
    self.titleLab5.text = [data[4] objectForKey:@"name"];
    self.titleLabel6.text = [data[5] objectForKey:@"name"];
    
    self.countLab1.text = [data[0] objectForKey:@"usepoint"];
    self.countLab2.text = [data[1] objectForKey:@"usepoint"];
    self.countLab3.text = [data[2] objectForKey:@"usepoint"];
   self.countLab4.text = [data[3] objectForKey:@"usepoint"];
    self.countLab5.text = [data[4] objectForKey:@"usepoint"];
    self.countLab6.text = [data[5] objectForKey:@"usepoint"];
    
    self.yuLab1.text = [data[0] objectForKey:@"sycount"];
    self.yuLab2.text = [data[1] objectForKey:@"sycount"];
   self.yuLab3.text = [data[2] objectForKey:@"sycount"];
    self.yuLab4.text = [data[3] objectForKey:@"sycount"];
    self.yuLab5.text = [data[4] objectForKey:@"sycount"];
    self.yuLab6.text = [data[5] objectForKey:@"sycount"];
}


@end
