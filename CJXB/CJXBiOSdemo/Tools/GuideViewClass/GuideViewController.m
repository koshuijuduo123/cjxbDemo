//
//  GuideViewController.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/25.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (int i = 0; i < self.imageArray.count; i++) {
        //创建引导页要展示的imageView
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(size_width*i, 0, size_width, size_height)];
        [self.backView addSubview:imageView];
        
        //判断当前引导页是否为最后一页，添加进入应用按钮
        if (i == self.imageArray.count-1) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(size_width/2, size_height-10-40, size_width/2, 40);
            
            //设置imageView的图片为外界传过来的图片
            [imageView addSubview:button];
            imageView.userInteractionEnabled = YES;
            [button addTarget:self action:@selector(enterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        [imageView setImage:[UIImage imageNamed:self.imageArray[i]]];
        
    }
}


-(void)enterButtonClick:(id)sender{
    //当用户点击进入按钮时，将主页面设置为window的root Controller
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    //获取tabBarcontroller
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UITabBarController *tabBarController = [storyBoard instantiateViewControllerWithIdentifier:@"RootViewController"];
    
    //设置当前app的window
    keyWindow.rootViewController = tabBarController;
    
    
}


//更新试图时，先调用这个方法
-(void)updateViewConstraints{
    [super updateViewConstraints];
    //设置back View的宽度为当前引导页的宽度
    self.widthConstraint.constant = size_width *self.imageArray.count;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
