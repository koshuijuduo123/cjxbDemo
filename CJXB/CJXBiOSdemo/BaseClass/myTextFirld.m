//
//  myTextFirld.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/21.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "myTextFirld.h"

@implementation myTextFirld

-(void)setHeight{
    
    CGRect rect = self.frame;
    rect.size.height = 50;
    self.frame = rect;
    
    
    
}

//调用顺序1 （从xib创建时调用）
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}
//调用顺序2 （从xib创建时调用）
- (void)awakeFromNib {
    
}

//调用顺序3 （无论xib还是纯代码创建都会调用）
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.tintColor = self.textColor; //设置光标颜色和文字颜色一样
    
}

- (BOOL)becomeFirstResponder {
    [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    return [super resignFirstResponder];
}



@end
