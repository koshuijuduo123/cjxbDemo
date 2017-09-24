//
//  MyNewsViewController.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 17/3/10.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "MyNewsViewController.h"
#import "AppDelegate.h"
#import "NewsTableViewCell.h"
#import "MyLoveNewsEntity.h"
#import "WebViewController.h"
#import "LoginDataModel.h"
#import "UserDefault.h"
#import "IMYWebView.h"
@interface MyNewsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation MyNewsViewController
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
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
    self.title = @"我的收藏";
    self.tableView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewsTableViewCell"];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    AppDelegate *app = CJXBAPP;
    self.dataSource = [NSMutableArray arrayWithArray:[app searchMyNewsforEntity]];
    if (!_dataSource.count) {
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"暂无数据.png"]];
        imgView.frame = CGRectMake(0, 0, size_width, size_height);
        [self.view addSubview:imgView];
        
    }
    
    
}

#pragma mark - tableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsTableViewCell" forIndexPath:indexPath];
    MyLoveNewsEntity *entity = self.dataSource[indexPath.row];
    [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:entity.imgUrl] placeholderImage:[UIImage imageNamed:@"zwt"]];
    cell.titleLab.text = entity.title;
    cell.timeLab.text = entity.timeAdd;
    cell.zhuanfaImg.hidden = YES;
    cell.baoCountLab.hidden = YES;
    cell.chatCountLab.hidden = YES;
    cell.countImg.hidden = YES;
    cell.chatImg.hidden  = YES;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (size_width<=320) {
        return 100;
    }else if(size_width==375){
        return 100;
    }else{
        return 110;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    MyLoveNewsEntity *entity = self.dataSource[indexPath.row];
    AppDelegate *app = CJXBAPP;
    [app.managedObjectContext deleteObject:entity];
    [self.dataSource removeObject:entity];
    [app.managedObjectContext save:nil];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
    
    if (!self.dataSource.count) {
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"暂无数据.png"]];
        imgView.frame = CGRectMake(0, 0, size_width, size_height);
        [self.view addSubview:imgView];
    }
    [self.tableView reloadData];
}
//设置删除键的名字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删 除";
}
//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WebViewController *webVC = [[WebViewController alloc]init];
    
    webVC.releareMyNews = ^(NSString *string){
       
        if (string.length) {
            [self.dataSource removeObjectAtIndex:indexPath.row];
            
            [self.tableView reloadData];
            
        }
    };
    
    
    
    webVC.hidesBottomBarWhenPushed = YES;
    webVC.shareHiddnBtn = YES;
    MyLoveNewsEntity *entity = self.dataSource[indexPath.row];
    
    NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"]];
    
    
    
    webVC.webView = [[IMYWebView alloc]initWithFrame:CGRectMake(0, 0, size_width, size_height-64-44-6)];
    [webVC.view addSubview:webVC.webView];
    
    [webVC.view bringSubviewToFront:webVC.backView];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:entity.newsUrl]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookieStorage setCookies:cookies forURL:[NSURL URLWithString:entity.newsUrl] mainDocumentURL:nil];
    
    NSMutableString *cookieString = [[NSMutableString alloc] init];
    
    if (cookies.count) {
        
        NSHTTPCookie *currentCookie= [[NSHTTPCookie alloc] init];
        
        for (NSHTTPCookie*cookie in [cookieStorage cookies]) {
            
            currentCookie = cookie;
            //多个字段之间用“；”隔开
            [cookieString appendFormat:@"%@=%@;",cookie.name,cookie.value];
            
            
        }
        //删除最后一个“；”
        [cookieString deleteCharactersInRange:NSMakeRange(cookieString.length - 1, 1)];
        
        NSString *cookie = [NSString stringWithFormat:@"%@",cookieString];
        
        [request addValue:cookie forHTTPHeaderField:@"Cookie"];
    }
    
    
    [webVC.webView loadRequest:request];
    
    
    
    
    
    webVC.titleLab = entity.title;
    UIImageView *imgView = [[UIImageView alloc]init];
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:entity.imgUrl]];
    
    
    
    webVC.titleImg = imgView.image;
    
    webVC.articleId = entity.newId;
    
    webVC.qiandao = @"YES";
    webVC.isMyNewsIn = YES;//设定收藏列表进入
    
    [self.navigationController pushViewController:webVC animated:YES];
    

    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
