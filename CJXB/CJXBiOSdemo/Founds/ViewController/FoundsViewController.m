//
//  FoundsViewController.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/25.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "FoundsViewController.h"
#import "FoundsOneViewController.h"
#import "FoundsTwoViewController.h"
#import "FoundsThreeViewController.h"
#import "FoundsFourViewController.h"

CGFloat const TitilesViewH = 44;
@interface FoundsViewController ()<UIScrollViewDelegate,UINavigationControllerDelegate>

/** 标签栏底部的红色指示器 */
@property (nonatomic, weak) UIView *indicatorView;
/** 当前选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
/** 顶部的所有标签 */
@property (nonatomic, weak) UIView *titlesView;
/** 底部的所有内容 */
@property (nonatomic, weak) UIScrollView *contentView;
@end

@implementation FoundsViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"小帮发现";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupChildVces];
    
    [self setupTitlesView];
    [self setupContentView];
}


- (void)setupChildVces{
    FoundsOneViewController *oneVC = [[FoundsOneViewController alloc]init];
    oneVC.title = @"最新";
    [self addChildViewController:oneVC];
    
    FoundsTwoViewController *towVC = [[FoundsTwoViewController alloc]init];
    towVC.title = @"活动";
    [self addChildViewController:towVC];
    
    FoundsThreeViewController *threeVC = [[FoundsThreeViewController alloc]init];
    threeVC.title = @"资讯";
    [self addChildViewController:threeVC];
    
    FoundsFourViewController *fourVC = [[FoundsFourViewController alloc]init];
    fourVC.title = @"知识";
    [self addChildViewController:fourVC];
    
    
    
    
}

/*
//判断两个颜色是否相同
+ (BOOL) isTheSameColor2:(UIColor*)color1 anotherColor:(UIColor*)color2
  {
          if (CGColorEqualToColor(color1.CGColor, color2.CGColor)) {
                  return YES;
              }
          else {
                  return NO;
             }
      }
*/
- (void)setupTitlesView
{
    //标签栏整体
    UIView *titlesView =  [[UIView alloc] init];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
    titlesView.width = self.view.width;
    titlesView.height = TitilesViewH;
    titlesView.y = 0;
    
    
    self.titlesView = titlesView;
    [self.view addSubview:titlesView];
    //下面的指示器view
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor colorWithRed:50/255.0 green:148/255.0 blue:252/255.0 alpha:1.0];
    indicatorView.height = 5;
    indicatorView.tag = -1;
    indicatorView.y = titlesView.height - indicatorView.height;
    self.indicatorView = indicatorView;
    
    // 内部子视图空间
    CGFloat width = titlesView.width / self.childViewControllers.count;
    CGFloat height = titlesView.height + 2;
    for (NSInteger i = 0; i<self.childViewControllers.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        button.height = height;
        button.width = width;
        button.x = i * width;
        UIViewController *vc = self.childViewControllers[i];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
        [button setTitle:vc.title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:50/255.0 green:148/255.0 blue:252/255.0 alpha:1.0] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:button];
        
        
        // 默认点击了第一个按钮
        if (i == 0) {
            button.enabled = NO;
            self.selectedButton = button;
            
            // 让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
            self.indicatorView.width = width;
            self.indicatorView.centerX = button.centerX;
        }
    }
    
    //底部灰色背景
    UIView *indicatorBgView = [[UIView alloc] init];
    indicatorBgView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
    indicatorBgView.width = self.view.width;
    indicatorBgView.height = 2;
    indicatorBgView.y = TitilesViewH - 2;
    [self.titlesView addSubview:indicatorBgView];
    
    
    [titlesView addSubview:indicatorView];
}


- (void)titleClick:(UIButton *)button
{
    // 修改按钮状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = size_width/self.childViewControllers.count;
        self.indicatorView.centerX = button.centerX;
    }];
    
    // 滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
}

/**
 * 底部的scrollView
 */
- (void)setupContentView
{
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.frame = self.view.bounds;
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    self.contentView = contentView;
    
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    // 取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0; // 设置控制器view的y值为0(默认是20)
    vc.view.height = scrollView.height; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
    [scrollView addSubview:vc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:self.titlesView.subviews[index]];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
