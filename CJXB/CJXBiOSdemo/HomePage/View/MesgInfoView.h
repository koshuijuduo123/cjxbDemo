//
//  MesgInfoView.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/27.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MesgInfoView : UIView
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;



-(instancetype)initWithFrame:(CGRect)frame;


@end
