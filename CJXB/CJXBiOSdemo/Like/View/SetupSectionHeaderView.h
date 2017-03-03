//
//  SetupSectionHeaderView.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/30.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ButtonHeaderViewClicks) (NSInteger tag);
@interface SetupSectionHeaderView : UIView


@property(nonatomic,copy)ButtonHeaderViewClicks buttonHeaderViewClicks;


-(instancetype)initWithFrame:(CGRect)frame;



@end
