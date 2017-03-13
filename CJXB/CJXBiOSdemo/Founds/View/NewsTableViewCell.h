//
//  NewsTableViewCell.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/29.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *baoCountLab;

@property (weak, nonatomic) IBOutlet UILabel *chatCountLab;
@property (weak, nonatomic) IBOutlet UIImageView *countImg;
@property (weak, nonatomic) IBOutlet UIImageView *chatImg;


@end
