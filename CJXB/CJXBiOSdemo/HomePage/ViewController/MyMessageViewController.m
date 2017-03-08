//
//  MyMessageViewController.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/9.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "MyMessageViewController.h"
#import "AppDelegate.h"
#import "MessageEntity.h"
#import "MesgInfoView.h"
#import "HeaderFoundView.h"
#import "StringUtils.h"
#import "JSONKit.h"
#import "MessageEntity.h"
#import "MessageData.h"
#import "LoginDataModel.h"
#import "UserDefault.h"
#import "NetworkManger.h"
#define KLogin_Data  @"user_data"
@interface MyMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSMutableDictionary *dataDic;
@property(nonatomic,strong)UIButton *button;
@end

@implementation MyMessageViewController



-(NSMutableDictionary *)dataDic{
    if (!_dataDic) {
        self.dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.backgroundColor = [UIColor colorWithRed:0/255.0 green:153/255.0 blue:255/255.0 alpha:1.0];
    
    _button.layer.cornerRadius = 5.0;
    _button.clipsToBounds = YES;
    
    [_button setTitle:@"删除" forState:(UIControlStateNormal)];
    
    [_button addTarget:self action:@selector(handleShouCang:) forControlEvents:UIControlEventTouchUpInside ];
    
    _button.frame = CGRectMake(size_width-30, 0, 54, 30);
    
    //收藏按钮坐标调整
    //button.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, -40);
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]initWithCustomView:_button];
    
    self.navigationItem.rightBarButtonItem = menuButton;
    
    CGRect backframe = CGRectMake(0,0,54,30);
    UIButton* backButton= [[UIButton alloc] initWithFrame:backframe];
    backButton.backgroundColor = [UIColor colorWithRed:0/255.0 green:153/255.0 blue:255/255.0 alpha:1.0];
    backButton.layer.cornerRadius = 5.0;
    backButton.clipsToBounds = YES;
    
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    // backButton.titleLabel.font=[UIFont systemFontOfSize:17];
    [backButton addTarget:self action:@selector(doClickBackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;

    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self sourcePlease];
    
    
    
    
}

-(void)doClickBackAction:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}


//点击删除
-(void)handleShouCang:(id)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定删除该驾驶证吗" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        AppDelegate *app = CJXBAPP;
        NSArray *arr = [app searchMessageEntity];
        
        
       
        
        
            [app.managedObjectContext deleteObject:arr.firstObject];
            [app.managedObjectContext save:nil];
            
        
        
       // NSLog(@"%ld",[app searchMessageEntity].count);
        
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];

    
    
    
    
    
    
    

}






-(void)loadSubViews{
   UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size_width, 500)];
    
    self.tableView.tableHeaderView = headerView;
    
    
    HeaderFoundView *foundView = [[HeaderFoundView alloc]initWithFrame:CGRectMake(0, 0, size_width, 150)];
    
    AppDelegate *app = CJXBAPP;
    NSArray *arr = [app searchMessageEntity];
    MessageEntity *entity = [arr firstObject];
    foundView.CarNameLab.text =[NSString stringWithFormat:@"%@的驾驶证",entity.xm];
    
    if ([entity.zt isEqualToString:@"A"]) {
        [foundView.thingLab setFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:16]];
        foundView.thingLab.text = @"您的驾驶证一切正常";
        foundView.thingLab.textColor = [UIColor greenColor];
    }else{
        foundView.thingLab.text = @"您的驾驶证存在异常";
        foundView.thingLab.textColor = [UIColor redColor];
        [foundView.thingLab setFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:16]];
    }
    
    __weak MyMessageViewController *weakSelf = self;
    
    foundView.tapClcik = ^(NSString *string){
        if ([string isEqualToString:@"success"]) {
            [weakSelf sourcePlease];
            
         }
        };
    
    [headerView addSubview:foundView];
    
    MesgInfoView *mesgView1 = [[MesgInfoView alloc]initWithFrame:CGRectMake(0, foundView.y+foundView.height+5, size_width, 60)];
    
    mesgView1.nameLab.text = @"扣分情况";
    NSInteger syCount = 12-[entity.ljjf integerValue];
    
    mesgView1.infoLab.text = [NSString stringWithFormat:@"已扣除积分:%@",entity.ljjf];
    
    mesgView1.timeLab.text = [NSString stringWithFormat:@"剩余积分:%ld",(long)syCount];
    
    [headerView addSubview:mesgView1];
    
    MesgInfoView *mesgView2 = [[MesgInfoView alloc]initWithFrame:CGRectMake(0, mesgView1.y+mesgView1.height+5, size_width, 60)];
    
    mesgView2.colorView.backgroundColor = [UIColor magentaColor];
    
    mesgView2.nameLab.text = @"清分日期";
    
    
    
    NSString *b2 = [entity.qfrq substringWithRange:NSMakeRange(5, 2)]; //月份
    NSString *b3 = [entity.qfrq substringWithRange:NSMakeRange(8, 2)]; //日子
    
    mesgView2.infoLab.text = [NSString stringWithFormat:@"每年的%@月%@日",b2,b3];
    
    mesgView2.timeLab.text = @"到期清零";
    
    [headerView addSubview:mesgView2];
    
    MesgInfoView *mesgView3 = [[MesgInfoView alloc]initWithFrame:CGRectMake(0, mesgView2.y+mesgView2.height+5, size_width, 60)];
    
    mesgView3.colorView.backgroundColor = [UIColor orangeColor];
    mesgView3.nameLab.text = @"审验日期";
    
    NSString *b4 = [entity.syrq substringToIndex:10];
    mesgView3.infoLab.text =b4;
    
    NSString *b5 = [self getUTCFormateDate:entity.syrq];
    
    mesgView3.timeLab.text = [NSString stringWithFormat:@"距离审证还有%@",b5];
    
    [headerView addSubview:mesgView3];
    
    MesgInfoView *mesgView4 = [[MesgInfoView alloc]initWithFrame:CGRectMake(0, mesgView3.y+mesgView3.height+5, size_width, 60)];
    mesgView4.colorView.backgroundColor = [UIColor greenColor];
    mesgView4.nameLab.text = @"有效期至";
    NSString *b6 = [entity.yxqz substringToIndex:10];
    mesgView4.infoLab.text = b6;
    
    NSString *b7 = [self getUTCFormateDate:entity.yxqz];
    mesgView4.timeLab.text = [NSString stringWithFormat:@"距离换证还有%@",b7];
    [headerView addSubview:mesgView4];
    [self hidenHUD];
    sleep(2);
    [foundView.layer removeAllAnimations];
}


//数据请求
-(void)sourcePlease{
    [self showHUDWith:@"小帮加载中..."];
    NSURL *url = [NSURL URLWithString:@"http://app1.henanga.gov.cn/jmt/app/trafficInfo_selectJSYWZXX"];
    //第二步，创建请求
    AppDelegate *app = CJXBAPP;
    
    NSArray *arr = [app searchMessageEntity];
    //NSLog(@"驾驶证%ld",arr.count);
    MessageEntity *entity = [arr firstObject];
    
    NSString *postStr = [[NSString alloc] initWithFormat:@"{\"SFZMHM\":\"%@\",\"DABH\":\"%@\",\"pageNo\":\"1\"}",entity.sfzmhm,entity.dabh];
    
    NSString *requeststr = [[NSString alloc] initWithFormat:@"auth=%@&info=%@", [StringUtils getAuthJsonObject:postStr],postStr];
    
    //NSLog(@"%@",postStr);
    
    NSData *postData = [requeststr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    //创建网络会话配置对象
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    //发起任务
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    [dataTask resume];


}

//接收到服务器回应的时候调用此方法
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
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
didCompleteWithError:(nullable NSError *)error{
    if (error==nil) {
        NSString *receiveStr = [[NSString alloc]initWithData:self.receivData encoding:NSUTF8StringEncoding];
        NSString *b  =[NSString stringWithFormat:@"%@",receiveStr];
        NSDictionary  *parserData = [b objectFromJSONString];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:parserData[@"resultData"]];
        MessageData *model = [[MessageData alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        AppDelegate *app = CJXBAPP;
        if ([app searchMessageEntity].count==0) {
            [app addMessageEntity:model];
            
        }else{
            
            [app updataMessage:model.ljjf with:model.zt];
            
        }
        /*
         NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
         
         //对取出的cookie进行反归档处理
         NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:@"kUserDefaultsCookie"]];
         
         if (cookies) {
         // NSLog(@"有cookie");
         //设置cookie
         NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
         for (id cookie in cookies) {
         [cookieStorage setCookie:(NSHTTPCookie *)cookie];
         }
         }else{
         //  NSLog(@"无cookie");
         
         }
         
         NSData *data = [userDefaults objectForKey:KLogin_Data];
         LoginDataModel *usermodel = [[LoginDataModel alloc]init];
         if (data) {
         usermodel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
         
         NSDictionary *parDic = @{@"exec":@"uploadjszinfo",@"dabh":model.dabh,@"jszh":model.sfzmhm,@"xm":model.xm,@"zjcx":model.zjcx,@"qfrq":model.qfrq,@"syrq":model.syrq,@"syyxqz":model.yxqs,@"yxqz":model.yxqz,@"ljjf":model.ljjf,@"sjhm":usermodel.mobile};
         
         [NetworkManger requestPOSTWithURLStr:@"http://x.xiaobang520.com/Sys/syshandler.ashx" parmDic:parDic finish:^(id responseObject) {
         //[MyMessageViewController showAlertMessageWithMessage:responseObject[@"Message"] duration:1.0];
         } enError:^(NSError *error) {
         
         }];
         }else{
         usermodel = nil;
         }
         
         */
        
        
        
        //传完之后调用界面
        [self loadSubViews];
        
    }else{
        HeaderFoundView *foundView = [[HeaderFoundView alloc]init];
        sleep(2);
        [self hidenHUD];
        [foundView.layer removeAllAnimations];
        
        [self loadSubViews];
        
    }
    
}



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



-(NSString *)getUTCFormateDate:(NSString *)newsDate
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSDate *newsDateFormatted = [dateFormatter dateFromString:newsDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate* current_date = [[NSDate alloc] init];
    
    NSTimeInterval time=[current_date timeIntervalSinceDate:newsDateFormatted];//间隔的秒数
    int month=((int)time)/(3600*24*30);
    int days=((int)time)/(3600*24);
    int hours=((int)time)%(3600*24)/3600;
    int minute=((int)time)%(3600*24)/60;
    
    
    NSString *dateContent;
    
    if(month!=0){
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",month,@"个月"];
        
    }else if(days!=0){
    
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",days,@"天"];
    }else if(hours!=0){
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",hours,@"小时"];
    }else {
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",minute,@"分钟"];
    }
    
    return dateContent;
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
