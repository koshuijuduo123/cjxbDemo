//
//  UMComWebViewController.m
//  UMCommunity
//
//  Created by Gavin Ye on 8/19/15.
//  Copyright (c) 2015 Umeng. All rights reserved.
//

#import "UMComWebViewController.h"
#import "UIViewController+UMComAddition.h"
#import "MJRefresh.h"
@interface UMComWebViewController ()
{
    BOOL theBool;
    NSTimer *myTimer;
}
@property(nonatomic,strong)UIProgressView *progressView;
@property (nonatomic) BOOL authenticated;

@property (nonatomic, strong) NSURLRequest *request;

@property (nonatomic, strong) NSURLRequest *failedRequest;



@property (nonatomic, strong) NSURLConnection * urlConnection;

@end

@implementation UMComWebViewController
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
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, size_width, 10)];
    
    self.progressView.progressViewStyle = UIProgressViewStyleBar;
    
    [self.webView addSubview:_progressView];
    
    //进入刷新状态
    self.webView.scrollView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self.webView reload];
        [self.webView.scrollView.header endRefreshing];
    }];
    
    
    
  
}



- (instancetype)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, size_width, size_height-64)];
        webView.delegate = self;
        self.webView = webView;
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [webView loadRequest:request];
        [self.view addSubview:webView];
        
 }
    return self;
}

//兼容HTTPS
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    BOOL result = _authenticated;
    if (!_authenticated) {
        self.failedRequest = request;
        self.urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    }
    return result;
}

-(void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURL* baseURL = self.request.URL;
        if ([challenge.protectionSpace.host isEqualToString:baseURL.host]) {
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        } 
    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)pResponse {
    _authenticated = YES;
    [connection cancel];
    [self.webView loadRequest:self.failedRequest];
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _progressView.progress = 0;
    theBool = false;
    _progressView.hidden = false;
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.11667 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
     theBool = true;
     _progressView.hidden = true;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}



-(void)timerCallback {
    if (theBool) {
        if (_progressView.progress >= 1) {
            _progressView.hidden = true;
            [myTimer invalidate];
            myTimer = nil;
        }
        else {
            _progressView.progress += 0.1;
        }
    }
    else {
        _progressView.progress += 0.05;
        if (_progressView.progress >= 0.95) {
            _progressView.progress = 0.95;
           
            // 注：这里关闭时间计时器，不然如果网页加载非常慢，计时器会一直执行，因为刷新比较迅速，会导致页面卡顿。这里关闭，在网页请求结束代理里面，再执行隐藏进度条动画
            [myTimer invalidate];
            myTimer = nil;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
