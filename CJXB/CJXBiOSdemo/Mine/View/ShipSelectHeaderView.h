//
//  ShipSelectHeaderView.h
//  VTravel
//
//  Created by lanouhn on 16/6/12.
//  Copyright © 2016年 口水巨多. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ButtonClick) (NSInteger index);
@interface ShipSelectHeaderView : UIView

@property(nonatomic,copy)ButtonClick buttonClick; //block回调前点击按钮index


-(instancetype)initWithFrame:(CGRect)frame;





@end
