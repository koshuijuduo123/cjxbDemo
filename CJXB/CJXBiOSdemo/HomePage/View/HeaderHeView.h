//
//  HeaderHeView.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/31.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ButtonQuClick) (NSString *string);
@interface HeaderHeView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UILabel *systemLab;
@property (weak, nonatomic) IBOutlet UILabel *jfLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *quButton;

@property(nonatomic,copy)ButtonQuClick buttonQuClick;


-(instancetype)initWithFrame:(CGRect)frame;


@end
