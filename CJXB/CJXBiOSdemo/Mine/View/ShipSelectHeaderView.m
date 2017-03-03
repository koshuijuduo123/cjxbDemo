//
//  ShipSelectHeaderView.m
//  VTravel
//
//  Created by lanouhn on 16/6/12.
//  Copyright © 2016年 口水巨多. All rights reserved.
//
#define KSummaryButton_Tag 111
#define KRouteButton_Tag  222
#import "ShipSelectHeaderView.h"
@interface ShipSelectHeaderView()

@property (weak, nonatomic) IBOutlet UIButton *summaryButton;//概述
@property (weak, nonatomic) IBOutlet UIButton *routeButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left;
@property(nonatomic,assign)NSInteger index;

@end
@implementation ShipSelectHeaderView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"ShipSelectHeaderView" owner:self options:nil];
        self = viewArray[0];
        self.frame = frame;
        self.summaryButton.tag = KSummaryButton_Tag;
        self.routeButton.tag = KRouteButton_Tag;
        
        
    }
    return self;
}







//点击按钮方法
- (IBAction)clickedTheButton:(UIButton *)sender {
    //判断当前点击的按钮是哪个
    if (sender.tag==KSummaryButton_Tag) {
        [self.summaryButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.routeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
     
        if (self.index==3) {
            [self.routeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        
        
        [UIView animateWithDuration:0.5 animations:^{
            self.lineView.frame = CGRectMake(20, self.lineView.y, self.lineView.width, self.lineView.height);
            self.left.constant = 20;
        }];
        
        
    }else{
        
        [self.summaryButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.routeButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        
        
        if (self.index==3) {
            [self.summaryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            self.lineView.frame = CGRectMake(self.routeButton.x, self.lineView.y, self.lineView.width, self.lineView.height);
            self.left.constant = self.routeButton.x;
        }];

        
        
        
        
    }
    
    self.buttonClick(sender.tag);
    
}


@end
