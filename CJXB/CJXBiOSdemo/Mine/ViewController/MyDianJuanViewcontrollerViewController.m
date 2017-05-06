//
//  MyDianJuanViewcontrollerViewController.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/16.
//  Copyright © 2016年 wang. All rights reserved.
//

#define KSummaryButton_Tag 111
#define KRouteButton_Tag  222
#define KTableView_tag  333 //当前主页tableView


#import "MyDianJuanViewcontrollerViewController.h"
#import "TickectsTableViewCell.h"
#import "NetworkManger.h"
#import "UserDefault.h"
#import "ShipSelectHeaderView.h"
#import "TickentInFoViewController.h"
#import "MJRefresh.h"

@interface MyDianJuanViewcontrollerViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataSourceArr;//未过期数据源
@property(nonatomic,strong)NSMutableDictionary *couponidDic; //相同电子券纪录字典
@property(nonatomic,strong)NSMutableArray *dataOldArr;//失效电子劵数据源

@property(nonatomic,strong)ShipSelectHeaderView *headerView;//声明全局区头

@property(nonatomic,assign)BOOL isSummary; //YES 表示未过期电子劵

@property(nonatomic,assign)BOOL isUp;

@property(nonatomic,strong)NSMutableDictionary *paramDic;//参数字典

@property(nonatomic,strong)NSString *sCount;//判断失效不失效的参数
@property(nonatomic,strong)NSMutableDictionary *dictArrObj;//去重数据字典
@property(nonatomic,strong)NSMutableArray *soureArr;//转接数组


@end

@implementation MyDianJuanViewcontrollerViewController
-(ShipSelectHeaderView *)headerView{
    if (_headerView==nil) {
        self.headerView = [[ShipSelectHeaderView alloc]initWithFrame:CGRectMake(0, 0, size_width, 40)];
    }
    return _headerView;
}

-(NSMutableDictionary *)paramDic{
    if (!_paramDic) {
        self.paramDic = [NSMutableDictionary dictionary];
    }
    return _paramDic;
}
-(NSMutableArray *)soureArr{
    if (!_soureArr) {
        self.soureArr = [NSMutableArray array];
    }
    return _soureArr;
}
-(NSMutableDictionary *)dictArrObj{
    if (!_dictArrObj) {
        self.dictArrObj = [NSMutableDictionary dictionary];
    }
    return _dictArrObj;
}

-(NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        self.dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}
-(NSMutableDictionary *)couponidArr{
    if (!_couponidDic) {
        self.couponidDic= [NSMutableDictionary dictionary];
    }
    return _couponidDic;
}


-(NSMutableArray *)dataOldArr{
    if (!_dataOldArr) {
        self.dataOldArr = [NSMutableArray array];
    }
    return _dataOldArr;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent  = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的电子劵";
    
    
    
    
    //注册自定义cell
    [self.tableView registerNib:[UINib nibWithNibName:@"TickectsTableViewCell" bundle:nil] forCellReuseIdentifier:@"TickectsTableViewCell"];
   
    //去掉cell之间的分割线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.sCount = @"0";
    [self loadData];
    [self addResfresh];
    //self.tableView.footer.automaticallyHidden = NO;
    
    self.tableView.tag = KTableView_tag;
    
    _isSummary = YES;
    __weak typeof (self)weakSelf = self;
    self.headerView.buttonClick = ^(NSInteger index){
        if (index==KSummaryButton_Tag) {
            _isSummary = YES;
            weakSelf.sCount = @"0";
            [weakSelf.dictArrObj removeAllObjects];
            [weakSelf.dataSourceArr removeAllObjects];
            [weakSelf.soureArr removeAllObjects];
            
            [weakSelf loadData];
        }else if (index==KRouteButton_Tag){
            _isSummary = NO;
            weakSelf.sCount = @"1";
            [weakSelf.dictArrObj removeAllObjects];
            [weakSelf.dataSourceArr removeAllObjects];
            [weakSelf.soureArr removeAllObjects];
            
            [weakSelf loadData];
        }
        
        
        [weakSelf.tableView reloadData];
    };

    
        
}

//添加上拉加载
-(void)addResfresh{
    //添加下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //下拉刷新的时候,将请求的page改为1
        [self.paramDic setObject:@"1" forKey:@"p"];
        [self requestDataList];
        self.isUp = NO;
        
    }];
    
    //[self.tableView.header beginRefreshing];
    //添加上拉加载
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //上拉加载时,将当前请求的页数加一
        NSInteger page = [[self.paramDic objectForKey:@"p"]integerValue];
        page++;
        [self.paramDic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"p"];
        
        
        
        [self requestDataList];
        
        
        _isUp = YES;
        
        
    }];

    
    
    
}


-(void)requestDataList{
    NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"]];
    NSHTTPCookieStorage * cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie * cookie in cookies){
        [cookieStorage setCookie: cookie];
    }
    
    [NetworkManger requestPOSTWithURLStr:@"http://x.xiaobang520.com/coupon/couponshandler.ashx" parmDic:self.paramDic finish:^(id responseObject) {
        [self hidenHUD];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject];
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:dic[@"Data"]];
        
        if (!_isUp) {
        //清空之前的数据
        [self.dataSourceArr removeAllObjects];
        [self.soureArr removeAllObjects];
        [self.dictArrObj removeAllObjects];
        }
        
        
         NSMutableDictionary *addDicts = [NSMutableDictionary dictionary];
       for (NSDictionary *dict in arr) {
           if (_isSummary==NO) {
               [self.soureArr addObject:dict];
           }else{
               if (![self.soureArr containsObject:dict]) {
                   [addDicts setObject:@"0" forKey:dict[@"couponid"]];
                   [self.dictArrObj setObject:dict forKey:dict[@"couponid"]];
                   
                   [self.soureArr addObject:dict];
               }
               
           }
           
           
           
        }
        
        if (_isSummary==YES) {
            self.dataSourceArr =[NSMutableArray arrayWithArray:_dictArrObj.allValues];
            for (NSDictionary *dic in self.soureArr) {
                NSString   *numbers = [addDicts objectForKey:dic[@"couponid"]];
                NSInteger nums =  [numbers integerValue]+1;
                [addDicts setObject:[NSString stringWithFormat:@"%ld",(long)nums] forKey:dic[@"couponid"]];
            }
            
            
            self.couponidDic = [NSMutableDictionary dictionaryWithDictionary:addDicts];
            
        }else{
            self.dataSourceArr =[NSMutableArray arrayWithArray:_soureArr];
        }
        
        
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
} enError:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
    


}




-(void)loadData{
    [self showHUDWith:@"小帮加载中..."];
    NSDictionary *dict =@{@"exec":@"getmylist",@"p":@"1",@"s":self.sCount};
    
    self.paramDic = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    /*
    [NetworkManger requestPOSTWithURLStr:@"http://x.xiaobang520.com/coupon/couponshandler.ashx" parmDic:self.paramDic finish:^(id responseObject) {
       
        [self hidenHUD];
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:responseObject[@"Data"]];
        for (NSDictionary *dic in array) {
            
            //得到当前系统日期
            NSDate * senddate=[NSDate date];
            NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"HH:mm"];
            //NSString * locationString=[dateformatter stringFromDate:senddate];
            [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            NSString * morelocationString=[dateformatter stringFromDate:senddate];
            
            if([morelocationString  compare: dic[@"endtime"] ]==NSOrderedDescending){
                
                [self.dataOldArr addObject:dic];
            }else{
                
                [self.dataSourceArr addObject:dic];
                
            }
            
            
            
        }
     
        [self requestDataList];
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        
    }];
   */
    
        
   [self requestDataList];
    
}




#pragma mark - UItableView代理

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return self.dataSourceArr.count;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TickectsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TickectsTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_isSummary==YES) {
        NSDictionary *dict = self.dataSourceArr[indexPath.row];
       
        cell.Zimg.hidden = YES;
        
        cell.tickNameLab.text =dict[@"name"];

        cell.bigBackView.backgroundColor = [UIColor colorWithRed:229/255.0 green:200/255.0 blue:144/255.0 alpha:1.0];        
        [cell.tickImageView sd_setImageWithURL:dict[@"img"] placeholderImage:[UIImage imageNamed:@"zwt"]];
        
        cell.jfCountLab.text = @"点击使用";
        cell.jfCountLab.backgroundColor =[UIColor orangeColor];
        cell.jfCountLab.textColor = [UIColor whiteColor];
        cell.syCountLab.hidden = NO;
        
        
        cell.syCountLab.text = [NSString stringWithFormat:@" 剩余：%@个",[NSString stringWithFormat:@"%@",self.couponidDic[dict[@"couponid"]]]];
           
        // cell.syCountLab.text = [NSString stringWithFormat:@" 剩：%@个",dict[@"sycount"]];
        
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
                
            }else{
                cell.zheLab.text = [string substringWithRange:NSMakeRange(2,2)];
            }
            
            
            
            
            cell.juanLab.text =@"折扣劵";
            cell.backImg.image = [UIImage imageNamed:@"coupon_yellow"];
            
        }

        NSString *string3 = [NSString stringWithFormat:@"%@",dict[@"distance"]];
        NSString *string2;
        if (string3.length>6) {
            string2 = [string3 substringWithRange:NSMakeRange(0, 6)];
            
        }else{
            string2 = string3;
        }
        
        
        cell.whereLab.text = [NSString stringWithFormat:@"%@米",string2];
        
        cell.tickentLab.text = dict[@"bname"];
        
        NSString *b = [dict[@"endtime"] substringToIndex:10 ];
        cell.timeLab.text = [NSString stringWithFormat:@"📅本券有效截止日期:%@",b];
        
        
        
        
        return cell;
        
        
    }else{
        
        NSDictionary *dict = self.dataSourceArr[indexPath.row];
        
        cell.Zimg.hidden  = NO;
        cell.Zimg.image = [UIImage imageNamed:@"used"];
        cell.backImg.image = [UIImage imageNamed:@"coupon_gray"];
        cell.tickNameLab.text =dict[@"name"];
        cell.bigBackView.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0];
        [cell.tickImageView sd_setImageWithURL:dict[@"img"]];
        
        
        cell.jfCountLab.text = @"已失效";
        cell.jfCountLab.backgroundColor =[UIColor darkGrayColor];
        cell.jfCountLab.textColor = [UIColor whiteColor];
        
        cell.syCountLab.hidden = YES;
        
        
        
        NSString *string1 = [NSString stringWithFormat:@"%@",dict[@"type"]];
        
        
        if ([string1 isEqualToString:@"0"]){
            
            cell.zheLab.text =[NSString stringWithFormat:@"%@元",dict[@"marketvalue"]];
            cell.juanLab.text = @"现金券";
            
        }else if ([string1 isEqualToString:@"2"]){
            cell.zheLab.text =[NSString stringWithFormat:@"%@元",dict[@"marketvalue"]];
            cell.juanLab.text = @"实物券";
            
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
            
            
        }
        
        cell.timeLab.text = [NSString stringWithFormat:@"📅使用日期:%@",dict[@"usetime"]];
        
        NSString *string3 = [NSString stringWithFormat:@"%@",dict[@"distance"]];
        NSString *string2;
        if (string3.length>6) {
            string2 = [string3 substringWithRange:NSMakeRange(0, 6)];
            
        }else{
            string2 = string3;
        }
        
        
        cell.whereLab.text = [NSString stringWithFormat:@"%@米",string2];
        
        
        return cell;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size_width, 40)];
    
    [backView addSubview:self.headerView];
    
    backView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    
    return backView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

//点击cell的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
       
    TickentInFoViewController *tickVC = [[TickentInFoViewController alloc]init];
    
    if (_isSummary==YES) {
        NSDictionary *dic = self.dataSourceArr[indexPath.row];
       
        tickVC.tickid = dic[@"id"];
        tickVC.MyTick = @"my";
        tickVC.isUse = YES;
        tickVC.tickDic = [NSDictionary dictionaryWithDictionary:dic];
        [self.navigationController pushViewController:tickVC animated:YES];
        
    }else{
        
        NSDictionary *dic = self.dataSourceArr[indexPath.row];
        tickVC.tickid = dic[@"id"];
        tickVC.MyTick = @"my";
        tickVC.isUse = NO;
        tickVC.tickDic = [NSDictionary dictionaryWithDictionary:dic];
        [self.navigationController pushViewController:tickVC animated:YES];
        
    }
    
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
