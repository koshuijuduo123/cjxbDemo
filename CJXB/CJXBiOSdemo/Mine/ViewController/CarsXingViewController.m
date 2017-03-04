//
//  CarsXingViewController.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 17/2/22.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "CarsXingViewController.h"
#import "MJExtension.h"
#import "NetworkManger.h"
#import "CarXingModel.h"
#import "MyCarModel.h"
#import "CarsInfoViewController.h"
@interface CarsXingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *coreView;
@property(nonatomic,strong)NSMutableArray *carXingDataArray;
@end
static NSString * const JGCell = @"CarXingCell";
@implementation CarsXingViewController
-(NSMutableArray *)carXingDataArray{
    if (!_carXingDataArray) {
        self.carXingDataArray = [NSMutableArray array];
    }
    return _carXingDataArray;
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
    self.title = @"选择车型";
    UIView *footView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footView;
    _tableView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
     [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:JGCell];
    [self loadData];
}

-(void)loadData{
    [self showHUDWith:@"小帮加载中..."];
    NSString *URL = [NSString stringWithFormat:@"https://comm.app.autohome.com.cn/comm_v1.0.0/ashx/spec-pm2-ss%@-t8.json",self.carXingid];
    [NetworkManger requestGETWithURLStr:URL parmDic:nil finish:^(id responseObject) {
        
        NSDictionary *dict = responseObject[@"result"];
        NSArray *array1 = dict[@"list"];
        NSArray *array2 = dict[@"otherlist"];
        NSMutableArray *allArr = [NSMutableArray array];
        for (NSDictionary *dict in array1) {
            [allArr addObject:dict];
        }
        for (NSDictionary *dict in array2) {
            [allArr addObject:dict];
        }
        self.carXingDataArray = [CarXingModel objectArrayWithKeyValuesArray:allArr];
        [self hidenHUD];
        
        if (self.carXingDataArray.count>0) {
            self.coreView.hidden = YES;
            [self.tableView reloadData];
            
        }else{
            
            UIImageView *noDataImg = [[UIImageView alloc]initWithFrame:self.coreView.frame];
            noDataImg.image = [UIImage imageNamed:@"暂无数据.png"];
            [self.coreView addSubview:noDataImg];
        }
        
        
        
    } enError:^(NSError *error) {
        [self hidenHUD];
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.carXingDataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CarXingModel *model = self.carXingDataArray[section];
    return model.speclist.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    CarXingModel *model = self.carXingDataArray[section];
    return model.name;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JGCell forIndexPath:indexPath];
    CarXingModel *model  = self.carXingDataArray[indexPath.section];
    CarXing *carXing = model.speclist[indexPath.row];
    cell.textLabel.text = carXing.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CarXingModel *model = self.carXingDataArray[indexPath.section];
    CarXing *carXing = model.speclist[indexPath.row];
    MyCarModel *myModel = [MyCarModel shareInstance];
    myModel.carXing = carXing.name;
    myModel.carDang = carXing.carDang;
    myModel.carPrice = carXing.price;
    CarsInfoViewController *carInfoVC = [[CarsInfoViewController alloc]init];
    [self.navigationController pushViewController:carInfoVC animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
