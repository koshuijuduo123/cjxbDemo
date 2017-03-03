//
//  CoreView.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/2.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoreView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *birdAnimationImageView;
@property (weak, nonatomic) IBOutlet UILabel *coreLab;

-(instancetype)initWithFrame:(CGRect)frame;

@end
