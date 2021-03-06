//
//  HomePageViewController.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/25.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "HomePageViewController.h"
#import "NetworkManger.h"
#import "TwoButtonView.h"
#import "IMYWebView.h"

#import "CountsView.h"
#import "TabHeaderView.h"
#import "TabFooterView.h"
#import "WebViewController.h"

#import "UserDefault.h"
#import "MapModel.h"
#import "MapDefaults.h"
#import "CoreView.h"
#import "UMTabHeaderView.h"

#import "UMComFeedTableViewController.h"
#import "UMComFindViewController.h"
#import "UMComPullRequest.h"
#import "UMComEditViewController.h"
#import "UMComNavigationController.h"
#import "UMComTopFeedTableViewHelper.h"
#import "UMComRequestTableViewController.h"
#import "UMCommunity.h"

#import "UMComUnReadNoticeModel.h"
#import "UMComSession.h"
#import "UMComNoticeSystemViewController.h"

#import "WKWebViewController.h"
#import "UMComDiscoverViewController.h"
#import "CarsPinPaiViewController.h"
#import "CarViewController.h"
#import "MessageViewController.h"
#import "LoginViewController.h"
#import "FuwuViewController.h"
#import "AppDelegate.h"
#import "MyCarViewController.h"
#import "MJExtension.h"
#import "MyMessageViewController.h"
#import "WeatherView.h"
#import "UILabel+PPCounter.h"
#import "UIScrollView+JElasticPullToRefresh.h"
#import "OpenGoodsService.h"
#import "OpenTradeService.h"
#import "MyWKWebViewController.h"
#import "UMComWebViewController.h"
#import <CoreLocation/CoreLocation.h> //核心定位框架
#import <AudioToolbox/AudioToolbox.h>
#define KTableView_Height 620 //tableView的高度
#define KTableView_Tag 444  //当前主页的tableView
#define UNavControllerImgLogo 6666  //导航栏logo图片

@interface HomePageViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,CLLocationManagerDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *cycleScrollViewDataArray;// 存放轮播图数据
@property(nonatomic,strong)NSMutableArray *dataSourceArray; //存放cell数据
@property(nonatomic,strong)NSMutableDictionary *dataSource;
@property(nonatomic,strong)NSMutableDictionary *juanDataSource;//电子劵大字典

@property(nonatomic,strong)NSMutableArray *imgArray;//存放轮播图图片数组
@property(nonatomic,strong)NSMutableArray *titleArray;//轮播图对应标题title数组

@property(nonatomic,strong)SDCycleScrollView *cycleScrollView ;
@property(nonatomic,strong)TabFooterView *tabFoterView;
@property(nonatomic,assign)NSInteger pageCount;

@property(nonatomic,strong)CLLocationManager *manager;//定位管理者
@property(nonatomic,strong)CLGeocoder *geocoder;//地理编码和反编码

@property(nonatomic,assign)CGFloat old_contentOfset;

@property(nonatomic,strong)CountsView *countView;

@property(nonatomic,strong)UIView *customNavibarView;

@property(nonatomic,strong)UMComFeedTableViewController *realTimeFeedsViewController;

@property(nonatomic,strong)UMTabHeaderView *umDoorView;

@end
static NSString *const identider = @"cell";
@implementation HomePageViewController

//反编码懒加载
-(CLGeocoder *)geocoder{
    if (!_geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

-(NSMutableArray *)titleArray{
    if (!_titleArray) {
        self.titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

-(NSMutableArray *)imgArray{
    if (!_imgArray) {
        self.imgArray = [NSMutableArray array];
    }
    return _imgArray;
}



-(NSMutableDictionary *)juanDataSource{
    if (!_juanDataSource) {
        self.juanDataSource = [NSMutableDictionary dictionary];
    }
    return _juanDataSource;
}



-(NSMutableDictionary *)dataSource{
    if (!_dataSource) {
        self.dataSource = [NSMutableDictionary dictionary];
    }
    return _dataSource;
}


-(NSMutableArray *)cycleScrollViewDataArray{
    if (!_cycleScrollViewDataArray) {
        self.cycleScrollViewDataArray = [NSMutableArray array];
    }
    return _cycleScrollViewDataArray;
}

-(NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        self.dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //设置导航栏不透明
    //self.navigationController.navigationBar.hidden = NO;
     self.customNavibarView.hidden = YES;
    //[self.navigationController setNavigationBarHidden:NO];
    //设置导航栏不透明
    //[self.navigationController.navigationBar setBackgroundImage:[self getImageWithAlpha:1.0] forBarMetrics:UIBarMetricsDefault];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.hidden = YES;
    //self.tabBarController.tabBar.hidden = NO;
    
     //[self.navigationController setNavigationBarHidden:YES];
    //_customNavibarView.hidden = NO;
    //设置导航栏不透明
    self.customNavibarView.hidden = NO;
    //设置navigationbar透明,调用这句话的目的是为了保持主界面消失的时候导航栏的透明度
    //[self scrollViewDidScroll:self.tableView];
    
    //[self.navigationController.navigationBar setBackgroundImage:[self getImageWithAlpha:1.0] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.translucent = YES;
    //防治图片卡顿现象
    [self.cycleScrollView adjustWhenControllerViewWillAppera];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.pageCount = 2;
    
    //取消滚动条
    self.tableView.showsVerticalScrollIndicator = FALSE;
    self.tableView.showsHorizontalScrollIndicator = FALSE;
    
    //注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"Login" object:nil];
    
    //未读消息更新通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UMDoorAction) name:kUMComUnreadNotificationRefreshNotification object:nil];
    
    [self loadData];
    [self loadSubViews];
    
    //设置导航栏系统返回键只保留箭头，不显示文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    
    //创建定位管理者
    self.manager = [[CLLocationManager alloc]init];
    //检查定位服务是否可用
    if (![CLLocationManager locationServicesEnabled]) {
        return;
    }
    
    //如果用户没有授权，要求授权开启
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined) {
        //开启
        [self.manager requestWhenInUseAuthorization];
    }
    
    //定位精度
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //多长的距离更新一次定位，定位频率
    CLLocationDirection distance = 100.0;//十米定位一次
    self.manager.distanceFilter = distance;
    
    //代理设置
    self.manager.delegate = self;
    //启动跟踪地位
    [self.manager startUpdatingLocation];
    
    
    
    
}

//新消息通知方法
-(void)UMDoorAction{
   [UMComPushRequest requestConfigDataWithResult:^(id responseObject, NSError *error) {
   JSBadgeView *bageView =  [self.umDoorView viewWithTag:9999];
   UMComUnReadNoticeModel *unReadNotice = [UMComSession sharedInstance].unReadNoticeModel;
   UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:0];
    if (unReadNotice.totalNotiCount==0) {
        bageView.badgeText =nil;
        item.badgeValue=nil;
    }else{
        
//        if (unReadNotice.totalNotiCount>[bageView.badgeText integerValue]) {
//            //系统声音
//            //AudioServicesPlaySystemSound(1007);
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"notices" ofType:@"mp3"];
//            //组装并播放音效
//            SystemSoundID soundID;
//            NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
//            AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
//            AudioServicesPlaySystemSound(soundID);
//            
//        }
        
        bageView.badgeText =[NSString stringWithFormat:@"%ld",(long)unReadNotice.totalNotiCount];
        if (unReadNotice.totalNotiCount>99) {
            item.badgeValue = @"99+";
        }
        //给标签加未读标记
        item.badgeValue =[NSString stringWithFormat:@"%ld",(long)unReadNotice.totalNotiCount];
        
    }
    
    [bageView setNeedsLayout];
     }];
}



//通知方法
- (void)notificationAction:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    //动画类型
    _countView.count.counterAnimationType = PPCounterAnimationTypeEaseOut;
    
    [_countView.count pp_fromNumber:[_countView.count.text floatValue] toNumber:[userInfo[@"points"] floatValue] duration:1.0 formatBlock:^NSString *(CGFloat number) {
        [_countView.count setFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:30]];
        _countView.count.textColor = [UIColor orangeColor];
        return  [NSString stringWithFormat:@"%d分",(int)number];
        
    }];
    
    
    
}



#pragma mark - 设置navigationBar透明
-(void)setNavibar{
    //将绘制的图片设置成导航栏的背景图片
    [self.navigationController.navigationBar setBackgroundImage:[self getImageWithAlpha:1.0] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.shadowImage = [self getImageWithAlpha:1.0];
    
    JElasticPullToRefreshLoadingViewCircle *loadingViewCircle = [[JElasticPullToRefreshLoadingViewCircle alloc] init];
    loadingViewCircle.tintColor = [UIColor whiteColor];
    //隐藏navationbar上的默认横线
    //NSArray *subViewArray = self.navigationController.navigationBar.subviews;
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
            
            [NetworkManger requestPOSTWithURLStr:@"http://x.xiaobang520.com/Sys/syshandler.ashx?exec=getzxfsgg" parmDic:@{@"t":@"1"} finish:^(id responseObject) {
                self.cycleScrollViewDataArray = [NSMutableArray arrayWithArray:responseObject[@"Data"]];
                
                [self.imgArray removeAllObjects];
                for (NSDictionary *dic in self.cycleScrollViewDataArray) {
                    
                    [self.titleArray addObject:dic[@"title"]];
                    [self.imgArray addObject:dic[@"imggg"]];
                }
                
                
                [self.cycleScrollView removeFromSuperview];
                //第三方添加轮播图
                
                if (size_width<350) {
                    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, size_width, 150) imageURLStringsGroup:self.imgArray];
                }else{
                    
                    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, size_width, 200) imageURLStringsGroup:self.imgArray];
                }
                //分页控制器靠右
                self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
                //自动滚动时间间隔
                self.cycleScrollView.autoScrollTimeInterval = 3.0;
                
                self.cycleScrollView.delegate = self;
                
                //当前分页圆圈的颜色
                self.cycleScrollView.currentPageDotColor = [UIColor greenColor];
                //站位图
                self.cycleScrollView.placeholderImage = [UIImage imageNamed:@"轮播图.png"];
                
                self.cycleScrollView.titlesGroup = self.titleArray;
                
              [self.tableView.tableHeaderView addSubview:self.cycleScrollView];
                WeatherView *weatherView = [_customNavibarView viewWithTag:7758258];
                [weatherView loadView];
                
            } enError:^(NSError *error) {
                
            }];
            
            
            [self loadData];
            
            [self.manager startUpdatingLocation];
            
            NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"]];
            
            
            if (cookies.count) {
                
                [NetworkManger requestPOSTWithURLStr:@"http://x.xiaobang520.com/com/handler.ashx" parmDic:@{@"exec":@"getuserinfo"} finish:^(id responseObject) {
                    if ([responseObject[@"Data"]isKindOfClass:[NSNull class]]) {
                        return ;
                    }
                    
                    
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
                    
                } enError:^(NSError *error) {
                    
                }];
                
                
            }
            
            
            [weakSelf.tableView stopLoading];
        });
    } LoadingView:loadingViewCircle];
    [self.tableView setJElasticPullToRefreshFillColor:[UIColor colorWithRed:46/255.0 green:49/255.0 blue:50/255.0 alpha:1.0]];
    
    [self.tableView setJElasticPullToRefreshBackgroundColor:self.tableView.backgroundColor];
    
    //关闭导航栏透明效果
    //self.navigationController.navigationBar.translucent = NO;
    
    
}


//根据透明度绘制一个图片
-(UIImage *)getImageWithAlpha:(CGFloat)alpha{
    //创建color对象
    UIColor *color = [UIColor colorWithRed:46/255.0 green:49/255.0 blue:50/255.0 alpha:alpha];
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



#pragma mark - 定位代理
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations firstObject];
    
   
    
    MapModel *model = [[MapModel alloc]init];
    
    model.pointx = location.coordinate.latitude;
    model.pointy = location.coordinate.longitude;
    
    if (model) {
        
        [self getAddressWithlatitude:model.pointx withlongitude:model.pointy];
    }
}

//地理反编码
-(void)getAddressWithlatitude:(CLLocationDegrees)latitude withlongitude:(CLLocationDegrees)longitude{
    //通过经纬度，封装了一个CLLoction对象
    CLLocation *loction = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    
    //反编码
    [self.geocoder reverseGeocodeLocation:loction completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placeMark = [placemarks firstObject];
        
        
        
        //获得定位城市
        NSArray *cityStr = placeMark.addressDictionary[@"FormattedAddressLines"];
        MapModel *model = [[MapModel alloc]init];
        model.addressTex = cityStr[0];
        
        if (model.addressTex) {
            
            [[MapDefaults standInstance] setDataWith:model];
        }
        
       
        int i;
        if (size_width<350) {
            i = 150;
        }else{
            i = 200;
        }
        
        CoreView *view1 = [[CoreView alloc]initWithFrame:CGRectMake(0, i, size_width, 60)];
        view1.coreLab.text = nil;
        if ([cityStr[0] length]) {
            view1.coreLab.text = cityStr[0];
        }else{
            view1.coreLab.text = @"网速太慢了";
        }
        UIView *viewling = [self.view viewWithTag:1024];
        [viewling addSubview:view1];
        
    }];
    
    
    
    
}

//加载子视图
-(void)loadSubViews{
    //self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tag = KTableView_Tag;
    
    [self setNavibar];
    
    
    //初始化自定义导航栏视图
    self.customNavibarView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, size_width, 64)];
    
    _customNavibarView.backgroundColor = [UIColor colorWithRed:46/255.0 green:49/255.0 blue:50/255.0 alpha:1.0];
    [self.navigationController.navigationBar addSubview:_customNavibarView];
    
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xblogo"]];
    imgView.frame = CGRectMake(-5,20, 150, 40);
    [_customNavibarView addSubview:imgView];
    
    WeatherView *weatView = [[WeatherView alloc]initWithFrame:CGRectMake(size_width/2, 20, size_width/2, 40)];
    weatView.backgroundColor = [UIColor clearColor];
    weatView.tag = 7758258;
    [_customNavibarView addSubview:weatView];
    
    
    
    int h;
    if (size_width<350) {
        h = 555;
    }else{
        h = 605;
    }
    
    //创建tableView的HeaderView
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size_width, h)];
    headerView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    //给tableView添加自定义的headerView
    self.tableView.tableHeaderView = headerView;
    headerView.tag = 1024;
    
    //###################添加轮播图#######################
    [NetworkManger requestPOSTWithURLStr:@"http://x.xiaobang520.com/Sys/syshandler.ashx?exec=getzxfsgg" parmDic:@{@"t":@"1"} finish:^(id responseObject) {
        self.cycleScrollViewDataArray = [NSMutableArray arrayWithArray:responseObject[@"Data"]];
        //NSLog(@"%@",self.cycleScrollViewDataArray);
        for (NSDictionary *dic in self.cycleScrollViewDataArray) {
            [self.imgArray addObject:dic[@"imggg"]];
            [self.titleArray addObject:dic[@"title"]];
        }
        
        
        
        
        //第三方添加轮播图
        if (size_width<350) {
            self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, size_width, 150) imageURLStringsGroup:self.imgArray];
        }else{
            
            self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, size_width, 200) imageURLStringsGroup:self.imgArray];
        }

        //分页控制器靠右
        self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        //自动滚动时间间隔
        self.cycleScrollView.autoScrollTimeInterval = 3.0;
        
        self.cycleScrollView.delegate = self;
        
        //当前分页圆圈的颜色
        self.cycleScrollView.currentPageDotColor = [UIColor greenColor];
        //站位图
        self.cycleScrollView.placeholderImage = [UIImage imageNamed:@"轮播图.png"];
        
        self.cycleScrollView.titlesGroup = self.titleArray;
        
        [headerView addSubview:_cycleScrollView];
    } enError:^(NSError *error) {
        
    }];
    int i;
    int k;
    if (size_width<350) {
         i = 160;
        k = 195;
    }else{
         i = 210;
        k = 245;
    }
    
    
    UILabel *coreLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, i, size_width, 30)];
    coreLabel.font = [UIFont systemFontOfSize:12.0];
    coreLabel.textColor = [UIColor lightGrayColor];
    coreLabel.text = @"开启定位后显示所在地";
    [headerView addSubview:coreLabel];
    
    
    //#################Twobutton模块###################
    TwoButtonView *twoButtonView = [[TwoButtonView alloc]initWithFrame:CGRectMake(0, k, size_width, 70)];
    [headerView addSubview:twoButtonView];
    
    AppDelegate  *app1 =  CJXBAPP;
    
    __weak HomePageViewController *weakSelf = self;
    //点击按钮回调
    twoButtonView.buttonClick = ^(NSInteger index){
       
        if (index==200) {
            //判断点击的是车辆
            if ([app1 searchMovieEntiity].count>0) {
                MyCarViewController *myVC = [[MyCarViewController alloc]init];
                
                myVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:myVC animated:YES];
                
            }else{
                CarViewController *carVC = [[CarViewController alloc]init];
                carVC.hidesBottomBarWhenPushed = YES;
                
                [weakSelf.navigationController pushViewController:carVC animated:YES];
                
            }
            }else{
           //判断点击的是驾照
            if ([app1 searchMessageEntity].count>0) {
               
                MyMessageViewController *myMegVC = [[MyMessageViewController alloc]init];
                myMegVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:myMegVC animated:YES];
            }else{
                
                MessageViewController *messVC = [[MessageViewController alloc]init];
                messVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:messVC animated:YES];
            }
            
            
        }
    };
    
    //###################ThreeButton模块####################
    TwoButtonView *threeButtonView = [[TwoButtonView alloc]initWithFrame:CGRectMake(0, twoButtonView.height+twoButtonView.y+5, size_width, 70)];
    threeButtonView.carImg.image = [UIImage imageNamed:@"签到"];
    threeButtonView.cardImg.image = [UIImage imageNamed:@"圈子"];
    
    [threeButtonView.carBtn setTitle:@"最新活动" forState:UIControlStateNormal];
    [threeButtonView.cardBtn setTitle:@"帮友圈子" forState:UIControlStateNormal];
    
    [headerView addSubview:threeButtonView];
    
    //点击按钮回调
    threeButtonView.buttonClick = ^(NSInteger tag){
        if (tag==200) {
            NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"]];
            
            if (cookies.count) {
//                WebViewController *webVC = [[WebViewController alloc]init];
//                webVC.hidesBottomBarWhenPushed = YES;
//                
//                webVC.isUIWebView = YES;
//                webVC.title = @"助力值签到";
//                webVC.webView = [[IMYWebView alloc]initWithFrame:CGRectMake(0, 0, size_width, size_height-64) usingUIWebView:YES];
//                
//                [webVC.view addSubview:webVC.webView];
//                
//                NSString *string5 = [NSString stringWithFormat:qiandaoCounts];
//                
//                NSURL *url1 = [[NSURL alloc]initWithString:string5];
//                
//                NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//                [cookieStorage setCookies:cookies forURL:url1 mainDocumentURL:nil];
//                
//                
//                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:string5]];
//                [webVC.webView loadRequest:request];
//                webVC.qiandao = @"qiandao";
                MyWKWebViewController *webVC = [[MyWKWebViewController alloc]init];
                webVC.loadUrl = @"https://h5.youzan.com/v2/feature/cz5r3ebb";
                webVC.hidesBottomBarWhenPushed = YES;
                webVC.title = @"最新活动";
                [weakSelf.navigationController pushViewController:webVC animated:YES];
                }else{
                
                LoginViewController *logVC = [[LoginViewController alloc]init];
                logVC.hidesBottomBarWhenPushed = YES;
                
                [logVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
                [weakSelf presentViewController:logVC animated:YES completion:nil];
            }
            }else {
            
                UIViewController *communityViewController = [UMCommunity getFeedsViewController];
                communityViewController.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:communityViewController animated:YES];
          }
            
            
};
    
    //################商城模块########################
    TwoButtonView *fourButtonView = [[TwoButtonView alloc]initWithFrame:CGRectMake(0, threeButtonView.height+threeButtonView.y+5, size_width, 70)];
    
    fourButtonView.carImg.image = [UIImage imageNamed:@"商城"];
    fourButtonView.cardImg.image = [UIImage imageNamed:@"保养"];
    
    [fourButtonView.carBtn setTitle:@"小帮商城" forState:UIControlStateNormal];
    [fourButtonView.cardBtn setTitle:@"保养预约" forState:UIControlStateNormal];
    
    [headerView addSubview:fourButtonView];
    
    fourButtonView.buttonClick = ^(NSInteger tag){
        if (tag==200) {
            weakSelf.tabBarController.selectedIndex=2;
        }
    
        if (tag==300) {
            CarsPinPaiViewController *carPinPai = [[CarsPinPaiViewController alloc]init];
            carPinPai.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:carPinPai animated:YES];
            
        }
    
    };
    
      //################积分板模块####################
    self.countView = [[CountsView alloc]initWithFrame:CGRectMake(0, fourButtonView.height+fourButtonView.y+5, size_width, 130)];
    
    NSDate * senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString * morelocationString=[dateformatter stringFromDate:senddate];
    NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"]];

    
    if (cookies.count) {
        LoginDataModel *model = [UserDefault getUserInfo];
        NSDictionary *dic = model.keyValues;
        
        [_countView.count setFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:30]];
        _countView.count.textColor = [UIColor orangeColor];
        
        NSNotification *notification = [NSNotification notificationWithName:@"Login" object:nil userInfo:dic];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        
    }
    
    
    _countView.timeLab.text = morelocationString;
    
    
    
    
    
    [headerView addSubview:_countView];
    
    //点击按钮回调
    _countView.buttonLookClick =^(NSString *string){
        if ([string isEqualToString:@"success"]) {
            NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"]];
            
            if (cookies.count) {
                
                WebViewController *webVC = [[WebViewController alloc]init];
                
                webVC.isUIWebView = YES;
                
                webVC.hidesBottomBarWhenPushed = YES;
               
                
                webVC.title = @"助力值纪录";
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

        }
    };
    
    
}




//加载数据
-(void)loadData{
    NSDictionary *parmDic = @{@"exec":@"recommendarticle",@"p":@(self.pageCount)};
    
    [NetworkManger requestPOSTWithURLStr:URL_WriteBook parmDic:parmDic finish:^(id responseObject) {
        
        self.dataSource = [NSMutableDictionary dictionaryWithDictionary:responseObject];
        
        
        self.dataSourceArray = self.dataSource[@"Data"];
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        
    }];
    
    OpenGoodsService *service = [[YZSDK sharedInstance] getService:@protocol(OpenGoodsServiceProtocol)];

    [service getGoodsItemsFields:@"title,price,pic_url,num,detail_url,origin_price" search:nil goodsState: YZGoodsOnSaleState  tagId:@"95358910" pageNO:@"0" pageSize:@"6" orderByWay: YZGOodsORderByCreateDescWay callback:^(NSDictionary *response, NSError *error) {
        if (!error) {
            self.juanDataSource = [NSMutableDictionary dictionaryWithDictionary:response[@"response"]];
            NSMutableArray *array1 = [NSMutableArray array];
            array1 = self.juanDataSource[@"items"];
            //屏幕适配
            int viewHeihgt;
            viewHeihgt=755+size_height;
            
            UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size_width, viewHeihgt)];
            
            self.tableView.tableFooterView = footerView;
            
            footerView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
            if (array1.count<6) {
                [service getGoodsItemsFields:@"title,price,pic_url,num,detail_url,origin_price" search:nil goodsState:YZGoodsSoldOutState  tagId:@"95358910" pageNO:@"0" pageSize:@"6" orderByWay: YZGOodsORderByCreateDescWay callback:^(NSDictionary *response, NSError *error) {
                    if (!error) {
                        NSDictionary *dic =[NSDictionary dictionaryWithDictionary:response[@"response"]];
                        NSArray *arr = [NSArray arrayWithArray:dic[@"items"]];
                        
                        NSMutableArray *array2 = [NSMutableArray array];
                        array2 =[NSMutableArray arrayWithArray:self.juanDataSource[@"items"]];
                        
                        for (NSDictionary *dict in arr) {
                            [array2 addObject:dict];
                        }
                        
                        self.tabFoterView = [[TabFooterView alloc]initWithFrame:CGRectMake(0, 0, size_width, viewHeihgt-size_height) withDataSourceArray:array2];
                        [footerView addSubview:_tabFoterView];
                        [self xuanZheQiWithArr:array2];
                        [self umMessageWith:footerView];
                    }
                    
                    
                }];
            }else{
                self.tabFoterView = [[TabFooterView alloc]initWithFrame:CGRectMake(0, 0, size_width, viewHeihgt-size_height) withDataSourceArray:array1];
                [footerView addSubview:_tabFoterView];
                [self xuanZheQiWithArr:array1];
                
                [self umMessageWith:footerView];
                
            }
            
    }
    }];
}

-(void)xuanZheQiWithArr:(NSMutableArray *)sarr{
     __weak HomePageViewController *weakSelf = self;
    __block NSArray *arr = [NSArray arrayWithArray:sarr];
    _tabFoterView.buttonJuanClick = ^(NSInteger tag){
        MyWKWebViewController *tickVC = [[MyWKWebViewController alloc]init];
        tickVC.hidesBottomBarWhenPushed = YES;
        tickVC.title = @"每日特惠";
        if (tag==800) {
            
            NSDictionary *dict = arr[0];
            //tickVC.loadUrl = nil;
            tickVC.loadUrl = dict[@"detail_url"];
            
            [weakSelf.navigationController pushViewController:tickVC animated:YES];
            
            
            
        }else if (tag==801){
            
            NSDictionary *dict1 = arr[1];
            //tickVC.loadUrl = nil;
            tickVC.loadUrl = dict1[@"detail_url"];
            [weakSelf.navigationController pushViewController:tickVC animated:YES];
            
        }else if (tag==802){
            
            NSDictionary *dict2 = arr[2];
            //tickVC.loadUrl = nil;
            tickVC.loadUrl = dict2[@"detail_url"];
            [weakSelf.navigationController pushViewController:tickVC animated:YES];
        }else if (tag==803){
            
            NSDictionary *dict3 = arr[3];
            //tickVC.loadUrl = nil;
            tickVC.loadUrl = dict3[@"detail_url"];
            [weakSelf.navigationController pushViewController:tickVC animated:YES];
        }else if(tag==804){
            
            NSDictionary *dict4 = arr[4];
            //tickVC.loadUrl = nil;
            tickVC.loadUrl = dict4[@"detail_url"];
            [weakSelf.navigationController pushViewController:tickVC animated:YES];
        }else if (tag==805){
            
            NSDictionary *dict5 = arr[5];
            //tickVC.loadUrl = nil;
            tickVC.loadUrl = dict5[@"detail_url"];
            [weakSelf.navigationController pushViewController:tickVC animated:YES];
        }else{
            //weakSelf.tabBarController.selectedIndex=2;
            //                    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            //                    LikesViewController *tabBarController = [storyBoard instantiateViewControllerWithIdentifier:@"LikesViewController"];
            //                    tabBarController.hidesBottomBarWhenPushed = YES;
            //
            //                    [weakSelf.navigationController pushViewController:tabBarController animated:YES];
           // tickVC.loadUrl = nil;
            tickVC.loadUrl = @"https://h5.youzan.com/v2/tag/19cwk6yup";
            [weakSelf.navigationController pushViewController:tickVC animated:YES];
        
        
        
        }
        
        
        
    };

}


-(void)umMessageWith:(UIView *)fatherView{
    __weak HomePageViewController *weakSelf = self;
    self.umDoorView = [[UMTabHeaderView alloc]initWithFrame:CGRectMake(0, _tabFoterView.y+_tabFoterView.height+5, size_width, 40)];
    
    _umDoorView.TimeRequestLab.text = @"最新动态";
    [_umDoorView.shuoshuoBtn setTitle:@"+发布动态／提问" forState: UIControlStateNormal];
    NSNotification *notification2 = [NSNotification notificationWithName:kUMComUnreadNotificationRefreshNotification object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification2];
    
    
    _umDoorView.buttonHeaderClick = ^(NSString *string){
        
        if ([string isEqualToString:@"success"]) {
            NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"]];
            
            if (cookies.count) {
                UMComEditViewController *editViewController = [[UMComEditViewController alloc] init];
                
                UMComNavigationController *editNaviController = [[UMComNavigationController alloc] initWithRootViewController:editViewController];
                [weakSelf presentViewController:editNaviController animated:YES completion:nil];
                
            }else{
                LoginViewController *logVC = [[LoginViewController alloc]init];
                
                [logVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
                
                [weakSelf presentViewController:logVC animated:YES completion:nil];
            }
        }
        
        if ([string isEqualToString:@"分类按钮"]) {
            JSBadgeView *bageView =  [weakSelf.umDoorView viewWithTag:9999];
            if (bageView.badgeText) {
                UMComNoticeSystemViewController *userNewaNoticeViewController = [[UMComNoticeSystemViewController alloc] init];
                userNewaNoticeViewController.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController  pushViewController:userNewaNoticeViewController animated:YES];
            }else{
                //弹出视图
                UMComDiscoverViewController *discover = [[UMComDiscoverViewController alloc]init];
                discover.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:discover animated:YES];
                
            }
            }
        
        if ([string isEqualToString:@"消息刷新"]) {
            [weakSelf.realTimeFeedsViewController refreshNewDataFromServer:nil];
        }
        
        
    };
    [fatherView addSubview:_umDoorView];
    dispatch_async(dispatch_queue_create("cjxb", DISPATCH_QUEUE_CONCURRENT), ^{
        self.realTimeFeedsViewController = [[UMComFeedTableViewController alloc] init];
        
        _realTimeFeedsViewController.isLoadLoacalData = NO;
        _realTimeFeedsViewController.isAutoStartLoadData = YES;
        _realTimeFeedsViewController.fetchRequest = [[UMComAllNewFeedsRequest alloc]initWithCount:5];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _realTimeFeedsViewController.tableView.frame = CGRectMake(0, _umDoorView.y+_umDoorView.height, size_width, size_height-50);
            [self addChildViewController:_realTimeFeedsViewController];
            
            [fatherView addSubview:_realTimeFeedsViewController.tableView];
        });
    });

}



#pragma mark - tableView 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *dic = self.dataSourceArray[indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    
    
    cell.imageView.image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"热点"]];
    
    cell.textLabel.text = dic[@"title"];
    // 添加右侧尖头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //取消点击效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TabHeaderView *tabheaderView = [[TabHeaderView alloc]initWithFrame:CGRectMake(0, 0, size_width, 30)];
    __weak HomePageViewController *weakSelf = self;
    tabheaderView.buttonHeaderClick = ^(NSString *string){
        if ([string isEqualToString:@"success"]) {
            
            
            weakSelf.pageCount++;
            
            [weakSelf netWorkTableViewCell:weakSelf.pageCount];
            
            
        }
    };
    
    return tabheaderView;
    
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    
    if (!error) {
        [HomePageViewController showAlertMessageWithMessage:@"保存成功" duration:1.0];
        
    }else{
        [HomePageViewController showAlertMessageWithMessage:@"保存失败" duration:1.0];
        
    }
}



//点击cell触发的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WebViewController *webVC = [[WebViewController alloc]init];
    webVC.hidesBottomBarWhenPushed = YES;
    webVC.shareHiddnBtn = YES;
    NSDictionary *dict =self.dataSourceArray[indexPath.row];
    
     webVC.webView = [[IMYWebView alloc]initWithFrame:CGRectMake(0, 0, size_width, size_height-64-44-6)];
    NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"]];
    
    
    
    [webVC.view addSubview:webVC.webView];
    
    [webVC.view sendSubviewToBack:webVC.webView];

    LoginDataModel *model = [UserDefault getUserInfo];
    NSString *string5 = [NSString stringWithFormat:@"http://x.xiaobang520.com/article/show.aspx?articleid=%@&userid=%@",dict[@"id"],model.myid];
    
    NSURL *url1 = [[NSURL alloc]initWithString:string5];
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookieStorage setCookies:cookies forURL:url1 mainDocumentURL:nil];
    NSMutableString *cookieString = [[NSMutableString alloc] init];
    
    if (cookies.count) {
        
        NSHTTPCookie *currentCookie= [[NSHTTPCookie alloc] init];
        
        for (NSHTTPCookie*cookie in [cookieStorage cookies]) {
            //kDLOG(@"cookie:%@", cookie);
            currentCookie = cookie;
            //多个字段之间用“；”隔开
            [cookieString appendFormat:@"%@=%@;",cookie.name,cookie.value];
            
            
        }
        //删除最后一个“；”
        [cookieString deleteCharactersInRange:NSMakeRange(cookieString.length - 1, 1)];
    }
    
    //[webVC.webView setMediaPlaybackRequiresUserAction:NO];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url1];
    if (cookies.count) {
        
        NSString *cookie = [NSString stringWithFormat:@"%@",cookieString];
        
        [request addValue:cookie forHTTPHeaderField:@"Cookie"];
    }
    
    [webVC.webView loadRequest:request];
    
    webVC.titleLab = dict[@"title"];
    webVC.titleImg = [UIImage imageNamed:@"share.png"];
    
    webVC.articleId = dict[@"id"];
    
    webVC.qiandao = @"YES";
    
    [self.navigationController pushViewController:webVC animated:YES];
    
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (size_width<=320) {
        return 40;
        
    }else if(size_width==375){
        return 50;
    }else{
        return 60;
    }

    
    
}



-(void)netWorkTableViewCell:(NSInteger)count{
    NSDictionary *parmDic = @{@"exec":@"recommendarticle",@"p":@(count)};
    
    [NetworkManger requestPOSTWithURLStr:URL_WriteBook parmDic:parmDic finish:^(id responseObject) {
        
        self.dataSource = [NSMutableDictionary dictionaryWithDictionary:responseObject];
        
        
        self.dataSourceArray = self.dataSource[@"Data"];
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        
    }];
    

}

#pragma mark - 轮播图代理
//点击轮播图跳转回调
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    NSDictionary *dic = self.cycleScrollViewDataArray[index];
    WebViewController *webVC = [[WebViewController alloc]init];
    
    webVC.hidesBottomBarWhenPushed = YES;
    NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"]];

    LoginDataModel *model = [UserDefault getUserInfo];
    
    NSString *string5 = nil;
    
    if (![dic[@"jumpurl"] isKindOfClass:[NSNull class]]){
        
        if ([dic[@"jumpurl"] rangeOfString:@"DuiHuanListByUI"].location !=NSNotFound) {
            webVC.webView = [[IMYWebView alloc]initWithFrame:CGRectMake(0, 0, size_width, size_height-64) usingUIWebView:YES];
            webVC.isUIWebView =YES;
            webVC.shareHiddnBtn = YES;
            [webVC.view addSubview:webVC.webView];
            
            string5 = [NSString stringWithFormat:lipinDuiHuanURL,model.myid];
            webVC.title = @"兑换礼品";
            
            webVC.qiandao = @"YES";
            
        }else if([dic[@"jumpurl"] rangeOfString:@"youzan"].location !=NSNotFound){
            MyWKWebViewController *webVC = [[MyWKWebViewController alloc]init];
            webVC.loadUrl = dic[@"jumpurl"];
            webVC.title = @"小帮特别推荐";
            webVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVC animated:YES];
            return;
         //判断是否链接全是空格
        }else if([dic[@"jumpurl"] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]].length==0){
            
            webVC.shareHiddnBtn = YES;
            webVC.webView = [[IMYWebView alloc]initWithFrame:CGRectMake(0, 0, size_width, size_height-64-44)];
            
            [webVC.view addSubview:webVC.webView];
            
            [webVC.view sendSubviewToBack:webVC.webView];
            
            string5 = [NSString stringWithFormat:@"http://x.xiaobang520.com/article/show.aspx?articleid=%@&userid=%@",dic[@"id"],model.myid];
            
            webVC.qiandao = @"YES";
            
        }else if ([dic[@"jumpurl"] rangeOfString:@"xiaobang520"].location !=NSNotFound){
                
            webVC.shareHiddnBtn = YES;
            webVC.webView = [[IMYWebView alloc]initWithFrame:CGRectMake(0, 0, size_width, size_height-64-44)];
            
            [webVC.view addSubview:webVC.webView];
            
            [webVC.view sendSubviewToBack:webVC.webView];
                
                string5 = [NSString stringWithFormat:@"http://x.xiaobang520.com/article/show.aspx?articleid=%@&userid=%@",dic[@"id"],model.myid];
                
                webVC.qiandao = @"YES";
        }else{
            UMComWebViewController * webViewController = [[UMComWebViewController alloc] initWithUrl:dic[@"jumpurl"]];
            //使用系统的返回按钮
            webViewController.isPushWebView = YES;
            webViewController.hidesBottomBarWhenPushed  =YES;
            [self.navigationController pushViewController:webViewController animated:YES];
            return;

        }
        webVC.title = @"最新活动";
        
    }else{
        webVC.shareHiddnBtn = YES;
        webVC.webView = [[IMYWebView alloc]initWithFrame:CGRectMake(0, 0, size_width, size_height-64-44)];
        
        [webVC.view addSubview:webVC.webView];
        
        [webVC.view sendSubviewToBack:webVC.webView];

        string5 = [NSString stringWithFormat:@"http://x.xiaobang520.com/article/show.aspx?articleid=%@&userid=%@",dic[@"id"],model.myid];
        
        webVC.qiandao = @"YES";
        
    }
    
    
    NSURL *url1 = [[NSURL alloc]initWithString:string5];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url1];
    if (![webVC.webView usingUIWebView]) {
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        [cookieStorage setCookies:cookies forURL:url1 mainDocumentURL:nil];
        
        NSMutableString *cookieString = [[NSMutableString alloc] init];
       
        if (cookies.count) {
            
            NSHTTPCookie *currentCookie= [[NSHTTPCookie alloc] init];
            
            for (NSHTTPCookie*cookie in [cookieStorage cookies]) {
                //kDLOG(@"cookie:%@", cookie);
                currentCookie = cookie;
                //多个字段之间用“；”隔开
                [cookieString appendFormat:@"%@=%@;",cookie.name,cookie.value];
                
                
            }
            //删除最后一个“；”
            [cookieString deleteCharactersInRange:NSMakeRange(cookieString.length - 1, 1)];
            
            NSString *cookie = [NSString stringWithFormat:@"%@",cookieString];
            
            [request addValue:cookie forHTTPHeaderField:@"Cookie"];
        }

    }
    
    
    
    [webVC.webView loadRequest:request];
    
   
    
    
    
    webVC.articleId = dic[@"id"];
    webVC.titleLab = dic[@"title"];
    
    UIImageView *imgView = [[UIImageView alloc]init];
    
    [imgView sd_setImageWithURL:dic[@"img"]];
    
    webVC.titleImg =imgView.image;
    [self.navigationController pushViewController:webVC animated:YES];
    
}


#pragma mark - UIScrollView代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.old_contentOfset = scrollView.contentOffset.y;
    //定义区头高度
    CGFloat sectionHeaderHeight = 40;
    //scrollView没有离开屏幕的时候,设置scrollView的内容视图的inset为scrollView的偏移量
    if (scrollView.contentOffset.y<=sectionHeaderHeight &&scrollView.contentOffset.y>-64) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }else if (scrollView.contentOffset.y>=sectionHeaderHeight){
        //当scrollview的偏移量大于区头高度时.改变区头的内容视图的inset为下面  使headerView的悬停位置改变为屏幕上方
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        
    }
    if (scrollView.contentOffset.y>=self.tableView.tableFooterView.y+self.tableView.tableFooterView.height-size_height-64) {
            
            self.realTimeFeedsViewController.tableView.scrollEnabled = YES;
        }else{
           self.realTimeFeedsViewController.tableView.scrollEnabled =NO;
            
        }
    
    scrollView.bounces = (scrollView.contentOffset.y >= size_height) ? NO : YES;
}

-(void)dealloc{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:kUMComUnreadNotificationRefreshNotification object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Login" object:nil];
    
        
    [self.tableView removeJElasticPullToRefreshView];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
