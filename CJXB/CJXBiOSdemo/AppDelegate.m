//
//  AppDelegate.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/25.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "AppDelegate.h"
#import "GuideViewController.h"
#import "UserDefault.h"
#import "CarModel.h"
#import "MessageModel.h"
#import "CarEntity.h"
#import "UMSocialWechatHandler.h"
#import "UMSocial.h"
#import "UserDefault.h"
#import "NetworkManger.h"
#import "ResultData.h"
#import "WebViewController.h"
#import "WeiZhangEntity.h"
#import "MessageEntity.h"
#import "MessageData.h"
#import "AFNetworking.h"
#import "MyLoveNewsEntity.h"
#import "LoginViewController.h"
#import "LoginDataModel.h"
#import "JWLaunchAd.h"
#import "MyNewsModel.h"



#import "MJExtension.h"
#import "IMYWebView.h"
#import <SMS_SDK/SMSSDK.h>
#import "YZSDK.h"
#import "UMCommunity.h"

static NSString *userAgent = @"1bd1cac4ba73df23c81490580437823";
static NSString *appID = @"10dc300fbf4f70e851";
static NSString *appSecret = @"764541f02fca5798d0e20b533c59aaca";
//#import <AVFoundation/AVFoundation.h>
@interface AppDelegate ()<UMSocialUIDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置AppID和AppSecret
    [YZSDK setOpenInterfaceAppID:appID appSecret:appSecret];
    //设置UA
    [YZSDK userAgentInit:userAgent version:@""];
    
    [UMCommunity setAppKey:UMAppKey withAppSecret:UMAppSecret];
    
    //后台收到消息推送之后处理消息
    /*
    NSDictionary *notificationDict = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if ([notificationDict valueForKey:@"umwsq"]) {//判断是否石友盟微社区的消息推送
        [UMComMessageManager startWithOptions:launchOptions];
        if ([notificationDict valueForKey:@"aps"]) // 点击推送进入
        {
            [UMComMessageManager didReceiveRemoteNotification:notificationDict];
        }
    } else {
        [UMComMessageManager startWithOptions:nil];
        //使用你的消息通知处理
    }
     */
   //初始化应用，appKey和appSecret从后台申请得
    [SMSSDK registerApp:SMSAppKey withSecret:SMSSecret];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:WXAPPID appSecret:WXAPPSecret url:@"http://www.xiaobang520.com"];
    //判断当前应用启动的次数，是否是第一次启动
    [UserDefault initDefaults];//先初始化
    
    if ([[UserDefault getLunchTimes] integerValue]==1) {
        //等于1说明第一次启动，要添加引导页
        GuideViewController *guideVC = [[GuideViewController alloc]init];
        //设置引导页的图片
        guideVC.imageArray = @[@"new_feature_1",@"new_feature_2",@"new_feature_3"];  
        //将当前的window的根视图设置为定义对象
        self.window.rootViewController = guideVC;
    }else{
       [self WZXLaunchView];
    }
    
    
    
    //更新启动次数
    [UserDefault setLaunchTimes:[NSString stringWithFormat:@"%ld",[[UserDefault getLunchTimes]integerValue]+1]];
    
    
    
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        
        [UINavigationBar appearance].translucent = NO;
        //状态栏控件白色
        [UINavigationBar appearance].barStyle = UIBarStyleBlackOpaque;
        
        [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:255/255.0 green:132/255.0 blue:1/255.0 alpha:1.0]];
        
        
       
        [[UINavigationBar appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:[UIColor purpleColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:17.0], NSFontAttributeName, nil]];
    }
    
    LoginViewController *logVC = [[LoginViewController alloc]init];
    [UMComLoginManager setLoginHandler:(id<UMComLoginDelegate>)logVC];
    

    return YES;
}



-(void)WZXLaunchView{
    
    //2.初始化启动页广告(初始化后,自动添加至视图,不用手动添加)
        [JWLaunchAd initImageWithAttribute:8.0 hideSkip:NO setLaunchAd:^(JWLaunchAd *launchAd,id responseObject) {
            __block JWLaunchAd *weakSelf = launchAd;
            
                    NSArray *arr = [NSArray arrayWithArray:responseObject[@"Data"]];
                    NSDictionary *dic =[NSDictionary dictionaryWithDictionary:[arr firstObject]];
                    NSString *HomePageImgURL = dic[@"imggg"];
                    NSString *webId = dic[@"id"];
            
            
                [launchAd setWebImageWithURL:HomePageImgURL options:JWWebImageDefault result:^(UIImage *image, NSURL *url) {
                    //3.异步加载图片完成回调(设置图片尺寸)
                    weakSelf.adFrame = CGRectMake(0, 0, size_width, size_height);
                } adClickBlock:^{
                    /// 点击广告
                    
                    //2.在webview中打开
                    WebViewController *webVC = [[WebViewController alloc] init];
                    
                    webVC.hidesBottomBarWhenPushed = YES;
                    webVC.shareHiddnBtn = YES;
                    LoginDataModel *model = [UserDefault getUserInfo];
                    NSString *string;
                    
                    if (![dic[@"jumpurl"] isKindOfClass:[NSNull class]]){
                        webVC.webView = [[IMYWebView alloc]initWithFrame:CGRectMake(0, 64, size_width, size_height-64-44) usingUIWebView:YES];
                        webVC.isUIWebView = YES;
                        if ([dic[@"jumpurl"] hasSuffix:@"?"]) {
                            string = [NSString stringWithFormat:@"%@&userid=%@&from=timeline&isappinstalled=1",dic[@"jumpurl"],model.myid];
                            
                        }else{
                            string = [NSString stringWithFormat:@"%@?userid=%@&from=timeline&isappinstalled=1",dic[@"jumpurl"],model.myid];
                        }
                    }else{
                        
                        string = [NSString stringWithFormat:@"http://x.xiaobang520.com/article/show.aspx?articleid=%@&userid=%@",webId,model.myid];
                         webVC.webView = [[IMYWebView alloc]initWithFrame:CGRectMake(0, 64, size_width, size_height-64-44) ];
                    }
                    
                    
                    
                    
                    
                    NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"]];
                    
                    //webVC.view.frame = CGRectMake(0, 0, size_width, size_height-50);
                    
                   
                    
                    //webView.scalesPageToFit = YES;
                    //webView.delegate = self;
                    
                    [webVC.view addSubview:webVC.webView];
                    
                    [webVC.view bringSubviewToFront:webVC.backView];
                    
                    //[webVC.view sendSubviewToBack:webVC.backView];
                    
                    //[webVC.webView setMediaPlaybackRequiresUserAction:NO];
                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:string]];
                    
                    
                    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                    [cookieStorage setCookies:cookies forURL:[NSURL URLWithString:string] mainDocumentURL:nil];
                    
                    NSMutableString *cookieString = [[NSMutableString alloc] init];
                    //NSMutableString *domain = [[NSMutableString alloc] initWithString:string5];
                    // NSArray *domainArr = [domain componentsSeparatedByString:@":"];
                    // NSMutableString *domainString = [NSMutableString stringWithString:domainArr[1]];
                    //[domainString deleteCharactersInRange:NSMakeRange(0, 2)];
                    if (cookies.count) {
                        
                        NSHTTPCookie *currentCookie= [[NSHTTPCookie alloc] init];
                        
                        for (NSHTTPCookie*cookie in [cookieStorage cookies]) {
                            //kDLOG(@"cookie:%@", cookie);
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
                    
                    
                    
                    
                    
                    webVC.titleLab = dic[@"title"];
                    UIImageView *imgView = [[UIImageView alloc]init];
                    
                    [imgView sd_setImageWithURL:dic[@"img"]];
                    
                    
                    
                    webVC.titleImg = imgView.image;
                    
                    webVC.articleId = dic[@"id"];
                    
                    webVC.qiandao = @"YES";
                    webVC.title = @"最新活动";
                    webVC.AppDelegateSele= -1;
                    
                    webVC.webBack= ^(){
                        //广告展示完成回调,设置window根控制器
                        //获得当前应用的主window
                       // UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
                        //获得tabBarcontroller
                        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        UITabBarController *tabBarController = [storyBoard instantiateViewControllerWithIdentifier:@"RootViewController"];
                        
                        
                        //设置当前APP的window
                        self.window.rootViewController =tabBarController;
                        
                    };
                    
                    
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:webVC];
                    self.window.rootViewController = nav;
                    
                    
                    
                }];
                
                
                
           
           
            
        }];
    
}


/**
 *  分享到微信的代理回掉方法
 */

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}



/*
#pragma mark Message
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"----devicetoken------%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                       stringByReplacingOccurrencesOfString: @">" withString: @""]
                                      stringByReplacingOccurrencesOfString: @" " withString: @""]);
    
   
    
    
    [UMComMessageManager registerDeviceToken:deviceToken];
    
    
    
    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ([userInfo valueForKey:@"umwsq"]) {
        [UMComMessageManager didReceiveRemoteNotification:userInfo];
    } else {
        //使用你自己的消息推送处理
    }
}

*/

    
    





-(void)setNSString:(NSString *)string{
    self.articleId = string;
}




//不用点击自动消失的提示框
+(void)showAlertMessageWithMessage:(NSString*)message duration:(NSTimeInterval)time
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示:" message:message delegate:nil
                                          cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:time];
}

//------------------------------------------------------------------------------

#pragma mark - 2、外部调用接口的回调方法

//------------------------------------------------------------------------------

+(void) dimissAlert:(UIAlertView *)alert {
    if(alert)     {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}




#pragma mark - 程序将要取消活跃状态
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

#pragma mark - 程序已经进入后台时触发
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

#pragma mark - 程序将要进入前台时触发
- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSNotification *notification2 = [NSNotification notificationWithName:kUMComUnreadNotificationRefreshNotification object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification2];
    
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
#pragma mark - 应用程序已经变得活跃了
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
#pragma mark - 参照:applicationDidEnterBackground:(已经进入后台)方法
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "net.xxbang.CJXBiOSdemo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CJXBiOSdemo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CJXBiOSdemo.sqlite"];
    //开启自动迁移命令
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@YES,NSInferMappingModelAutomaticallyOption:@YES};
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


//添加汽车实体方法
-(void)addMovEntiityWith:(CarModel *)model{
    //创建实体
    CarEntity *entity = [NSEntityDescription insertNewObjectForEntityForName:@"CarEntity" inManagedObjectContext:self.managedObjectContext];
    
    if (entity==nil) {
        
    }
    entity.hphm = model.cphm;
    //NSString *string =[self hpzlClick:model.cpzl];
    entity.hpzl = model.cpzl;
    entity.fkje = model.fkje;
    entity.wfjfs = model.fkjf;
    entity.count = model.count;
    
    entity.hp = model.hp;
    entity.mm = model.mm;
    entity.lz = model.zl;
    
    //保存
    [self.managedObjectContext save:nil];
}

//查询并返回实体
-(NSArray *)searchMovieEntiity{
    //实体描述
    NSEntityDescription *entityDes = [NSEntityDescription entityForName:@"CarEntity" inManagedObjectContext:self.managedObjectContext];
    
    //建立查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    //设置请求哪个实体
    [request setEntity:entityDes];
    
    //遍历所有实体，获取实体信息，存在数组里
    NSArray *arr = [self.managedObjectContext executeFetchRequest:request error:nil];
    
   return arr;
    
}

//修改车辆存储值
-(void)updataWith:(NSString *)str with:(NSString *)fkje with:(NSString *)fkjfs with:(NSString *)count{
    //实体描述
    NSEntityDescription *entityDes = [NSEntityDescription entityForName:@"CarEntity" inManagedObjectContext:self.managedObjectContext];
    
    //建立查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    //设置请求哪个实体
    [request setEntity:entityDes];
    
    //遍历所有实体，获取实体信息，存在数组里
    NSArray *arr = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    for (CarEntity *entity in arr) {
        if ([entity.hp isEqualToString:str]) {
            entity.fkje = [NSString stringWithFormat:@"%@",fkje];
            entity.wfjfs = [NSString stringWithFormat:@"%@",fkjfs];
            entity.count = [NSString stringWithFormat:@"%@",count];
            
             [self.managedObjectContext save:nil];
        }
    }




}

//添加收藏文章实体
-(void)addMyLoveNewEntity:(MyNewsModel*)model{
    //创建实体
    MyLoveNewsEntity *entity =[NSEntityDescription insertNewObjectForEntityForName:@"MyLoveNewsEntity" inManagedObjectContext:self.managedObjectContext];
    if (entity==nil) {
    }
    entity.imgUrl = model.imgUrl;
    entity.title  = model.title;
    entity.newsUrl = model.pushUrl;
    entity.newId = [NSString stringWithFormat:@"%@",model.newsId];
    entity.timeAdd = model.timeAdd;
    [self.managedObjectContext save:nil];
    
}
//查询收藏文章
-(NSArray *)searchMyNewsforEntity{
    //实体描述
    NSEntityDescription *entityDes = [NSEntityDescription entityForName:@"MyLoveNewsEntity" inManagedObjectContext:self.managedObjectContext];
    //建立查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    //设置请求哪个实体
    [request setEntity:entityDes];
    
    //遍历所有实体，获取实体信息，存在数组里
    NSArray *arr = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    return arr;

}

-(void)addCarInfoEntity:(ResultData *)model{
    //创建实体
    WeiZhangEntity *entity = [NSEntityDescription insertNewObjectForEntityForName:@"WeiZhangEntity" inManagedObjectContext:self.managedObjectContext];
    
    if (entity==nil) {
        
    }
    
    entity.clbj = model.clbj;
    entity.fkje = [NSString stringWithFormat:@"%@",model.fkje];
    entity.hphm = model.hphm;
    entity.hpzl = model.hpzl;
    entity.pageNo = [NSString stringWithFormat:@"%@",model.pageNo];
    entity.wfbh = model.wfbh;
    entity.wfdz = model.wfdz;
    entity.wfjfs = [NSString stringWithFormat:@"%@",model.wfjfs];
    entity.wfsj = model.wfsj;
    entity.wfxw = model.wfxw;
    entity.wfxwdm = model.wfxwdm;

    //保存
    [self.managedObjectContext save:nil];
    
    
}
-(NSArray *)searchCarinfoEntity{
    //实体描述
    NSEntityDescription *entityDes = [NSEntityDescription entityForName:@"WeiZhangEntity" inManagedObjectContext:self.managedObjectContext];
    
    //建立查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    //设置请求哪个实体
    [request setEntity:entityDes];
    
    //遍历所有实体，获取实体信息，存在数组里
    NSArray *arr = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    return arr;

    
    
    
}


//驾驶证实体
-(void)addMessageEntity:(MessageData *)model{
    //创建实体
    MessageEntity *entity = [NSEntityDescription insertNewObjectForEntityForName:@"MessageEntity" inManagedObjectContext:self.managedObjectContext];
    
    if (entity==nil) {
        
    }
    
    entity.dabh = model.dabh;
    entity.sfzmhm = model.sfzmhm;
    entity.zjcx = model.zjcx;
    entity.yxqs = model.yxqs;
    entity.yxqz = model.yxqz;
    entity.ljjf = [NSString stringWithFormat:@"%@",model.ljjf];
    entity.zt = model.zt;
    entity.fzjg = model.fzjg;
    entity.xm = model.xm;
    entity.xb = model.xb;
    entity.qfrq = model.qfrq;
    entity.syrq = model.syrq;
    
    //保存
    [self.managedObjectContext save:nil];
    
}

-(NSArray *)searchMessageEntity{
    //实体描述
    NSEntityDescription *entityDes = [NSEntityDescription entityForName:@"MessageEntity" inManagedObjectContext:self.managedObjectContext];
    
    //建立查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    [request setIncludesPropertyValues:NO];
    //设置请求哪个实体
    [request setEntity:entityDes];
    
    //遍历所有实体，获取实体信息，存在数组里
    NSArray *arr = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    return arr;
}

-(void)updataMessage:(NSString *)ljjf with:(NSString *)zt{
    //实体描述
    NSEntityDescription *entityDes = [NSEntityDescription entityForName:@"MessageEntity" inManagedObjectContext:self.managedObjectContext];
    
    //建立查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    //设置请求哪个实体
    [request setEntity:entityDes];
    
    //遍历所有实体，获取实体信息，存在数组里
    NSArray *arr = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    MessageEntity *entity = [arr firstObject];
    
    entity.ljjf = [NSString stringWithFormat:@"%@",ljjf];
    entity.zt = [NSString stringWithFormat:@"%@",zt];
    
    [self.managedObjectContext save:nil];
    
}




-(NSString *)hpzlClick:(NSString *)string{
    switch ([string integerValue]) {
        case 01:
            return @"大型汽车";
            break;
        case 02:
            return @"小型汽车";
            break;
        case 03:
            return @"普通摩托车";
            break;
        case 04:
            return @"轻便摩托车";
            break;
        case 05:
            return @"低速车";
            break;
        case 06:
            return @"挂车";
            break;
        case 07:
            return @"教练车";
            break;
        default:
            return @"神秘车型";
            break;
    }
    
    
    
    
}














@end
