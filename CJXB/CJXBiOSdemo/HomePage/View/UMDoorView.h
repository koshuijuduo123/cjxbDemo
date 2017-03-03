//
//  UMDoorView.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/11/29.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ButtonUMPushAction) (NSString *string);
@interface UMDoorView : UIView

@property(nonatomic,copy)ButtonUMPushAction buttonUMPushAction;
@property (weak, nonatomic) IBOutlet UILabel *unPushLab;
@property (weak, nonatomic) IBOutlet UIButton *bigButton;
@property (weak, nonatomic) IBOutlet UIButton *umMessageBtn;

-(instancetype)initWithFrame:(CGRect)frame;

//-(void)buttonMaiDongAction:(UIButton *)sender;
@end
