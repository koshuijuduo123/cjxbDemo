//
//  BigNewsTableViewCell.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 17/6/15.
//  Copyright © 2017年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigNewsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *baoCountLab;

@property (weak, nonatomic) IBOutlet UILabel *chatCountLab;


@property (weak, nonatomic) IBOutlet UILabel *authorLab;
@property (weak, nonatomic) IBOutlet UIImageView *hotNewsImg;
@property (weak, nonatomic) IBOutlet UIImageView *actionImg;

@end
