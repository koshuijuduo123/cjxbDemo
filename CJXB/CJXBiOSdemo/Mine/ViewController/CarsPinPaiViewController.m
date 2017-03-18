//
//  CarsPinPaiViewController.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 17/2/21.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "CarsPinPaiViewController.h"
#import "CarGroupModel.h"
#import "MyCarModel.h"
#import "LGUIView.h"
#import "MJExtension.h"
#import "NetworkManger.h"
#import "CarsXiViewController.h"
@interface CarsPinPaiViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *coreView;
@property(nonatomic,strong)NSArray *dataArrM;

@property(nonatomic,strong)LGUIView *lgView;
@end
static NSString * const JGCell = @"JGCell";
@implementation CarsPinPaiViewController
- (NSArray *)dataArrM {
    if (!_dataArrM) {
        self.dataArrM = [NSArray array];
    }
    return _dataArrM;
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
    self.title = @"选择品牌";
    self.view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:JGCell];
    [self loadData];
}


-(void)loadData{
    [self showHUDWith:@"小帮加载中...."];
    [NetworkManger requestGETWithURLStr:CarPinPai parmDic:nil finish:^(id responseObject) {
        NSDictionary *Bigdic = [NSDictionary dictionaryWithDictionary:responseObject];
        NSDictionary *smallDic = [NSDictionary dictionaryWithDictionary:Bigdic[@"result"]];
        self.dataArrM = [CarGroupModel objectArrayWithKeyValuesArray:[NSArray arrayWithArray:smallDic[@"brandlist"]]];
        [self creatLGView];
        
        [self hidenHUD];
        self.coreView.hidden = YES;
        [self.tableView reloadData];
    } enError:^(NSError *error) {
        [self hidenHUD];
    }];

}




-(void)creatLGView{
    
    NSMutableArray * arr = [NSMutableArray new];
    for (int i = 0; i < self.dataArrM.count; i ++)
    {
        CarGroupModel *group = [_dataArrM objectAtIndex:i];
        [arr addObject:group.letter];
    }
    
    
    
    self.lgView = [[LGUIView alloc]initWithFrame:CGRectMake(size_width-30, (size_height-500-44)/2, 30, 500) indexArray:arr];
    [self.view addSubview:_lgView];
    
    
    [_lgView selectIndexBlock:^(NSInteger section)
     {
         [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]
                                 animated:NO
                           scrollPosition:UITableViewScrollPositionTop];
     }];
    
    
}


#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArrM.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CarGroupModel *model = _dataArrM[section];
    return model.list.count;
}
//头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    CarGroupModel *group = [_dataArrM objectAtIndex:section];
    return group.letter;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JGCell forIndexPath:indexPath];
    
    CarGroupModel *group = [_dataArrM objectAtIndex:indexPath.section];
    Car *car = [group.list objectAtIndex:indexPath.row];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:car.imgurl] placeholderImage:[UIImage imageNamed:@"zwt"]];
    
    cell.textLabel.text = car.name;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CarGroupModel *group = [_dataArrM objectAtIndex:indexPath.section];
    Car *car = [group.list objectAtIndex:indexPath.row];
    CarsXiViewController *carXiVC = [[CarsXiViewController alloc]init];
    carXiVC.carXiid = car.carid;
    MyCarModel *model = [MyCarModel shareInstance];
    model.carPinPai = car.name;
    model.carImgUrl = car.imgurl;
    [self.navigationController pushViewController:carXiVC animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
