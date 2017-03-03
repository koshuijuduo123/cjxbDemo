//
//  TwoHeView.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/31.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwoHeView : UIView
@property (weak, nonatomic) IBOutlet UILabel *leftLab;

@property (weak, nonatomic) IBOutlet UILabel *rightLab;

-(instancetype)initWithFrame:(CGRect)frame;



@end
