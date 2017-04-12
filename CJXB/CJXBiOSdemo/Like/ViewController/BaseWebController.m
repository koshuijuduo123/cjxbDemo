//
//  BaseWebViewController.m
//  YouzaniOSDemo
//
//  Created by 可乐 on 16/10/31.
//  Copyright © 2016年 张伟. All rights reserved.
//

#import "BaseWebController.h"
#import <WebKit/WebKit.h>

@interface BaseWebController ()

//@property(nonatomic,strong)UIProgressView *progressView; //进度条
@end

@implementation BaseWebController

-(NSArray *)logTypeArrM{
    if (!_logTypeArrM) {
        self.logTypeArrM = @[@"分享此商品",@"在浏览器打开",@"复制链接"];
    }
    return _logTypeArrM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBarButtonItem];
    _shareBtn.enabled = NO;//默认分享按钮不可用
    
    if ([UserDefault isLogin]) {
        self.loginTime = kLoginTimePrior;
        
    }else{
        self.loginTime = kLoginTimeWhenNeed;
    }
    
    
    //加载链接
    
    if (self.loadUrl) {
        [self loginAndloadUrl:self.loadUrl];
        
    }else{
        [self loginAndloadUrl:@"https://kdt.im/m5FEvr"];
        
    }
   
    
    
    
    
    
}

/**
 *  显示分享数据
 *
 *  @param data
 */
- (void)showShareData:(id)data {
    NSDictionary *shareDic = (NSDictionary *)data;
    NSString *message = [NSString stringWithFormat:@"%@\r%@ %@ %@" , shareDic[SHARE_TITLE],shareDic[SHARE_LINK],shareDic[SHARE_IMAGE_URL],shareDic[SHARE_DESC]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"数据已经复制到黏贴版" message:message delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alertView show];
    //复制到粘贴板
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = message;
}

/**
 *  加载链接。
 *
 *  @remark 这里强制先登录再加载链接，你的工程里由你控制。
 *  @param urlString 链接
 */
- (void)loginAndloadUrl:(NSString*)urlString {
    if (self.loginTime != kLoginTimePrior) {
        [self loadWithString:urlString];
        return;
    }
    
    LoginDataModel*model = [UserDefault getUserInfo];
   
    if(model) {
        YZUserModel *userModel = [UserDefault modelWithUser:model];
        [YZSDK registerYZUser:userModel callBack:^(NSString *message, BOOL isError) {
            if(!isError) {
                
                [self loadWithString:urlString];
            } else {
                [self webViewFail];
            }
        }];
    } else {
        //self.loginTime = kLoginTimeWhenNeed;
        [self loadWithString:urlString];
    }
    //[self loadWithString:urlString];
}


//-(void)timerCallback {
//    
//    if (_progressView.progress >= 0.95) {
//        _progressView.hidden = YES;
//        [myTimer invalidate];
//        [self webViewFail];
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        self.tabBarController.tabBar.hidden = NO;
//    }
//    else {
//        
//        self.progressView.hidden = NO;
//        _progressView.progress += 0.1;
//        [self.progressView setProgress:_progressView.progress animated:YES];
//    }
//    
//}



#pragma mark - Action

- (void)closeItemBarButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reloadButtonAction {
    NSAssert(YES, @"需要子类覆写");
}

/**
 *  触发分享功能
 */
- (void)shareButtonAction {
    NSAssert(YES, @"需要子类覆写");
}

-(void)logTypeArrMAction:(UIButton *)btn{
    NSAssert(YES,@"需要子类复写");
}



#pragma mark - Private Method

- (void)initBarButtonItem {
    
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_shareBtn setImage:[UIImage imageNamed:@"选项"] forState:UIControlStateNormal];
    
    [_shareBtn addTarget:self action:@selector(logTypeArrMAction:) forControlEvents:UIControlEventTouchUpInside ];
    
    _shareBtn.frame = CGRectMake(5, 0, 30, 30);
    
    UIView *rightShareBtn = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
    [rightShareBtn addSubview:_shareBtn];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]initWithCustomView:rightShareBtn];
    self.navigationItem.rightBarButtonItem = menuButton;
}

- (void)loadWithString:(NSString *)urlStr {
    NSAssert(YES, @"需要子类覆写");
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


-(void)webViewFail{
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size_width, size_height-64)];
    view1.backgroundColor = [UIColor whiteColor];
    UIImageView *imgVc = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size_width, size_height-64)];
    imgVc.image = [UIImage imageNamed:@"请求错误"];
    
    [view1 addSubview:imgVc];
    imgVc.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *tapFestrer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapRefeshAction:)];
    [imgVc addGestureRecognizer:tapFestrer];
    
    
    [view1 addSubview:imgVc];
    
    UILabel *refrshLab = [[UILabel alloc]initWithFrame:CGRectMake((size_width-150)/2, 70, 150, 40)];
    refrshLab.text = @"点击页面刷新";
    refrshLab.font = [UIFont systemFontOfSize:18.0];
    refrshLab.textColor = [UIColor colorWithRed:182/255.0 green:207/255.0 blue:211/255.0 alpha:1.0];
    refrshLab.textAlignment = NSTextAlignmentCenter;
    [view1 addSubview:refrshLab];
    view1.tag = 9999;
    [self.view addSubview:view1];

}

//点击图片刷新
-(void)TapRefeshAction:(UIGestureRecognizer *)sender{
    UIView *view = [self.view viewWithTag:9999];
    [view removeFromSuperview];
    [self loadWithString:@"https://kdt.im/m5FEvr"];
    

    
}

@end
