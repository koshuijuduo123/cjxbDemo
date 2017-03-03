//
//  MyCarTableViewCell.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/9.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *carLabel;
@property (weak, nonatomic) IBOutlet UILabel *carSystemlab;
@property (weak, nonatomic) IBOutlet UILabel *feiZlab;
@property (weak, nonatomic) IBOutlet UILabel *moneylab;
@property (weak, nonatomic) IBOutlet UILabel *pointLab;

@end
