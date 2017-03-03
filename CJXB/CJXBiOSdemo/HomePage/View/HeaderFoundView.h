//
//  HeaderFoundView.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/24.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TapGeurceClcik)(NSString *string);
@interface HeaderFoundView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *DaFengCheimg;
@property (weak, nonatomic) IBOutlet UILabel *CarNameLab;
@property (weak, nonatomic) IBOutlet UILabel *thingLab;


@property(nonatomic,copy)TapGeurceClcik tapClcik;



-(instancetype)initWithFrame:(CGRect)frame;
@end
