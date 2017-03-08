//
//  MineViewController.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/25.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "MineViewController.h"
#import "MinTouView.h"
#import "LoginViewController.h"

#import "MessageEntity.h"
#import "FuwuViewController.h"
#import "AppDelegate.h"
#import "MyCarViewController.h"
#import "CarViewController.h"

#import "UserDefault.h"
#import "MyDianJuanViewcontrollerViewController.h"
#import "NoticeView.h"
#import "MessageViewController.h"
#import "WebViewController.h"
#import "MJExtension.h"
#import "MyMessageViewController.h"
#import "UMComProfileSettingController.h"
#import "UIScrollView+JElasticPullToRefresh.h"
#import "NetworkManger.h"
#import "UILabel+PPCounter.h"
#import "UMCommunity.h"
#import "UMComLoginManager.h"
#import "UMComUser.h"
#import "UMComImageUrl.h"
#import "IMYWebView.h"
#import "UMComDiscoverViewController.h"
#import "CarsPinPaiViewController.h"
@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray *arr1;
@property(nonatomic,strong)NSArray *arr2;

@property(nonatomic,strong)NSArray *imageArray1;
@property(nonatomic,strong)NSArray *imageArray2;

@property(nonatomic,strong)UIButton *button; //加入小帮

@property(nonatomic,strong)MinTouView *touView;
@property(nonatomic,strong)NoticeView *notice;

@property(nonatomic,assign)BOOL isNotice;

@property(nonatomic,assign)NSInteger vip;
@property(nonatomic,strong)NSString *rcount;//我的电子券数量
@property(nonatomic,strong)UILabel *rcountLab; //我的电子券个数显示lab
@end
static NSString *const idemter = @"cell";
@implementation MineViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.hidden = NO;
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.rcount = @"0";
    self.rcountLab = [[UILabel alloc]init];
    [self setNavibar];
    [self body];
    [self myDianZiQuanCount];
    UIView *footView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footView;
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self hsUpdateApp];
    });
}

-(void)setNavibar{
    [self.navigationController.navigationBar setBackgroundImage:[self getImageWithAlpha:1.0] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [self getImageWithAlpha:1.0];
    
    JElasticPullToRefreshLoadingViewCircle *loadingViewCircle = [[JElasticPullToRefreshLoadingViewCircle alloc] init];
    loadingViewCircle.tintColor = [UIColor whiteColor];
    
    
    for (UIView *tempView in self.navigationController.navigationBar.subviews) {
        
        
        
        if ([tempView isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
            
            for (UIView *temp in tempView.subviews) {
                
                
                
                if ([temp isKindOfClass:[UIImageView class]]) {
                    
                    temp.hidden = YES;
                }
            }
        }
    }

    
    __weak __typeof(self)weakSelf = self;
    [self.tableView addJElasticPullToRefreshViewWithActionHandler:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"]];
            
            
            if (cookies.count) {
                [self myDianZiQuanCount];
                [NetworkManger requestPOSTWithURLStr:@"http://x.xiaobang520.com/com/handler.ashx" parmDic:@{@"exec":@"getuserinfo"} finish:^(id responseObject) {
                    
                    LoginDataModel *model = [[LoginDataModel alloc]init];
                    [model setValuesForKeysWithDictionary:responseObject[@"Data"]];
                    model.myid = [responseObject[@"Data"] objectForKey:@"id"];
                    
                    
                    
                    if ([model.nickname isEqualToString:@""]) {
                        
                        model.nickname = [NSString stringWithFormat:@"%@",model.username];
                    }
                    
                    //将登录数据存入本地
                    [UserDefault saveUserInfo:model];
                    
                    
                    
                    
                    NSDictionary *dic = model.keyValues;
                    
                    //发送通知
                    //创建通知
                    NSNotification *notification = [NSNotification notificationWithName:@"Login" object:nil userInfo:dic];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    
                    [MineViewController showAlertMessageWithMessage:@"更新成功" duration:1.0];
                    
                } enError:^(NSError *error) {
                    
                }];
                
                
            }
            
            
            
            
            
            
            
            [weakSelf.tableView stopLoading];
        });
    } LoadingView:loadingViewCircle];
    [self.tableView setJElasticPullToRefreshFillColor:[UIColor colorWithRed:255/255.0 green:132/255.0 blue:1/255.0 alpha:1.0]];
    [self.tableView setJElasticPullToRefreshBackgroundColor:self.tableView.backgroundColor];
    

}

-(UIImage *)getImageWithAlpha:(CGFloat)alpha{
    //创建color对象
    UIColor *color = [UIColor colorWithRed:255/255.0 green:132/255.0 blue:1/255.0 alpha:alpha];
    //声明一个绘制大小
    CGSize colorSize = CGSizeMake(1, 1);
    
    //开始绘制颜色区域
    UIGraphicsBeginImageContext(colorSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //根据提供的颜色值给相应的绘制内容填充
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    //设置填充相应的区域
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    //声明UIImage对象
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    //结束绘制
    UIGraphicsEndImageContext();
    
    
    
    return img;
}


-(void)myDianZiQuanCount{
    
    [NetworkManger requestPOSTWithURLStr:@"http://x.xiaobang520.com/coupon/couponshandler.ashx" parmDic:@{@"exec":@"getmylist",@"p":@"1",@"s":@"0"} finish:^(id responseObject) {
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject];
        self.rcount =[NSString stringWithFormat:@"%@",dic[@"rcount"]];
        //刷新指定
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } enError:^(NSError *error) {
        
    }];

}



-(void)body{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"个人中心";
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size_width, 210)];
    
    self.tableView.tableHeaderView = headerView;
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size_width, 150)];
    imageView.image = [UIImage imageNamed:@"personCard"];
    [headerView addSubview:imageView];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _button.frame = CGRectMake((size_width-size_width/4)/2, (headerView.height-40)/2, size_width/4, 40);
    
    [_button setTitle:@"加入小帮" forState:UIControlStateNormal];
    
    [_button setTitleColor:[UIColor orangeColor]forState:UIControlStateNormal];
    
    _button.backgroundColor = [UIColor whiteColor];
    _button.alpha = 0.6;
    
    [_button addTarget:self action:@selector(handlePushAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _button.layer.cornerRadius = 5.0;
    _button.clipsToBounds = YES;
    
    [headerView addSubview:_button];
    
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((size_width-250)/2, 20, 250, 30)];
    
    label.font = [UIFont systemFontOfSize:16.0];
    label.text = @"车驾小帮，全心全意为车友服务";
    
    label.textAlignment =  NSTextAlignmentCenter;
    
    label.textColor = [UIColor whiteColor];
    [headerView addSubview:label];
    
    //注册登录消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"Login" object:nil];
    
    //注册退出消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RuturnAction) name:@"Ruturn" object:nil];
    
    //注册信息修改通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SaveAction:) name:@"Save" object:nil];
    
    
    
    self.touView = [[MinTouView alloc]initWithFrame:CGRectMake(0, imageView.height, size_width, 60)];
    
    NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"]];
    //NSLog(@"%ld",cookies.count);
    if (cookies.count) {
        LoginDataModel *model = [UserDefault getUserInfo];
        NSDictionary *dic = model.keyValues;
        
        
        NSNotification *notification = [NSNotification notificationWithName:@"Login" object:nil userInfo:dic];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        
    }
    
    
    
    
    [headerView addSubview:_touView];
    __weak MineViewController *weakSelf = self;
    _touView.buttonTwosClick = ^(NSInteger tag){
        NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"]];
        
        if (tag==700) {
            
            if(cookies.count){
                WebViewController *webVC = [[WebViewController alloc]init];
                
                webVC.hidesBottomBarWhenPushed = YES;
               
                webVC.isUIWebView = YES;
                webVC.navigationItem.title = @"积分纪录";
                webVC.webView = [[IMYWebView alloc]initWithFrame:CGRectMake(0, 0, size_width, size_height-64) usingUIWebView:YES];
                
                [webVC.view addSubview:webVC.webView];
                NSString *string5 = [NSString stringWithFormat:CountsNotes_URL];
                NSURL *url1 = [[NSURL alloc]initWithString:string5];
                
                
                NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                [cookieStorage setCookies:cookies forURL:url1 mainDocumentURL:nil];
                
                
                NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url1];
                
                
                
                [webVC.webView loadRequest:request];
                webVC.qiandao = @"YES";
                
                [weakSelf.navigationController pushViewController:webVC animated:YES];
                
                
                
                
            }else{
                LoginViewController *logVC = [[LoginViewController alloc]init];
                
                
                logVC.hidesBottomBarWhenPushed = YES;
                [logVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
               [weakSelf presentViewController:logVC animated:YES completion:nil];
            
                
            }
            
            
            
        }else{
            if (cookies.count) {
                
                WebViewController *webVC = [[WebViewController alloc]init];
                
                webVC.hidesBottomBarWhenPushed = YES;
                
                webVC.isUIWebView = YES;
                webVC.navigationItem.title = @"钱包纪录";
                webVC.webView = [[IMYWebView alloc]initWithFrame:CGRectMake(0, 0, size_width, size_height-64) usingUIWebView:YES];
                
                [webVC.view addSubview:webVC.webView];
                
                NSString *string5 = [NSString stringWithFormat:@"http://x.xiaobang520.com/Sys/moneysShow.aspx"];
                NSURL *url1 = [[NSURL alloc]initWithString:string5];
                
                
                NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                [cookieStorage setCookies:cookies forURL:url1 mainDocumentURL:nil];
                
                
                NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url1];
                
                
                
                [webVC.webView loadRequest:request];
                webVC.qiandao = @"YES";
                
                [weakSelf.navigationController pushViewController:webVC animated:YES];
                
                
                
                
            }else{
                LoginViewController *logVC = [[LoginViewController alloc]init];
                logVC.hidesBottomBarWhenPushed = YES;
                
                [logVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
                [weakSelf presentViewController:logVC animated:YES completion:nil];
            }
        }
        
    };
    
    
    
    
    
    //注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:idemter];
    self.arr1 = @[@"保养爱车",@"我的驾驶证"];
    self.arr2 = @[@"个人信息",@"周边商户",@"帮友之家"];
    
    self.imageArray1 = @[@"我的爱车",@"驾驶证"];
    self.imageArray2 = @[@"个人信息",@"合作",@"朋友圈"];
    

    
    
    
}



//接到通知后执行的方法
- (void)notificationAction:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    //动画类型
    _touView.jfLab.counterAnimationType = PPCounterAnimationTypeEaseOut;
    
    [_touView.jfLab pp_fromNumber:[_touView.jfLab.text floatValue] toNumber:[userInfo[@"points"] floatValue] duration:1.0 formatBlock:^NSString *(CGFloat number) {
        
        return  [NSString stringWithFormat:@"%d分",(int)number];
        
    }];
    
    _touView.jfLab.text = [NSString stringWithFormat:@"%@分",userInfo[@"points"]];
    
    
    _touView.moneyLab.text = [NSString stringWithFormat:@"¥%@",userInfo[@"money"]];
    
    self.notice = [[NoticeView alloc]initWithFrame:CGRectMake(0, 0, size_width, 150)];
    
    
    
    
    //获取本地存储的user
   //UMComUser *user =[UMComUser objectWithObjectId:[UserDefault getDianZiJuanDate]];
    
    
    
    
    [_notice.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userInfo[@"headimgurl"]]] placeholderImage:[UIImage imageNamed:@"icon_user_avatar_anonymous"]];
    
    
    
    if ([userInfo[@"sex"] integerValue]==1) {
        _notice.sexImg.image = [UIImage imageNamed:@"男"];
    }else{
        _notice.sexImg.image = [UIImage imageNamed:@"女"];
    }
    
    
    _notice.nameLab.text = userInfo[@"nickname"];
    //是否包含某个字段
    if ([userInfo[@"vipname"] containsString:@"会员"]) {
        
        _notice.vipNameLab.text = [NSString stringWithFormat:@"%@",userInfo[@"vipname"]];
    }else{
        _notice.vipNameLab.text = [NSString stringWithFormat:@"%@会员",userInfo[@"vipname"]];
    }
   
    
    
    
    [self.tableView.tableHeaderView addSubview:_notice];
    __weak MineViewController *weakSelf = self;
    _notice.buttonActionClcik = ^(NSString *string){
      
        if ([string isEqualToString:@"success"]) {
            WebViewController *webVC = [[WebViewController alloc]init];
            webVC.hidesBottomBarWhenPushed = YES;
          
            webVC.isUIWebView = YES;
            webVC.navigationItem.title = @"会员特权";
            webVC.webView = [[IMYWebView alloc]initWithFrame:CGRectMake(0, 0, size_width, size_height-64) usingUIWebView:YES];
            
            [webVC.view addSubview:webVC.webView];
            
            if ([userInfo[@"viplevel"] integerValue]==1) {
                weakSelf.vip = 1;
            }else if ([userInfo[@"viplevel"] integerValue]==2){
                weakSelf.vip = 2;
            }else if ([userInfo[@"viplevel"] integerValue]==3){
                weakSelf.vip=3;
            }else{
                weakSelf.vip = 4;
            }
            
            NSString *string5 = [NSString stringWithFormat:@"http://x.xiaobang520.com/vip%ld.htm?userid=%@&from=timeline&isapptalled=1",(long)weakSelf.vip,userInfo[@"myid"]];
            
            NSURL *url1 = [[NSURL alloc]initWithString:string5];
            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url1];
            
            
            
            [webVC.webView loadRequest:request];
            
            [weakSelf.navigationController pushViewController:webVC animated:YES];

        }
        
        if ([string isEqualToString:@"tapSuccess"]) {
            
            
            
            UMComProfileSettingController *infoMessageVC = [[UMComProfileSettingController alloc]init];
            
            
            infoMessageVC.hidesBottomBarWhenPushed = YES;
            
            
            [weakSelf.navigationController pushViewController:infoMessageVC animated:YES];
        }
        
        
    };
    
    
    
}


-(void)RuturnAction{
    __weak MineViewController *weakself = self;
    
        //退出操作
        //清除本地登录信息
        [UserDefault clearUserData];
        
        NSUserDefaults *defult = [NSUserDefaults standardUserDefaults];
        [defult removeObjectForKey:@"kUserDefaultsCookie"];
        [defult synchronize];
        //清除cookie
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray *_tmpArray = [NSArray arrayWithArray:[cookieJar cookies]];
        for (id obj in _tmpArray) {
            [cookieJar deleteCookie:obj];
        }
        //退出友盟登录
        if ([UMComLoginManager isLogin]) {
            [UMComLoginManager userLogout];
        }
        
        
        [weakself.notice removeFromSuperview];
    
        
        weakself.touView.jfLab.text = @"";
        weakself.touView.moneyLab.text = @"";
        
        [self body];
}




-(void)SaveAction:(NSNotification *)notification{
    [NetworkManger requestPOSTWithURLStr:@"http://x.xiaobang520.com/Sys/syshandler.ashx" parmDic:notification.userInfo finish:^(id responseObject) {
        
        
        NSString *str = [responseObject[@"Message"] stringByRemovingPercentEncoding];
        
        
        
        if ([str isEqualToString:@"修改信息成功"]) {
            
            
            
            LoginDataModel *model = [UserDefault getUserInfo];
            model.nickname = notification.userInfo[@"n"];
            model.headimgurl = notification.userInfo[@"img"];
            model.sex = [NSString stringWithFormat:@"%@",notification.userInfo[@"sex"]];
            [UserDefault saveUserInfo:model];
            NSDictionary *dic = model.keyValues;
            
            //创建通知
            NSNotification *notification = [NSNotification notificationWithName:@"Login" object:nil userInfo:dic];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            
            
        }else{
}
        
        
    } enError:^(NSError *error) {
        
    }];
    
}





//点击登录（加入小帮）
-(void)handlePushAction:(UIButton *)sender{
    
    LoginViewController *loginVC = [[LoginViewController alloc]init];
       
    
    loginVC.hidesBottomBarWhenPushed = YES;
    
    [loginVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    
    
    [self presentViewController:loginVC animated:YES completion:nil];
    
}




#pragma mark - tableView 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if (section==1){
        return self.arr1.count;
    }else{
        return self.arr2.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idemter forIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.section==0) {
        cell.textLabel.text = @"我的电子劵";
        cell.imageView.image = [UIImage imageNamed:@"电子券"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        _rcountLab.font = [UIFont boldSystemFontOfSize:14];
        [_rcountLab sizeToFit];
        _rcountLab.backgroundColor = [UIColor clearColor];
        
        _rcountLab.backgroundColor = [UIColor clearColor];
        _rcountLab.textColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0];
        _rcountLab.text = [NSString stringWithFormat:@"共有%@张",self.rcount];
        _rcountLab.frame =CGRectMake(size_width -_rcountLab.frame.size.width - 30, 15, _rcountLab.frame.size.width, _rcountLab.frame.size.height);
        [cell.contentView addSubview:_rcountLab];
    }
    
    if (indexPath.section==1) {
         NSString *name = self.arr1[indexPath.row];
        NSString *imageName = self.imageArray1[indexPath.row];
        cell.textLabel.text = name;
        cell.imageView.image = [UIImage imageNamed:imageName];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (indexPath.row==0) {
            [cell.contentView addSubview:[self creatCellInLabel:@"选择车型"]];
        }
        if (indexPath.row==1) {
            AppDelegate *app = CJXBAPP;
            if ([app searchMessageEntity].count) {
                NSArray *arr = [app searchMessageEntity];
                MessageEntity *entity = [arr firstObject];
                NSString *carUserName =[NSString stringWithFormat:@"%@的驾驶证",entity.xm];
                [cell.contentView addSubview:[self creatCellInLabel:carUserName]];
                }
        }
        
        
        
    }
    
    if (indexPath.section==2) {
        NSString *name = self.arr2[indexPath.row];
        NSString *imageName = self.imageArray2[indexPath.row];
        cell.textLabel.text = name;
        cell.imageView.image = [UIImage imageNamed:imageName];
        
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row==0) {
            [cell.contentView addSubview:[self creatCellInLabel:@"更换头像姓名等"]];
        }
        if (indexPath.row==1) {
            [cell.contentView addSubview:[self creatCellInLabel:@"周边汽车服务一览"]];
        }
        if (indexPath.row==2) {
            [cell.contentView addSubview:[self creatCellInLabel:@"车友动态随时掌握"]];
        }
        
        /*
        if (indexPath.row==3) {
           cell.accessoryType = UITableViewCellAccessoryNone;
            CGFloat size  =[self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject];
            //NSString *message = size > 1?[NSString stringWithFormat:@"缓存%.2fM,删除缓存",size]: [NSString stringWithFormat:@"缓存%.2fK,删除缓存", size * 1024.0];
            
            
            UILabel *label = [[UILabel alloc] init]; //定义一个在cell最右边显示的label
            label.text = [NSString stringWithFormat:@"%.2fM",size];
            label.font = [UIFont boldSystemFontOfSize:14];
            [label sizeToFit];
            label.backgroundColor = [UIColor clearColor];
            label.frame =CGRectMake(size_width -label.frame.size.width - 10, 12, label.frame.size.width, label.frame.size.height);
            [cell.contentView addSubview:label];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0];
            
            
            //cell.accessoryType = UITableViewCellAccessoryCheckmark;
            //cell.detailTextLabel.text =message;
            //cell.separatorInset = UIEdgeInsetsMake(0, size_width, 0, 0);
            
            
        }
        */
        
        
        
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    AppDelegate *app = CJXBAPP;
    if (indexPath.section==0) {
         NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"]];
        
        if (cookies.count) {
            MyDianJuanViewcontrollerViewController *DianVC = [[MyDianJuanViewcontrollerViewController alloc]init];
            
            DianVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:DianVC animated:YES];
            
            
        }else{
            
            
            [MineViewController showAlertMessageWithMessage:@"加入小帮后可查看" duration:1.0];
        }
        
        
        
    }
    
    
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            
            CarsPinPaiViewController *fuwuVC = [[CarsPinPaiViewController alloc]init];
            fuwuVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:fuwuVC animated:YES];
            
            /*
            if ([app searchMovieEntiity].count>0) {
                MyCarViewController *myVC = [[MyCarViewController alloc]init];
                myVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myVC animated:YES];
            }else{
                CarViewController *carVC = [[CarViewController alloc]init];
                carVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:carVC animated:YES];
                
                
            }
            */
            
            
        }
        
        
        if (indexPath.row==1) {
           
            
            
            
            if ([app searchMessageEntity].count>0) {
                MyMessageViewController  *myVC = [[MyMessageViewController alloc]init];
                myVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myVC animated:YES];
            }else{
                
                
                MessageViewController *messVC = [[MessageViewController alloc]init];
                messVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:messVC animated:YES];
                
            }
    }
    }
    if (indexPath.section==2) {

        if (indexPath.row==0) {
            __weak typeof(self) ws = self;
                [UMComLoginManager performLogin:ws completion:^(id responseObject, NSError *error) {
                    if (!error) {
                       UMComProfileSettingController *settingVc = [[UMComProfileSettingController alloc]init];
                            settingVc.hidesBottomBarWhenPushed = YES;
                            [ws.navigationController pushViewController:settingVc animated:YES];
                                               
                    }
                }];
                
            
        }
        
        
        if (indexPath.row==1) {
            FuwuViewController *fuwuVC = [[FuwuViewController alloc]init];
            
            fuwuVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:fuwuVC animated:YES];
            
            
        }
        
        
        if (indexPath.row==2) {
                UIViewController *communityViewController = [UMCommunity getFeedsViewController];
                communityViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:communityViewController animated:YES];
                
            
            
        }
        
        
        /*
        if (indexPath.row==3) {
            CGFloat size  =[self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject];
            NSString *message = size > 1?[NSString stringWithFormat:@"缓存%.2fM,删除缓存",size]: [NSString stringWithFormat:@"缓存%.2fK,删除缓存", size * 1024.0];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:(UIAlertControllerStyleAlert)];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                [self cleanCaches:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject];
                
                [MineViewController showAlertMessageWithMessage:@"清理完毕" duration:1.0];
                
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:2];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                
                
            }];
            
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
            
            [alert addAction:action1];
            [alert addAction:action2];
            [self presentViewController:alert animated:YES completion:nil];

        }
         */
    }
    
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size_width, 10)];
    view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
   
    return view;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 5;
    }
    
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (size_width<=320) {
        return 40;
    }else if (size_width==375){
        return 50;
    }else{
        return 60;
    }
}


-(void)hsUpdateApp{
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];//为当前工程项目版本号
    
    NSString *storeAppID = @"1163572663";//配置自己项目在商店的ID
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",storeAppID]]] returningResponse:nil error:nil];
    
    
    
    
    
    if (response == nil) {
        
        return;
    }
    NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        
        return;
    }
    
    NSArray *array = appInfoDic[@"results"];
    if (array.count < 1) {
        
        return;
    }
    NSDictionary *dic = array[0];
    //商店版本号
    NSString *appStoreVersion = dic[@"version"];
    
    currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (currentVersion.length==2) {
        currentVersion  = [currentVersion stringByAppendingString:@"0"];
    }else if (currentVersion.length==1){
        currentVersion  = [currentVersion stringByAppendingString:@"00"];
    }
    appStoreVersion = [appStoreVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (appStoreVersion.length==2) {
        appStoreVersion  = [appStoreVersion stringByAppendingString:@"0"];
    }else if (appStoreVersion.length==1){
        appStoreVersion  = [appStoreVersion stringByAppendingString:@"00"];
    }
    
    //4当前版本号小于商店版本号,就更新
    if([currentVersion floatValue] < [appStoreVersion floatValue])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alercConteoller = [UIAlertController alertControllerWithTitle:@"版本有更新" message:[NSString stringWithFormat:@"检测到新版本(%@),是否更新?",dic[@"version"]] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //此处加入应用在app store的地址，方便用户去更新，一种实现方式如下
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", storeAppID]];
                [[UIApplication sharedApplication] openURL:url];
            }];
            UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alercConteoller addAction:actionYes];
            [alercConteoller addAction:actionNo];
            [self presentViewController:alercConteoller animated:YES completion:nil];
            
        });
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    }
    
}



/*
//计算目录大小
-(CGFloat)folderSizeAtPath:(NSString *)path{
    //利用NSFileManger实现对文件的管理
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        //获取目录下的文件,计算其大小
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        //将大小转换为M单位
        
        return size/1024.0/1024.0;
        
    }
    
    return 0;
    
}

//根据路径删除文件
-(void)cleanCaches:(NSString *)path{
    //利用NSFileManager实现对文件的管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        //获取该路径下的文件名
        NSArray *childFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childFiles) {
            //拼接路径
            NSString *absoulutePath = [path stringByAppendingPathComponent:fileName];
            //将文件删除
            [fileManager removeItemAtPath:absoulutePath error:nil];
        }
        
        
    }
    
    
    
}
*/

-(UILabel *)creatCellInLabel:(NSString *)string{
    UILabel *label = [[UILabel alloc] init]; //定义一个在cell最右边显示的label
    label.text = string;
    label.font = [UIFont boldSystemFontOfSize:14];
    [label sizeToFit];
    label.backgroundColor = [UIColor clearColor];
    label.frame =CGRectMake(size_width -label.frame.size.width - 30, 15, label.frame.size.width, label.frame.size.height);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0];
    return label;
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"Login" object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Ruturn" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Save" object:nil];
    
    
    [self.tableView removeJElasticPullToRefreshView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
