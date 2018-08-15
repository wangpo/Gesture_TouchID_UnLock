//
//  SYSGestureLockViewController.h
//   Demo
//
//  Created by wangpo on 2018/7/31.
//  Copyright © 2018年 王坡. All rights reserved.
//  手势解锁VC

#import <UIKit/UIKit.h>
@class SYSGestureLockViewController;

typedef NS_ENUM(NSInteger,SYSUnlockType) {
    SYSUnlockTypeCreatePsw = 0, // 创建手势密码
    SYSUnlockTypeValidatePsw, // 校验手势密码
};

@protocol SYSGestureLockViewControllerDelegate <NSObject>
- (void)gestureCreateCancel:(SYSGestureLockViewController *)vc;//取消手势创建
- (void)gestureCreateSuccess:(SYSGestureLockViewController *)vc;//手势创建成功

- (void)gestureUnlockSuccess:(SYSGestureLockViewController *)vc;//手势解锁成功
- (void)gestureUnlockFail:(SYSGestureLockViewController *)vc;//手势解锁失败

@end


@interface SYSGestureLockViewController : UIViewController

@property (nonatomic, weak) id<SYSGestureLockViewControllerDelegate> delegate;

- (instancetype)initWithUnlockType:(SYSUnlockType)unlockType;
+ (void)deleteGesturesPassword;//删除手势密码
+ (NSString *)gesturesPassword;//获取手势密码
@end
