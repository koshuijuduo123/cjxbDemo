//
//  ChouJiangView.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/14.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TouchBlockClick) (BOOL isMo);
@interface ChouJiangView : UIView

@property(nonatomic,copy)TouchBlockClick touchBlockClick;



-(instancetype)initWithFrame:(CGRect)frame;




@end
