//
//  CountsView.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/27.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ButtonLookClick) (NSString *string);
@interface CountsView : UIView
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property(nonatomic,copy)ButtonLookClick buttonLookClick;

-(instancetype)initWithFrame:(CGRect)frame;

@end
