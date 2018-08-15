//
//  SYSGestureLockViewController.m
//   Demo
//
//  Created by wangpo on 2018/7/31.
//  Copyright © 2018年 王坡. All rights reserved.
//

#import "SYSGestureLockViewController.h"
#import "SYSGestureLockView.h"
#import "Masonry.h"

#define HEXRGBCOLOR(hex)        [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]
#define kGesturesPassword @"gesturespassword"

#define SG_PROPERTY_LOCK(name) \
@synchronized (name) { \
if (!name) { \
do {} while(0)

#define SG_PROPERTY_UNLOCK() \
}} do {} while(0)


@interface SYSGestureLockViewController () <SYSGestureLockViewDelegate>

@property (strong, nonatomic) UIButton *closeBtn;
@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *headIcon;
@property (strong, nonatomic) UILabel *phoneLabel;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) SYSGestureLockView *gestureLockView;

@property (nonatomic, copy) NSString *lastGesturePsw;// 创建的手势密码
@property (nonatomic) SYSUnlockType unlockType;

@end

@implementation SYSGestureLockViewController

#pragma mark - 类方法
+ (void)deleteGesturesPassword {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kGesturesPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)addGesturesPassword:(NSString *)gesturesPassword {
    [[NSUserDefaults standardUserDefaults] setObject:gesturesPassword forKey:kGesturesPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)gesturesPassword {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kGesturesPassword];
}

#pragma mark - inint
- (instancetype)initWithUnlockType:(SYSUnlockType)unlockType {
    if (self = [super init]) {
        _unlockType = unlockType;
    }
    return self;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupMainUI];
    switch (_unlockType) {
        case SYSUnlockTypeCreatePsw:{
            self.statusLabel.text = @"请设置手势密码";
            [self.closeBtn setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
        }
            break;
        case SYSUnlockTypeValidatePsw:{
            self.statusLabel.text = @"请输入手势进行登录";
            [self.closeBtn setImage:[UIImage imageNamed:@"login_close_white"] forState:UIControlStateNormal];
        }
            break;
    }
}

#pragma mark - setter & getter
- (UIButton *)closeBtn
{
    SG_PROPERTY_LOCK(_closeBtn);
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    SG_PROPERTY_UNLOCK();
    return _closeBtn;
}

- (UIImageView *)headIcon
{
    SG_PROPERTY_LOCK(_headIcon);
    _headIcon = [[UIImageView alloc] init];
    SG_PROPERTY_UNLOCK();
    return _headIcon;
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

- (UILabel *)statusLabel
{
    SG_PROPERTY_LOCK(_statusLabel);
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.font = [UIFont systemFontOfSize:14];
    _statusLabel.textColor = HEXRGBCOLOR(0x636B73);
    SG_PROPERTY_UNLOCK();
    return _statusLabel;
}

- (SYSGestureLockView *)gestureLockView
{
    SG_PROPERTY_LOCK(_gestureLockView);
    _gestureLockView = [[SYSGestureLockView alloc] init];
    _gestureLockView.backgroundColor = [UIColor whiteColor];
    _gestureLockView.delegate = self;
    _gestureLockView.hiddenGestureTrack = NO;//不隐藏手势轨迹
    SG_PROPERTY_UNLOCK();
    return _gestureLockView;
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

// 创建界面
- (void)setupMainUI {
    if (self.unlockType == SYSUnlockTypeCreatePsw) {
        //创建手势
        [self.view addSubview:self.headIcon];
        self.headIcon.image = [UIImage imageNamed:@"icon_hi"];
        [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(86);
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        [self.view addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(34);
            make.left.equalTo(self.view).offset(30);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        
    }else if (self.unlockType == SYSUnlockTypeValidatePsw){
        //手势登录
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
    }
    
    [self.view addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(176);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(22);
    }];
    
    [self.view addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneLabel.mas_bottom).offset(33);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    
    [self.view addSubview:self.gestureLockView];
    [self.gestureLockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusLabel.mas_bottom).offset(8);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(275);
    }];
    
}

#pragma mark - private
//  创建手势密码
- (void)createGesturesPassword:(NSMutableString *)gesturesPassword {
    
    if (self.lastGesturePsw.length == 0) {
        
        if (gesturesPassword.length < 4) {
            self.statusLabel.text = @"至少连接四个点，请重新输入";
            [self shakeAnimationForView:self.statusLabel];
            return;
        }
        
        self.lastGesturePsw = gesturesPassword;
        self.statusLabel.text = @"请再次设置手势密码";
        return;
    }
    
    if ([self.lastGesturePsw isEqualToString:gesturesPassword]) { // 设置成功
        
        [self dismissViewControllerAnimated:YES completion:^{
            // 保存手势密码
            [SYSGestureLockViewController addGesturesPassword:gesturesPassword];
            if (self.delegate && [self.delegate respondsToSelector:@selector(gestureCreateSuccess:)]) {
                [self.delegate gestureCreateSuccess:self];
            }
        }];
        
    }else {
        self.statusLabel.text = @"与上一次设置不一致，请重新设置";
        [self shakeAnimationForView:self.statusLabel];
    }
}

// 验证手势密码
- (void)validateGesturesPassword:(NSMutableString *)gesturesPassword {
    
    static NSInteger errorCount = 5;
    
    if ([gesturesPassword isEqualToString:[SYSGestureLockViewController gesturesPassword]]) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            errorCount = 5;
            //解锁成功
            if (self.delegate && [self.delegate respondsToSelector:@selector(gestureUnlockSuccess:)]) {
                [self.delegate gestureUnlockSuccess:self];
            }
        }];
    } else {
        if (errorCount - 1 == 0) {
            [self showAlertWithTitle:@"手势密码已失效" message:@"请选择其他方式登录" leftTitle:@"确定" leftBlock:^{
               
                [self dismissViewControllerAnimated:YES completion:^{
                    errorCount = 5;
                    //解锁失败
                    if (self.delegate && [self.delegate respondsToSelector:@selector(gestureUnlockFail:)]) {
                        [self.delegate gestureUnlockFail:self];
                    }
                }];
                
            } rightTitle:nil rightBlock:nil];
            return;
        }
        
        self.statusLabel.text = [NSString stringWithFormat:@"密码错误，还可以再输入%ld次",--errorCount];
        [self shakeAnimationForView:self.statusLabel];
    }
}

// 抖动动画
- (void)shakeAnimationForView:(UIView *)view {
    
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint left = CGPointMake(position.x - 10, position.y);
    CGPoint right = CGPointMake(position.x + 10, position.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:left]];
    [animation setToValue:[NSValue valueWithCGPoint:right]];
    [animation setAutoreverses:YES]; // 平滑结束
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    
    [viewLayer addAnimation:animation forKey:nil];
}

#pragma mark - ZLgestureLockViewDelegate
- (void)gestureLockView:(SYSGestureLockView *)lockView drawRectFinished:(NSMutableString *)gesturePassword {
    
    switch (_unlockType) {
        case SYSUnlockTypeCreatePsw: // 创建手势密码
        {
            [self createGesturesPassword:gesturePassword];
        }
            break;
        case SYSUnlockTypeValidatePsw: // 校验手势密码
        {
            [self validateGesturesPassword:gesturePassword];
        }
            break;
        default:
            break;
    }
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
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.unlockType == SYSUnlockTypeCreatePsw) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(gestureCreateCancel:)]) {
                [self.delegate gestureCreateCancel:self];
            }
        }
    }];
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
