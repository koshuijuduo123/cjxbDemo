//
//  FuwuViewController.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/6.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "FuwuViewController.h"
#import "NetworkManger.h"
#import "MJRefresh.h"
#import "FuwuTableViewCell.h"
@interface FuwuViewController ()<UITableViewDataSource,
UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property(nonatomic,strong)NSMutableArray *dataSourceArr;//cell数据源

@property(nonatomic,strong)NSMutableDictionary *parmDic; //参数字典

@property(nonatomic,assign)BOOL isUp;

@property(nonatomic,strong)UIWebView *webView;
@end

@implementation FuwuViewController

-(NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        self.dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}


-(NSMutableDictionary *)parmDic{
    if (!_parmDic) {
        self.parmDic = [NSMutableDictionary dictionary];
    }
    return _parmDic;
}


//创建一个UIWebView来加载URL，拨完后能自动回到原应用

-(UIWebView *)webView{
    if (_webView == nil) {
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        
    }    return _webView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"FuwuTableViewCell" bundle:nil] forCellReuseIdentifier:@"FuwuTableViewCell"];
    
    self.tableView.estimatedRowHeight =50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.title = @"周边汽车服务";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadData];
    [self addResfresh];
    
    
        
}


//加载数据
-(void)loadData{
    //显示加载圈
    [self showHUDWith:@"小帮加载中"];
    NSDictionary *parmDics = @{@"exec":@"getlist",@"p":@"1"};
    self.parmDic = [NSMutableDictionary dictionaryWithDictionary:parmDics];
    
    
    [self requesDataList];
    
}

//请求数据
-(void)requesDataList{
    [NetworkManger requestPOSTWithURLStr:URL_compand parmDic:self.parmDic finish:^(id responseObject) {
        [self hidenHUD];
        self.backView.hidden = YES;
        
        if (!_isUp) {
            [self.dataSourceArr removeAllObjects];
        }
        
        for (NSDictionary *arr in responseObject[@"Data"]) {
            [self.dataSourceArr addObject:arr];
        }
        
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        
        
    } enError:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size_width, size_height)];
        view1.backgroundColor = [UIColor whiteColor];
        UIImageView *imgVc = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size_width, size_height)];
        imgVc.image = [UIImage imageNamed:@"请求错误"];
        imgVc.userInteractionEnabled = YES;
        
        [view1 addSubview:imgVc];
        
        [self.view addSubview:view1];
    }];
    
    
}

//添加上拉加载数据
-(void)addResfresh{
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.parmDic setObject:@"1" forKey:@"p"];
        [self requesDataList];
        self.isUp = NO;
        
    }];
    
    [self.tableView.header beginRefreshing];
    //添加上拉加载
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSInteger p = [[self.parmDic objectForKey:@"p"]integerValue];
        p++;
        [self.parmDic setObject:[NSString stringWithFormat:@"%ld",p] forKey:@"p"];
        [self requesDataList];
        _isUp = YES;
        
    }];
    
    
}

//返回随机色
+(UIColor *)randomColor{
    
    CGFloat hue = (arc4random()%256/255.0);
    CGFloat saturation = (arc4random()%256/255.0);
    CGFloat brightness = (arc4random()%256/255.0);
    
    return [UIColor colorWithRed:hue green:saturation blue:brightness alpha:1.0];
    
    
    
    
}





#pragma mark - UItableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FuwuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FuwuTableViewCell" forIndexPath:indexPath];
    
    NSDictionary *dict = self.dataSourceArr[indexPath.row];
    
    cell.nameLab.text = dict[@"bname"];
    cell.addressLab.text = dict[@"baddress"];
    cell.yewuLab.text = dict[@"summary"];
    cell.phoneNumber = dict[@"phone"];
    
    cell.leftColorLab.backgroundColor = [FuwuViewController randomColor];
    
    cell.phoneButtonClick = ^(NSString *string){
    
        //调取电话页
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",string]]]];
        //NSLog(@"%@",string);
        
        [self.view addSubview:self.webView];
    };
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return -1;
}
//点击cell触发的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
