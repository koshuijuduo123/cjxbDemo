//
//  FuwuTableViewCell.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/6.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "FuwuTableViewCell.h"

@implementation FuwuTableViewCell

- (void)awakeFromNib {
    // Initialization code
}






//电话
- (IBAction)phoneButtonAction:(UIButton *)sender {
    sender.showsTouchWhenHighlighted = YES;
    self.phoneButtonClick(self.phoneNumber);
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
