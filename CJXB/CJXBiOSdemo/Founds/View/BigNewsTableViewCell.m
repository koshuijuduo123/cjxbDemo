//
//  BigNewsTableViewCell.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 17/6/15.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "BigNewsTableViewCell.h"

@implementation BigNewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
     _titleLab.backgroundColor = [UIColor colorWithRed:152/255.0 green:152/255.0 blue:152/255.0 alpha:0.8];

    // Configure the view for the selected state
}


// cell为高亮状态时

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    [super setHighlighted:highlighted animated:animated];
    
    //加上这句哦
    _titleLab.backgroundColor = [UIColor colorWithRed:152/255.0 green:152/255.0 blue:152/255.0 alpha:0.8];
   
    
}


@end
