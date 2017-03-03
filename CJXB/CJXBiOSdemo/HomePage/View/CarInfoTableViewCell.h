//
//  CarInfoTableViewCell.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/12.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *yearLab;
@property (weak, nonatomic) IBOutlet UILabel *daysLab;
@property (weak, nonatomic) IBOutlet UILabel *zhoulab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *pointsLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end
