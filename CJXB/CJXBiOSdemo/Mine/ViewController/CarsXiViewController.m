//
//  CarsXiViewController.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 17/2/22.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "CarsXiViewController.h"
#import "MJExtension.h"
#import "NetworkManger.h"
#import "CarsXingViewController.h"
#import "CarXiModel.h"
#import "MyCarModel.h"
@interface CarsXiViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *coreView;

@property(nonatomic,strong)NSMutableArray *carXiFataArray;
@end
static NSString * const JGCell = @"CarXiCell";
@implementation CarsXiViewController

-(NSMutableArray *)carXiFataArray{
    if (!_carXiFataArray) {
        self.carXiFataArray = [NSMutableArray array];
    }
    return _carXiFataArray;
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
    UIView *footView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footView;
    self.title = @"选择车系";
    _tableView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
     [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:JGCell];
    [self loadData];
}

-(void)loadData{
     [self showHUDWith:@"小帮加载中..."];
    
    NSString *URL = [NSString stringWithFormat:@"https://comm.app.autohome.com.cn/comm_v1.0.0/ashx/series-pm2-b%@-t8.json",self.carXiid];
    [NetworkManger requestGETWithURLStr:URL parmDic:nil finish:^(id responseObject) {
        
        NSDictionary *dict = responseObject[@"result"];
        NSArray *arr1 = dict[@"fctlist"];
        NSArray *arr2 = dict[@"otherlist"];
        NSMutableArray *allArr = [NSMutableArray array];
        for (NSDictionary*dict in arr1) {
            [allArr addObject:dict];
        }
        for (NSDictionary *dict in arr2) {
            [allArr addObject:dict];
        }
        
        self.carXiFataArray = [CarXiModel objectArrayWithKeyValuesArray:allArr];
        
        [self hidenHUD];
        
        if (self.carXiFataArray.count>0) {
            self.coreView.hidden = YES;
            [self.tableView reloadData];
            
        }else{
            UIImageView *noDataImg = [[UIImageView alloc]initWithFrame:self.coreView.frame];
            noDataImg.image = [UIImage imageNamed:@"暂无数据.png"];
            [self.coreView addSubview:noDataImg];
        }
        
        
    } enError:^(NSError *error) {
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.carXiFataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CarXiModel *model = self.carXiFataArray[section];
    return model.serieslist.count;
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    CarXiModel *model = self.carXiFataArray[section];
    return model.name;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JGCell forIndexPath:indexPath];
    CarXiModel *model = self.carXiFataArray[indexPath.section];
    CarXi *carXi = model.serieslist[indexPath.row];
    cell.textLabel.text = carXi.name;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CarXiModel *model = self.carXiFataArray[indexPath.section];
    CarXi *carXi = model.serieslist[indexPath.row];
    CarsXingViewController *carXingVC = [[CarsXingViewController alloc]init];
    carXingVC.carXingid = carXi.carXiId;
    MyCarModel *myModel = [MyCarModel shareInstance];
    myModel.carName = carXi.name;
    [self.navigationController pushViewController:carXingVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
