//
//  TabHeaderView.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/27.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ButtonHeaderClick) (NSString *string);
@interface TabHeaderView : UIView
@property(nonatomic,copy)ButtonHeaderClick buttonHeaderClick;
@property (weak, nonatomic) IBOutlet UILabel *TimeRequestLab;
@property (weak, nonatomic) IBOutlet UIButton *shuoshuoBtn;

-(instancetype)initWithFrame:(CGRect)frame;


@end
