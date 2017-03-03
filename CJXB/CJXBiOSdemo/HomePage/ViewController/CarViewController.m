//
//  CarViewController.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/4.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "CarViewController.h"
#import "JSONKit.h"

#import "MyMD5.h"
#import "StringUtils.h"
#import "NetworkManger.h"
#import "ResultData.h"
#import "MyCarViewController.h"
#import "AppDelegate.h"
#import "CarEntity.h"
#import "CarModel.h"
#import "CarInfoViewController.h"
#import "UserDefault.h"

@interface CarViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFirld;//车号

@property (weak, nonatomic) IBOutlet UITextField *maTextFirld;//车架号
@property (weak, nonatomic) IBOutlet UITextField *systemTextFirld;//车的类型
@property (weak, nonatomic) IBOutlet UIPickerView *systemPickView;//选择体

@property(nonatomic,strong)NSArray *proTitleList;

@property(nonatomic,strong)CarModel *carModel;

@property(nonatomic,strong)NSMutableArray *dasourceArray;//存放model的数组

@property(nonatomic,copy)NSString *stringlz;//类型代号；
@end

@implementation CarViewController

-(NSMutableArray *)dasourceArray{
    if (!_dasourceArray) {
        self.dasourceArray = [NSMutableArray array];
    }
    return _dasourceArray;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.systemPickView.delegate = self;
    self.systemPickView.dataSource = self;
    self.systemTextFirld.delegate = self;
    self.phoneTextFirld.delegate = self;
    self.maTextFirld.delegate = self;
    self.systemPickView.hidden = YES;
    self.systemTextFirld.tag=666;
    self.proTitleList = [[NSArray alloc]initWithObjects:@"大型汽车",@"小型汽车",@"普通摩托车",@"轻便摩托车",@"低速车",@"挂车",@"教练车",nil];
    self.title = @"机动车信息";
    
    
    
    
}




//确定按钮
- (IBAction)putButtonAction:(UIButton *)sender {
    
    if (self.phoneTextFirld.text.length==0||self.maTextFirld.text.length==0||self.systemTextFirld.text.length==0) {
        [CarViewController showAlertMessageWithMessage:@"内容不能为空" duration:2.0];
        return;
    }
    
   
//    NSString *carRegex =@"^[\u4e00-\u9fa5]{1}[A-Z]{1}[A-Z_0-9]{5}$";
//    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
//    
//    if (![carTest evaluateWithObject:[NSString stringWithFormat:@"豫G%@",_phoneTextFirld.text]]) {
//        [CarViewController showAlertMessageWithMessage:@"车牌号码格式错误" duration:1.0];
//        
//        return;
//    }
    
    NSString *carNum = @"^[0-9]{6}";
    NSPredicate *carnum = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carNum];
    if (![carnum evaluateWithObject:[NSString stringWithFormat:@"%@",_maTextFirld.text]]) {
        [CarViewController showAlertMessageWithMessage:@"识别代号格式错误" duration:1.0];
        
        return;
    }
    
    AppDelegate *app = CJXBAPP;
    
    //遍历防止重复添加
    for (CarEntity *entity in [app searchMovieEntiity]) {
        NSString *string = [NSString stringWithFormat:@"豫%@",self.phoneTextFirld.text];
        if ([entity.hphm isEqualToString:string]) {
            
             [CarViewController showAlertMessageWithMessage:@"此车辆已入库，换辆看看" duration:2.0];
            
            
            
            return;

        }
    }
    
    if ([app searchMovieEntiity].count>4) {
         [CarViewController showAlertMessageWithMessage:@"车位已满，小帮也无能为力" duration:2.0];
        
        
        
        
        
        return;

    }
    
    
    [self showHUDWith:@"车辆验证中..."];
    
    //第一步，创建url
    NSURL *url = [NSURL URLWithString:@"http://app1.henanga.gov.cn/jmt/app/trafficInfo_selectJDCWZXX"];
    //NSURL *url = [NSURL URLWithString:@"http://117.158.5.51:89/jmt/app/trafficInfo_selectJDCWZXX"];
    //第二步，创建请求
    NSString *MaString = [self.phoneTextFirld.text substringToIndex:1];
    NSString *NumberString = [self.phoneTextFirld.text substringFromIndex:1];
    
    NSString *postStr = [[NSString alloc] initWithFormat:@"{\"HPZL\":\"%@\",\"FZJG\":\"豫%@\",\"HPHM\":\"%@\",\"CLSBDH\":\"%@\",\"FDJH\":\"\",\"pageNo\":\"1\"}",self.stringlz,MaString,NumberString,[self.maTextFirld text]];
    
    NSString *requeststr = [[NSString alloc] initWithFormat:@"auth=%@&info=%@", [StringUtils getAuthJsonObject:postStr],postStr];
    
    
    
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
    //允许收到响应后,继续接收数据,如果不写,后面代理方法无法执行
    completionHandler(NSURLSessionResponseAllow);
   
}

//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    
    [self.receivData appendData:data];
    
    
}

//数据传完之后调用此方法
//任务完成时(无论成功和失败这个方法都会走)
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
     AppDelegate *app = CJXBAPP;
   // NSLog(@"数据传输完成，输出所有数据结果。。。");
    if (error==nil) {
        NSString *receiveStr = [[NSString alloc]initWithData:self.receivData encoding:NSUTF8StringEncoding];
        
        //切割后余下的数据
        NSString *b = [NSString stringWithFormat:@"%@",receiveStr];
        if ([b containsString:@"没有该车牌的信息"]) {
            [self hidenHUD];
            [CarViewController showAlertMessageWithMessage:@"没有该车牌的信息" duration:1.0];
            return;
        }
        
        if ([b containsString:@"车辆识别号错误"]) {
            [self hidenHUD];
            [CarViewController showAlertMessageWithMessage:@"车辆识别号错误" duration:1.0];
            return;
        }
        if ([b containsString:@"服务校验不通过"]) {
            [self hidenHUD];
            [CarViewController showAlertMessageWithMessage:@"服务校验不通过" duration:1.0];
            return;
        }
        
        
        
        //解析数据，用字典接
        NSDictionary *parserDic = [b objectFromJSONString];
        
        NSArray *array = [parserDic objectForKey:@"resultData"];
        
        self.carModel = [[CarModel alloc]init];
        
        _carModel.count = [NSString stringWithFormat:@"%lu",(unsigned long)array.count];
        
        _carModel.cphm = [NSString stringWithFormat:@"豫%@",self.phoneTextFirld.text];
        _carModel.cpzl = [NSString stringWithFormat:@"【%@】",self.systemTextFirld.text];
        
        _carModel.hp = self.phoneTextFirld.text;
        _carModel.mm = self.maTextFirld.text;
        
        NSInteger jfs = 0;
        NSInteger jes = 0;
        for (NSDictionary *dic in array) {
            ResultData *model = [[ResultData alloc]init];
            
            if (_carModel.zl==nil) {
                
                _carModel.zl = dic[@"hpzl"];
            }
            
            [model setValuesForKeysWithDictionary:dic];
            [self.dasourceArray addObject:model];
            
            jfs  = jfs+[dic[@"wfjfs"] integerValue];
            
            jes = jes + [dic[@"fkje"] integerValue];
            
            
            
        }
        
        _carModel.fkjf =[NSString stringWithFormat:@"%ld",(long)jfs];
        _carModel.fkje =[NSString stringWithFormat:@"%ld",(long)jes];
        
        
        //存储数据
        [app addMovEntiityWith:_carModel];
        [self hidenHUD];
        
        //取出保存的cookie
       // NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
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
            
            NSDictionary *dic = @{@"hphm":[self.phoneTextFirld.text substringFromIndex:1],@"hpzl":_carModel.zl,@"sbdh":self.maTextFirld.text,@"fkje":_carModel.fkje,@"wfjfs":_carModel.fkjf,@"wfsl":_carModel.count};
            
            LoginDataModel *userModel = [UserDefault getUserInfo];
            //登录状态上传数据
            NSDictionary *parmDic =@{@"chelist":@[dic],@"username":userModel.username,@"password":userModel.password};
            
            
            [NetworkManger requestPOSTWithURLStr:@"http://x.xiaobang520.com/Sys/syshandler.ashx?exec=uploadcarinfo" parmDic:parmDic finish:^(id responseObject) {
                [CarViewController showAlertMessageWithMessage:responseObject[@"Message"] duration:1.0];
            } enError:^(NSError *error) {
                
            }];
            
        }else{
        }
        */
        
        MyCarViewController *myVC = [[MyCarViewController alloc]init];
        
        
        [self.navigationController pushViewController:myVC animated:YES];
        
        
    }else{
        [self hidenHUD];
        
        [CarViewController showAlertMessageWithMessage:@"车辆绑定失败，稍后再试" duration:2.0];
        
    }
}


#pragma mark - pickView代理
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
        return [_proTitleList count];
    
    
    
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return 180;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}




// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
   NSString  *proNameStr = [_proTitleList objectAtIndex:row];
    
    self.stringlz = [NSString stringWithFormat:@"0%ld",row+1];
    
    self.systemTextFirld.text = proNameStr;
   
    
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
        return [_proTitleList objectAtIndex:row];
    
}


#pragma TextFirld代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
        return [textField resignFirstResponder];
    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==666) {
        self.systemPickView.hidden = NO;
        return [self.view endEditing:YES];
    }else{
        self.systemPickView.hidden = YES;
        return YES;
    }
}




-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField.tag==666) {
        [textField resignFirstResponder];
        
        self.systemPickView.hidden = NO;
        
    }else{
        
        self.systemPickView.hidden = YES;
    }
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
