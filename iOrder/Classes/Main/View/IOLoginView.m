//
//  IOLoginView.m
//  iOrder
//
//  Created by 易无解 on 8/17/16.
//  Copyright © 2016 易无解. All rights reserved.
//

#import "IOLoginView.h"

#import "YWJLoginTool.h"
#import "YWJLoginParam.h"
#import "YWJLoginResult.h"
#import "MBProgressHUD.h"

#pragma mark - implementation IOLoginView

@interface IOLoginView ()

@property (nonatomic, weak) UIImageView *backgroundImg;
@property (nonatomic, weak) UIImageView *appIconImg;
@property (nonatomic, weak) UIImageView *appNameImg;
@property (nonatomic, weak) IOLoginTextField *userName;
@property (nonatomic, weak) IOLoginTextField *password;
@property (nonatomic, weak) UIButton *loginBtn;
@property (nonatomic, weak) UIButton *registerBtn;
@property (nonatomic, weak) UIView *partingLine;
@property (nonatomic, weak) UIButton *helpBtn;

@end

@implementation IOLoginView

#pragma mark - privacy

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupAllChildView];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - custom

- (void)setupAllChildView {//添加所有子控件
//    1、背景图片
    UIImageView *backgroundImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroud"]];
    [self addSubview:backgroundImg];
    _backgroundImg = backgroundImg;
    
//    2、图标
    UIImageView *appIconImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [self addSubview:appIconImg];
    _appIconImg = appIconImg;
    
//    3、图标文字
    UIImageView *appNameImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"i order"]];
    [self addSubview:appNameImg];
    _appNameImg = appNameImg;
    
//    4、用户名输入框
    IOLoginTextField *userName = [[IOLoginTextField alloc] init];
    userName.background = [UIImage imageNamed:@"usename_bar"];
    userName.placeholder = @"username";
    [userName setValue:YWJRGBColor(111, 95, 97, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textLabelChanged) name:UITextFieldTextDidChangeNotification object:userName];
    [self addSubview:userName];
    _userName = userName;
    
//    5、密码输入框
    IOLoginTextField *password = [[IOLoginTextField alloc] init];
    password.background = [UIImage imageNamed:@"password_bar"];
    password.placeholder = @"password";
    [password setSecureTextEntry:YES];
    [password setValue:YWJRGBColor(111, 95, 97, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textLabelChanged) name:UITextFieldTextDidChangeNotification object:password];
    [self addSubview:password];
    _password = password;
    
//    6、登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bar"]];
    [loginBtn setTitle:@"Login" forState:UIControlStateNormal];
    loginBtn.enabled = NO;
    [loginBtn addTarget:self action:@selector(loginBtnDidPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginBtn];
    _loginBtn = loginBtn;
    
//    7、注册按钮
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setTitle:@"Sign in" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnDidPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:registerBtn];
    _registerBtn = registerBtn;
    
//    8、分割线
    UIView *partingLine = [[UIView alloc] init];
    partingLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:partingLine];
    _partingLine = partingLine;
    
//    9、帮助按钮
    UIButton *helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [helpBtn setTitle:@"Help" forState:UIControlStateNormal];
    [helpBtn addTarget:self action:@selector(helpBtnDidPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:helpBtn];
    _helpBtn = helpBtn;
}

- (void)textLabelChanged {
    self.loginBtn.enabled = (self.userName.text.length != 0 && self.password.text.length != 0);
}

- (void)loginBtnDidPressed:(UIButton *)btn {
    YWJLoginParam *param = [[YWJLoginParam alloc] init];
    param.userName = self.userName.text;
    param.userPass = self.password.text;
    
    [YWJLoginTool loginWithLoginParam:param success:^(YWJLoginResult *loginResult) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            [self doSomeWork];
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES afterDelay:2.];
                if (loginResult.code == 1) {
                    if ([self.delegate respondsToSelector:@selector(loginView:loginBtnDidPressed:)]) {
                        [self.delegate loginView:self loginBtnDidPressed:btn];
                    }
                } else {
                    hud.mode = MBProgressHUDModeCustomView;
                    UIImage *image = [[UIImage imageNamed:@"error"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    hud.customView = [[UIImageView alloc] initWithImage:image];
                    hud.square = YES;
                    hud.labelText = NSLocalizedString(@"Login Failed", @"HUD done title");
                    [hud hide:YES afterDelay:1.f];
                }
            });
        });
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)doSomeWork {
    sleep(2.);
}

- (void)registerBtnDidPressed:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(loginView:registerBtnDidPressed:)]) {
        [self.delegate loginView:self registerBtnDidPressed:btn];
    }
}

- (void)helpBtnDidPressed:(UIButton *)btn {
    NSLog(@"help....");
}

#pragma mark - masonry

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    [self.backgroundImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
    }];
    
    [self.appIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(65);
        make.centerX.equalTo(self);
        make.width.equalTo(@99);
        make.height.equalTo(@102);
    }];
    
    [self.appNameImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appIconImg.mas_bottom).offset(20);
        make.centerX.equalTo(self);
        make.width.equalTo(@80);
        make.height.equalTo(@18);
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(278);
        make.centerX.equalTo(self);
        make.width.equalTo(@300);
        make.height.equalTo(@44);
    }];
    
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userName.mas_bottom).offset(30);
        make.centerX.equalTo(self);
        make.width.equalTo(@300);
        make.height.equalTo(@44);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.password.mas_bottom).offset(30);
        make.centerX.equalTo(self);
        make.width.equalTo(@300);
        make.height.equalTo(@44);
    }];
    
    [self.partingLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-40);
        make.width.equalTo(@1);
        make.height.equalTo(@22);
    }];
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.partingLine.mas_centerY);
        make.right.equalTo(self.partingLine.mas_left).offset(-10);
        make.width.equalTo(@80);
        make.height.equalTo(@22);
    }];
    
    [self.helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.partingLine.mas_centerY);
        make.left.equalTo(self.partingLine.mas_right).offset(10);
        make.width.equalTo(@80);
        make.height.equalTo(@22);
    }];
    
    [super updateConstraints];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

#pragma mark - implementation IOLoginTextField

@implementation IOLoginTextField

#pragma mark - privacy

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 17, 0)];//设置文字距左边框的位置
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    
    return self;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {//控制placeholder的位置
    return CGRectMake(17, 0, 270, 44);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {//控制光标的位置
    return CGRectMake(17, 0, 270, 44);
}

@end
