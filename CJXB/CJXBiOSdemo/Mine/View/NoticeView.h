//
//  NoticeView.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/18.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ButtonActionClick) (NSString *string);
@interface NoticeView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *vipNameLab;


@property (weak, nonatomic) IBOutlet UIImageView *sexImg;


@property(nonatomic,copy)ButtonActionClick buttonActionClcik;

@end
