//
//  CountsView.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/27.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "CountsView.h"

@implementation CountsView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"CountsView" owner:self options:nil];
        
        self = viewArray[0];
        self.frame = frame;
        
               
        
        
    }
    
    return self;
    
}

- (IBAction)buttonAction:(UIButton *)sender {
    self.buttonLookClick(@"success");
        
    
}

@end
