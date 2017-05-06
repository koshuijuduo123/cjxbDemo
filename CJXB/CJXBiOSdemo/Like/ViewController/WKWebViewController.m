//
//  WKWebViewController.m
//  YouzaniOSDemo
//
//  Created by 可乐 on 16/10/31.
//  Copyright © 2016年 张伟. All rights reserved.
//

#import "WKWebViewController.h"
#import "WebKit/WebKit.h"
#import "LoginViewController.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "UMSocialWechatHandler.h"
#import "MJRefresh.h"

@interface WKWebViewController () <WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate,selectIndexPathDelegate,UMSocialUIDelegate>
{
    NSTimer *myTimer;
}
@property(nonatomic,strong)UIProgressView *progressView; //进度条

@property(nonatomic,strong)NSDictionary *shareDic;//分享数据
@property(nonatomic,assign)BOOL isLoadingOver;//页面是否加载完毕
@end

@implementation WKWebViewController
-(NSDictionary *)shareDic{
    if (!_shareDic) {
        self.shareDic = [NSDictionary dictionary];
    }
    return _shareDic;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
   
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
}
- (void)viewDidLoad {
    
    [self addWKWebView];
    [super viewDidLoad];
    self.navigationItem.title = @"小帮商城";
   
    //进入刷新状态
    _webView.scrollView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self.webView reload];
        [_webView.scrollView.header endRefreshing];
    }];

    
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


- (void)dealloc {
    //Demo中 退出当前controller就清除用户登录信息
    BOOL result = [YZSDK logoutYouzanWithWKWebView];
    if (result) {
        //LoginDataModel *model = [UserDefault getUserInfo];
        //model.isLogined = NO;
    }
    
     [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
}

#pragma mark - WKWebView Delegate



- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.isLoadingOver = YES;
    
    self.tabBarController.tabBar.hidden = NO;
    [YZSDK initYouzanWithWKWebView:webView];
    //是否添加返回按钮
    if ([_webView canGoBack]) {
            UIButton * backButton = [UIButton buttonWithType:UIButtonTypeSystem];
            backButton.frame = CGRectMake(0, 0, 25, 25);
            [backButton setBackgroundImage:[UIImage imageNamed:@"返回1"] forState:UIControlStateNormal];
            [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithCustomView:backButton];
            
            UIBarButtonItem *negative = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            
            negative.width = -15;
            self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negative,btn, nil];
    }else{
        self.navigationItem.leftBarButtonItems = nil;
    }

}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURL *url = navigationAction.request.URL;
    
    if(![[url absoluteString] hasPrefix:@"http"]){
        
       YZNotice *noticeFromYZ = [YZSDK noticeFromYouzanWithUrl:url];
       if(noticeFromYZ.notice & YouzanNoticeLogin) {//登录
            if (self.loginTime == kLoginTimeNever) {
                decisionHandler(WKNavigationActionPolicyCancel);
                return;
            }
        
            LoginDataModel *model = [UserDefault getUserInfo];
            if([UserDefault isLogin]) {//如果你的本地数据里有买家的信息
                YZUserModel *userModel = [UserDefault modelWithUser:model];
                [self loginWhenReceiveNoticeWithModel:userModel];
                
                decisionHandler(WKNavigationActionPolicyCancel);
                return;
            }
            
            //若你本地也没有买家的信息，需要唤起原生登录界面提醒买家登录
            
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            loginVC.isShoping = YES;
            loginVC.loginBlock = ^(LoginDataModel *model, BOOL success) {//买家登录结果
                if (success) {
                    YZUserModel *userModel = [UserDefault modelWithUser:model];
                    [self loginWhenReceiveNoticeWithModel:userModel];
                } else {
                    //登录失败
                    if ([webView canGoBack]) {
                        [webView goBack];
                    }
                }
            };
            [self presentViewController:loginVC animated:YES completion:nil];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        } else if(noticeFromYZ.notice & YouzanNoticeShare) {//分享
            //[self showShareData:noticeFromYZ.response];
            
            self.shareDic = (NSDictionary *)noticeFromYZ.response;
            
            [self shareButtonActionWithDic:_shareDic];
            
            decisionHandler(WKNavigationActionPolicyCancel);
        } else if(noticeFromYZ.notice & YouzanNoticeReady) {//有赞环境初始化成功，分享按钮可用
            dispatch_async(dispatch_get_main_queue(), ^{
                self.shareBtn.enabled = YES;
            });
            
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        } else if (noticeFromYZ.notice & IsYouzanNotice) {
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
        
        //WK需要自行处理scheme跳转
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
        
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //self.shareBtn.enabled = NO;
    });
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

//web页面加载出错时，走这个方法
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(nonnull NSError *)error{
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
    
    
}


-(void)timerCallback {
   
        if (_progressView.progress >= 0.95) {
            _progressView.hidden = YES;
            [myTimer invalidate];
            [self webViewFail];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            self.tabBarController.tabBar.hidden = NO;
        }
        else {
            UIView *backView = [self.view viewWithTag:9999];
            [backView removeFromSuperview];
            self.progressView.hidden = NO;
            _progressView.progress += 0.1;
            [self.progressView setProgress:_progressView.progress animated:YES];
        }
    
}



#pragma mark - Override

- (void)shareButtonAction {
    //[YZSDK shareActionWithWKWebView:self.webView];
    //NSLog(@"aaaaa");
}

- (void)loadWithString:(NSString *)urlStr {
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.webView loadRequest:[YZSDK requestInWKWebViewWithUrl:url]];
}

-(void)logTypeArrMAction:(UIButton *)btn{
    CGPoint point = CGPointMake(btn.superview.center.x,btn.frame.origin.y + 45);
    JGPopView *view2 = [[JGPopView alloc] initWithOrigin:point Width:btn.frame.size.width*7  Height:50 * 3 Type:JGTypeOfUpRight Color:[UIColor colorWithRed:46/255.0 green:49/255.0 blue:50/255.0 alpha:1.0]];
    view2.dataArray = self.logTypeArrM;
    view2.fontSize = 18;
    view2.row_height = 50;
    view2.titleTextColor = [UIColor whiteColor];
    view2.delegate = self;
    [view2 popView];
}

- (void)selectIndexPathRow:(NSInteger)index{
    [self.shareBtn setTitle:[self.logTypeArrM objectAtIndex:index] forState:UIControlStateNormal];
    if (index==0) {
        //分享链接
        [YZSDK shareActionWithWKWebView:self.webView];
    }else if (index==1){
        //用浏览器打开
        [[UIApplication sharedApplication] openURL: [ NSURL URLWithString:_webView.URL.absoluteString]];
    }else{
       //复制链接
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = _webView.URL.absoluteString;
        if (pasteboard.string.length) {
            [WKWebViewController showAlertMessageWithMessage:@"复制成功" duration:1.0];
            
        }else{
             [WKWebViewController showAlertMessageWithMessage:@"复制失败" duration:1.0];
        }
    }
}



#pragma mark - Private

//若是二级的web页面，则返回上一级web界面
-(void)back:(UIBarButtonItem *)sender{
    
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        
        if (_webView.backForwardList.backList.count==1) {
            
            self.navigationItem.leftBarButtonItems = nil;
        }
    }else{
        
        self.navigationItem.leftBarButtonItems = nil;
    }
}


#pragma mark - UIScrollView代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
        //滑到底部加载更多
        return;
    }
    if (scrollView.contentOffset.y <= 0) {
        //滑到顶部更新
        return;
    }
    
    if (_isLoadingOver) {
        
        static float newx = 0;
        static float oldIx = 0;
        newx= scrollView.contentOffset.y;
        if (newx != oldIx ) {
            if (newx > oldIx) {
                self.tabBarController.tabBar.hidden = YES;
                _webView.frame = CGRectMake(0, 0, size_width, size_height-15);
            }else if(newx < oldIx){
                self.tabBarController.tabBar.hidden = NO;
                _webView.frame = CGRectMake(0, 0, size_width, size_height-59);
            }
            oldIx = newx;
        }
        
    }
    

}


- (void)loginWhenReceiveNoticeWithModel:(YZUserModel *)model {
    [YZSDK loginIfNeedWithModel:model inWKWebView:self.webView];
}

- (void)addWKWebView {
    self.webView = [WKWebView new];
    [self.webView setUIDelegate:self];
    [self.webView setNavigationDelegate:self];
    [self.webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.webView];
    
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, size_width, 40)];
    
    self.progressView.progressViewStyle = UIProgressViewStyleBar;
     self.progressView.progressTintColor = [UIColor colorWithRed:0/255.0 green:150/255.0 blue:29/255.0 alpha:1.0];
    //[self.webView addSubview:_progressView];
    [self.navigationController.navigationBar addSubview:_progressView];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    //开启手势触摸
    self.webView.scrollView.delegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES;
    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]]];
}


//分享
- (void)shareButtonActionWithDic:(NSDictionary *)shareDic {
    
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
    
    
    UIImageView *titleImgView = [[UIImageView alloc]init];
    [titleImgView sd_setImageWithURL:[NSURL URLWithString:shareDic[SHARE_IMAGE_URL]] placeholderImage:[UIImage imageNamed:@"share"]];
    //实验 不行去掉
    [UMSocialWechatHandler setWXAppId:@"wxdcdd2ba2548e88b5" appSecret:@"29ceee15ff96df366c93a043d695862d" url:shareDic[SHARE_LINK]];
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"57ca6a40e0f55ac3c6003450" shareText:shareDic[SHARE_TITLE] shareImage:titleImgView.image shareToSnsNames:plantFormArr delegate:self];
}

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData{
    UIImageView *titleImgView = [[UIImageView alloc]init];
    [titleImgView sd_setImageWithURL:[NSURL URLWithString:_shareDic[SHARE_IMAGE_URL]] placeholderImage:[UIImage imageNamed:@"share"]];
    if (!_shareDic[SHARE_DESC]) {
        [_shareDic[SHARE_DESC] setObject:@"车驾小帮特卖商品" forKey:SHARE_DESC];
    }
    socialData.extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    if (platformName==UMShareToWechatTimeline) {
        socialData.extConfig.wechatTimelineData.shareText = _shareDic[SHARE_DESC];
        socialData.extConfig.wechatTimelineData.shareImage = titleImgView.image;
        socialData.extConfig.wechatTimelineData.url =_shareDic[SHARE_LINK];
        socialData.extConfig.wechatTimelineData.title = self.shareDic[SHARE_TITLE];
    }
    
    if (platformName==UMShareToWechatSession) {
        socialData.extConfig.wechatSessionData.shareText = _shareDic[SHARE_DESC];
        socialData.extConfig.wechatSessionData.shareImage = titleImgView.image;
        socialData.extConfig.wechatSessionData.url = _shareDic[SHARE_LINK];
        socialData.extConfig.wechatSessionData.title = _shareDic[SHARE_TITLE];
        
    }
    
    if (platformName==UMShareToSms) {
        socialData.extConfig.smsData.shareText = _shareDic[SHARE_DESC];
        socialData.extConfig.smsData.shareImage = titleImgView.image;
        socialData.extConfig.smsData.urlResource.url =_shareDic[SHARE_LINK];
        socialData.extConfig.wechatSessionData.title = _shareDic[SHARE_TITLE];
    }
    
    
    
}


//分享成功的回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    if (response.responseCode==UMSResponseCodeSuccess) {
        [WKWebViewController showAlertMessageWithMessage:@"分享成功" duration:1.0];
    }
    
}




@end
