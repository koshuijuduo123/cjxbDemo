//
//  TickentInFoViewController.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/31.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "TickentInFoViewController.h"
#import "NetworkManger.h"
#import "HeaderHeView.h"
#import "TwoHeView.h"
#import "ThreeHesView.h"
#import "FourWebView.h"
#import "MapModel.h"
#import "UserDefault.h"
#import "MJExtension.h"
#import "MapDefaults.h"
#import "MyDianJuanViewcontrollerViewController.h"
#import <MapKit/MapKit.h>
@interface TickentInFoViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *conreView;

@property(nonatomic,strong)NSMutableArray *dataSourceArray;//cell数据源

@property(nonatomic,strong)NSMutableDictionary *dataSourceDic; //数据字典

@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)UIWebView *webView1;

@property(nonatomic,assign)BOOL isDown;//是否点击了按钮，默认NO

@property(nonatomic,strong)NSMutableDictionary *htmlDic;

@property(nonatomic,strong)FourWebView *bigView;



//地理编码
@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation TickentInFoViewController


//#warning geocoder懒加载
-(CLGeocoder *)geocoder
{
    if (_geocoder==nil) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}



//创建一个UIWebView来加载URL，拨完后能自动回到原应用

-(UIWebView *)webView{
    if (_webView == nil) {
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        
    }
    return _webView;
}

-(NSMutableDictionary *)htmlDic{
    if (!_htmlDic) {
        self.htmlDic = [NSMutableDictionary dictionary];
    }
    return _htmlDic;
}

-(NSMutableDictionary *)dataSourceDic{
    if (!_dataSourceDic) {
        self.dataSourceDic = [NSMutableDictionary dictionary];
    }
    return _dataSourceDic;
}


-(NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        self.dataSourceArray = [NSMutableArray array];
    }

    return _dataSourceArray;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent  = YES;
    if (self.isDown==YES) {
        //获取网页中的积分值
        NSString *pointStr = [self.webView1 stringByEvaluatingJavaScriptFromString:@"document.getElementById('totalpointsnum').innerHTML"];
        LoginDataModel *model =[UserDefault getUserInfo];
        
        model.points = pointStr;
        
        [UserDefault saveUserInfo:model];
        
        NSDictionary *dic = model.keyValues;
        NSNotification *notification = [NSNotification notificationWithName:@"Login" object:nil userInfo:dic];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        
    }
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    //调整取消毛玻璃时，视图下移问题
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"电子劵详情";
    
    [self loadData];
    
    
    self.isDown = NO;
    //滑动时隐藏导航栏
    //self.navigationController.hidesBarsOnSwipe = YES;
    
}

-(void)loadData{
    //显示加载圈
    [self showHUDWith:@"小帮加载中...."];
    NSDictionary *parmDic = [NSDictionary dictionary];
    if ([self.MyTick isEqualToString:@"my"]) {
        parmDic = @{@"exec":@"getmycoupon",@"id":self.tickid};
        
    }else{
        
        parmDic = @{@"exec":@"getcoupon",@"couponid":self.tickid};
    }
    
    
        
        //请求数据
        [NetworkManger requestPOSTWithURLStr:URL_TIckInfo parmDic:parmDic finish:^(id responseObject) {
            //隐藏加载圈
            [self hidenHUD];
            self.conreView.hidden = YES;
            //cell数据源
            self.dataSourceArray = responseObject[@"Data"];
            
            self.dataSourceDic = self.dataSourceArray[0];
            
            [self loadSubViews];
            
        } enError:^(NSError *error) {
            
        }];
    
    
}



-(void)loadSubViews{
    UIView *headerView = [[UIView alloc]init];
    if ([self.MyTick isEqualToString:@"my"]) {
        headerView.frame = CGRectMake(0, 0, size_width, 1520);
    }else{
        headerView.frame = CGRectMake(0, 0, size_width, 1420);
    }
    
    
    
    self.tableView.tableHeaderView = headerView;
    
    //#################头标题视图模块###################
    HeaderHeView *heView = [[HeaderHeView alloc]initWithFrame:CGRectMake(0, 64, size_width, 270)];
    
    heView.buttonQuClick = ^(NSString *string){
        if ([string isEqualToString:@"立即领取"]) {
            
            NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"]];
            if (cookies.count) {
                
                if ([self.MyTick isEqualToString:@"my"]) {
                    self.tickid = self.tickDic[@"couponid"];
                }
                
                NSHTTPCookieStorage * cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                for (NSHTTPCookie * cookie in cookies){
                    [cookieStorage setCookie: cookie];
                }
                [NetworkManger requestPOSTWithURLStr:URL_TIckInfo parmDic:@{@"exec":@"lingcoupon",@"couponid":self.tickid} finish:^(id responseObject) {
                    
                    if ([responseObject[@"IsError"] integerValue]==0) {
                        
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:responseObject[@"Message"] message:@"是否前往我的电子券查看" preferredStyle:(UIAlertControllerStyleAlert)];
                        
                        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                            MyDianJuanViewcontrollerViewController *myDianJuanVC = [[MyDianJuanViewcontrollerViewController alloc]init];
                            
                            [self.navigationController pushViewController:myDianJuanVC animated:YES];
                        
                        
                        }];
                        
                        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
                        
                        [alert addAction:action1];
                        [alert addAction:action2];
                        [self presentViewController:alert animated:YES completion:nil];
                        
                        
                        
                    }else{
                        
                        [TickentInFoViewController showAlertMessageWithMessage:responseObject[@"Message"] duration:2.0];
                    }
                    
                    
                    
                    
                } enError:^(NSError *error) {
                    
                }];
                
                self.webView1 = [[UIWebView alloc]init];
                
                
                NSString *string5 = [NSString stringWithFormat:@"http://x.xiaobang520.com/com/qiandao.aspx"];
                
                NSURL *url1 = [[NSURL alloc]initWithString:string5];
                
                
                
                [cookieStorage setCookies:cookies forURL:url1 mainDocumentURL:nil];
                
                
                
                NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url1];
                
                self.isDown = YES;
                
                [_webView1 loadRequest:request];
                
                
               
                
                
            }else{
                [TickentInFoViewController showAlertMessageWithMessage:@"加入小帮后可领取" duration:1.0];
                
            }
            
            
            
            
            
        }else{
            //NSLog(@"已经领完了");
        }
    };
    
    if ([self.MyTick isEqualToString:@"my"]) {
        [heView.titleImageView sd_setImageWithURL:self.dataSourceDic[@"bimg"] placeholderImage:[UIImage imageNamed:@"zwt"]];
    }else{
        
       // NSLog(@"%@",self.dataSourceDic);
        [heView.titleImageView sd_setImageWithURL:self.dataSourceDic[@"img"] placeholderImage:[UIImage imageNamed:@"zwt"]];
    }
    
    
    
    NSString *string1;
    if ([self.MyTick isEqualToString:@"my"]) {
        string1 = [NSString stringWithFormat:@"%@",self.dataSourceDic[@"discount"]];
        if ([string1 isEqualToString:@"0"]){
            if ([self.MyTick isEqualToString:@"my"]) {
                heView.countLab.text =[NSString stringWithFormat:@"%@元",self.tickDic[@"marketvalue"]];
            }else{
                
                heView.countLab.text =[NSString stringWithFormat:@"%@元",self.dataSourceDic[@"marketvalue"]];
            }
            
            
            heView.systemLab.text = @"优惠券";
            
        }else{
            NSString *string = [NSString stringWithFormat:@"%@折",self.dataSourceDic[@"discount"]];
            
            if (string.length>4) {
                NSString *string1 = [string substringWithRange:NSMakeRange(2,1)];
                NSString *string2 = [string substringWithRange:NSMakeRange(3, 2)];
                
                heView.countLab.text = [NSString stringWithFormat:@"%@.%@",string1,string2];
                
            }else{
                heView.countLab.text = [string substringWithRange:NSMakeRange(2,2)];
            }
            
            heView.systemLab.text = @"折扣劵";
        }
        
        if ([self.MyTick isEqualToString:@"my"]) {
            heView.jfLab.text =[NSString stringWithFormat:@"%@分(兑)",self.tickDic[@"usepoint"]];
        }else{
            heView.jfLab.text = [NSString stringWithFormat:@"%@分(兑)",self.dataSourceDic[@"usepoint"]];
            
        }
        
        
    }else{
        
        string1 = [NSString stringWithFormat:@"%@",self.dataSourceDic[@"type"]];
        if ([string1 isEqualToString:@"0"]){
            if ([self.MyTick isEqualToString:@"my"]) {
                heView.countLab.text =[NSString stringWithFormat:@"%@元",self.tickDic[@"marketvalue"]];
            }else{
                
                heView.countLab.text =[NSString stringWithFormat:@"%@元",self.dataSourceDic[@"marketvalue"]];
            }
            
            
            heView.systemLab.text = @"现金券";
            
        }else if ([string1 isEqualToString:@"2"]){
            
            if ([self.MyTick isEqualToString:@"my"]) {
                heView.countLab.text =[NSString stringWithFormat:@"%@元",self.tickDic[@"marketvalue"]];
            }else{
                
                heView.countLab.text =[NSString stringWithFormat:@"%@元",self.dataSourceDic[@"marketvalue"]];
            }
            
            heView.systemLab.text = @"实物券";
            
            
        }else{
            NSString *string = [NSString stringWithFormat:@"%@折",self.dataSourceDic[@"discount"]];
            
            if (string.length>4) {
                NSString *string1 = [string substringWithRange:NSMakeRange(2,1)];
                NSString *string2 = [string substringWithRange:NSMakeRange(3, 2)];
                
                heView.countLab.text = [NSString stringWithFormat:@"%@.%@",string1,string2];
                
            }else{
                heView.countLab.text = [string substringWithRange:NSMakeRange(2,2)];
            }
            
            heView.systemLab.text = @"折扣劵";
        }
        
        if ([self.MyTick isEqualToString:@"my"]) {
            heView.jfLab.text =[NSString stringWithFormat:@"%@分(兑)",self.tickDic[@"usepoint"]];
        }else{
            heView.jfLab.text = [NSString stringWithFormat:@"%@分(兑)",self.dataSourceDic[@"usepoint"]];
            
        }
    }
    
    
    
    //得到当前系统日期
    NSDate * senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    //NSString * locationString=[dateformatter stringFromDate:senddate];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString * morelocationString=[dateformatter stringFromDate:senddate];
    //NSLog(@"这个时间%@",morelocationString);
    
    if ([self.MyTick isEqualToString:@"my"]) {
        if ([self.tickDic[@"sycount"] integerValue]==0||[morelocationString compare:self.dataSourceDic[@"endtime"]]==NSOrderedDescending) {
            
            [heView.quButton setTitle:@"无法领取" forState:(UIControlStateNormal)];
            heView.quButton.backgroundColor = [UIColor darkGrayColor];
            
        }else{
            [heView.quButton setTitle:@"无法领取" forState:(UIControlStateNormal)];
            heView.quButton.backgroundColor = [UIColor orangeColor];
        }
 
    }else{
        if ([self.dataSourceDic[@"sycount"] integerValue]==0||[morelocationString compare:self.dataSourceDic[@"endtime"]]==NSOrderedDescending) {
            
            [heView.quButton setTitle:@"无法领取" forState:(UIControlStateNormal)];
            heView.quButton.backgroundColor = [UIColor darkGrayColor];
            
        }else{
            [heView.quButton setTitle:@"无法领取" forState:(UIControlStateNormal)];
            heView.quButton.backgroundColor = [UIColor orangeColor];
        }
        
        
    }
    
    
    
    
    
    
    heView.nameLab.text = self.dataSourceDic[@"name"];
    
    
    
    
    
    [headerView addSubview:heView];
    
    
    //################第二模块###################
    TwoHeView *twoView = [[TwoHeView alloc]initWithFrame:CGRectMake(0, heView.y+heView.height+5, size_width, 60)];
    
    if ([self.MyTick isEqualToString:@"my"]) {
        NSInteger count = [self.tickDic[@"count"] integerValue];
        
        NSInteger sycount = [self.tickDic[@"sycount"] integerValue];
        
        NSInteger ycount = count - sycount;
        
        
        
        twoView.leftLab.text = [NSString stringWithFormat:@"已领取%ld个,还剩%ld个",(long)ycount,(long)sycount];
    }else{
        
        NSInteger count = [self.dataSourceDic[@"count"] integerValue];
        
        NSInteger sycount = [self.dataSourceDic[@"sycount"] integerValue];
        
        NSInteger ycount = count - sycount;
        
        
        
        twoView.leftLab.text = [NSString stringWithFormat:@"已领取%ld个,还剩%ld个",(long)ycount,(long)sycount];
    }
    
    
    
    if ([self.MyTick isEqualToString:@"my"]) {
        twoView.rightLab.text = [NSString stringWithFormat:@"领取后,请在%@前使用",self.tickDic[@"endtime"]];
    }else{
        twoView.rightLab.text = [NSString stringWithFormat:@"领取后,请在%@日内使用",self.dataSourceDic[@"validdays"]];
        
    }
    
    
    
    
    [headerView addSubview:twoView];
    
    
    
    //################第三模块##################
    ThreeHesView *threeView = [[ThreeHesView alloc]initWithFrame:CGRectMake(0, twoView.y+twoView.height+5, size_width, 170)];
    
    threeView.nameLabel.text = self.dataSourceDic[@"bname"];
    threeView.address.text = self.dataSourceDic[@"baddress"];
    
    
    
    threeView.metsLab.text = @"";
    
    threeView.ppx = self.dataSourceDic[@"poinx"];
    threeView.ppy = self.dataSourceDic[@"poiny"];
    
    
    if ([self.MyTick isEqualToString:@"my"]) {
        threeView.BiaotiLab.text = @"点击使用该劵";
    }
    
   
    __weak TickentInFoViewController *weakSelf = self;
    
    threeView.buttonPhonClick = ^(NSDictionary *dic){
      
        
            //拨打电话
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",dic[@"phone"]]];
            [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:url]];
            [weakSelf.view addSubview:weakSelf.webView];
            
    };
    
    
    NSData *data = [self.dataSourceDic[@"phone"] dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *gotoDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    threeView.phoneArr = [NSMutableArray arrayWithArray:gotoDic];
    
   
   // __weak TickentInFoViewController *weakSelf = self;

    threeView.buttonMapClick = ^(NSString *address){
        [weakSelf showHUDWith:@"地图导航中..."];
       // MapViewController *mapVC= [[MapViewController alloc]init];
       // mapVC.px = [strx integerValue];
        //mapVC.py = [stry integerValue];
        
        //MapModel *model = [[MapModel alloc]init];
        
        NSString *xaddress = [[MapDefaults standInstance] sentDataWith];
        
        NSString *yaddress = [NSString stringWithFormat:@"中国河南省新乡市%@",address];
        
        
        //通过经纬度，封装了一个CLLoction对象
        //CLLocation *loction = [[CLLocation alloc]initWithLatitude:pointx longitude:pointy];
        //CLLocation *loction2 = [[CLLocation alloc]initWithLatitude:[strx doubleValue] longitude:[stry doubleValue]];
        [weakSelf.geocoder geocodeAddressString:xaddress  completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            CLPlacemark *starPlacemark = [placemarks firstObject];
            
            
            [weakSelf.geocoder geocodeAddressString:yaddress  completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                CLPlacemark *endPlacemark = [placemarks firstObject];
                
                //获得地标后开始导航
                [weakSelf startNavigationWithStartPlacemark:starPlacemark endPlacemark:endPlacemark];
                
            }];
        }];
        
    };
    
    
    
    
    
    
    
    [headerView addSubview:threeView];


    //################第四模块#######################
    if ([self.MyTick isEqualToString:@"my"]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(5, threeView.y+threeView.height+5, size_width-10, 40);
        button.tag = 1000;
        if (self.isUse==NO) {
            button.backgroundColor = [UIColor darkGrayColor];
            button.userInteractionEnabled = NO;
        }else{
            button.backgroundColor = [UIColor greenColor];
            button.userInteractionEnabled = YES;
        }
        
        
        button.tintColor = [UIColor whiteColor];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.isUse==NO) {
            [button setTitle:@"已失效" forState: UIControlStateNormal];
        }else{
            
            [button setTitle:@"点击使用" forState: UIControlStateNormal];
        }
        
        
        
        [headerView addSubview:button];
        
        NSString *str1 = self.dataSourceDic[@"couponid"];
        [NetworkManger requestPOSTWithURLStr:URL_TIckInfo parmDic:@{@"exec":@"getcoupon",@"couponid":str1} finish:^(id responseObject) {
            
            //cell数据源
            NSArray *arr = [NSArray arrayWithArray:responseObject[@"Data"]];
            self.htmlDic =[NSMutableDictionary dictionaryWithDictionary:arr[0]];
            
            
            self.bigView = [[FourWebView alloc]init];
            
            
            _bigView.webView.scalesPageToFit = NO;
            
            _bigView.webView.delegate = self;
            
            _bigView.webView.scrollView.bounces = NO;
            
            NSString *string4 = nil;
            string4 = [NSString stringWithFormat:@"http://x.xiaobang520.com/coupon/couponshandler.ashx?exec=getcoupon&couponid=%@",str1];
            
            NSURL *url1 = [[NSURL alloc]initWithString:string4];
            [_bigView.webView loadHTMLString:self.htmlDic[@"introduce"] baseURL:url1];
        
            
        } enError:^(NSError *error) {
            
        }];

        
        
        
        return;
    }

    
    self.bigView = [[FourWebView alloc]init];
    
    //webView是否自适应屏幕，YES是适应
    _bigView.webView.scalesPageToFit = NO;
    
    _bigView.webView.delegate = self;
    
    _bigView.webView.scrollView.bounces = NO;
    
    NSString *string4 = nil;
    
    
        
    string4 = [NSString stringWithFormat:@"http://x.xiaobang520.com/coupon/couponshandler.ashx?exec=getcoupon&couponid=%@",self.tickid];
    
    
    
    
    NSURL *url1 = [[NSURL alloc]initWithString:string4];
    
    [_bigView.webView loadHTMLString:self.dataSourceDic[@"introduce"] baseURL:url1];
        
    //[headerView addSubview:bigView];
    
    
    
    
}


-(void)startNavigationWithStartPlacemark:(CLPlacemark *)startPlacemark endPlacemark:(CLPlacemark*)endPlacemark
{
    //0,创建起点
    MKPlacemark * startMKPlacemark = [[MKPlacemark alloc]initWithPlacemark:startPlacemark];
    //0,创建终点
    MKPlacemark * endMKPlacemark = [[MKPlacemark alloc]initWithPlacemark:endPlacemark];
    
    //1,设置起点位置
    MKMapItem * startItem = [[MKMapItem alloc]initWithPlacemark:startMKPlacemark];
    //2,设置终点位置
    MKMapItem * endItem = [[MKMapItem alloc]initWithPlacemark:endMKPlacemark];
    //3,起点,终点数组
    NSArray * items = @[ startItem ,endItem];
    
    //4,设置地图的附加参数,是个字典
    NSMutableDictionary * dictM = [NSMutableDictionary dictionary];
    //导航模式(驾车,步行)
    dictM[MKLaunchOptionsDirectionsModeKey] = MKLaunchOptionsDirectionsModeDriving;
    //地图显示的模式
    dictM[MKLaunchOptionsMapTypeKey] = MKMapTypeStandard;
    
    
    //只要调用MKMapItem的open方法,就可以调用系统自带地图的导航
    //Items:告诉系统地图从哪到哪
    //launchOptions:启动地图APP参数(导航的模式/是否需要先交通状况/地图的模式/..)
    
    [MKMapItem openMapsWithItems:items launchOptions:dictM];
    [self hidenHUD];
}






-(void)buttonAction:(UIButton *)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请商家输入验证密码" preferredStyle:(UIAlertControllerStyleAlert)];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        //输入框传值
        NSString *string = [alert.textFields firstObject].text;
        
        [NetworkManger requestPOSTWithURLStr:@"http://x.xiaobang520.com/coupon/couponshandler.ashx" parmDic:@{@"exec":@"usecoupon",@"username":[UserDefault getUserInfo].username,@"password":[UserDefault getUserInfo].password,@"id":self.tickid,@"code":string} finish:^(id responseObject) {
            
            [TickentInFoViewController showAlertMessageWithMessage:responseObject[@"Message"] duration:2.0];
            //使用成功
            if ([responseObject[@"IsError"] integerValue]==0) {
                
                
                UIButton *button = [self.tableView.tableHeaderView viewWithTag:1000];
                button.backgroundColor = [UIColor darkGrayColor];
                button.userInteractionEnabled = NO;
                [button setTitle:@"已失效" forState: UIControlStateNormal];
                
            }
            
            
        } enError:^(NSError *error) {
            
        }];
        
        
        
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
    

    
    
    
}

#pragma mark - UIWebView代理
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    CGFloat
    
    webViewHeight=[webView.scrollView
                   
                   contentSize].height;
    
    CGRect
    
    newFrame
    =
    webView.frame;
    
    
    
    newFrame.size.height
    
    = 
    webViewHeight*2.5;
    
    newFrame.size.width = size_width;
    
    
    webView.frame
    
    = 
    newFrame;
    if ([self.MyTick isEqualToString:@"my"]) {
        self.bigView.frame = CGRectMake(0, 640, size_width, webView.height);
        [self.tableView.tableHeaderView addSubview:self.bigView];
    }else{
        self.bigView.frame = CGRectMake(0, 580,size_width, webView.height);
        [self.tableView.tableHeaderView addSubview:self.bigView];
        
    }
    
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //判断是否是单击
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        NSURL *url = [request URL];
        if([[UIApplication sharedApplication]canOpenURL:url])
        {
            [[UIApplication sharedApplication]openURL:url];
        }
        return NO;
    }
    return YES;
}



#pragma mark - UIScrollView代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //设置webView滚动触发时机
    if ([self.MyTick isEqualToString:@"my"]) {
        if (scrollView.contentOffset.y>=700) {
            self.bigView.webView.userInteractionEnabled = YES;
        }else{
            self.bigView.webView.userInteractionEnabled = NO;
        }
        
    }else{
        if (scrollView.contentOffset.y>=600) {
            self.bigView.webView.userInteractionEnabled = YES;
        }else{
            self.bigView.webView.userInteractionEnabled = NO;
        }
 
    }
    
    
    
    
}



#pragma mark - UITableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 1;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
