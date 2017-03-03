//
//  FourWebView.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/1.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FourWebView : UIView

@property (weak, nonatomic) IBOutlet UIWebView *webView;




@property(nonatomic,strong)NSString *fourStr;

@property(nonatomic,strong)UIImageView *webImageView;

-(instancetype)initWithFrame:(CGRect)frame;

@end
