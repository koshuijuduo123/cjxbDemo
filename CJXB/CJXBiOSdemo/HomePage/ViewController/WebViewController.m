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
@interface WebViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UMSocialUIDelegate,IMYWebViewDelegate,HZPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UIButton *sheetBtn;
@property (weak, nonatomic) IBOutlet UIButton *jfBtn;

@property (weak, nonatomic) IBOutlet UITextField *taskTextFirld;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLine;

@property(nonatomic,strong)IMYWebView *webVC;

@property(nonatomic,assign)NSValue *animationDurationValue;

@property(nonatomic,strong)NSString *string5;

@property(nonatomic,copy)NSString *str2;//嵌入网页的表情字符串

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,assign)BOOL isLookImg;//是否弹出放大UIimage YES表示是

@property(nonatomic,strong)UIProgressView *progressView; //进度条
@property(nonatomic,assign)BOOL isTiShiKuang;//是否弹出过提示框
@property(nonatomic, strong)NSMutableArray *imageArray;//HTML中的图片个数
@property(nonatomic,strong)MBProgressHUD *hud;
@end

@implementation WebViewController

-(NSMutableArray *)imageArray{
    if (!_imageArray) {
        self.imageArray = [NSMutableArray array];
    }
    return _imageArray;
}





-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    //赋初始值
    self.isLookImg = YES;
    
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
    
    
    //初始化hud
    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    //设置等待框动画样式
    _hud.mode = MBProgressHUDModeCustomView;
    [self ImgAction];
    [self.view addSubview:self.hud];
    
    
    
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(0, 0, 30, 30);
    [backButton setBackgroundImage:[UIImage imageNamed:@"返回1"] forState:UIControlStateNormal];
    
    
    
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    UIBarButtonItem *negative = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    negative.width = -15;
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negative,btn, nil];
    
    
    
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"分享给"] forState:UIControlStateNormal];
    
    [shareBtn addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside ];
    
    shareBtn.frame = CGRectMake(5, 0, 30, 30);
    
    UIView *rightShareBtn = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
    [rightShareBtn addSubview:shareBtn];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]initWithCustomView:rightShareBtn];
    self.navigationItem.rightBarButtonItem = menuButton;
    
    
    
    
    self.webView.scrollView.delegate = self;
    
    if (![self.webView usingUIWebView]) {
        
        self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, size_width, 10)];
        
        self.progressView.progressViewStyle = UIProgressViewStyleBar;
        
        [self.webView addSubview:_progressView];
        
        [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    
    
    
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
    //NSLog(@"横屏%f",keyboardSize.height);
    float keyboardHeight = keyboardSize.height;
    
    // 获取键盘弹出的时间
    self.animationDurationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [_animationDurationValue getValue:&animationDuration];
    
    //自定义的frame大小的改变的语句
    self.bottomLine.constant = keyboardHeight;
}






//若是二级的web页面，则返回上一级web界面
-(void)back:(UIBarButtonItem *)sender{
    
    if (self.AppDelegateSele==-1) {
        if(self.webBack){
            
            self.webBack();
        }
        //[self dismissViewControllerAnimated:YES completion:nil];
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
             [webView loadRequest:request];
            
            if ([self.webView usingUIWebView]) {
                [self.hud show:YES];
                UIImageView *imgView = [_hud viewWithTag:7777];
                [imgView startAnimating];
                self.hud.labelText = @"小帮加载中...";
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                
            }
            self.isLookImg = NO;
           
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
    
    
    
    [self webViewFail];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)webViewFail{
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size_width, size_height)];
    view1.backgroundColor = [UIColor whiteColor];
    UIImageView *imgVc = [[UIImageView alloc]initWithFrame:CGRectMake((size_width-300)/2, 0, 300, size_height)];
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
        
        //LoginViewController *logVC = [[LoginViewController alloc]init];
        //[self.navigationController pushViewController:logVC animated:YES];
    
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
            //[self.taskTextFirld resignFirstResponder];
            //[self textFieldDidEndEditing:_taskTextFirld];
            [WebViewController showAlertMessageWithMessage:responseObject[@"Message"] duration:1.0];
            
        } enError:^(NSError *error) {
            //[WebViewController showAlertMessageWithMessage:@"评论失败" duration:1.0];
        }];
        
        //刷新界面
        [self.webView reload];
        
        
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
         
    //[app setNSString:self.articleId];
    
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
        
        
        [UIView animateWithDuration:0.5 animations:^{
            self.backView.frame = CGRectMake(0, size_height-60-self.bottomLine.constant, size_width, 60);
            
        }];
        
        
        
    }
    
    //[self updateViewConstraints];

}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    return [textField resignFirstResponder];
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.bottomLine.constant = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backView.frame = CGRectMake(0, size_height-60-self.bottomLine.constant, size_width, 60);
        
    }];
    //[self updateViewConstraints];
    
}

-(void)dealloc{
    
    if (![self.webView usingUIWebView]) {
        
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
    
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
