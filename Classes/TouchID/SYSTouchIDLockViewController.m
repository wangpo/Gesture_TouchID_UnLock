//
//  SYSTouchIDLockViewController.m
//   Demo
//
//  Created by wangpo on 2018/7/31.
//  Copyright © 2018年 王坡. All rights reserved.
//

#import "SYSTouchIDLockViewController.h"
#import "SYSTouchIDAuthManager.h"
#import "Masonry.h"

#define HEXRGBCOLOR(hex)        [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

#define SG_PROPERTY_LOCK(name) \
@synchronized (name) { \
if (!name) { \
do {} while(0)

#define SG_PROPERTY_UNLOCK() \
}} do {} while(0)


@interface SYSTouchIDLockViewController ()

@property (strong, nonatomic) UIButton *closeBtn;
@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UIImageView *headIcon;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *phoneLabel;
@property (strong, nonatomic) UIButton *touchIDBtn;
@property (strong, nonatomic) UILabel *statusLabel;

@end

@implementation SYSTouchIDLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupMainUI];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadAuthentication];
    });
}

#pragma mark - setter & getter
- (UIButton *)closeBtn
{
    SG_PROPERTY_LOCK(_closeBtn);
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[UIImage imageNamed:@"login_close_white"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    SG_PROPERTY_UNLOCK();
    return _closeBtn;
}

- (UIImageView *)headImageView
{
    SG_PROPERTY_LOCK(_headImageView);
    _headImageView = [[UIImageView alloc] init];
    _headImageView.image = [UIImage imageNamed:@""];
    _headImageView.backgroundColor = HEXRGBCOLOR(0X15A9F2);
    SG_PROPERTY_UNLOCK();
    return _headImageView;
}

- (UILabel *)nameLabel
{
    SG_PROPERTY_LOCK(_nameLabel);
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.text = @"未知用户";
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textColor = HEXRGBCOLOR(0xFFFFFF);
    SG_PROPERTY_UNLOCK();
    return _nameLabel;
}

- (UIImageView *)headIcon
{
    SG_PROPERTY_LOCK(_headIcon);
    _headIcon = [[UIImageView alloc] init];
    _headIcon.image = [UIImage imageNamed:@"icon_default"];
    SG_PROPERTY_UNLOCK();
    return _headIcon;
}

- (UILabel *)phoneLabel
{
    SG_PROPERTY_LOCK(_phoneLabel);
    _phoneLabel = [[UILabel alloc] init];
    _phoneLabel.textAlignment = NSTextAlignmentCenter;
    _phoneLabel.text = @"186****6981";
    _phoneLabel.font = [UIFont systemFontOfSize:16];
    _phoneLabel.textColor = HEXRGBCOLOR(0x636B73);
    SG_PROPERTY_UNLOCK();
    return _phoneLabel;
}

- (UIButton *)touchIDBtn
{
    SG_PROPERTY_LOCK(_touchIDBtn);
    _touchIDBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_touchIDBtn setImage:[UIImage imageNamed:@"touchID"] forState:UIControlStateNormal];
    [_touchIDBtn addTarget:self action:@selector(touchIDBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    SG_PROPERTY_UNLOCK();
    return _touchIDBtn;
}

- (UILabel *)statusLabel
{
    SG_PROPERTY_LOCK(_statusLabel);
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.font = [UIFont systemFontOfSize:14];
    _statusLabel.textColor = HEXRGBCOLOR(0x636B73);
    _statusLabel.text = @"使用指纹登录";
    SG_PROPERTY_UNLOCK();
    return _statusLabel;
}

// 创建界面
- (void)setupMainUI {
    [self.view addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(145);
    }];
    
    [self.view addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(34);
        make.left.equalTo(self.view).offset(30);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.view addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(86);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    
    [self.view addSubview:self.headIcon];
    self.headIcon.image = [UIImage imageNamed:@"icon_default"];
    [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(46, 46));
    }];
    
    [self.view addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(176);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(22);
    }];
    
    
    [self.view addSubview:self.touchIDBtn];
    [self.touchIDBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneLabel.mas_bottom).offset(75);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(112, 112));
    }];
    
    [self.view addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.touchIDBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
}

/**
 * 指纹登录验证
 */
- (void)loadAuthentication
{
    [SYSTouchIDAuthManager touchIDAuthenticationSuccessCallBack:^{
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(touchIDUnlockSuccess:)]) {
                [self.delegate touchIDUnlockSuccess:self];
            }
        }];
    } failureCallback:^(LAError errorCode) {
        NSString *message = @"";
         if (errorCode == LAErrorAuthenticationFailed){
            message = @"指纹识别失败，请重新识别！";
        } else if(errorCode == LAErrorTouchIDLockout) {
            message = @"指纹已禁用，请锁定手机后重试！";
        }
        [self showAlertWithTitle:nil message:message leftTitle:@"知道了" leftBlock:nil rightTitle:nil rightBlock:nil];
        
    } nonsupportCallback:^(LAError errorCode) {
        NSString *message = @"";
        if (errorCode == LAErrorTouchIDNotEnrolled){
            message = @"此设备未录入指纹，请先录入！";
        }else if (errorCode == LAErrorPasscodeNotSet) {
            message = @"此设备未设置系统密码，请先设置！";
        }else if (errorCode == LAErrorTouchIDNotAvailable) {
            message = @"此设备不支持指纹识别功能，请更换设备！";
        }else if(errorCode == LAErrorTouchIDLockout) {
            message = @"指纹已禁用，请锁定手机后重试！";
        }
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(touchIDUnlockError:message:)]) {
                [self.delegate touchIDUnlockError:self message:message];
            }
        }];
    }];

}

#pragma mark - private method
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)msg leftTitle:(NSString *)leftTitle leftBlock:(void(^)(void))leftBlock rightTitle:(NSString *)rightTitle rightBlock:(void(^)(void))rightBlock
{
    UIAlertController * alertCtr = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * leftAction = [UIAlertAction actionWithTitle:leftTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (leftBlock) {
            leftBlock();
        }
    }];
    UIAlertAction * rightAction = nil;
    if (rightTitle){
        rightAction = [UIAlertAction actionWithTitle:rightTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (rightBlock) {
                rightBlock();
            }
        }];
    }
    [alertCtr addAction:leftAction];
    if (rightAction) {
        [alertCtr addAction:rightAction];
    }
    [self presentViewController:alertCtr animated:YES completion:nil];
}

#pragma mark - ActionEvent
- (void)closeBtnAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchIDBtnAction:(UIButton *)sender
{
    [self loadAuthentication];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
