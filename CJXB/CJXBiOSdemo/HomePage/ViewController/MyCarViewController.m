//
//  MyCarViewController.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/9.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "MyCarViewController.h"
#import "CarEntity.h"
#import "CarModel.h"
#import "MyCarTableViewCell.h"
#import "AppDelegate.h"
#import "CarViewController.h"
#import "CarInfoViewController.h"
#import "MyCarHeaderView.h"

@interface MyCarViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataSource;//储存从coreData取出的数据

@property(nonatomic,strong)UIButton *button;


@end

@implementation MyCarViewController

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
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSIndexSet *index = [[NSIndexSet alloc]initWithIndex:0];
    [self.tableView reloadSections:index withRowAnimation:UITableViewRowAnimationAutomatic];
    
}





- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCarTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyCarTableViewCell"];
    _tableView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    self.title = @"我的车库";
    AppDelegate *app = CJXBAPP;
    
    self.dataSource =[NSMutableArray arrayWithArray:[app searchMovieEntiity]];
    
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.backgroundColor = [UIColor colorWithRed:0/255.0 green:153/255.0 blue:255/255.0 alpha:1.0];
    
    _button.layer.cornerRadius = 5.0;
    _button.clipsToBounds = YES;
    
    [_button setTitle:@"添加" forState:(UIControlStateNormal)];
    
    [_button addTarget:self action:@selector(handleShouCang:) forControlEvents:UIControlEventTouchUpInside ];
    
    _button.frame = CGRectMake(size_width-30, 0, 54, 30);
    
    //收藏按钮坐标调整
    //button.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, -40);
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]initWithCustomView:_button];
    
    
    if ([app searchMovieEntiity].count>4) {
        _button.hidden = YES;
    }else{
        _button.hidden = NO;
    }
    
    
    
    self.navigationItem.rightBarButtonItem = menuButton;
    
    
    //去掉cell之间的分隔线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    CGRect backframe = CGRectMake(0,0,54,30);
    UIButton* backButton= [[UIButton alloc] initWithFrame:backframe];
    backButton.backgroundColor = [UIColor colorWithRed:0/255.0 green:153/255.0 blue:255/255.0 alpha:1.0];
    backButton.layer.cornerRadius = 5.0;
    backButton.clipsToBounds = YES;
    
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
   
    [backButton addTarget:self action:@selector(doClickBackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    
    
}
-(void)doClickBackAction:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}


//点击添加
-(void)handleShouCang:(id)sender{
    CarViewController *carVC = [[CarViewController alloc]init];
    
    [self.navigationController pushViewController:carVC animated:YES];
    
}




#pragma mark - UItableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCarTableViewCell" forIndexPath:indexPath];
        
    
    //取出展示数据
    CarEntity *entity = self.dataSource[indexPath.row];
    
    cell.carLabel.text = entity.hphm;
    
    cell.carSystemlab.text = entity.hpzl;
    
    
    cell.feiZlab.text = [NSString stringWithFormat:@"未处理违章数:%@次",entity.count];
    
    cell.moneylab.text = [NSString stringWithFormat:@"%@【仅供参考】",entity.fkje];
    
    cell.pointLab.text = entity.wfjfs;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    CarEntity *entity = self.dataSource[indexPath.row];
    AppDelegate *app = CJXBAPP;
    [app.managedObjectContext deleteObject:entity];
    [self.dataSource removeObject:entity];
    [app.managedObjectContext save:nil];
    
    if ([app searchMovieEntiity].count>4) {
        self.button.hidden = YES;
    }else{
        self.button.hidden = NO;
    }
    
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
    
    [self.tableView reloadData];
    
}
//设置删除键的名字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"丢 弃";
}



//点击cell触发
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CarEntity *entity = self.dataSource[indexPath.row];
    
    CarInfoViewController *infoVC = [[CarInfoViewController alloc]init];
    infoVC.hm = entity.hp;
    infoVC.mm = entity.mm;
    infoVC.lz = entity.lz;
    [self.navigationController pushViewController:infoVC animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MyCarHeaderView *headerView = [[MyCarHeaderView alloc]initWithFrame:CGRectMake(0, 0, size_width, 40)];
    
    AppDelegate *app = CJXBAPP;
    
      NSInteger number  = [app searchMovieEntiity].count;
    
    headerView.coreLab.text = [NSString stringWithFormat:@"常用机动车【%ld】辆，最多可设置5辆",number];
    return headerView;
}





-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
