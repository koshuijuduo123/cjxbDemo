//
//  TabFooterView.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/27.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ButtonJuanClick) (NSInteger tag);
@interface TabFooterView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *juanImage1;
@property (weak, nonatomic) IBOutlet UIImageView *juanImage2;
@property (weak, nonatomic) IBOutlet UIImageView *juanImage3;
@property (weak, nonatomic) IBOutlet UIImageView *juanImage4;
@property (weak, nonatomic) IBOutlet UIImageView *juanImage5;

@property (weak, nonatomic) IBOutlet UIImageView *juanImage6;

@property (weak, nonatomic) IBOutlet UILabel *titleLab1;
@property (weak, nonatomic) IBOutlet UILabel *titleLab2;

@property (weak, nonatomic) IBOutlet UILabel *titleLab3;
@property (weak, nonatomic) IBOutlet UILabel *titleLab4;
@property (weak, nonatomic) IBOutlet UILabel *titleLab5;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel6;
@property (weak, nonatomic) IBOutlet UILabel *countLab1;
@property (weak, nonatomic) IBOutlet UILabel *yuLab1;
@property (weak, nonatomic) IBOutlet UILabel *countLab2;
@property (weak, nonatomic) IBOutlet UILabel *yuLab2;
@property (weak, nonatomic) IBOutlet UILabel *countLab3;
@property (weak, nonatomic) IBOutlet UILabel *yuLab3;
@property (weak, nonatomic) IBOutlet UILabel *countLab4;
@property (weak, nonatomic) IBOutlet UILabel *yuLab4;
@property (weak, nonatomic) IBOutlet UILabel *countLab5;
@property (weak, nonatomic) IBOutlet UILabel *yuLab5;
@property (weak, nonatomic) IBOutlet UILabel *countLab6;
@property (weak, nonatomic) IBOutlet UILabel *yuLab6;


@property (weak, nonatomic) IBOutlet UIImageView *Zimg1;
@property (weak, nonatomic) IBOutlet UIImageView *Zimg2;
@property (weak, nonatomic) IBOutlet UIImageView *Zimg3;
@property (weak, nonatomic) IBOutlet UIImageView *Zimg4;

@property (weak, nonatomic) IBOutlet UIImageView *Zimg5;
@property (weak, nonatomic) IBOutlet UIImageView *Zimg6;
@property (weak, nonatomic) IBOutlet UILabel *yuanJiaLab;
@property (weak, nonatomic) IBOutlet UILabel *yuanJiaLab2;
@property (weak, nonatomic) IBOutlet UILabel *yuanJiaLab3;
@property (weak, nonatomic) IBOutlet UILabel *yuanJiaLab4;
@property (weak, nonatomic) IBOutlet UILabel *yuanJiaLab5;
@property (weak, nonatomic) IBOutlet UILabel *yuanJiaLab6;



@property(nonatomic,copy)ButtonJuanClick buttonJuanClick;

@property(nonatomic,copy)NSArray *dataArr;//接受传递过来的数据

-(instancetype)initWithFrame:(CGRect)frame withDataSourceArray:(NSMutableArray *)array;


-(void)updataWith:(NSMutableArray *)data;


//对数据源再次进行赋值
-(void)geiYuDataSource:(NSArray *)array;


@end
