//
//  ThreeHesView.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/1.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ButtonPhoneClick) (NSDictionary  *dic);
typedef void (^ButtonMapClick)(NSString *address);
@interface ThreeHesView : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *metsLab;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;
@property (weak, nonatomic) IBOutlet UILabel *BiaotiLab;


@property(nonatomic,copy)NSString *ppx;
@property(nonatomic,copy)NSString *ppy;

@property(nonatomic,strong)NSMutableArray *phoneArr;//电话数组；

@property(nonatomic,copy)ButtonPhoneClick buttonPhonClick;//回调；

@property(nonatomic,copy)ButtonMapClick buttonMapClick;//地图回掉



-(instancetype)initWithFrame:(CGRect)frame;


@end
