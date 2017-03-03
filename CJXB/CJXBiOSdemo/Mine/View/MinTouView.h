//
//  MinTouView.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/28.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ButtonTwosClick) (NSInteger tag);
@interface MinTouView : UIView
@property(nonatomic,copy)ButtonTwosClick buttonTwosClick;
@property (weak, nonatomic) IBOutlet UILabel *jfLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

-(instancetype)initWithFrame:(CGRect)frame;


@end
