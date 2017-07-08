//
//  TickectsTableViewCell.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/29.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "TickectsTableViewCell.h"

@implementation TickectsTableViewCell

- (void)awakeFromNib {
   

}

//成为第一响应者
-(BOOL)canBecomeFirstResponder{
    return YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
