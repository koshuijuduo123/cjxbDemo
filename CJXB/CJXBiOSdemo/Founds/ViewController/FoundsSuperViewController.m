//
//  FoundsSuperViewController.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 17/1/10.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "FoundsSuperViewController.h"
#import "MJRefresh.h"
#import "MJRefreshGifHeader.h"
#import "NewsTableViewCell.h"
#import "NetworkManger.h"
#import "WebViewController.h"
#import "LoginDataModel.h"
#import "UserDefault.h"
#import "AFNetworking.h"
#import "IMYWebView.h"
@interface FoundsSuperViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)BOOL isUp;//上拉表示YES，NO是下拉
@property(nonatomic,strong)NSMutableArray *dataSourceArray;//cell数据源数据

@property(nonatomic,strong)NSMutableDictionary *dataSourceDic;//请求参数字典

@property(nonatomic,strong)NSMutableArray *refreshImages;//刷新动画的图片数组
@property(nonatomic,strong)NSMutableArray *normalImages;//普通状态下的图片数组

@end

@implementation FoundsSuperViewController
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


-(NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        self.dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

-(NSMutableDictionary *)dataSourceDic{
    if (!_dataSourceDic) {
        self.dataSourceDic = [NSMutableDictionary dictionary];
    }
    return _dataSourceDic;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    [self addResfresh];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewsTableViewCell"];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, size_width, size_height-44-40-64)];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
}


-(void)loadNewDate{
    [self.dataSourceDic setObject:@"1" forKey:@"p"];
    [self requestDataList];
    self.isUp = NO;
}

//添加上拉加载数据
-(void)addResfresh{
    //添加下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //下拉刷新的时候，将请求的page改为1
        [self.dataSourceDic setObject:@"1" forKey:@"p"];
        [self requestDataList];
        self.isUp = NO;
        
    }];
    
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDate)];
    [header setImages:self.refreshImages forState:MJRefreshStateRefreshing];
    
    [header setImages:self.normalImages forState:MJRefreshStateIdle];
    
    [header setImages:self.refreshImages forState:MJRefreshStatePulling];
    
    self.tableView.header = header;
    
    
    
    
    [self.tableView.header beginRefreshing];
    
    //添加上拉加载
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //上拉加载时将当前请求页数加一
        NSInteger p = [[self.dataSourceDic objectForKey:@"p"]integerValue];
        p++;
        NSString *stringTitleNumber =[NSString stringWithFormat:@"%ld",(long)p];
        [self.dataSourceDic setObject:stringTitleNumber forKey:@"p"];
        [self requestDataList];
        
        _isUp = YES;
    }];
    
    
    
    
}

//请求列表数据方法
-(void)requestDataList{
    //[self showHUDWith:@"小帮加载中..."];
    [NetworkManger requestPOSTWithURLStr:URL_News parmDic:self.dataSourceDic finish:^(id responseObject) {
        //[self hidenHUD];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject];
        
        
        if (!_isUp) {
            //清空之前的数据
            [self.dataSourceArray removeAllObjects];
            
        }
        
        for (NSDictionary *arr in dic[@"Data"]) {
            [self.dataSourceArray addObject:arr];
        }
        
        [self.tableView reloadData];
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        
    } enError:^(NSError *error) {
        //[self hidenHUD];
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size_width, size_height)];
        view1.backgroundColor = [UIColor whiteColor];
        UIImageView *imgVc = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size_width, size_height)];
        imgVc.image = [UIImage imageNamed:@"请求错误"];
        imgVc.userInteractionEnabled = YES;
        
        
        UITapGestureRecognizer *tapFestrer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapRefeshAction:)];
        [imgVc addGestureRecognizer:tapFestrer];
        
        
        [view1 addSubview:imgVc];
        
        UILabel *refrshLab = [[UILabel alloc]initWithFrame:CGRectMake((size_width-150)/2, 70, 150, 40)];
        refrshLab.text = @"点击页面刷新";
        refrshLab.font = [UIFont systemFontOfSize:18.0];
        refrshLab.textColor = [UIColor colorWithRed:182/255.0 green:207/255.0 blue:211/255.0 alpha:1.0];
        refrshLab.textAlignment = NSTextAlignmentCenter;
        [view1 addSubview:refrshLab];
        view1.tag = 9999;
        [self.view addSubview:view1];
        
        
        
    }];
    
}

//点击图片刷新
-(void)TapRefeshAction:(UIGestureRecognizer *)sender{
    UIView *view = [self.view viewWithTag:9999];
    [view removeFromSuperview];
    [self addResfresh];
    
}


//加载数据源
-(void)loadDataWithTitleNumber:(NSString *)title{
    
    NSDictionary *parmDic =@{@"exec":@"getlist",@"p":@"1",@"id":@"15",@"c":title};
    
    self.dataSourceDic = [NSMutableDictionary dictionaryWithDictionary:parmDic];
    
    [NetworkManger requestPOSTWithURLStr:URL_News parmDic:self.dataSourceDic finish:^(id responseObject) {
        
        self.dataSourceArray = [NSMutableArray arrayWithArray:responseObject[@"Data"]];
        
        [self requestDataList];
        
        [self.tableView reloadData];
        
        
        
    } enError:^(NSError *error) {
        
    }];
    
    
}


#pragma mark - tableView 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsTableViewCell" forIndexPath:indexPath];
    NSDictionary *dic = self.dataSourceArray[indexPath.row];
    [cell.titleImageView sd_setImageWithURL:dic[@"img"] placeholderImage:[UIImage imageNamed:@"zwt"]];
    
    
    cell.titleLab.text = dic[@"title"];
    
    NSString *string1 = [NSString stringWithFormat:@"%@",dic[@"zfpoints"]];
    
    if ([string1 isEqualToString:@"0"])  {
        cell.baoCountLab.text =@"x2";
        
        
    }else{
        cell.baoCountLab.text = [NSString stringWithFormat:@"x%@",string1];
    }
    
    cell.chatCountLab.text = [NSString stringWithFormat:@"%@",dic[@"see"]];
    
    
    NSString *string = [NSString stringWithFormat:@"%@",dic[@"addtime"]];
    
    if (string.length>11) {
        cell.timeLab.text  =[string substringWithRange:NSMakeRange(5,11)];
        
    }else{
        cell.timeLab.text = string;
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (size_width<=320) {
        return 100;
        
        
        
    }else if(size_width==375){
        return 100;
    }else{
        return 110;
    }
}

//点击cell触发
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WebViewController *webVC = [[WebViewController alloc]init];
    webVC.hidesBottomBarWhenPushed = YES;
    
    LoginDataModel *model = [UserDefault getUserInfo];
    
    NSDictionary *dict =self.dataSourceArray[indexPath.row];
    //NSLog(@"%@",dict[@"id"]);
    NSString *string = [NSString stringWithFormat:@"http://x.xiaobang520.com/article/show.aspx?articleid=%@&userid=%@",dict[@"id"],model.myid];
    
    
    NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"]];
    
    
    
    webVC.webView = [[IMYWebView alloc]initWithFrame:CGRectMake(0, 0, size_width, size_height-64-44)];
    [webVC.view addSubview:webVC.webView];
    
    [webVC.view bringSubviewToFront:webVC.backView];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:string]];
    
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookieStorage setCookies:cookies forURL:[NSURL URLWithString:string] mainDocumentURL:nil];
    
    NSMutableString *cookieString = [[NSMutableString alloc] init];
    
    if (cookies.count) {
        
        NSHTTPCookie *currentCookie= [[NSHTTPCookie alloc] init];
        
        for (NSHTTPCookie*cookie in [cookieStorage cookies]) {
            
            currentCookie = cookie;
            //多个字段之间用“；”隔开
            [cookieString appendFormat:@"%@=%@;",cookie.name,cookie.value];
            
            
        }
        //删除最后一个“；”
        [cookieString deleteCharactersInRange:NSMakeRange(cookieString.length - 1, 1)];
        
        NSString *cookie = [NSString stringWithFormat:@"%@",cookieString];
        
        [request addValue:cookie forHTTPHeaderField:@"Cookie"];
    }
    
    
    [webVC.webView loadRequest:request];
    
    
    
    
    
    webVC.titleLab = dict[@"title"];
    UIImageView *imgView = [[UIImageView alloc]init];
    
    [imgView sd_setImageWithURL:dict[@"img"]];
    
    
    
    webVC.titleImg = imgView.image;
    
    webVC.articleId = dict[@"id"];
    
    webVC.qiandao = @"YES";
    
    [self.navigationController pushViewController:webVC animated:YES];
    
    
    
    
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
