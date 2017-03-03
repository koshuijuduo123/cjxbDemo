//
//  UMComLoginViewController.m
//  UMCommunity
//
//  Created by wyq.Cloudayc on 5/11/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComLoginViewController.h"
#import "UMComRegisterViewController.h"
#import "UMUtils.h"
#import "UMComTools.h"
#import "UMComPushRequest.h"
#import "UIViewController+UMComAddition.h"
#import "UMComShowToast.h"
#import "UMComProgressHUD.h"

#import "UMSocial.h"
#import "WXApi.h"
#import "UMComImageUrl+CoreDataProperties.h"
#import "UMComUser.h"

@interface UMComLoginViewController ()

@property (nonatomic, weak) UITextField *currentField;

@end

@implementation UMComLoginViewController

- (instancetype)init
{
    if (self = [self initWithNibName:@"UMComLoginViewController" bundle:nil]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UMComColorWithColorValueString(@"#E1E6E9");

    [self setForumUITitle:UMComLocalizedString(@"um_com_login", @"登录")];

    [self initViews];
    
    [self initPlatformLogin];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItems = nil;

    UIButton *closeButon = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButon setImage:UMComImageWithImageName(@"close") forState:UIControlStateNormal];
    [closeButon addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    closeButon.frame = CGRectMake(0.f, 0.f, 22.f, 22.f);
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeButon];
    [self.navigationItem setLeftBarButtonItem:closeItem];
    
    UIView *placeHolderView = [[UIView alloc] init];
    placeHolderView.frame = CGRectMake(0.f, 0.f, 22.f, 22.f);
    UIBarButtonItem *placeHolderButton = [[UIBarButtonItem alloc] initWithCustomView:placeHolderView];
    [self.navigationItem setRightBarButtonItem:placeHolderButton];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews
{
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    [_accountIcon setImage:UMComImageWithImageName(@"userid")];
    [_passwordIcon setImage:UMComImageWithImageName(@"keyword")];
    
    _registerButton.layer.borderWidth = 1.f;
    _registerButton.layer.borderColor = UMComColorWithColorValueString(@"#469EF8").CGColor;
    
    UITapGestureRecognizer *tapClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapClose];
}

- (IBAction)forgotPassword:(id)sender {
    [_passwordField resignFirstResponder];
    [_accountField resignFirstResponder];
    if (_accountField.text.length == 0) {
        [UMComShowToast accountEmailEmpty];
        return;
    }
    
    if (![UMUtils checkEmailFormat:_accountField.text]) {
        [UMComShowToast accountEmailInvalid];
        return;
    }
    
    
    [UMComPushRequest userPasswordForgetForUMCommunity:_accountField.text response:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            [UMComShowToast showFetchResultTipWithError:error];
        } else {
            [UMComShowToast accountFindPasswordSuccess];
        }
    }];
}


- (IBAction)login:(id)sender {
    [_passwordField resignFirstResponder];
    [_accountField resignFirstResponder];

    if (_accountField.text.length == 0) {
        [UMComShowToast accountEmailEmpty];
        return;
    }
    
    if (![UMUtils checkEmailFormat:_accountField.text]) {
        [UMComShowToast accountEmailInvalid];
        return;
    }
    
    if (_passwordField.text.length == 0) {
        [UMComShowToast accountPasswordEmpty];
        return;
    }
    
    if (_passwordField.text.length < 6 || _passwordField.text.length > 18 || ![UMUtils includeAlphabetOrDigitOnly:_passwordField.text]) {
        [UMComShowToast accountPasswordInvalid];
        return;
    }
    
    //加入等待框
    UMComProgressHUD *hud = [UMComProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.label.text = UMComLocalizedString(@"um_com_loginingContent",@"登录中...");
    hud.label.backgroundColor = [UIColor clearColor];
    
    __weak typeof(self) ws = self;
    [UMComPushRequest userLoginInUMCommunity:_accountField.text password:_passwordField.text response:^(id responseObject, NSError *error) {
        [hud hideAnimated:YES];
        if (error) {
            [UMComShowToast showFetchResultTipWithError:error];
        } else {
            [UMComShowToast accountLoginSuccess];
            
            __strong typeof(ws) ss = ws;
            [UMComLoginManager loginWithLoginViewController:ss userAccount:nil response:responseObject error:error loginCompletion:^(id responseObject, NSError *error) {
                [ws dismissViewControllerAnimated:YES completion:nil];
            }];
        }
    }];
}

- (IBAction)registerAccount:(id)sender {
    __weak typeof(self) ws = self;
    UMComRegisterViewController *registerVC = [[UMComRegisterViewController alloc] init];
    registerVC.completion = ^(id responseObject, NSError *error) {
        __strong typeof(ws) ss = ws;
        
        UMComUser *user = responseObject;
        if ([user isKindOfClass:[UMComUser class]]) {
            [UMComLoginManager loginWithLoginViewController:ss
                                                userAccount:[self getUserAccountFromUserObj:user]
                                                   response:responseObject error:error
                                            loginCompletion:^(id responseObject, NSError *error) {
                                                [ws dismissViewControllerAnimated:YES completion:nil];
                                            }];
        }
    };
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (UMComUserAccount *)getUserAccountFromUserObj:(UMComUser *)user
{
    UMComUserAccount *account = [[UMComUserAccount alloc] init];
    account.usid = user.source_uid;
    account.custom = @"这是一个自定义字段，可以改成自己需要的数据";
    account.name = user.name;
    account.icon_url = user.icon_url.midle_url_string;
    account.gender = user.gender;
    return account;
}

#pragma mark - Platform Login


- (void)initPlatformLogin
{
    self.sinaLoginButton.tag = UMSocialSnsTypeSina;
    self.qqLoginButton.tag = UMSocialSnsTypeMobileQQ;
    self.wechatLoginButton.tag = UMSocialSnsTypeWechatSession;
    
    if ([UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ]) {
        [self.qqLoginButton setImage:UMComImageWithImageName(@"tencentx") forState:UIControlStateNormal];
    }
    if ([UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession]) {
        [self.wechatLoginButton setImage:UMComImageWithImageName(@"wechatx") forState:UIControlStateNormal];
    }
    
    [self.sinaLoginButton addTarget:self action:@selector(onClickLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.qqLoginButton addTarget:self action:@selector(onClickLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.wechatLoginButton addTarget:self action:@selector(onClickLogin:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)checkWechatInstallStatus
{
    
}

- (void)onClickLogin:(UIButton *)button
{
    NSString *snsName = nil;
    switch (button.tag) {
        case UMSocialSnsTypeSina:
            snsName = UMShareToSina;
            break;
        case UMSocialSnsTypeMobileQQ:
            snsName = UMShareToQQ;
            break;
        case UMSocialSnsTypeWechatSession:
            snsName = UMShareToWechatSession;
            break;
        default:
            break;
    }
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
    if (!snsPlatform) {
        [UMComShowToast notSupportPlatform];
//    } else if ([snsName isEqualToString:UMShareToWechatSession] && ![WXApi isWXAppInstalled]){
//        [UMComShowToast showNotInstall];
    } else {
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity * response){
            
            __weak typeof(self) ws = self;
            if (response.responseCode == UMSResponseCodeSuccess) {
                [[UMSocialDataService defaultDataService] requestSnsInformation:snsPlatform.platformName completion:^(UMSocialResponseEntity *userInfoResponse) {
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
                    UMComSnsType snsType = -1;
                    if ([snsPlatform.platformName isEqualToString:UMShareToSina]) {
                        snsType = UMComSnsTypeSina;
                    } else if ([snsPlatform.platformName isEqualToString:UMShareToWechatSession]){
                        snsType = UMComSnsTypeWechat;
                    } else if ([snsPlatform.platformName isEqualToString:UMShareToQQ]){
                        snsType = UMComSnsTypeQQ;
                    }
                    UMComUserAccount *account = [[UMComUserAccount alloc] initWithSnsType:snsType];
                    account.usid = snsAccount.usid;
                    account.custom = @"这是一个自定义字段，可以改成自己需要的数据";
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        if ([userInfoResponse.data valueForKey:@"screen_name"]) {
                            account.name = [userInfoResponse.data valueForKey:@"screen_name"];
                        }
                        if ([userInfoResponse.data valueForKey:@"profile_image_url"]) {
                            account.icon_url = [userInfoResponse.data valueForKey:@"profile_image_url"];
                        }
                        if ([userInfoResponse.data valueForKey:@"gender"]) {
                            account.gender = [userInfoResponse.data valueForKey:@"gender"] ;
                        }
                        if ([snsPlatform.platformName isEqualToString:UMShareToWechatSession]) {
                            if (response.thirdPlatformUserProfile[@"unionid"]) {
                                account.unionId = response.thirdPlatformUserProfile[@"unionid"];
                            }
                        }
                    }
                    
                    UMComProgressHUD *hud = [UMComProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    hud.label.text = UMComLocalizedString(@"um_com_loginingContent",@"登录中...");
                    hud.label.backgroundColor = [UIColor clearColor];
                    [UMComPushRequest loginWithUser:account completion:^(id responseObject, NSError *error) {
                        [hud hideAnimated:YES];
                        __strong typeof(ws) ss = ws;
                        [UMComLoginManager loginWithLoginViewController:ss userAccount:account response:responseObject error:error loginCompletion:^(id responseObject, NSError *error) {
                            [ws dismissViewControllerAnimated:YES completion:nil];
                        }];
                    }];
                }];
                
            } else {
                [UMComLoginManager loginWithLoginViewController:self userAccount:nil loginCompletion:^(id responseObject, NSError *error) {
                    [ws dismissViewControllerAnimated:YES completion:nil];
                }];
            }
        });
    }
}

#pragma mark - UITextField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentField = textField;
    [self refreshColorView];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self refreshColorView];
}

#pragma mark - event
- (void)refreshColorView
{
    _accountColorView.hidden = [_accountField isFirstResponder];
    _pwdColorView.hidden = [_passwordField isFirstResponder];
}

- (void)hideKeyboard
{
    [_currentField resignFirstResponder];
}

- (void)close
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
