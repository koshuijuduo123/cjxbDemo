//
//  AboutMyInfoMessageViewController.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 17/4/28.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "AboutMyInfoMessageViewController.h"
#import "MyCarTypeTableViewCell.h"
#import "MyWKWebViewController.h"
@interface AboutMyInfoMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *gongSiName;
@property(nonatomic,strong)NSMutableArray *dataSourceArr;
@end
static NSString *const MYCell = @"MYCell";
@implementation AboutMyInfoMessageViewController

-(NSArray *)dataSourceArr{
    if (!_dataSourceArr) {
        self.dataSourceArr = [NSMutableArray new];
    }
    return _dataSourceArr;
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
    self.view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    UIView *footView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footView;
    //设置cell分割线颜色
    [_tableView setSeparatorColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0]];
    //注册自定义cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCarTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyCarTypeTableViewCell"];
    
[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MYCell];
    self.title = @"关于我们";
    self.gongSiName.text = GongSiName;
   
    _dataSourceArr = @[@"小帮简介",@"我们的网站",@"用户协议",@"隐私政策",@"小帮的感谢信"].mutableCopy;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self hsUpdateNewApp];
       
    });
    
    
   
   
}


#pragma maek-UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        
        return self.dataSourceArr.count;
    }
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        MyCarTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCarTypeTableViewCell" forIndexPath:indexPath];
        cell.imgView.image = [UIImage imageNamed:@"xiaobangLogo"];
        cell.titleLab.text = @"车驾小帮 无所不帮";
        cell.titleLab.textColor = [UIColor orangeColor];
        NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];//为当前工程项目版本号
        cell.contentLab.text =[NSString stringWithFormat:@"版本:%@",currentVersion];
        
        if (size_width<375) {
            [cell.titleLab setFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:18]];
            [cell.contentLab setFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:10]];
            
        }else{
            [cell.titleLab setFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:20]];
            [cell.contentLab setFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:12]];
        }
        
        return cell;
        
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MYCell forIndexPath:indexPath];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = _dataSourceArr[indexPath.row];
        if (indexPath.row==5) {
            cell.imageView.image = [UIImage imageNamed:@"new"];
        }else{
            cell.imageView.image = nil;
        }
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyWKWebViewController *myWebVC =[[MyWKWebViewController alloc]init];
    if (indexPath.section==1) {
        if (indexPath.row==0) {
         myWebVC.loadUrl =@"https://h5.youzan.com/v2/feature/bndc1l4n";
            myWebVC.title = @"小帮简介";
        }
        
        if (indexPath.row==1) {
            myWebVC.loadUrl = @"http://www.xiaobang520.com";
        }
        
        if (indexPath.row==2) {
            myWebVC.loadUrl =@"https://h5.youzan.com/v2/feature/19w5w0v04";
            myWebVC.title = @"用户协议";
        }
        
        if (indexPath.row==3) {
            myWebVC.loadUrl = @"https://h5.youzan.com/v2/feature/ihv922pp";
            myWebVC.title = @"隐私声明";
        }
        
        
        if (indexPath.row==4) {
            myWebVC.loadUrl = @"https://h5.youzan.com/v2/feature/nk5k5ako";
            myWebVC.title = @"小帮感谢信";
        }
        if (indexPath.row==5) {
            NSString *storeAppID = @"1163572663";
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", storeAppID]];
            [[UIApplication sharedApplication] openURL:url];
            return;
        }
        
        myWebVC.aoutMyMessage = @"aboutMyMessage";
        [self.navigationController pushViewController:myWebVC animated:YES];
    }
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 100;
    }else{
        return 60;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 20;
    }else{
        return 0;
    }
}

-(void)hsUpdateNewApp{
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
[_dataSourceArr addObject:[NSString stringWithFormat:@"发现新版本:%@",dic[@"version"]]];

}else{
    
}
    
}


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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
