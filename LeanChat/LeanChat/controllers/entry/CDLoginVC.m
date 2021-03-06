//
//  CDLoginController.m
//  AVOSChatDemo
//
//  Created by Qihe Bian on 7/24/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import "CDLoginVC.h"
#import "CDRegisterVC.h"
#import "CDAppDelegate.h"
#import "CDEntryBottomButton.h"
#import "CDEntryActionButton.h"

@interface CDLoginVC () <CDEntryVCDelegate>

@property (nonatomic, strong) CDEntryActionButton *loginButton;
@property (nonatomic, strong) CDEntryBottomButton *registerButton;
@property (nonatomic, strong) CDEntryBottomButton *forgotPasswordButton;

@end

@implementation CDLoginVC

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.registerButton];
    [self.view addSubview:self.forgotPasswordButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.usernameField.text = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERNAME];
    [self changeButtonState];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Propertys

- (CDResizableButton *)loginButton {
    if (_loginButton == nil) {
        _loginButton = [[CDEntryActionButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.usernameField.frame), CGRectGetMaxY(self.passwordField.frame) + kEntryVCVerticalSpacing, CGRectGetWidth(self.usernameField.frame), CGRectGetHeight(self.usernameField.frame))];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        _loginButton.enabled = NO;
        [_loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIButton *)registerButton {
    if (_registerButton == nil) {
        _registerButton = [[CDEntryBottomButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - kEntryVCTextFieldHeight, CGRectGetWidth(self.view.frame) / 2, kEntryVCTextFieldHeight)];
        [_registerButton setTitle:@"注册账号" forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(toRegister:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

- (UIButton *)forgotPasswordButton {
    if (_forgotPasswordButton == nil) {
        _forgotPasswordButton = [[CDEntryBottomButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) - kEntryVCTextFieldHeight, CGRectGetWidth(self.view.frame) / 2, kEntryVCTextFieldHeight)];
        [_forgotPasswordButton setTitle:@"找回密码" forState:UIControlStateNormal];
        [_forgotPasswordButton addTarget:self action:@selector(toFindPassword:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgotPasswordButton;
}

#pragma mark - Actions
- (void)login:(id)sender {
    [AVUser logInWithUsernameInBackground:self.usernameField.text password:self.passwordField.text block: ^(AVUser *user, NSError *error) {
        if (error) {
            [self showHUDText:error.localizedDescription];
        }
        else {
            [[NSUserDefaults standardUserDefaults] setObject:self.usernameField.text forKey:KEY_USERNAME];
            CDAppDelegate *delegate = (CDAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate toMain];
        }
    }];
}

- (void)toRegister:(id)sender {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    CDRegisterVC *vc = [[CDRegisterVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)changeButtonState {
    if (self.usernameField.text.length >= USERNAME_MIN_LENGTH && self.passwordField.text.length >= PASSWORD_MIN_LENGTH) {
        self.loginButton.enabled = YES;
    }
    else {
        self.loginButton.enabled = NO;
    }
}

- (void)toFindPassword:(id)sender {
    [self showHUDText:@"鞭打工程师中..."];
}

- (void)didPasswordTextFieldReturn:(CDTextField *)passwordField {
    if (self.registerButton.enabled) {
        [self login:nil];
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    [self changeButtonState];
}

@end
