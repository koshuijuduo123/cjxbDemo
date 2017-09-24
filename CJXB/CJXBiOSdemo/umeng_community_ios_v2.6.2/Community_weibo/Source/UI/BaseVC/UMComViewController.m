//
//  UMComViewController.m
//  UMCommunity
//
//  Created by umeng on 15/9/14.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComViewController.h"
#import "UMComTools.h"
#import "UMComSession.h"
#import "UMComLoginManager.h"
#import "UIViewController+UMComAddition.h"
#import "UMComErrorCode.h"

@interface UMComViewController ()

@end

@implementation UMComViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.doNotShowBackButton == NO) {
        [self setllForumUIBackButton];
    }
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(communityInvalidErrorNotitficationAlert) name:kUMComCommunityInvalidErrorNotification object:nil];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUMComCommunityInvalidErrorNotification object:nil];
}


- (void)communityInvalidErrorNotitficationAlert
{
    [UMComLoginManager userLogout];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUMComCommunityInvalidErrorNotification object:nil];
    [[[UIAlertView alloc]initWithTitle:nil message:UMComLocalizedString(ERR_MSG_INVALID_COMMUNITY,@"社区已经被强制关闭，暂时无法访问请见谅。") delegate:nil cancelButtonTitle:UMComLocalizedString(@"um_com_ok",@"好") otherButtonTitles:nil, nil] show];
}


- (void)setllForumUIBackButton
{
    [self setBackButtonWithImageName:@"um_forum_back_gray" buttonSize:CGSizeMake(10, 19) action:@selector(goBack)];
}

- (void)goBack
{
    if (self.AppDelegateSele==-1) {
        if(self.webBack){
            
            self.webBack();
        }
        
        
    }
    
    
    
    
    if (self.navigationController.viewControllers.count >1) {
        if (self.isPushWebView==YES) {
            if ([self.webView canGoBack]) {
                [self.webView goBack];
            }else{
               [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
