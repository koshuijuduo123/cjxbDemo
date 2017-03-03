//
//  LikesViewController.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/25.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "LikesViewController.h"
#import "SetupSectionHeaderView.h"

#import "MJRefresh.h"
#import "MJRefreshGifHeader.h"
#import "NetworkManger.h"
#import "IMYWebView.h"
#import "TickectsTableViewCell.h"

#import "TickentInFoViewController.h"
#import "WebViewController.h"
#import "ChouJiangView.h"
#import "MapDefaults.h"
#import "UserDefault.h"
#include <string.h>

@interface LikesViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIWebViewDelegate,SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)UIView *backView;//展示刷选视图

@property(nonatomic,assign)BOOL flag;//标示视图是否出现，YES表示出现

@property(nonatomic,strong)UITableView *oneTableView;

@property(nonatomic,strong)UITableView *twoTableView;

@property(nonatomic,assign)BOOL isSee1;//table1是否出现；YES表示出现
@property(nonatomic,assign)BOOL isSee2;

@property(nonatomic,assign)BOOL isUp;//上拉表示YES

@property(nonatomic,strong)NSMutableDictionary *parmaDic;//参数大字典

@property(nonatomic,strong)NSMutableArray *dataSourceArray;//cell展示数据源

@property(nonatomic,strong)SetupSectionHeaderView *headerView;

@property(nonatomic,assign)CGFloat old_contentOfset;

@property(nonatomic,strong)NSMutableArray *dataArr; //参数排序数组

@property(nonatomic,strong)UIView *headersView;//tableHeaderView

@property(nonatomic,assign)BOOL isDate; //记录电子劵过期状态，yes表示过期了

@property(nonatomic,strong)NSMutableArray *refreshImages;//刷新动画的图片数组
@property(nonatomic,strong)NSMutableArray *normalImages;//普通状态下的图片数组

@property(nonatomic,assign)BOOL isRuturnView;//是否处于回收视图状态  YES表示是



@end

@implementation LikesViewController

-(NSMutableArray *)refreshImages{
    if (!_refreshImages) {
        self.refreshImages = [NSMutableArray array];
        
        for (NSUInteger i=1; i<5; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"wawago%ld",(unsigned long)i]];
            [self.refreshImages addObject:image];
        }
        
    }
    return _refreshImages;
}

-(NSMutableArray *)normalImages{
    if (!_normalImages) {
        self.normalImages = [NSMutableArray array];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"wawago0"]];
        [self.normalImages addObject:image];
    }
    return _normalImages;
}


-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
}



-(NSMutableDictionary *)parmaDic{
    if (!_parmaDic) {
        self.parmaDic = [NSMutableDictionary dictionary];
    }
    return _parmaDic;
}


-(NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        self.dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}


-(SetupSectionHeaderView *)headerView{
    if (!_headerView) {
        self.headerView = [[SetupSectionHeaderView alloc]initWithFrame:CGRectMake(0, 0, size_width, 40)];
    }
    return _headerView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    
    
}






//创建弹出的视图
-(UIView *)backView{
    
    if (_backView==nil) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size_width, size_height)];
        _backView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0];
        
        //创建4个button
        for (int i = 0; i < 4; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.showsTouchWhenHighlighted = YES;
            button.frame = CGRectMake(size_width/2, 40*i, size_width/2, 40);
            [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            button.layer.borderWidth = 1.0;
            button.backgroundColor = [UIColor whiteColor];
            button.layer.borderColor = [UIColor orangeColor].CGColor;
            
            button.layer.cornerRadius = 5.0;
            button.clipsToBounds = YES;
            [button addTarget:self action:@selector(hanleButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
            [button setTag:100+i];
            switch (i) {
                case 0:
                    [button setTitle:@"距离最近" forState:(UIControlStateNormal)];
                    break;
                case 1:
                    [button setTitle:@"折扣最低" forState:(UIControlStateNormal)];
                    break;
                case 2:
                    [button setTitle:@"人气最高" forState:(UIControlStateNormal)];
                    break;
                case 3:
                    [button setTitle:@"积分最少" forState:(UIControlStateNormal)];
                    break;
                    
                default:
                    break;
            }
            
            [_backView addSubview:button];
            
           // self.oneTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, size_width/2, size_height)];
            //_oneTableView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.8];
            
           // [self.backView addSubview:_oneTableView];
            
            
            //self.twoTableView = [[UITableView alloc]initWithFrame:CGRectMake(size_width/3, 0, size_width/3, size_height)];
            //_twoTableView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.8];
            
           // [self.backView addSubview:_twoTableView];
          //[self.view addSubview:_backView];
            
        }
        
        //创建4个button
        for (int i = 0; i < 3; i++) {
            UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
            button2.showsTouchWhenHighlighted = YES;
            button2.frame = CGRectMake(0, 40*i, size_width/2, 40);
            [button2 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            button2.layer.borderWidth = 1.0;
            button2.backgroundColor = [UIColor whiteColor];
            button2.layer.borderColor = [UIColor orangeColor].CGColor;
            
            button2.layer.cornerRadius = 5.0;
            button2.clipsToBounds = YES;
            [button2 addTarget:self action:@selector(hanleButtonAction2:) forControlEvents:(UIControlEventTouchUpInside)];
            [button2 setTag:200+i];
            switch (i) {
                case 0:
                    [button2 setTitle:@"全部分类" forState:(UIControlStateNormal)];
                    break;
                case 1:
                    [button2 setTitle:@"爱车养护" forState:(UIControlStateNormal)];
                    break;
                case 2:
                    [button2 setTitle:@"生活服务" forState:(UIControlStateNormal)];
                    break;
                    
                default:
                    break;
            }
            
            [_backView addSubview:button2];
            
            
            
        }

        [self.view addSubview:_backView];
        
        
        
        
        
        
        
        
    }
    return _backView;
}







#pragma mark - 点击button响应方法

-(void)hanleButtonAction2:(UIButton *)sender{
    NSString *titleStr = nil;
    self.isRuturnView = YES;
    switch (sender.tag) {
        case 200:
            titleStr = @"全部分类";
            [self.parmaDic setObject:@"0" forKey:@"c"];
            [self.tableView.header beginRefreshing];
            break;
        case 201:
            titleStr = @"爱车养护";
            [self.parmaDic setObject:@"18" forKey:@"c"];
            [self.tableView.header beginRefreshing];
            break;
        case 202:
            titleStr = @"生活服务";
            [self.parmaDic setObject:@"19" forKey:@"c"];
            [self.tableView.header beginRefreshing];
            break;
        default:
            break;
    }
    
    
    [self returnTheBackView];//回收视图
    
    //更新button显示
    UIButton *selectButton = [self.view viewWithTag:600];
    [selectButton setTitle:titleStr forState:(UIControlStateNormal)];
    self.isSee1 = NO;
}




-(void)hanleButtonAction:(UIButton *)sender{
    NSString *titleStr = nil;
    self.isRuturnView = YES;
    switch (sender.tag) {
        case 100:
            //NSLog(@"距离最近");
            titleStr = @"距离最近";
            [self.parmaDic setObject:@"4" forKey:@"o"];
            
            [self.tableView.header beginRefreshing];
            break;
        case 101:
        {
            //NSLog(@"折扣最低");
            //[self.parmaDic setObject:@"clevel.desc" forKey:@"o"];
            
            //NSSortDescriptor *classWithSort=[[NSSortDescriptor alloc]initWithKey:@"discount" ascending:YES];
            //NSSortDescriptor *ageWithSort=[[NSSortDescriptor alloc]initWithKey:@"marketvalue" ascending:YES];
           // NSArray *elementarr=[NSArray arrayWithObjects:ageWithSort,classWithSort, nil];
            
            [self.parmaDic setObject:@"1" forKey:@"o"];
            
           // [self.dataSourceArray sortUsingDescriptors:elementarr];
            
            
            
            titleStr = @"折扣最低";
            [self.tableView.header beginRefreshing];
            break;
        }
        case 102:
        { //NSLog(@"人气最高");
           // NSSortDescriptor *classWithSort=[[NSSortDescriptor alloc]initWithKey:@"sycount" ascending:YES];
           // NSArray *elementarr=[NSArray arrayWithObjects:classWithSort, nil];
           /// [self.dataSourceArray sortUsingDescriptors:elementarr];
           
            [self.parmaDic setObject:@"2" forKey:@"o"];
            titleStr = @"人气最高";
            

            [self.tableView.header beginRefreshing];
            
            break;
            
        }
        case 103:
        {  //NSLog(@"积分最少");
            titleStr = @"积分最少";
            //[self.parmaDic setObject:@"marketvalue" forKey:@"o"];
            
            
            
//            NSSortDescriptor *classWithSort=[[NSSortDescriptor alloc]initWithKey:@"usepoint" ascending:YES];
//            NSArray *elementarr=[NSArray arrayWithObjects:classWithSort, nil];
//            [self.dataSourceArray sortUsingDescriptors:elementarr];
            
            [self.parmaDic setObject:@"3" forKey:@"o"];
            [self.tableView.header beginRefreshing];
            break;
        }
        
        default:
            break;
    }
    [self returnTheBackView];//回收视图
    
    //更新button显示
    UIButton *selectButton = [self.view viewWithTag:602];
    [selectButton setTitle:titleStr forState:(UIControlStateNormal)];
    self.flag = NO;
    
    
}







//收回button视图
-(void)returnTheBackView{
    for (UIButton *button in self.backView.subviews) {
        [button removeFromSuperview];
    }
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.frame = CGRectMake(0, self.backView.y, size_width, 0);
    }];
    self.backView = nil;
    self.isRuturnView = YES;
}






- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    //self.tableView.frame = CGRectMake(0, -64, size_width, size_height-64);
    //将绘制的图片设置成导航栏的背景图片
    //[self.navigationController.navigationBar setBackgroundImage:[self getImageWithAlpha:1.0] forBarMetrics:UIBarMetricsDefault];
    
    //self.navigationController.navigationBar.shadowImage = [self getImageWithAlpha:1.0];
   
     
    self.isRuturnView = YES;
    
       
    self.navigationItem.title =@"优惠集锦";
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.tag = 111;
    self.oneTableView.tag = 222;
    self.twoTableView.tag = 333;
    
    //self.oneTableView.hidden = YES;
    
    //self.twoTableView.hidden = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.showsVerticalScrollIndicator = FALSE;
    self.tableView.showsHorizontalScrollIndicator = FALSE;
    
    //注册自定义cell
    [self.tableView registerNib:[UINib nibWithNibName:@"TickectsTableViewCell" bundle:nil] forCellReuseIdentifier:@"TickectsTableViewCell"];
    
    
    self.headersView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size_width, size_height*2/7)];
    
    //headerView.backgroundColor = [UIColor orangeColor];
    
    self.tableView.tableHeaderView = _headersView;
    
    self.flag = NO;
    self.isSee1 = NO;
    self.isSee2 = NO;
    
    
    [self loadData];
    
    
    
    
    
    [self addResfresh];
    
    [self loadSubVies];
    
    //self.title =@"优惠集锦";
    
    //self.isLines = NO;//默认没有经过排序
    
    
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
}

-(void)loadSubVies{
    
    SDCycleScrollView *systemVC = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, size_width, size_height*2/7) imageNamesGroup:@[@"dui",@"huiyuan"]];
    
    
    systemVC.delegate = self;
    
    systemVC.tag = 777;
    
    [self.headersView addSubview:systemVC];
    
    
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    /*
    if (index==1) {
        WebViewController *webVC = [[WebViewController alloc]init];
        webVC.qiandao = @"YES";
        webVC.hidesBottomBarWhenPushed = YES;
        //webVC.view.frame = CGRectMake(0, 64, size_width, size_height-64);
        
        webVC.navigationItem.title = @"幸运大抽奖";
        webVC.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, size_width, size_height-64)];
        
        [webVC.view addSubview:webVC.webView];
        webVC.webView.scalesPageToFit = YES;
        //webVC.webView.delegate = self;
        //LoginDataModel *model   =  [UserDefault getUserInfo];
        NSString *string5 = [NSString stringWithFormat:@"http://x.xiaobang520.com/Sys/dazhuanpan.aspx"];
        
        NSURL *url1 = [[NSURL alloc]initWithString:string5];
        
        NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"]];
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        [cookieStorage setCookies:cookies forURL:url1 mainDocumentURL:nil];
        
        
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url1];
        
        
        
        [webVC.webView loadRequest:request];
        
        [self.navigationController pushViewController:webVC animated:YES];
        

        
        
        
    }else
     */
     if(index==0){
        WebViewController *webVC = [[WebViewController alloc]init];
        webVC.qiandao = @"YES";
         webVC.isUIWebView = YES;
         webVC.hidesBottomBarWhenPushed = YES;
        //webVC.view.frame = CGRectMake(0, 64, size_width, size_height-64);
        
        
        webVC.webView = [[IMYWebView alloc]initWithFrame:CGRectMake(0, 0, size_width, size_height-64) usingUIWebView:YES];
        
        [webVC.view addSubview:webVC.webView];
        webVC.webView.scalesPageToFit = YES;
        //webVC.webView.delegate = self;
        LoginDataModel *model   =  [UserDefault getUserInfo];
        
        NSString *string5 = [NSString stringWithFormat:lipinDuiHuanURL,model.myid];
        
        NSURL *url1 = [[NSURL alloc]initWithString:string5];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url1];
        
        
        
        [webVC.webView loadRequest:request];
        
        [self.navigationController pushViewController:webVC animated:YES];

        
        
        
        
        
    }else{
        WebViewController *webVC = [[WebViewController alloc]init];
        webVC.hidesBottomBarWhenPushed = YES;
        
        webVC.isUIWebView = YES;
        webVC.navigationItem.title = @"会员特权";
        webVC.webView = [[IMYWebView alloc]initWithFrame:CGRectMake(0, 0, size_width, size_height-64) usingUIWebView:YES];
        
        [webVC.view addSubview:webVC.webView];
        webVC.webView.scalesPageToFit = YES;
        
        NSString *string5 = [NSString stringWithFormat:@"http://x.xiaobang520.com/vip1.htm?from=timeline&isapptalled=1"];
        
        NSURL *url1 = [[NSURL alloc]initWithString:string5];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url1];
        
        
        
        [webVC.webView loadRequest:request];
        
        
        [self.navigationController pushViewController:webVC animated:YES];
    }
    
    
    
}




-(void)loadData{
     //CGFloat pointx  =[[MapDefaults standInstance] sentPontxDataWith];
     //CGFloat pointy = [[MapDefaults standInstance] sentPontyDataWith];
    NSDictionary *dic = @{@"exec":@"getlist",@"p":@"1",@"o":@"2",@"c":@"0",@"k":@""};
    
    self.parmaDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    [NetworkManger requestPOSTWithURLStr:URL_DianZiJuan parmDic:self.parmaDic finish:^(id responseObject) {
    
        for (NSDictionary *dict in responseObject[@"Data"]) {
            [self.dataSourceArray addObject:dict];
        }
        
        [self requestDataList];
        [self.tableView reloadData];
        [self loadSubVies];
        
        
    } enError:^(NSError *error) {
        
    }];
    
    
    
    
    
    
}

-(void)loadNewDate{
    [self.parmaDic setObject:@"1" forKey:@"p"];
    
    self.isUp = NO;
    [self requestDataList];

}


//添加上拉加载数据
-(void)addResfresh{
    
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.parmaDic setObject:@"1" forKey:@"p"];
        
        self.isUp = NO;
        [self requestDataList];
        
        
        
    }];
    
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDate)];
    [header setImages:self.refreshImages forState:MJRefreshStateRefreshing];
    
    [header setImages:self.normalImages forState:MJRefreshStateIdle];
    
    [header setImages:self.refreshImages forState:MJRefreshStatePulling];
    
    self.tableView.header = header;

    
    [self.tableView.header beginRefreshing];
    
    
    //添加上拉加载
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSInteger p = [[self.parmaDic objectForKey:@"p"]integerValue];
        p++;
        [self.parmaDic setObject:[NSString stringWithFormat:@"%ld",(long)p] forKey:@"p"];
        
        _isUp = YES;
        [self requestDataList];
        
        
    }];
    
    
}

//请求数据
-(void)requestDataList{
    [NetworkManger requestPOSTWithURLStr:URL_DianZiJuan parmDic:self.parmaDic finish:^(id responseObject) {
        
        if (!_isUp) {
            
                //清空之前的数据
                [self.dataSourceArray removeAllObjects];
                
            
            
        }
    
        
        for (NSDictionary *dict in responseObject[@"Data"]) {
            
            if (![self.dataSourceArray containsObject:dict]) {
                [self.dataSourceArray addObject:dict];
            }

        }
        
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        
    } enError:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];

}


#pragma mark - tableView 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==111) {
        return self.dataSourceArray.count;
        
    }
    
    return 10;
    
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==111) {
        TickectsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TickectsTableViewCell" forIndexPath:indexPath];
        
        NSDictionary *dict = self.dataSourceArray[indexPath.row];
        cell.tickNameLab.text = dict[@"name"];
       
        cell.bigBackView.backgroundColor = [UIColor colorWithRed:54/255.0 green:198/255.0 blue:254/255.0 alpha:1.0];
        [cell.tickImageView sd_setImageWithURL:dict[@"img"] placeholderImage:[UIImage imageNamed:@"zwt"]];
        cell.jfCountLab.text = [NSString stringWithFormat:@"%@分（兑）",dict[@"usepoint"]];
        
        cell.syCountLab.text = [NSString stringWithFormat:@" 剩：%@个",dict[@"sycount"]];
        
        NSString *string1 = [NSString stringWithFormat:@"%@",dict[@"type"]];
        
        
        if ([string1 isEqualToString:@"0"]){
           
            cell.zheLab.text =[NSString stringWithFormat:@"%@元",dict[@"marketvalue"]];
            cell.juanLab.text = @"现金券";
            cell.backImg.image = [UIImage imageNamed:@"coupon_blue"];
        }else if ([string1 isEqualToString:@"2"]){
            cell.zheLab.text =[NSString stringWithFormat:@"%@元",dict[@"marketvalue"]];
            cell.juanLab.text = @"实物券";
            cell.backImg.image = [UIImage imageNamed:@"coupon_red"];
        }else{
          NSString *string = [NSString stringWithFormat:@"%@折",dict[@"discount"]];
            if (string.length>4) {
                NSString *string1 = [string substringWithRange:NSMakeRange(2,1)];
                NSString *string2 = [string substringWithRange:NSMakeRange(3, 2)];
                
                cell.zheLab.text = [NSString stringWithFormat:@"%@.%@",string1,string2];
                
            }else if(string.length>2){
                cell.zheLab.text = [string substringWithRange:NSMakeRange(2,2)];
            }else{
                cell.zheLab.text = string;
            }
 
           
            
           
            cell.juanLab.text =@"折扣劵";
            
            
            cell.backImg.image = [UIImage imageNamed:@"coupon_yellow"];
            
        }
        
        //得到当前系统日期
        NSDate * senddate=[NSDate date];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"HH:mm"];
        
        [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString * morelocationString=[dateformatter stringFromDate:senddate];
        
        
        
        NSString*string3 = [NSString stringWithFormat:@"%@",dict[@"distance"]];
        NSString *string2;
        if (string3.length>6) {
            string2 = [string3 substringWithRange:NSMakeRange(0, 6)];
            
        }else{
            string2 = string3;
        }
        
        cell.whereLab.text = [NSString stringWithFormat:@"%@米",string2];
        
        cell.tickentLab.text = dict[@"bname"];
        
        NSString *b = [dict[@"endtime"] substringToIndex:10];
        
        cell.timeLab.text = [NSString stringWithFormat:@"结束日期:%@",b];
        
        if ([dict[@"sycount"] integerValue]==0) {
            cell.Zimg.hidden  = NO;
            
            cell.Zimg.image = [UIImage imageNamed:@"azz"];
            cell.backImg.image = [UIImage imageNamed:@"coupon_gray"];
            cell.bigBackView.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0];
        }else if([morelocationString  compare: dict[@"endtime"] ]==NSOrderedDescending){
            cell.Zimg.hidden  = NO;
            cell.Zimg.image = [UIImage imageNamed:@"bew"];
            cell.backImg.image = [UIImage imageNamed:@"coupon_gray"];
            cell.bigBackView.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0];
        }else{
                
                cell.Zimg.hidden = YES;
            }
        //取消点击效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    
    
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    
    return cell;
}









-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //调用懒加载
    self.headerView = [self headerView];
    __weak LikesViewController *weakSelf = self;
    //点击button选项按钮的回调
    _headerView.buttonHeaderViewClicks = ^(NSInteger tag){
        weakSelf.isRuturnView = NO;
        if (tag==602) {
            
                for (UIButton *button  in weakSelf.backView.subviews) {
                    button.hidden = YES;
                }
                
                
                [weakSelf.backView viewWithTag:100].hidden = NO;
                [weakSelf.backView viewWithTag:101].hidden = NO;
                [weakSelf.backView viewWithTag:102].hidden = NO;
                [weakSelf.backView viewWithTag:103].hidden = NO;
                
            
            
            
            
            
            
            
           
            
            //获得头视图在当前tableView中的位置
            CGRect rectInTableView = [weakSelf.tableView rectForHeaderInSection:0];
            //     NSLog(@"111111111x=%f,y=%f,width=%f,height=%f",rectInTableView.origin.x,rectInTableView.origin.y,rectInTableView.size.width,rectInTableView.size.height);
            //转化左边系统为tableView的父视图
            CGRect rectInSuperview = [weakSelf.tableView convertRect:rectInTableView toView:[weakSelf.tableView superview]];
            //判断当rectInSuperview.origin.y<=20时，这时sectionHeader悬停，不再取相对位置
            if (rectInSuperview.origin.y<=20) {
                rectInSuperview = CGRectMake(rectInSuperview.origin.x, 20, rectInSuperview.size.width, rectInSuperview.size.height);
            }
            //     NSLog(@"222222222x=%f,y=%f,width=%f,height=%f",rectInSuperview.origin.x,rectInSuperview.origin.y,rectInSuperview.size.width,rectInSuperview.size.height);
            
            if (!weakSelf.flag) {
                //设置backView的frame
                weakSelf.backView.frame = CGRectMake(0, rectInSuperview.origin.y + rectInSuperview.size.height, weakSelf.backView.width, 0);
                
                
                
                
                
                //弹出视图
                [UIView animateWithDuration:0.2 animations:^{
                    weakSelf.backView.frame = CGRectMake(0, weakSelf.backView.y, size_width, size_height);
                }];
                weakSelf.flag = YES;
                
                
            }else {
               
                
               if (weakSelf.isSee1==NO) {
                    weakSelf.flag = NO;
                    
                    //收回视图
                 [weakSelf returnTheBackView];
                    
                }else{
                   
                    
                    
                    weakSelf.isSee1 = NO;
                    
                    
                }
                
                
                
            }
            //weakSelf.flag = !weakSelf.flag;
            
            //weakSelf.isSee1 = !weakSelf.isSee1;

        }
        
        if (tag==600) {
           //选择类别
            
                for (UIButton *button  in weakSelf.backView.subviews) {
                    button.hidden = YES;
                }
                
                
                [weakSelf.backView viewWithTag:200].hidden = NO;
                [weakSelf.backView viewWithTag:201].hidden = NO;
                [weakSelf.backView viewWithTag:202].hidden = NO;
                
            
            
            
            //获得头视图在当前tableView中的位置
            CGRect rectInTableView = [weakSelf.tableView rectForHeaderInSection:0];
            //     NSLog(@"111111111x=%f,y=%f,width=%f,height=%f",rectInTableView.origin.x,rectInTableView.origin.y,rectInTableView.size.width,rectInTableView.size.height);
            //转化左边系统为tableView的父视图
            CGRect rectInSuperview = [weakSelf.tableView convertRect:rectInTableView toView:[weakSelf.tableView superview]];
            //判断当rectInSuperview.origin.y<=20时，这时sectionHeader悬停，不再取相对位置
            if (rectInSuperview.origin.y<=20) {
                rectInSuperview = CGRectMake(rectInSuperview.origin.x, 20, rectInSuperview.size.width, rectInSuperview.size.height);
            }
            //     NSLog(@"222222222x=%f,y=%f,width=%f,height=%f",rectInSuperview.origin.x,rectInSuperview.origin.y,rectInSuperview.size.width,rectInSuperview.size.height);
            
            if (!weakSelf.isSee1) {
                //设置backView的frame
                weakSelf.backView.frame = CGRectMake(0, rectInSuperview.origin.y + rectInSuperview.size.height, weakSelf.backView.width, 0);
                //弹出视图
                [UIView animateWithDuration:0.2 animations:^{
                    weakSelf.backView.frame = CGRectMake(0, weakSelf.backView.y, size_width, size_height);
                }];
                
                weakSelf.isSee1 = YES;
                
            }else {
                
                if (weakSelf.flag==NO) {
                    weakSelf.isSee1 = NO;
                
                    //收回视图
                [weakSelf returnTheBackView];
                }else{
                    weakSelf.flag = NO;
                    
                    
                }
                
                
            }
            //weakSelf.isSee1 = !weakSelf.isSee1;
            //weakSelf.flag = !weakSelf.flag;
            
            
        }
        
        if (tag==601) {
           //选择区域
            for (UIButton *button  in weakSelf.backView.subviews) {
                button.hidden = YES;
            }
            
            for (UITableView *table in weakSelf.backView.subviews) {
                table.hidden = YES;
            }
            
            
            //weakSelf.twoTableView.hidden = NO;
            
            
            //获得头视图在当前tableView中的位置
            CGRect rectInTableView = [weakSelf.tableView rectForHeaderInSection:0];
            //     NSLog(@"111111111x=%f,y=%f,width=%f,height=%f",rectInTableView.origin.x,rectInTableView.origin.y,rectInTableView.size.width,rectInTableView.size.height);
            //转化左边系统为tableView的父视图
            CGRect rectInSuperview = [weakSelf.tableView convertRect:rectInTableView toView:[weakSelf.tableView superview]];
            //判断当rectInSuperview.origin.y<=20时，这时sectionHeader悬停，不再取相对位置
            if (rectInSuperview.origin.y<=20) {
                rectInSuperview = CGRectMake(rectInSuperview.origin.x, 20, rectInSuperview.size.width, rectInSuperview.size.height);
            }
            //     NSLog(@"222222222x=%f,y=%f,width=%f,height=%f",rectInSuperview.origin.x,rectInSuperview.origin.y,rectInSuperview.size.width,rectInSuperview.size.height);
            
            if (!weakSelf.isSee2) {
                //设置backView的frame
                weakSelf.backView.frame = CGRectMake(0, rectInSuperview.origin.y + rectInSuperview.size.height, weakSelf.backView.width, 0);
                //弹出视图
                [UIView animateWithDuration:0.2 animations:^{
                    weakSelf.backView.frame = CGRectMake(0, weakSelf.backView.y, size_width, size_height);
                }];
            }else {
                //收回视图
                [weakSelf returnTheBackView];
            }
            weakSelf.isSee2 = !weakSelf.isSee2;

        }
        
        
    };
    
    
    //self.headerView.hidden = YES;
    
    return _headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==111) {
        return 110;
    }
    return 30;

}



//点击cell触发的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (tableView.tag==111) {
        
        NSDictionary *dict = self.dataSourceArray[indexPath.row];
        
        TickentInFoViewController *tickVC = [[TickentInFoViewController alloc]init];
        
        tickVC.tickid = dict[@"id"];
        
        tickVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:tickVC animated:YES];
        
        
        
        
    }
    
    
    
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
    
    if (scrollView.contentOffset.y>0) {
        
    }


    if (self.isRuturnView==NO) {
        //NSLog(@"sssss");
        self.isSee1 = NO;
        self.isSee2 = NO;
        [self returnTheBackView];
        
    }
    

}






#pragma mark - 计算未来的某个时间
/**
 *  获取未来某个日期是星期几
 *  注意：featureDate 传递过来的格式 必须 和 formatter.dateFormat 一致，否则endDate可能为nil
 *
 */
- (NSString *)featureWeekdayWithDate:(NSString *)featureDate{
    // 创建 格式 对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置 日期 格式 可以根据自己的需求 随时调整， 否则计算的结果可能为 nil
    formatter.dateFormat = @"yyyy-MM-dd";
    // 将字符串日期 转换为 NSDate 类型
    NSDate *endDate = [formatter dateFromString:featureDate];
    // 判断当前日期 和 未来某个时刻日期 相差的天数
    long days = [self daysFromDate:[NSDate date] toDate:endDate];
    // 将总天数 换算为 以 周 计算（假如 相差10天，其实就是等于 相差 1周零3天，只需要取3天，更加方便计算）
    long day = days >= 7 ? days % 7 : days;
    long week = [self getNowWeekday] + day;
    switch (week) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
            
        default:
            break;
    }
    return nil;
}


/**
 *  计算2个日期相差天数
 *  startDate   起始日期
 *  endDate     截至日期
 */
-(NSInteger)daysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //得到相差秒数
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
    int minute = ((int)time)%(3600*24)/3600/60;
    if (days <= 0 && hours <= 0&&minute<= 0) {
        NSLog(@"0天0小时0分钟");
        return 0;
    }
    else {
        NSLog(@"%@",[[NSString alloc] initWithFormat:@"%i天%i小时%i分钟",days,hours,minute]);
        // 之所以要 + 1，是因为 此处的days 计算的结果 不包含当天 和 最后一天\
        （如星期一 和 星期四，计算机 算的结果就是2天（星期二和星期三），日常算，星期一——星期四相差3天，所以需要+1）\
        对于时分 没有进行计算 可以忽略不计
        return days + 1;
    }
}
// 获取当前是星期几
- (NSInteger)getNowWeekday {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday
    |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate *now = [NSDate date];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:now];
    return [comps weekday];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
