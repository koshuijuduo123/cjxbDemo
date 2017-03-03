//
//  FuwuTableViewCell.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/6.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^PhoneButtonClick) (NSString *string);
@interface FuwuTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *yewuLab;

@property(nonatomic,copy)NSString *phoneNumber;

@property (weak, nonatomic) IBOutlet UIView *leftColorLab;
@property(nonatomic,copy)PhoneButtonClick phoneButtonClick;


@end
