//
//  CarsInfoViewController.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 17/3/4.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "CarsInfoViewController.h"
#import "MyCarModel.h"
#import "WebViewController.h"
#import "IMYWebView.h"
@interface CarsInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
static NSString *const ImgCell = @"ImgCell";

@implementation CarsInfoViewController
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
    self.title = @"车型详情";
    self.view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ImgCell];
    
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.tableView.tableFooterView = footView;
}

//保养此车型
- (IBAction)addCarTypeAction:(UIButton *)sender {
    WebViewController *webVC = [[WebViewController alloc]init];
    webVC.hidesBottomBarWhenPushed = YES;
    webVC.isUIWebView = YES;
    webVC.isPushExtcl = YES;
    webVC.title = @"保养预约";
    webVC.webView = [[IMYWebView alloc]initWithFrame:CGRectMake(0, 0, size_width, size_height-64) usingUIWebView:YES];
    [webVC.view addSubview:webVC.webView];
    NSString *string5 = [NSString stringWithFormat:@"https://jinshuju.net/f/FAJgNj"];
    NSURL *url1 = [[NSURL alloc]initWithString:string5];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url1];
    [webVC.webView loadRequest:request];
    //webVC.qiandao = @"YES";
    
    [self.navigationController pushViewController:webVC animated:YES];
}



#pragma mark - UItableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if (section==1){
        return 1;
    }else{
        return 3;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
       return @"车辆品牌";
    }else if (section==1){
        return @"车系";
    }else{
        return @"车型";
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ImgCell forIndexPath:indexPath];
    MyCarModel *model = [MyCarModel shareInstance];
    
    if (indexPath.section==0) {
            if (indexPath.row==0) {
                UIImageView *carPinPaiImg = [[UIImageView alloc]init];
                [carPinPaiImg sd_setImageWithURL:[NSURL URLWithString:model.carImgUrl]placeholderImage:[UIImage imageNamed:@"zwt"]];
                cell.imageView.image = carPinPaiImg.image;
                cell.textLabel.text = model.carPinPai;
            }

        }
        
    if (indexPath.section==1) {
            
            if (indexPath.row==0) {
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.carPhotosImgUrl]placeholderImage:[UIImage imageNamed:@"zwt"]];
                cell.textLabel.text = model.carName;
            }
        }
    if (indexPath.section==2) {
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row==0) {
            cell.textLabel.text = model.carXing;
        }
        if (indexPath.row==1) {
            cell.textLabel.text = model.carDang;
        }
        if (indexPath.row==2) {
            cell.textLabel.text = [NSString stringWithFormat:@"市场价:%@",model.carPrice];
        }
    }
    
        return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {
        return 50;
    }else if(indexPath.section==0) {
        return 60;
    }else{
        return 80;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
