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

-(instancetype)initWithFrame:(CGRect)frame withDataSourceArray:(NSMutableArray *)array{
    
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
        if (size_width<=350) {
            self.countLab1.font = [UIFont systemFontOfSize:15.0];
            self.countLab2.font = [UIFont systemFontOfSize:15.0];
            self.countLab3.font = [UIFont systemFontOfSize:15.0];
            self.countLab4.font = [UIFont systemFontOfSize:15.0];
            self.countLab5.font = [UIFont systemFontOfSize:15.0];
            self.countLab6.font = [UIFont systemFontOfSize:15.0];
            self.yuLab1.font = [UIFont systemFontOfSize:10.0];
            self.yuLab2.font = [UIFont systemFontOfSize:10.0];
            self.yuLab3.font = [UIFont systemFontOfSize:10.0];
            self.yuLab4.font = [UIFont systemFontOfSize:10.0];
            self.yuLab5.font = [UIFont systemFontOfSize:10.0];
            self.yuLab6.font = [UIFont systemFontOfSize:10.0];
            self.titleLab1.font = [UIFont systemFontOfSize:15.0];
            self.titleLab2.font = [UIFont systemFontOfSize:15.0];
            self.titleLab3.font = [UIFont systemFontOfSize:15.0];
            self.titleLab4.font = [UIFont systemFontOfSize:15.0];
            self.titleLab5.font = [UIFont systemFontOfSize:15.0];
            self.titleLabel6.font = [UIFont systemFontOfSize:15.0];
            self.yuanJiaLab.font = [UIFont systemFontOfSize:10.0];
            self.yuanJiaLab2.font = [UIFont systemFontOfSize:10.0];
            self.yuanJiaLab3.font = [UIFont systemFontOfSize:10.0];
            self.yuanJiaLab4.font = [UIFont systemFontOfSize:10.0];
            self.yuanJiaLab5.font = [UIFont systemFontOfSize:10.0];
            self.yuanJiaLab6.font = [UIFont systemFontOfSize:10.0];
        }
        
        
        [self.juanImage1 sd_setImageWithURL:[array[0] objectForKey:@"pic_url"]placeholderImage:[UIImage imageNamed:@"zwt"]];
            [self.juanImage2 sd_setImageWithURL:[array[1] objectForKey:@"pic_url"]placeholderImage:[UIImage imageNamed:@"zwt"]];
            [self.juanImage3 sd_setImageWithURL:[array[2] objectForKey:@"pic_url"] placeholderImage:[UIImage imageNamed:@"zwt"]];
            [self.juanImage4 sd_setImageWithURL:[array[3] objectForKey:@"pic_url"] placeholderImage:[UIImage imageNamed:@"zwt"]];
            [self.juanImage5 sd_setImageWithURL:[array[4] objectForKey:@"pic_url"] placeholderImage:[UIImage imageNamed:@"zwt"]];
            [self.juanImage6 sd_setImageWithURL:[array[5] objectForKey:@"pic_url"] placeholderImage:[UIImage imageNamed:@"zwt"]];
        
            self.titleLab1.text = [array[0] objectForKey:@"title"];
            self.titleLab2.text = [array[1] objectForKey:@"title"];
            self.titleLab3.text = [array[2] objectForKey:@"title"];
            self.titleLab4.text = [array[3] objectForKey:@"title"];
            self.titleLab5.text = [array[4] objectForKey:@"title"];
            self.titleLabel6.text = [array[5] objectForKey:@"title"];
        
        for (int i = 0; i<6; i++) {
           NSString *deleteAfterPriceStr =[self deleteTheDecimalPointAfterTheNumber:[array[i] objectForKey:@"price"]];
            switch (i) {
                case 0:
                    self.countLab1.text = [NSString stringWithFormat:@"¥%@",deleteAfterPriceStr];
                    break;
                case 1:
                    self.countLab2.text = [NSString stringWithFormat:@"¥%@",deleteAfterPriceStr];
                    break;
                case 2:
                    self.countLab3.text = [NSString stringWithFormat:@"¥%@",deleteAfterPriceStr];
                    break;
                case 3:
                    self.countLab4.text = [NSString stringWithFormat:@"¥%@",deleteAfterPriceStr];
                    break;
                case 4:
                    self.countLab5.text = [NSString stringWithFormat:@"¥%@",deleteAfterPriceStr];
                    break;
                    
                default:
                    self.countLab6.text = [NSString stringWithFormat:@"¥%@",deleteAfterPriceStr];
                    break;
            }
        }
        
        
        self.yuLab1.text = [NSString stringWithFormat:@"剩:%@",[array[0] objectForKey:@"num"]];
        self.yuLab2.text = [NSString stringWithFormat:@"剩:%@",[array[1] objectForKey:@"num"]];
        self.yuLab3.text = [NSString stringWithFormat:@"剩:%@",[array[2] objectForKey:@"num"]];
        self.yuLab4.text = [NSString stringWithFormat:@"剩:%@",[array[3] objectForKey:@"num"]];
        self.yuLab5.text =[NSString stringWithFormat:@"剩:%@", [array[4] objectForKey:@"num"]];
        self.yuLab6.text = [NSString stringWithFormat:@"剩:%@",[array[5] objectForKey:@"num"]];
        
        self.yuanJiaLab.text = [NSString stringWithFormat:@"原价:%@",[array[0] objectForKey:@"origin_price"]];
        self.yuanJiaLab2.text = [NSString stringWithFormat:@"原价:%@",[array[1] objectForKey:@"origin_price"]];
        self.yuanJiaLab3.text = [NSString stringWithFormat:@"原价:%@",[array[2] objectForKey:@"origin_price"]];
        self.yuanJiaLab4.text = [NSString stringWithFormat:@"原价:%@",[array[3] objectForKey:@"origin_price"]];
        self.yuanJiaLab5.text = [NSString stringWithFormat:@"原价:%@",[array[4] objectForKey:@"origin_price"]];
        self.yuanJiaLab6.text = [NSString stringWithFormat:@"原价:%@",[array[5] objectForKey:@"origin_price"]];
        [self underlineUsePriceWithObject:_yuanJiaLab];
        [self underlineUsePriceWithObject:_yuanJiaLab2];
        [self underlineUsePriceWithObject:_yuanJiaLab3];
        [self underlineUsePriceWithObject:_yuanJiaLab4];
        [self underlineUsePriceWithObject:_yuanJiaLab5];
        [self underlineUsePriceWithObject:_yuanJiaLab6];
        
        //是否抢光
        [self hiddinWith:array];
        
    }
    
    return self;
    
}

-(void)underlineUsePriceWithObject:(UILabel *)label{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:label.text];
    
    [attributedString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, label.text.length)];
    label.attributedText = attributedString;
}

-(NSString *)deleteTheDecimalPointAfterTheNumber:(NSString *)price{
    NSString *string = [NSString stringWithFormat:@"%.1f",[price floatValue]];
    return string;
}

//优惠劵详情点击按钮
- (IBAction)ButtonAction:(UIButton *)sender {
    self.buttonJuanClick(sender.tag);
}

//查看更多
- (IBAction)ButtonMoreAction:(UIButton *)sender {
    self.buttonJuanClick(sender.tag);
}


-(void)hiddinWith:(NSMutableArray *)arr{
    self.Zimg1.hidden = YES;
    self.Zimg2.hidden = YES;
    self.Zimg3.hidden = YES;
    self.Zimg4.hidden = YES;
    self.Zimg5.hidden = YES;
    self.Zimg6.hidden = YES;
    NSArray *array = @[self.Zimg1,self.Zimg2,self.Zimg3,self.Zimg4,self.Zimg5,self.Zimg6];
    for (int i =0; i<6; i++) {
        if ([[arr[i] objectForKey:@"num"] integerValue]==0) {
            UIImageView *img = array[i];
            img.hidden = NO;
        }
    }
    
}




-(void)geiYuDataSource:(NSArray *)array{
    self.dataArr = array;
}

-(void)updataWith:(NSMutableArray *)data{
    [self.juanImage1 sd_setImageWithURL:[data[0] objectForKey:@"pic_url"]];
    [self.juanImage2 sd_setImageWithURL:[data[1] objectForKey:@"pic_url"]];
    [self.juanImage3 sd_setImageWithURL:[data[2] objectForKey:@"pic_url"]];
    [self.juanImage4 sd_setImageWithURL:[data[3] objectForKey:@"pic_url"]];
    [self.juanImage5 sd_setImageWithURL:[data[4] objectForKey:@"pic_url"]];
    [self.juanImage6 sd_setImageWithURL:[data[5] objectForKey:@"pic_url"]];
    
    self.titleLab1.text = [data[0] objectForKey:@"title"];
    self.titleLab2.text = [data[1] objectForKey:@"title"];
    self.titleLab3.text = [data[2] objectForKey:@"title"];
    self.titleLab4.text = [data[3] objectForKey:@"title"];
    self.titleLab5.text = [data[4] objectForKey:@"title"];
    self.titleLabel6.text = [data[5] objectForKey:@"title"];
    
    self.countLab1.text = [data[0] objectForKey:@"price"];
    self.countLab2.text = [data[1] objectForKey:@"price"];
    self.countLab3.text = [data[2] objectForKey:@"price"];
   self.countLab4.text = [data[3] objectForKey:@"price"];
    self.countLab5.text = [data[4] objectForKey:@"price"];
    self.countLab6.text = [data[5] objectForKey:@"price"];
    
    self.yuLab1.text = [data[0] objectForKey:@"num"];
    self.yuLab2.text = [data[1] objectForKey:@"num"];
   self.yuLab3.text = [data[2] objectForKey:@"num"];
    self.yuLab4.text = [data[3] objectForKey:@"num"];
    self.yuLab5.text = [data[4] objectForKey:@"num"];
    self.yuLab6.text = [data[5] objectForKey:@"num"];
    
    self.yuanJiaLab.text = [data[0] objectForKey:@"origin_price"];
    self.yuanJiaLab2.text = [data[1] objectForKey:@"origin_price"];
    self.yuanJiaLab3.text = [data[2] objectForKey:@"origin_price"];
    self.yuanJiaLab4.text = [data[3] objectForKey:@"origin_price"];
    self.yuanJiaLab5.text = [data[4] objectForKey:@"origin_price"];
    self.yuanJiaLab6.text = [data[5] objectForKey:@"origin_price"];
    
}


@end
