//
//  WeatherView.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/10/31.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *wearherImg;
@property (weak, nonatomic) IBOutlet UILabel *weatherText;



-(instancetype)initWithFrame:(CGRect)frame;


-(void)loadView;


@end
