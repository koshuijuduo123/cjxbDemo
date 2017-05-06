//
//  WebViewController.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/31.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "WebViewController.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "NetworkManger.h"
#import "UserDefault.h"
#import "LoginViewController.h"
#import "LoginDataModel.h"
#import "MJExtension.h"
#import "UMSocialWechatHandler.h"
#import "IMYWebView.h"
#import "HZPhotoBrowser.h"
#import "MBProgressHUD.h"
#import "JGPopView.h"
#import "MyNewsModel.h"
#import "MyLoveNewsEntity.h"
#import "MyCarModel.h"
#import "MyWKWebViewController.h"
#import "MJRefresh.h"
@interface WebViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UMSocialUIDelegate,IMYWebViewDelegate,HZPhotoBrowserDelegate,selectIndexPathDelegate>
@property (weak, nonatomic) IBOutlet UIButton *sheetBtn;
@property (weak, nonatomic) IBOutlet UIButton *jfBtn;

@property (weak, nonatomic) IBOutlet UITextField *taskTextFirld;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLine;

@property(nonatomic,strong)IMYWebView *webVC;

@property(nonatomic,assign)NSTimeInterval animationDuration;
@property(nonatomic,strong)NSString *string5;

@property(nonatomic,copy)NSString *str2;//嵌入网页的表情字符串

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,assign)BOOL isLookImg;//是否弹出放大UIimage YES表示是

@property(nonatomic,strong)UIProgressView *progressView; //进度条
@property(nonatomic,assign)BOOL isTiShiKuang;//是否弹出过提示框
@property(nonatomic, strong)NSMutableArray *imageArray;//HTML中的图片个数
@property(nonatomic,strong)MBProgressHUD *hud;
@property(nonatomic,strong)NSArray *logTypeArrM;
@property(nonatomic,strong)UIButton *shareBtn;

@property(nonatomic,assign)BOOL isPushShoping;//是否跳转到商城链接
@end

@implementation WebViewController
-(NSArray *)logTypeArrM{
    if (!_logTypeArrM) {
        self.logTypeArrM = @[@"分享此文章",@"收藏此文章",@"用浏览器打开",@"复制链接"];
    }
    return _logTypeArrM;
}
-(NSMutableArray *)imageArray{
    if (!_imageArray) {
        self.imageArray = [NSMutableArray array];
    }
    return _imageArray;
}





-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //赋初始值
    self.isLookImg = YES;
    if (self.AppDelegateSele==-1) {
        self.navigationController.navigationBar.translucent = YES;
    }else{
        self.navigationController.navigationBar.translucent = NO;
    }
    
    
    self.navigationController.navigationBar.hidden = NO;
    self.bottomLine.constant = 0;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (self.AppDelegateSele==-1) {
        self.navigationController.navigationBar.translucent = NO;
    }else{
        self.navigationController.navigationBar.translucent = YES;
    }
    
    
    if ([_qiandao isEqualToString:@"YES"]) {
        self.webVC = [[IMYWebView alloc]initWithFrame:CGRectZero usingUIWebView:YES];
        NSString *string5 = [NSString stringWithFormat:@"http://x.xiaobang520.com/com/qiandao.aspx"];
        
        NSURL *url1 = [[NSURL alloc]initWithString:string5];
        
        NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"]];
        
        
            NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            [cookieStorage setCookies:cookies forURL:url1 mainDocumentURL:nil];
            
            
            
            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url1];
            
            [_webVC loadRequest:request];
            
        
        
    }
    

    
}




-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if ([self.qiandao isEqualToString:@"qiandao"]) {
       //获取网页中的积分值
       // NSString *pointStr = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('totalpointsnum').innerHTML"];
       
        [self.webView evaluateJavaScript:@"document.getElementById('totalpointsnum').innerHTML" completionHandler:^(id object, NSError *error) {
            NSString *pointStr = [NSString stringWithFormat:@"%@",object];
            LoginDataModel *model =[UserDefault getUserInfo];
            
            model.points = pointStr;
            
            if ([model.points isEqualToString:@""]) {
                return;
            }
            [UserDefault saveUserInfo:model];
            
            NSDictionary *dic = model.keyValues;
            NSNotification *notification = [NSNotification notificationWithName:@"Login" object:nil userInfo:dic];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }];
        
        
        
        
    }else if([_qiandao isEqualToString:@"YES"]){
       
        
        
        NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"]];
        
        if (cookies.count) {
            
            //获取网页中的积分值
           // NSString *pointStr = [self.webVC stringByEvaluatingJavaScriptFromString:@"document.getElementById('totalpointsnum').innerHTML"];
            
            [self.webVC evaluateJavaScript:@"document.getElementById('totalpointsnum').innerHTML" completionHandler:^(id object, NSError *error) {
                NSString *pointStr = [NSString stringWithFormat:@"%@",object];
                LoginDataModel *model =[UserDefault getUserInfo];
                
                model.points = pointStr;
                
                if ([model.points isEqualToString:@""]) {
                    
                    return;
                }
                
                [UserDefault saveUserInfo:model];
                
                NSDictionary *dic = model.keyValues;
                NSNotification *notification = [NSNotification notificationWithName:@"Login" object:nil userInfo:dic];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }];
            
            
        }
        
        
    }
    
}





- (void)viewDidLoad {
    [super viewDidLoad];
    //self.automaticallyAdjustsScrollViewInsets = YES;
    self.sheetBtn.layer.cornerRadius = 10.0;
    self.sheetBtn.clipsToBounds = YES;
    
    self.jfBtn.layer.cornerRadius = 10.0;
    self.jfBtn.clipsToBounds = YES;
    
    self.taskTextFirld.delegate = self;
    
    self.taskTextFirld.tag = 888;
    
    if (!self.title.length) {
        self.title = @"小帮发现";
        
    }
    
    self.webView.scalesPageToFit = YES;
    
    self.webView.delegate = self;
    
    if (self.isUIWebView==YES) {
        
        self.backView.hidden = YES;
    }
    
    //网页下拉刷新
    _webView.scrollView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self.webView reload];
        [_webView.scrollView.header endRefreshing];
    }];

    
    
    
    //初始化hud
    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    //设置等待框动画样式
    _hud.mode = MBProgressHUDModeCustomView;
    [self ImgAction];
    [self.view addSubview:self.hud];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(0, 0, 25, 25);
    [backButton setBackgroundImage:[UIImage imageNamed:@"返回1"] forState:UIControlStateNormal];
    
    
    
   [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    UIBarButtonItem *negative = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    negative.width = -15;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negative,btn, nil];
    
    if (_shareHiddnBtn==YES) {
        self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_shareBtn setImage:[UIImage imageNamed:@"选项"] forState:UIControlStateNormal];
        
        [_shareBtn addTarget:self action:@selector(logTypeArrMAction:) forControlEvents:UIControlEventTouchUpInside ];
        
        _shareBtn.frame = CGRectMake(5, 0, 30, 30);
        
        UIView *rightShareBtn = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
        [rightShareBtn addSubview:_shareBtn];
        
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]initWithCustomView:rightShareBtn];
        self.navigationItem.rightBarButtonItem = menuButton;
        
    }
    self.webView.scrollView.delegate = self;
    
    if (![self.webView usingUIWebView]) {
        
        self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, size_width, 40)];
        
        self.progressView.progressViewStyle = UIProgressViewStyleBar;
        self.progressView.progressTintColor = [UIColor colorWithRed:0/255.0 green:150/255.0 blue:29/255.0 alpha:1.0];
        
        [self.webView addSubview:_progressView];
        
        [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        
    }
}

-(void)pushWithCarModelToWebView{
   MyCarModel *model = [MyCarModel shareInstance];
    
    NSString *jsString4 = [NSString stringWithFormat:@"document.getElementById('entry_field_4').value='%@';",model.carPinPai];
    [_webView evaluateJavaScript:jsString4 completionHandler:nil];
   //设置不可编辑属性
    NSString *jsStrings4 = [NSString stringWithFormat:@"document.getElementById('entry_field_4').readOnly='true';"];
    [_webView evaluateJavaScript:jsStrings4 completionHandler:nil];
    
    NSString *jsString5 = [NSString stringWithFormat:@"document.getElementById('entry_field_5').value='%@';",model.carName];
    [_webView evaluateJavaScript:jsString5 completionHandler:nil];
    
    NSString *jsStrings5 = [NSString stringWithFormat:@"document.getElementById('entry_field_5').readOnly='true';"];
    [_webView evaluateJavaScript:jsStrings5 completionHandler:nil];

    
    NSString *jsString6 = [NSString stringWithFormat:@"document.getElementById('entry_field_6').value='%@';",model.carXing];
    [_webView evaluateJavaScript:jsString6 completionHandler:nil];
    
    NSString *jsStrings6 = [NSString stringWithFormat:@"document.getElementById('entry_field_6').readOnly='true';"];
    [_webView evaluateJavaScript:jsStrings6 completionHandler:nil];

    
}




-(void)logTypeArrMAction:(UIButton *)btn{
    CGPoint point = CGPointMake(btn.superview.center.x,btn.frame.origin.y + 45);
    JGPopView *view2 = [[JGPopView alloc] initWithOrigin:point Width:btn.frame.size.width*7  Height:50 * 4 Type:JGTypeOfUpRight Color:[UIColor colorWithRed:46/255.0 green:49/255.0 blue:50/255.0 alpha:1.0]];
    view2.dataArray = self.logTypeArrM;
    view2.fontSize = 18;
    view2.row_height = 50;
    view2.titleTextColor = [UIColor whiteColor];
    view2.delegate = self;
    [view2 popView];
}




-(void)ImgAction{
    NSMutableArray *refreshImages = [NSMutableArray array];
    
    for (NSUInteger i=1; i<5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"wawago%ld",(unsigned long)i]];
        [refreshImages addObject:image];
    }
    
    UIImageView *refresH = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wawago1"]];
    refresH.animationImages = refreshImages;
    refresH.animationDuration = 0.4;
    refresH.animationRepeatCount = 0;
    refresH.tag = 7777;
    
    
    _hud.customView = refresH;
    
    
}




//kvo计算进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
   
    if ([keyPath isEqualToString:@"loading"]) {
        
    } else if ([keyPath isEqualToString:@"title"]) {
        self.title = self.webView.title;
    } else if ([keyPath isEqualToString:@"URL"]) {
        
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        self.progressView.progress = self.webView.estimatedProgress;
    }
    
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}





//通知触发方法
-(void)KeyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    
    //获取高度
    NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];//关键的一句，网上关于获取键盘高度的解决办法，多到这句就over了。系统宏定义的UIKeyboardBoundsUserInfoKey等测试都不能获取正确的值。不知道为什么。。。
    
    CGSize keyboardSize = [value CGRectValue].size;
    
    float keyboardHeight = keyboardSize.height;
    
     //获取键盘弹出的时间
    NSValue *animationDurationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    [animationDurationValue getValue:&_animationDuration];
    
    //自定义的frame大小的改变的语句
    self.bottomLine.constant = keyboardHeight;
}






//若是二级的web页面，则返回上一级web界面
-(void)back:(UIBarButtonItem *)sender{
    
    if (self.AppDelegateSele==-1) {
        if(self.webBack){
            
            self.webBack();
        }
        return;

    }
    
    
    
    
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        
            
        self.isLookImg = YES;
        
    }else{
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

#pragma mark- IMYWebView代理
//提示框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    
    
    
    
}


//开始加载
- (void)webViewDidStartLoad:(IMYWebView*)webView{
    
    if (webView.usingUIWebView) {
        
            
        if (!self.hud.labelText.length) {
            
            [self.hud show:YES];
            UIImageView *imgView = [_hud viewWithTag:7777];
            [imgView startAnimating];
            self.hud.labelText = @"小帮加载中...";
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
        }
        
    }
    
}





//完成加载
- (void)webViewDidFinishLoad:(IMYWebView*)webView{
    if (webView.usingUIWebView) {
        
        UIImageView *imgView = [_hud viewWithTag:7777];
        [imgView stopAnimating];
        [self.hud hide:YES];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
    
    
    
    //js方法遍历图片添加点击事件 返回图片个数
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    for(var i=0;i<objs.length;i++){\
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\"+this.src;\
    };\
    };\
    return objs.length;\
    };";
    
    
    
    [webView evaluateJavaScript:jsGetImages completionHandler:nil];
    
    
    if (self.isLookImg==YES) {
        [webView evaluateJavaScript:@"getImages()" completionHandler:nil];
    }
    //获取HTML中的图片
    [self getImgs];
    
    
    //保养表格显示
    if (_isPushExtcl==YES) {
    [self pushWithCarModelToWebView];
    }

}

//此方法可以获取网页上的数据

- (BOOL)webView:(IMYWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    //将url转换为string
    NSString *requestString = [[request URL] absoluteString];
    //判断是否有跳转链接
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        NSURL *url = [request URL];
        if([[UIApplication sharedApplication]canOpenURL:url])
       {
           self.isLookImg = NO;
           if ([[url absoluteString] rangeOfString:@"youzan"].location !=NSNotFound) {
               //[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webView.URL.absoluteString]]];
               
               self.isPushShoping = YES;
               MyWKWebViewController *webVC = [[MyWKWebViewController alloc]init];
               webVC.loadUrl = requestString;
               [self.navigationController pushViewController:webVC animated:YES];
               
           }else{
               self.isPushShoping = NO;
               
               if ([self.webView usingUIWebView]) {
                   [self.hud show:YES];
                   UIImageView *imgView = [_hud viewWithTag:7777];
                   [imgView startAnimating];
                   self.hud.labelText = @"小帮加载中...";
                   [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                   
               }
               [webView loadRequest:request];
           }
           

           
        }
        
        return NO;
    }
        
    
    if (self.isLookImg==YES) {
        
            //hasPrefix 判断创建的字符串内容是否以pic:字符开始
            if ([requestString hasPrefix:@"myweb:imageClick:"]) {
                NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
                if (_imageArray.count != 0) {
                    
                    HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
                    browserVc.imageCount = self.imageArray.count; // 图片总数
                    browserVc.currentImageIndex = [_imageArray indexOfObject:imageUrl];//当前点击的图片
                    browserVc.delegate = self;
                    [browserVc show];
                }
                return NO;
            }
            
        }
        return YES;
        
    
}

    



//web页面加载出错时，走这个方法
- (void)webView:(IMYWebView*)webView didFailLoadWithError:(NSError*)error{
    if ([error code]==NSURLErrorCancelled) {
        return;
    }
   
    if (_isPushShoping==NO) {
        [self webViewFail];
        
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)webViewFail{
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size_width, size_height)];
    view1.backgroundColor = [UIColor whiteColor];
    UIImageView *imgVc = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size_width, size_height)];
    imgVc.image = [UIImage imageNamed:@"请求错误"];
    [view1 addSubview:imgVc];
    [self.view addSubview:view1];
}



#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    //图片浏览时，未加载出图片的占位图
    return [UIImage imageNamed:@"zwt"];
    
}

- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [self.imageArray[index] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
}


#pragma mark -- 获取文章中的图片个数
- (NSArray *)getImgs
{
    
    NSMutableArray *arrImgURL = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self nodeCountOfTag:@"img"]; i++) {
        NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].src", i];
        [_webView evaluateJavaScript:jsString completionHandler:^(NSString *str, NSError *error) {
            
            if (error ==nil) {
                [arrImgURL addObject:str];
            }
            
            
            
        }];
    }
    _imageArray = [NSMutableArray arrayWithArray:arrImgURL];
    
    
    return arrImgURL;
}

// 获取某个标签的结点个数
- (NSInteger)nodeCountOfTag:(NSString *)tag
{
    
    NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('%@').length", tag];
    
    int count =  [[_webView stringByEvaluatingJavaScriptFromString:jsString] intValue];
    return count;
}





//发送
- (IBAction)sheetButtonAction:(UIButton *)sender {
    [self.taskTextFirld resignFirstResponder];
    
    NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"]];
    if (cookies.count==0) {
        [WebViewController showAlertMessageWithMessage:@"加入小帮参与评论" duration:1.0];
        return;
    }else{
        
        
        if (self.taskTextFirld.text.length==0) {
            [WebViewController showAlertMessageWithMessage:@"内容不能为空" duration:1.0];
            return;
        }
        
        //发送
        NSHTTPCookieStorage * cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie * cookie in cookies){
            [cookieStorage setCookie: cookie];
        }
        
        //让后台识别表情符号
       // NSString * str1 =  [self.taskTextFirld.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
       
        
       // self.str2 = [str1  stringByRemovingPercentEncoding];
        
        [NetworkManger requestPOSTWithURLStr:@"http://x.xiaobang520.com/article/articlehandler.ashx" parmDic:@{@"exec":@"addpl",@"articleid":self.articleId,@"con":self.taskTextFirld.text} finish:^(id responseObject) {
            self.taskTextFirld.text = nil;
            [WebViewController showAlertMessageWithMessage:responseObject[@"Message"] duration:1.0];
            //刷新界面
            [self.webView reload];
            
        } enError:^(NSError *error) {
            
        }];
        }
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


//分享
- (IBAction)shareButtonAction:(UIButton *)sender {
    [self.taskTextFirld resignFirstResponder];
    [UMSocialData setAppKey:@"57ca6a40e0f55ac3c6003450"];
    //存放当前显示的分享平台，不能强迫用户安装需要分享的应用
    NSMutableArray *plantFormArr = [[NSMutableArray alloc]init];
   
    //添加短信平台（后期去掉）
    [plantFormArr addObject:UMShareToSms];
    
    //判断当前是否安装了微信
    if ([WXApi isWXAppInstalled]) {
        [plantFormArr addObject:UMShareToWechatTimeline];
        [plantFormArr addObject:UMShareToWechatSession];
    }
    
    LoginDataModel *model = [UserDefault getUserInfo];
    self.string5 = nil;
    
    self.string5 = [NSString stringWithFormat:@"%@",self.webView.URL.absoluteURL];
    
    
    if ([_string5 isEqualToString:@""]) {
      
        self.string5 = [NSString stringWithFormat:@"http://x.xiaobang520.com/article/show.aspx?articleid=%@&userid=%@",self.articleId,model.myid];
    }
    
    self.titleLab = self.webView.title;
    
    if (!self.titleLab) {
        self.titleLab = @"发现一篇来自车驾小帮的好文章";
    }
    //[UMSocialData defaultData].extConfig.smsData =string5;
    
   // [UMSocialData defaultData].extConfig.wechatSessionData.url = string5;
    
    //[UMSocialData defaultData].extConfig.wechatTimelineData.url = string5;
    
    if (!self.titleImg) {
        
        self.titleImg = [UIImage imageNamed:@"share"];
    }
    //实验 不行去掉
    [UMSocialWechatHandler setWXAppId:@"wxdcdd2ba2548e88b5" appSecret:@"29ceee15ff96df366c93a043d695862d" url:_string5];
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"57ca6a40e0f55ac3c6003450" shareText:self.titleLab shareImage:self.titleImg shareToSnsNames:plantFormArr delegate:self];
}

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData{
    socialData.extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    if (platformName==UMShareToWechatTimeline) {
        socialData.extConfig.wechatTimelineData.shareText = self.titleLab;
        socialData.extConfig.wechatTimelineData.shareImage = self.titleImg;
        socialData.extConfig.wechatTimelineData.url =_string5;
    }
    
    if (platformName==UMShareToWechatSession) {
        socialData.extConfig.wechatSessionData.shareText = self.titleLab;
        socialData.extConfig.wechatSessionData.shareImage = self.titleImg;
        socialData.extConfig.wechatSessionData.url = _string5;
        
    }
    
    if (platformName==UMShareToSms) {
        socialData.extConfig.smsData.shareText = self.titleLab;
        socialData.extConfig.smsData.shareImage = self.titleImg;
        socialData.extConfig.smsData.urlResource.url = _string5;
    }
    
    
    
}


//分享成功的回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    if (response.responseCode==UMSResponseCodeSuccess) {
        
        NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"]];
        NSHTTPCookieStorage * cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie * cookie in cookies){
            [cookieStorage setCookie: cookie];
        }
        
        
        if (cookies.count) {
            LoginDataModel *model = [UserDefault getUserInfo];
            
            
            
            //分享积分接口
            [NetworkManger requestPOSTWithURLStr:URL_News parmDic:@{@"exec":@"addzf",@"userid":model.myid,@"articleid":self.articleId} finish:^(id responseObject) {
                [WebViewController showAlertMessageWithMessage:responseObject[@"Message"] duration:1.0];
            } enError:^(NSError *error) {
                
            }];
            
            
        }else{
            [WebViewController showAlertMessageWithMessage:@"登录后才可赚取积分" duration:2.0];
            
        }
}

}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.hud.labelText.length) {
       
        UIImageView *imgView = [_hud viewWithTag:7777];
        [imgView stopAnimating];
        [self.hud hide:YES];
    }
    
    
}



#pragma mark - UITextFirld代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    if (textField.tag==888) {
        
        //键盘动态弹出高度通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
       
        
        [UIView animateWithDuration:_animationDuration animations:^{
            self.backView.frame = CGRectMake(0, size_height-60-self.bottomLine.constant, size_width, 60);
            
        }];
        }
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    return [textField resignFirstResponder];
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.bottomLine.constant = 0;
    
    [UIView animateWithDuration:_animationDuration animations:^{
        self.backView.frame = CGRectMake(0, size_height-60-self.bottomLine.constant, size_width, 60);
        
    }];
}

- (void)selectIndexPathRow:(NSInteger)index{
    [self.shareBtn setTitle:[self.logTypeArrM objectAtIndex:index] forState:UIControlStateNormal];
    
    if (index==0) {
        [self shareButtonAction:self.shareBtn];
    }
    if (index==1) {
        //收藏功能
        MyNewsModel *newsModel = [[MyNewsModel alloc]init];
        LoginDataModel *model = [UserDefault getUserInfo];
        self.string5 = nil;
        
        self.string5 = [NSString stringWithFormat:@"%@",self.webView.URL.absoluteURL];
        
        
        if ([_string5 isEqualToString:@""]) {
            
            self.string5 = [NSString stringWithFormat:@"http://x.xiaobang520.com/article/show.aspx?articleid=%@&userid=%@",self.articleId,model.myid];
        }
        if (!self.imgUrl) {
            self.imgUrl = UMLoginImgURL;
        }
        if (!self.titleLab) {
            self.titleLab = @"我的收藏页面";
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"添加日期📅:yyyy-MM-dd HH:mm"];
        NSString *datetime = [formatter stringFromDate:[NSDate date]];
        
        newsModel.pushUrl = _string5;
        newsModel.imgUrl =  self.imgUrl;
        newsModel.title = self.titleLab;
        newsModel.newsId = self.articleId;
        newsModel.timeAdd = datetime;
        AppDelegate *app = CJXBAPP;
        
        for (MyLoveNewsEntity *entity in [app searchMyNewsforEntity]) {
            if ([[NSString stringWithFormat:@"%@",newsModel.newsId]isEqualToString:entity.newId]) {
                [WebViewController showAlertMessageWithMessage:@"文章不能重复收藏" duration:2.0];
                return;
            }
        }
        
        [app addMyLoveNewEntity:newsModel];
        
        [WebViewController showAlertMessageWithMessage:@"收藏成功" duration:2.0];
        
        
        }
    
    
    if (index==2) {
        //用浏览器打开
        [[UIApplication sharedApplication] openURL: [ NSURL URLWithString:_webView.URL.absoluteString]];
    }
    
    if (index==3) {
        //复制链接
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = _webView.URL.absoluteString;
        if (pasteboard.string.length) {
            [WebViewController showAlertMessageWithMessage:@"复制成功" duration:1.0];
            
        }else{
            [WebViewController showAlertMessageWithMessage:@"复制失败" duration:1.0];
        }

    }
    
    
}

-(void)dealloc{
    
    if (![self.webView usingUIWebView]) {
        
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
