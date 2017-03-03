//
//  MesgInfoView.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/27.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "MesgInfoView.h"


@implementation MesgInfoView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //从xib中找到我们定义的view
        NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"MesgInfoView" owner:self options:nil];
        self = viewArray[0];
        self.frame = frame;
        
        
        
    }
    
    return self;
    
}

@end
