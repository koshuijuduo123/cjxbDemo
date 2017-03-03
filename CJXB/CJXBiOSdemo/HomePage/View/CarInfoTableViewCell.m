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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
