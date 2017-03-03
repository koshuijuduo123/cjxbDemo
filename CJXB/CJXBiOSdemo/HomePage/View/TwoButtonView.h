//
//  TwoButtonView.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/26.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ButtonClick) (NSInteger index);
@interface TwoButtonView : UIView
@property (weak, nonatomic) IBOutlet UIButton *carBtn;
@property (weak, nonatomic) IBOutlet UIButton *cardBtn;
@property (weak, nonatomic) IBOutlet UIImageView *carImg;
@property (weak, nonatomic) IBOutlet UIImageView *cardImg;

@property(nonatomic,copy)ButtonClick buttonClick;

-(instancetype)initWithFrame:(CGRect)frame;

@end
