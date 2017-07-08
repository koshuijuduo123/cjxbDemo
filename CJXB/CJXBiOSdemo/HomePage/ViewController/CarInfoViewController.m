//
//  CarInfoViewController.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/12.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "CarInfoViewController.h"
#import "CarInfoTableViewCell.h"
#import "CarEntity.h"
#import "StringUtils.h"
#import "JSONKit.h"
#import "ResultData.h"
#import "HeaderFoundView.h"
#import "AppDelegate.h"
#import "WeiZhangEntity.h"
#import "CarModel.h"
#import "CarEntity.h"
#import "NetworkManger.h"
#include <string.h>
@interface CarInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property(nonatomic,strong)NSMutableArray *dataSource;//cell数据源

@end

@implementation CarInfoViewController

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent  = YES;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars =YES;
    self.tableView.estimatedRowHeight = 100;
     self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self sourcePlease];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CarInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"CarInfoTableViewCell"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
     _tableView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    self.title = @"违章纪录";
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

-(void)sourcePlease{
    [self showHUDWith:@"小帮加载中..."];
    //第一步，创建url
    NSURL *url = [NSURL URLWithString:@"http://app1.henanga.gov.cn/jmt/app/trafficInfo_selectJDCWZXX"];
    
    //第二步，创建请求
    NSString *MaString = [self.hm substringToIndex:1];
    NSString *NumberString = [self.hm substringFromIndex:1];
    
    NSString *postStr = [[NSString alloc] initWithFormat:@"{\"HPZL\":\"%@\",\"FZJG\":\"豫%@\",\"HPHM\":\"%@\",\"CLSBDH\":\"%@\",\"FDJH\":\"\",\"pageNo\":\"1\"}",self.lz,MaString,NumberString,self.mm];
    
    NSString *requeststr = [[NSString alloc] initWithFormat:@"auth=%@&info=%@", [StringUtils getAuthJsonObject:postStr],postStr];
    
    //NSLog(@"%@",postStr);
    
    NSData *postData = [requeststr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    //第三步，连接服务器
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    //发起任务
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    [dataTask resume];
    
}


//接收到服务器回应的时候调用此方法
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    
    
    self.receivData = [NSMutableData data];//数据存储对象的的初始化
    completionHandler(NSURLSessionResponseAllow);
   
}

//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    
    [self.receivData appendData:data];
    
    
}

//数据传完之后调用此方法
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    if (error==nil) {
        HeaderFoundView *view = [[HeaderFoundView alloc]init];
        NSString *receiveStr = [[NSString alloc]initWithData:self.receivData encoding:NSUTF8StringEncoding];
        
        //切割后余下的数据
        
        NSString *b = [NSString stringWithFormat:@"%@",receiveStr];
        //解析数据，用字典接
        NSDictionary *parserDic = [b objectFromJSONString];
        
        NSArray *array = [parserDic objectForKey:@"resultData"];
       
        AppDelegate *app = CJXBAPP;
        
        NSArray *entityArr = [app searchCarinfoEntity];
        
        for (WeiZhangEntity *entity in entityArr) {
            [app.managedObjectContext deleteObject:entity];
            
            
        }
        
        [app.managedObjectContext save:nil];
        [self.dataSource removeAllObjects];
        
        
        
        
        for (NSDictionary *dic in array) {
            ResultData *model = [[ResultData alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataSource addObject:model];
            
            
            [app addCarInfoEntity:model];
            
            
        }
        ResultData *model = [[ResultData alloc]init];
        CarModel *carModel = [[CarModel alloc]init];
        
        carModel.count = [NSString stringWithFormat:@"%lu",(unsigned long)array.count];
        
        carModel.cphm = [NSString stringWithFormat:@"豫%@",model.hphm];
        carModel.cpzl = [NSString stringWithFormat:@"【%@】",model.hpzl];
        
        //carModel.hp = model.hphm;
        //carModel.mm = self.maTextFirld.text;
        
        NSInteger jfs = 0;
        NSInteger jes = 0;
        
        for (NSDictionary *dic in array) {
            
            if (carModel.zl==nil) {
                
                carModel.zl = dic[@"hpzl"];
            }
            
            jfs  = jfs+[dic[@"wfjfs"] integerValue];
            
            jes = jes + [dic[@"fkje"] integerValue];
            
            
            
        }
        
        carModel.fkjf =[NSString stringWithFormat:@"%ld",(long)jfs];
        carModel.fkje =[NSString stringWithFormat:@"%ld",(long)jes];
        
        
        //存储数据
        [app updataWith:model.hphm with:carModel.fkje with:carModel.fkjf with:[NSString stringWithFormat:@"%lu",(unsigned long)array.count]];
        
        //取出保存的cookie
        //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        //对取出的cookie进行反归档处理
        //NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:@"kUserDefaultsCookie"]];
        /*
         if (cookies) {
         //NSLog(@"有cookie");
         //设置cookie
         NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
         for (id cookie in cookies) {
         [cookieStorage setCookie:(NSHTTPCookie *)cookie];
         }
         NSDictionary *dictStr = @{@"hphm":self.hm,@"hpzl":self.mm,@"sbdh":self.lz,@"fkje":carModel.fkje,@"wfjfs":carModel.fkjf,@"wfsl":carModel.count};
         
         NSArray *arr = @[dictStr];
         //        NSArray *keyArr = @[@"hphm",@"hpzl",@"sbdh",@"fkje",@"wfjfs",@"wfsl"];
         //        NSMutableDictionary *dic =[NSMutableDictionary dictionary];
         //        for (NSString *key in keyArr) {
         //            NSInteger i = 0;
         //            [dic setValue:arr[i] forKey:key];
         //            i++;
         //        }
         //
         //        NSArray *returnArr = @[dic];
         
         //登录状态上传数据
         NSDictionary *parmDic = @{@"exec":@"uploadcarinfo",@"chelist":arr};
         
         
         [NetworkManger requestPOSTWithURLStr:@"http://x.xiaobang520.com/Sys/syshandler.ashx" parmDic:parmDic finish:^(id responseObject) {
         //[CarInfoViewController showAlertMessageWithMessage:responseObject[@"Message"] duration:1.0];
         } enError:^(NSError *error) {
         
         }];
         
         }else{
         //NSLog(@"无cookie");
         //MyCarViewController *myVC = [[MyCarViewController alloc]init];
         
         
         //[self.navigationController pushViewController:myVC animated:YES];
         //return;
         }
         */
        sleep(2);
        self.backView.hidden = YES;
        [self hidenHUD];
        
        
        [view.layer removeAllAnimations];
        [self.tableView reloadData];
        
    }else{
        HeaderFoundView *foundView = [[HeaderFoundView alloc]init];
        sleep(2);
        self.backView.hidden = YES;
        [self hidenHUD];
        [foundView.layer removeAllAnimations];
        
        AppDelegate *app = CJXBAPP;
        NSArray *arr =  [app searchCarinfoEntity];
        
        for (WeiZhangEntity *dic in arr) {
            
            NSString *string = [NSString stringWithFormat:@"豫%@",self.hm];
            
            
            if ([dic.hphm isEqualToString:string]) {
                
                [self.dataSource addObject:dic];
                
                
            }
            
        }
        
        
        [self.tableView reloadData];
 
    }
    
    
}




#pragma mark - UItableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataSource.count>0) {
        return self.dataSource.count;
        
    }else{
        return 1;
    }
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataSource.count>0) {
        
        CarInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CarInfoTableViewCell" forIndexPath:indexPath];
        ResultData *model = self.dataSource[indexPath.row];
        NSString *string = nil;
        string = model.wfsj;
        NSString *b = nil;
        b=[string substringToIndex:10];
        
        
        NSString *b1 = [string substringToIndex:4];
        cell.yearLab.text = b1;
        NSString *b2 = [string substringWithRange:NSMakeRange(5, 2)]; //月份
        NSString *b3 = [string substringWithRange:NSMakeRange(8, 2)]; //日子
        
        cell.daysLab.text = [NSString stringWithFormat:@"%@月%@日",b2,b3];
        
        NSDate *date1 = [self strToDate:b];
        cell.zhoulab.text = [self getweekDayWithDate:date1];
        
        cell.nameLab.text = model.wfxw;
        cell.addressLab.text = model.wfdz;
        cell.moneyLab.text = [NSString stringWithFormat:@"%@(参考)",model.fkje];
        
        
        cell.pointsLab.text = [NSString stringWithFormat:@"%@分",model.wfjfs];
        
        //取消点击效果
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        
        NSString *b4 = [string substringToIndex:16];
        cell.timeLab.text = [NSString stringWithFormat:@"具体时间:%@",b4];
        
        return cell;
    }else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        cell.imageView.image = [UIImage imageNamed:@"民警"];
        cell.textLabel.text = @"您的车辆纪录良好";
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:20.0];
        cell.textLabel.textColor = [UIColor orangeColor];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        return cell;
    }
    
    
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return -1;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HeaderFoundView *foundView = [[HeaderFoundView alloc]initWithFrame:CGRectMake(0, 0, size_width, 150)];
    AppDelegate *app = CJXBAPP;
    
    
    foundView.CarNameLab.text = [NSString stringWithFormat:@"豫%@",self.hm];
    
    NSInteger jfs = 0;
    NSInteger jes = 0;
    
    for (ResultData *model in self.dataSource) {
        jfs  = jfs+[model.wfjfs integerValue];
        
        jes = jes + [model.fkje integerValue];

    }
    NSString *jf = [NSString stringWithFormat:@"%ld",(long)jfs];
    NSString *je = [NSString stringWithFormat:@"%ld",(long)jes];
    NSString *count = [NSString stringWithFormat:@"%lu",(unsigned long)self.dataSource.count];
    [app updataWith:self.hm with:je with:jf with:count];
    
    
    if (self.dataSource.count>0) {
        foundView.thingLab.text = [NSString stringWithFormat:@"未处理违章:%lu条,扣:%ld分,罚款%ld元(仅供参考)",(unsigned long)self.dataSource.count,(long)jfs,(long)jes];
        foundView.thingLab.textColor = [UIColor redColor];
        
        if (size_width<=320) {
            foundView.thingLab.font = [UIFont systemFontOfSize:14.0];
        }
        
        
        
    }else{
        foundView.thingLab.text = [NSString stringWithFormat:@"没有违章，继续保持"];
        foundView.thingLab.textColor = [UIColor greenColor];
        
    }

    
    
    
    
    
    
    
    
    
    
//    NSArray *arr = [app searchMovieEntiity];
//    
//    
//    
//    
//    for (CarEntity *dic in arr) {
//        if ([dic.hp isEqualToString:self.hm]) {
//            foundView.CarNameLab.text = dic.hphm;
//            if (self.dataSource.count>0) {
//                foundView.thingLab.text = [NSString stringWithFormat:@"未处理违章:%ld条,扣:%@分,罚款%@元(仅供参考)",self.dataSource.count,dic.wfjfs,dic.fkje];
//                foundView.thingLab.textColor = [UIColor redColor];
//                
//                if (size_width<=320) {
//                    foundView.thingLab.font = [UIFont systemFontOfSize:14.0];
//                }
//
//            }else{
//                foundView.thingLab.text = [NSString stringWithFormat:@"没有违章，继续保持"];
//                foundView.thingLab.textColor = [UIColor greenColor];
//                
//            }
//            break;
//        }
//    }
    
   __weak CarInfoViewController *WeakSelf = self;
    foundView.tapClcik = ^(NSString *string){
        
        if ([string isEqualToString:@"success"]) {
            
            [WeakSelf.dataSource removeAllObjects];
            
            
            [WeakSelf sourcePlease];
        }
        
    };
    return foundView;
}





-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 150;
}



// 日期和字符串之间的转换
- (NSDate *) strToDate:(NSString *)dateStr
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"]; // 年-月-日 时:分:秒
    // 这个格式可以随便定义,比如：@"yyyy,MM,dd,HH,mm,ss"
    
    
    NSDate * date1 = [formatter dateFromString:dateStr];
    return date1;
    
}


- (NSString *) getweekDayWithDate:(NSDate *) date
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; // 指定日历的算法
    NSDateComponents *comps = [calendar components:NSWeekdayCalendarUnit fromDate:date];
    
    // 1 是周日，2是周一 3.以此类推
    //return @([comps weekday]);
    NSUInteger week = [comps weekday];
    //week++;
    
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
            return @"神秘日";
            break;
    }
    return nil;

    
}





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
        //NSLog(@"0天0小时0分钟");
        return 0;
    }
    else {
        //NSLog(@"%@",[[NSString alloc] initWithFormat:@"%i天%i小时%i分钟",days,hours,minute]);
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
