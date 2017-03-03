//
//  UMComLoginViewController.h
//  UMCommunity
//
//  Created by wyq.Cloudayc on 5/11/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComViewController.h"

typedef void (^LoginCompletion)(id responseObject, NSError *error);

@interface UMComLoginViewController : UMComViewController

#pragma mark community login
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (weak, nonatomic) IBOutlet UIImageView *accountIcon;
@property (weak, nonatomic) IBOutlet UIImageView *passwordIcon;

@property (weak, nonatomic) IBOutlet UIView *accountColorView;
@property (weak, nonatomic) IBOutlet UIView *pwdColorView;

#pragma mark platform login
@property (nonatomic, weak) IBOutlet UIButton *sinaLoginButton;
@property (nonatomic, weak) IBOutlet UIButton *qqLoginButton;
@property (nonatomic, weak) IBOutlet UIButton *wechatLoginButton;

@property (nonatomic, copy) LoginCompletion completion;

- (IBAction)forgotPassword:(id)sender;

- (IBAction)login:(id)sender;

- (IBAction)registerAccount:(id)sender;

@end
