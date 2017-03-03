//
//  TickectsTableViewCell.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/29.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TickectsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *tickNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *tickImageView;
@property (weak, nonatomic) IBOutlet UILabel *jfCountLab;
@property (weak, nonatomic) IBOutlet UILabel *syCountLab;

@property (weak, nonatomic) IBOutlet UILabel *whereLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *zheLab;
@property (weak, nonatomic) IBOutlet UILabel *juanLab;
@property (weak, nonatomic) IBOutlet UILabel *tickentLab;
@property (weak, nonatomic) IBOutlet UIView *bigBackView;


@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (weak, nonatomic) IBOutlet UIImageView *Zimg;


@end
