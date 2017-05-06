//
//  UMTabHeaderView.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 17/4/27.
//  Copyright © 2017年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ButtonHeaderClick) (NSString *string);
@interface UMTabHeaderView : UIView
@property(nonatomic,copy)ButtonHeaderClick buttonHeaderClick;
@property (weak, nonatomic) IBOutlet UILabel *TimeRequestLab;
@property (weak, nonatomic) IBOutlet UIButton *shuoshuoBtn;
@property (weak, nonatomic) IBOutlet UIButton *umMyInfoMessageBtn;

-(instancetype)initWithFrame:(CGRect)frame;


@end
