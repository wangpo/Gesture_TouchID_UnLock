//
//  ViewController.m
//   Demo
//
//  Created by wangpo on 2018/7/31.
//  Copyright © 2018年 王坡. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "MBProgressHUD.h"

#import "SYSTouchIDLockViewController.h"
#import "SYSGestureLockViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,SYSGestureLockViewControllerDelegate,SYSTouchIDLockViewControllerDelegate>

@property (nonatomic, strong) MBProgressHUD  *toastView;
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _dataSource = [NSMutableArray arrayWithObjects:@"手势创建",@"手势解锁",@"手势删除",@"指纹解锁",nil];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - Setter & Getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        /*
         * 去掉空白 cell 的分割线
         */
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame: CGRectMake (0, 0, 0, CGFLOAT_MIN)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame: CGRectMake (0, 0, 0, CGFLOAT_MIN)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        /*
         * 分割线风格
         */
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake (0, 10, 0, 10);
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}
#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *text = self.dataSource[indexPath.row];
    if ([text isEqualToString:@"手势创建"]) {
        SYSGestureLockViewController *vc = [[SYSGestureLockViewController alloc] initWithUnlockType:SYSUnlockTypeCreatePsw];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }else if ([text isEqualToString:@"手势解锁"]){
        if (![SYSGestureLockViewController gesturesPassword]) {
            [self showToastHUDView:@"请先创建手势密码"];
            return;
        }
        SYSGestureLockViewController *vc = [[SYSGestureLockViewController alloc] initWithUnlockType:SYSUnlockTypeValidatePsw];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }else if ([text isEqualToString:@"手势删除"]){
        [SYSGestureLockViewController deleteGesturesPassword];
        [self showToastHUDView:@"手势删除成功"];
    }else if ([text isEqualToString:@"指纹解锁"]){
        SYSTouchIDLockViewController *vc = [[SYSTouchIDLockViewController alloc] init];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }
   
}

#pragma mark - SYSGestureLockViewControllerDelegate

- (void)gestureCreateCancel:(SYSGestureLockViewController *)vc
{
    [self showToastHUDView:@"手势创建取消"];
}

- (void)gestureCreateSuccess:(SYSGestureLockViewController *)vc
{
    [self showToastHUDView:@"手势创建成功"];
}

- (void)gestureUnlockSuccess:(SYSGestureLockViewController *)vc
{
    [self showToastHUDView:@"手势解锁成功"];
}

- (void)gestureUnlockFail:(SYSGestureLockViewController *)vc
{
    [self showToastHUDView:@"手势解锁失败"];
}

#pragma mark - SYSTouchIDLockViewControllerDelegate
- (void)touchIDUnlockSuccess:(SYSTouchIDLockViewController *)vc
{
    [self showToastHUDView:@"指纹解锁成功"];
}

- (void)touchIDUnlockError:(SYSTouchIDLockViewController *)vc message:(NSString *)message;
{
    //指纹不支持
    [self showToastHUDView:message];
}

- (void)showToastHUDView:(NSString *)title
{
    if (_toastView) {
        [_toastView hideAnimated:NO];
        _toastView = nil;
    }
    [self.toastView.label setText:title];
}

- (MBProgressHUD *)toastView
{
    if (!_toastView) {
        _toastView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _toastView.mode = MBProgressHUDModeText;
        _toastView.removeFromSuperViewOnHide = YES;
        _toastView.label.textColor = [UIColor whiteColor];
        _toastView.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        _toastView.bezelView.color = [UIColor colorWithWhite:0 alpha:0.8];
        _toastView.bezelView.layer.cornerRadius = 0;
        _toastView.userInteractionEnabled = NO;
        [_toastView hideAnimated:YES afterDelay:1.5];
    }
    return _toastView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
